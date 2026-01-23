package XBillr::Controller::Users;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Service::AuthService;
use XBillr::Service::EmailService;
use UUID::Tiny ':std';
use DateTime;

sub list {
    my $c = shift;
    
    $c->app->log->debug("Users::list called");
    
    eval {
        my $schema = $c->app->schema;
        my $users = $schema->resultset('User')->search({}, {
            order_by => 'created_at DESC',
        });
        
        my @result = ();
        while (my $user = $users->next) {
            # Lade Rollen
            my @roles = ();
            my $user_roles = $schema->resultset('UserRole')->search({
                user_id => $user->id,
            });
            while (my $ur = $user_roles->next) {
                push @roles, {
                    id => $ur->role->id,
                    name => $ur->role->name,
                };
            }
            
            push @result, {
                id => $user->id,
                username => $user->username,
                email => $user->email,
                firstName => $user->first_name,
                lastName => $user->last_name,
                isActive => $user->is_active ? 1 : 0,
                isEmailVerified => $user->is_email_verified ? 1 : 0,
                lastLogin => $user->last_login,
                roles => \@roles,
                createdAt => $user->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Users list error: $error");
        $c->render(json => { error => 'Fehler beim Laden der Benutzer' }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $current_user = $c->stash('current_user');
        
        # Validierung
        unless ($data->{username} && $data->{email} && $data->{password}) {
            return $c->render(json => { error => 'Benutzername, E-Mail und Passwort sind erforderlich' }, status => 400);
        }
        
        # Prüfe ob Benutzername bereits existiert
        if ($schema->resultset('User')->find({ username => $data->{username} })) {
            return $c->render(json => { error => 'Benutzername bereits vergeben' }, status => 400);
        }
        
        # Prüfe ob E-Mail bereits existiert
        if ($schema->resultset('User')->find({ email => $data->{email} })) {
            return $c->render(json => { error => 'E-Mail-Adresse bereits vergeben' }, status => 400);
        }
        
        # Erstelle Benutzer
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        my $password_hash = $auth_service->hash_password($data->{password});
        
        my $user = $schema->resultset('User')->create({
            id => create_uuid_as_string(UUID_V4),
            username => $data->{username},
            email => $data->{email},
            password_hash => $password_hash,
            first_name => $data->{firstName},
            last_name => $data->{lastName},
            is_active => $data->{isActive} // 1,
            is_email_verified => 0,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            created_by => $current_user ? $current_user->id : undef,
        });
        
        # Weise Standard-Rolle zu (falls angegeben)
        if ($data->{roleIds} && ref($data->{roleIds}) eq 'ARRAY') {
            foreach my $role_id (@{$data->{roleIds}}) {
                $schema->resultset('UserRole')->create({
                    id => create_uuid_as_string(UUID_V4),
                    user_id => $user->id,
                    role_id => $role_id,
                    assigned_by => $current_user ? $current_user->id : undef,
                    assigned_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        } else {
            # Standard-Rolle "user" zuweisen
            my $default_role = $schema->resultset('Role')->find({ name => 'user' });
            if ($default_role) {
                $schema->resultset('UserRole')->create({
                    id => create_uuid_as_string(UUID_V4),
                    user_id => $user->id,
                    role_id => $default_role->id,
                    assigned_by => $current_user ? $current_user->id : undef,
                    assigned_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        }
        
        # Sende E-Mail mit Login-Daten (falls angefordert)
        if ($data->{sendEmail}) {
            my $email_cfg = $c->app->config->{email} || {};
            my $email_service = XBillr::Service::EmailService->new(%$email_cfg);
            my $email_result = $email_service->send_login_credentials($user, $data->{password});
            if (!$email_result->{success}) {
                $c->app->log->warn("Failed to send login email: " . ($email_result->{error} || 'Unknown error'));
            }
        }
        
        # Lade Rollen für Antwort
        my @roles = ();
        my $user_roles = $schema->resultset('UserRole')->search({
            user_id => $user->id,
        });
        while (my $ur = $user_roles->next) {
            push @roles, {
                id => $ur->role->id,
                name => $ur->role->name,
            };
        }
        
        $c->render(json => {
            id => $user->id,
            username => $user->username,
            email => $user->email,
            firstName => $user->first_name,
            lastName => $user->last_name,
            isActive => $user->is_active ? 1 : 0,
            roles => \@roles,
            createdAt => $user->created_at,
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("User create error: $error");
        $c->render(json => { error => 'Fehler beim Erstellen des Benutzers' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $current_user = $c->stash('current_user');
        
        my $user = $schema->resultset('User')->find($id);
        unless ($user) {
            return $c->render(json => { error => 'Benutzer nicht gefunden' }, status => 404);
        }
        
        # Aktualisiere Benutzerdaten
        my $update_data = {
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        };
        
        $update_data->{first_name} = $data->{firstName} if exists $data->{firstName};
        $update_data->{last_name} = $data->{lastName} if exists $data->{lastName};
        $update_data->{is_active} = $data->{isActive} ? 1 : 0 if exists $data->{isActive};
        
        # Passwort ändern (falls angegeben)
        if ($data->{password}) {
            my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
            $update_data->{password_hash} = $auth_service->hash_password($data->{password});
        }
        
        $user->update($update_data);
        
        # Rollen aktualisieren (falls angegeben)
        if ($data->{roleIds} && ref($data->{roleIds}) eq 'ARRAY') {
            # Lösche alte Rollen
            $schema->resultset('UserRole')->search({
                user_id => $id,
            })->delete;
            
            # Füge neue Rollen hinzu
            foreach my $role_id (@{$data->{roleIds}}) {
                $schema->resultset('UserRole')->create({
                    id => create_uuid_as_string(UUID_V4),
                    user_id => $id,
                    role_id => $role_id,
                    assigned_by => $current_user ? $current_user->id : undef,
                    assigned_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        }
        
        # Lade aktualisierte Rollen
        my @roles = ();
        my $user_roles = $schema->resultset('UserRole')->search({
            user_id => $id,
        });
        while (my $ur = $user_roles->next) {
            push @roles, {
                id => $ur->role->id,
                name => $ur->role->name,
            };
        }
        
        $c->render(json => {
            id => $user->id,
            username => $user->username,
            email => $user->email,
            firstName => $user->first_name,
            lastName => $user->last_name,
            isActive => $user->is_active ? 1 : 0,
            roles => \@roles,
            updatedAt => $user->updated_at,
        }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("User update error: $error");
        $c->render(json => { error => 'Fehler beim Aktualisieren des Benutzers' }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        
        my $user = $schema->resultset('User')->find($id);
        unless ($user) {
            return $c->render(json => { error => 'Benutzer nicht gefunden' }, status => 404);
        }
        
        # Verhindere Löschen des eigenen Accounts
        my $current_user = $c->stash('current_user');
        if ($current_user && $current_user->id eq $id) {
            return $c->render(json => { error => 'Sie können Ihren eigenen Account nicht löschen' }, status => 400);
        }
        
        $user->delete;
        
        $c->render(json => { success => 1, message => 'Benutzer gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("User delete error: $error");
        $c->render(json => { error => 'Fehler beim Löschen des Benutzers' }, status => 500);
    };
}

sub send_credentials {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        my $user = $schema->resultset('User')->find($id);
        unless ($user) {
            return $c->render(json => { error => 'Benutzer nicht gefunden' }, status => 404);
        }
        
        # Generiere temporäres Passwort oder verwende vorhandenes
        my $password = $data->{password} || _generate_temp_password();
        
        # Setze neues Passwort
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        $user->update({
            password_hash => $auth_service->hash_password($password),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        # Sende E-Mail
        my $email_cfg = $c->app->config->{email} || {};
        my $email_service = XBillr::Service::EmailService->new(%$email_cfg);
        my $email_result = $email_service->send_login_credentials($user, $password);
        
        if ($email_result->{success}) {
            $c->render(json => { 
                success => 1, 
                message => 'Login-Daten wurden per E-Mail versendet',
                password => $password,  # Nur für Admin-Anzeige
            }, status => 200);
        } else {
            $c->render(json => { 
                success => 0,
                error => 'E-Mail konnte nicht versendet werden',
                password => $password,  # Fallback: Passwort zurückgeben
            }, status => 500);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Send credentials error: $error");
        $c->render(json => { error => 'Fehler beim Versenden der Login-Daten' }, status => 500);
    };
}

sub _generate_temp_password {
    my $length = 12;
    my @chars = ('a'..'z', 'A'..'Z', '0'..'9', '!', '@', '#', '$', '%');
    my $password = '';
    $password .= $chars[rand @chars] for 1..$length;
    return $password;
}

1;

