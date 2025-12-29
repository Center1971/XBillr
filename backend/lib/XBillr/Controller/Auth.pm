package XBillr::Controller::Auth;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Service::AuthService;
use XBillr::Service::EmailService;
use UUID::Tiny ':std';
use DateTime;

sub login {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        unless ($data->{username} && $data->{password}) {
            return $c->render(json => { error => 'Benutzername und Passwort sind erforderlich' }, status => 400);
        }
        
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        my $security = $c->app->security;
        my $ip_address = $security->get_client_ip($c);
        my $user_agent = $c->req->headers->user_agent || '';
        
        my $result = $auth_service->login(
            $data->{username},
            $data->{password},
            $ip_address,
            $user_agent
        );
        
        if ($result->{success}) {
            my $user = $result->{user};
            my $permissions = $auth_service->get_user_permissions($user);
            
            # Lade Rollen
            my @roles = ();
            my $user_roles = $schema->resultset('UserRole')->search({
                user_id => $user->id,
            });
            while (my $ur = $user_roles->next) {
                push @roles, {
                    id => $ur->role->id,
                    name => $ur->role->name,
                    description => $ur->role->description,
                };
            }
            
            $c->render(json => {
                success => 1,
                session_token => $result->{session_token},
                user => {
                    id => $user->id,
                    username => $user->username,
                    email => $user->email,
                    firstName => $user->first_name,
                    lastName => $user->last_name,
                    roles => \@roles,
                    permissions => $permissions,
                },
            }, status => 200);
        } else {
            $c->render(json => { error => $result->{error} }, status => 401);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Login error: $error");
        $c->render(json => { error => 'Anmeldung fehlgeschlagen' }, status => 500);
    };
}

sub logout {
    my $c = shift;
    
    eval {
        my $token = $c->req->headers->header('Authorization') || '';
        $token =~ s/^Bearer\s+//;
        
        if ($token) {
            my $schema = $c->app->schema;
            my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
            $auth_service->delete_session($token);
        }
        
        $c->render(json => { success => 1, message => 'Abmeldung erfolgreich' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Logout error: $error");
        $c->render(json => { error => 'Abmeldung fehlgeschlagen' }, status => 500);
    };
}

sub me {
    my $c = shift;
    
    eval {
        my $user = $c->stash('current_user');
        
        unless ($user) {
            return $c->render(json => { error => 'Nicht authentifiziert' }, status => 401);
        }
        
        my $schema = $c->app->schema;
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        my $permissions = $auth_service->get_user_permissions($user);
        
        # Lade Rollen
        my @roles = ();
        my $user_roles = $schema->resultset('UserRole')->search({
            user_id => $user->id,
        });
        while (my $ur = $user_roles->next) {
            push @roles, {
                id => $ur->role->id,
                name => $ur->role->name,
                description => $ur->role->description,
            };
        }
        
        $c->render(json => {
            id => $user->id,
            username => $user->username,
            email => $user->email,
            firstName => $user->first_name,
            lastName => $user->last_name,
            roles => \@roles,
            permissions => $permissions,
        }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Me error: $error");
        $c->render(json => { error => 'Fehler beim Laden der Benutzerdaten' }, status => 500);
    };
}

1;

