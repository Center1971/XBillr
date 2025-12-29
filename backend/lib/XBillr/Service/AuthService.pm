package XBillr::Service::AuthService;

use strict;
use warnings;
use Crypt::PBKDF2;
use UUID::Tiny ':std';
use DateTime;
use DateTime::Format::MySQL;
use MIME::Base64;

sub new {
    my ($class, %args) = @_;
    my $self = {
        schema => $args{schema},
        pbkdf2 => Crypt::PBKDF2->new(
            hash_class => 'HMACSHA1',
            iterations => 10000,
            output_len => 32,
        ),
    };
    bless $self, $class;
    return $self;
}

sub hash_password {
    my ($self, $password) = @_;
    return $self->{pbkdf2}->generate($password);
}

sub verify_password {
    my ($self, $password, $hash) = @_;
    return 0 unless $hash;
    
    # Entferne mögliche Whitespace
    $hash =~ s/^\s+|\s+$//g;
    
    # WICHTIG: validate() erwartet (hash, password) nicht (password, hash)!
    # Verwende ein neues, unkonfiguriertes PBKDF2-Objekt
    # Das kann Hash-Strings automatisch parsen
    my $result = 0;
    eval {
        my $pbkdf2 = Crypt::PBKDF2->new;
        $result = $pbkdf2->validate($hash, $password);
    };
    
    # Wenn das fehlschlägt, versuche es mit dem konfigurierten PBKDF2-Objekt
    unless ($result) {
        eval {
            $result = $self->{pbkdf2}->validate($hash, $password);
        };
    }
    
    return $result ? 1 : 0;
}

sub generate_session_token {
    my ($self) = @_;
    my $token = create_uuid_as_string(UUID_V4) . '-' . time() . '-' . rand();
    return encode_base64($token, '');
}

sub create_session {
    my ($self, $user_id, $ip_address, $user_agent) = @_;
    my $schema = $self->{schema};
    my $token = $self->generate_session_token();
    my $expires_at = DateTime->now->add(hours => 24);
    
    my $session = $schema->resultset('UserSession')->create({
        id => create_uuid_as_string(UUID_V4),
        user_id => $user_id,
        session_token => $token,
        ip_address => $ip_address,
        user_agent => $user_agent,
        expires_at => $expires_at->strftime('%Y-%m-%d %H:%M:%S'),
        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        last_activity => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    
    return $session;
}

sub validate_session {
    my ($self, $token) = @_;
    my $schema = $self->{schema};
    
    my $session = $schema->resultset('UserSession')->find({
        session_token => $token,
    });
    
    return undef unless $session;
    
    # Prüfe Ablaufzeit
    my $expires_at = DateTime::Format::MySQL->parse_datetime($session->expires_at);
    if (DateTime->now > $expires_at) {
        $session->delete;
        return undef;
    }
    
    # Aktualisiere letzte Aktivität
    $session->update({
        last_activity => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    
    return $session->user;
}

sub delete_session {
    my ($self, $token) = @_;
    my $schema = $self->{schema};
    
    my $session = $schema->resultset('UserSession')->find({
        session_token => $token,
    });
    
    $session->delete if $session;
}

sub login {
    my ($self, $username_or_email, $password, $ip_address, $user_agent) = @_;
    my $schema = $self->{schema};
    
    # Finde Benutzer
    my $user = $schema->resultset('User')->search({
        -or => [
            username => $username_or_email,
            email => $username_or_email,
        ],
    })->first;
    
    return { success => 0, error => 'Benutzer nicht gefunden' } unless $user;
    
    # Prüfe ob Benutzer aktiv ist
    return { success => 0, error => 'Benutzer ist deaktiviert' } unless $user->is_active;
    
    # Prüfe ob Benutzer gesperrt ist
    if ($user->locked_until) {
        my $locked_until = DateTime::Format::MySQL->parse_datetime($user->locked_until);
        if (DateTime->now < $locked_until) {
            return { success => 0, error => 'Benutzer ist gesperrt' };
        } else {
            # Sperre aufheben
            $user->update({
                locked_until => undef,
                failed_login_attempts => 0,
            });
        }
    }
    
    # Prüfe Passwort
    unless ($self->verify_password($password, $user->password_hash)) {
        my $attempts = $user->failed_login_attempts + 1;
        my $update_data = { failed_login_attempts => $attempts };
        
        # Nach 5 fehlgeschlagenen Versuchen für 30 Minuten sperren
        if ($attempts >= 5) {
            $update_data->{locked_until} = DateTime->now->add(minutes => 30)->strftime('%Y-%m-%d %H:%M:%S');
        }
        
        $user->update($update_data);
        return { success => 0, error => 'Ungültiges Passwort' };
    }
    
    # Login erfolgreich - setze Zähler zurück
    $user->update({
        failed_login_attempts => 0,
        locked_until => undef,
        last_login => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    
    # Erstelle Session
    my $session = $self->create_session($user->id, $ip_address, $user_agent);
    
    return {
        success => 1,
        user => $user,
        session_token => $session->session_token,
    };
}

sub has_permission {
    my ($self, $user, $resource, $action) = @_;
    return 0 unless $user;
    
    # Admin-Rolle hat alle Rechte
    my $admin_role = $self->{schema}->resultset('Role')->find({ name => 'admin' });
    if ($admin_role) {
        my $user_has_admin = $self->{schema}->resultset('UserRole')->find({
            user_id => $user->id,
            role_id => $admin_role->id,
        });
        return 1 if $user_has_admin;
    }
    
    # Prüfe Rechte über Rollen
    my $permission = $self->{schema}->resultset('Permission')->find({
        resource => $resource,
        action => $action,
    });
    
    return 0 unless $permission;
    
    # Prüfe ob Benutzer eine Rolle mit diesem Recht hat
    my $user_roles = $self->{schema}->resultset('UserRole')->search({
        user_id => $user->id,
    });
    
    while (my $user_role = $user_roles->next) {
        my $role_permission = $self->{schema}->resultset('RolePermission')->find({
            role_id => $user_role->role_id,
            permission_id => $permission->id,
        });
        return 1 if $role_permission;
    }
    
    return 0;
}

sub get_user_permissions {
    my ($self, $user) = @_;
    return [] unless $user;
    
    my @permissions = ();
    my $schema = $self->{schema};
    
    # Admin hat alle Rechte
    my $admin_role = $schema->resultset('Role')->find({ name => 'admin' });
    if ($admin_role) {
        my $user_has_admin = $schema->resultset('UserRole')->find({
            user_id => $user->id,
            role_id => $admin_role->id,
        });
        if ($user_has_admin) {
            # Lade alle Rechte
            my $all_permissions = $schema->resultset('Permission')->search({});
            while (my $perm = $all_permissions->next) {
                push @permissions, {
                    id => $perm->id,
                    name => $perm->name,
                    resource => $perm->resource,
                    action => $perm->action,
                };
            }
            return \@permissions;
        }
    }
    
    # Lade Rechte über Rollen
    my $user_roles = $schema->resultset('UserRole')->search({
        user_id => $user->id,
    });
    
    my %seen_permissions = ();
    while (my $user_role = $user_roles->next) {
        my $role_permissions = $schema->resultset('RolePermission')->search({
            role_id => $user_role->role_id,
        });
        
        while (my $role_perm = $role_permissions->next) {
            my $permission = $role_perm->permission;
            unless ($seen_permissions{$permission->id}) {
                push @permissions, {
                    id => $permission->id,
                    name => $permission->name,
                    resource => $permission->resource,
                    action => $permission->action,
                };
                $seen_permissions{$permission->id} = 1;
            }
        }
    }
    
    return \@permissions;
}

1;

