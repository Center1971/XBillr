package XBillr::Controller::Roles;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $roles = $schema->resultset('Role')->search({}, {
            order_by => 'name ASC',
        });
        
        my @result = ();
        while (my $role = $roles->next) {
            # Lade Rechte
            my @permissions = ();
            my $role_permissions = $schema->resultset('RolePermission')->search({
                role_id => $role->id,
            });
            while (my $rp = $role_permissions->next) {
                push @permissions, {
                    id => $rp->permission->id,
                    name => $rp->permission->name,
                    resource => $rp->permission->resource,
                    action => $rp->permission->action,
                };
            }
            
            push @result, {
                id => $role->id,
                name => $role->name,
                description => $role->description,
                isSystemRole => $role->is_system_role ? 1 : 0,
                permissions => \@permissions,
                createdAt => $role->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Roles list error: $error");
        $c->render(json => { error => 'Fehler beim Laden der Rollen' }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        unless ($data->{name}) {
            return $c->render(json => { error => 'Rollenname ist erforderlich' }, status => 400);
        }
        
        # Prüfe ob Rolle bereits existiert
        if ($schema->resultset('Role')->find({ name => $data->{name} })) {
            return $c->render(json => { error => 'Rolle bereits vorhanden' }, status => 400);
        }
        
        # Erstelle Rolle
        my $role = $schema->resultset('Role')->create({
            id => create_uuid_as_string(UUID_V4),
            name => $data->{name},
            description => $data->{description},
            is_system_role => 0,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        # Weise Rechte zu (falls angegeben)
        if ($data->{permissionIds} && ref($data->{permissionIds}) eq 'ARRAY') {
            my $current_user = $c->stash('current_user');
            foreach my $permission_id (@{$data->{permissionIds}}) {
                $schema->resultset('RolePermission')->create({
                    id => create_uuid_as_string(UUID_V4),
                    role_id => $role->id,
                    permission_id => $permission_id,
                    granted_by => $current_user ? $current_user->id : undef,
                    granted_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        }
        
        # Lade Rechte für Antwort
        my @permissions = ();
        my $role_permissions = $schema->resultset('RolePermission')->search({
            role_id => $role->id,
        });
        while (my $rp = $role_permissions->next) {
            push @permissions, {
                id => $rp->permission->id,
                name => $rp->permission->name,
                resource => $rp->permission->resource,
                action => $rp->permission->action,
            };
        }
        
        $c->render(json => {
            id => $role->id,
            name => $role->name,
            description => $role->description,
            isSystemRole => $role->is_system_role ? 1 : 0,
            permissions => \@permissions,
            createdAt => $role->created_at,
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Role create error: $error");
        $c->render(json => { error => 'Fehler beim Erstellen der Rolle' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        my $role = $schema->resultset('Role')->find($id);
        unless ($role) {
            return $c->render(json => { error => 'Rolle nicht gefunden' }, status => 404);
        }
        
        # System-Rollen können nicht geändert werden
        if ($role->is_system_role) {
            return $c->render(json => { error => 'System-Rollen können nicht geändert werden' }, status => 400);
        }
        
        # Aktualisiere Rollendaten
        my $update_data = {
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        };
        
        $update_data->{name} = $data->{name} if exists $data->{name};
        $update_data->{description} = $data->{description} if exists $data->{description};
        
        $role->update($update_data);
        
        # Rechte aktualisieren (falls angegeben)
        if ($data->{permissionIds} && ref($data->{permissionIds}) eq 'ARRAY') {
            # Lösche alte Rechte
            $schema->resultset('RolePermission')->search({
                role_id => $id,
            })->delete;
            
            # Füge neue Rechte hinzu
            my $current_user = $c->stash('current_user');
            foreach my $permission_id (@{$data->{permissionIds}}) {
                $schema->resultset('RolePermission')->create({
                    id => create_uuid_as_string(UUID_V4),
                    role_id => $id,
                    permission_id => $permission_id,
                    granted_by => $current_user ? $current_user->id : undef,
                    granted_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        }
        
        # Lade aktualisierte Rechte
        my @permissions = ();
        my $role_permissions = $schema->resultset('RolePermission')->search({
            role_id => $id,
        });
        while (my $rp = $role_permissions->next) {
            push @permissions, {
                id => $rp->permission->id,
                name => $rp->permission->name,
                resource => $rp->permission->resource,
                action => $rp->permission->action,
            };
        }
        
        $c->render(json => {
            id => $role->id,
            name => $role->name,
            description => $role->description,
            isSystemRole => $role->is_system_role ? 1 : 0,
            permissions => \@permissions,
            updatedAt => $role->updated_at,
        }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Role update error: $error");
        $c->render(json => { error => 'Fehler beim Aktualisieren der Rolle' }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        
        my $role = $schema->resultset('Role')->find($id);
        unless ($role) {
            return $c->render(json => { error => 'Rolle nicht gefunden' }, status => 404);
        }
        
        # System-Rollen können nicht gelöscht werden
        if ($role->is_system_role) {
            return $c->render(json => { error => 'System-Rollen können nicht gelöscht werden' }, status => 400);
        }
        
        $role->delete;
        
        $c->render(json => { success => 1, message => 'Rolle gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Role delete error: $error");
        $c->render(json => { error => 'Fehler beim Löschen der Rolle' }, status => 500);
    };
}

1;

