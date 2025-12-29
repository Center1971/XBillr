package XBillr::Middleware::Auth;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';
use XBillr::Service::AuthService;

sub register {
    my ($self, $app, $conf) = @_;
    
    # Helper für aktuellen Benutzer
    $app->helper(current_user => sub {
        my $c = shift;
        return $c->stash('current_user');
    });
    
    # Helper für Authentifizierung prüfen
    $app->helper(require_auth => sub {
        my $c = shift;
        
        # Prüfe verschiedene Möglichkeiten, den Authorization-Header zu lesen
        # Versuche zuerst die Standard-Methode
        my $auth_header = $c->req->headers->header('Authorization') || '';
        
        # Fallback: Versuche lowercase
        unless ($auth_header) {
            $auth_header = $c->req->headers->header('authorization') || '';
        }
        
        # Wenn immer noch leer, prüfe den rohen Request über to_hash
        unless ($auth_header) {
            my $headers_hash = $c->req->headers->to_hash;
            foreach my $key (keys %$headers_hash) {
                if (lc($key) eq 'authorization') {
                    my $value = $headers_hash->{$key};
                    $auth_header = ref($value) eq 'ARRAY' ? $value->[0] : $value;
                    last;
                }
            }
        }
        
        # Wenn immer noch leer, prüfe den rohen HTTP-Request-String
        unless ($auth_header) {
            # Versuche den Header direkt aus dem Request-String zu extrahieren
            my $raw_request = $c->req->to_string;
            if ($raw_request =~ /Authorization:\s*(.+?)(?:\r?\n|$)/i) {
                $auth_header = $1;
                $auth_header =~ s/\s+$//;
            }
        }
        
        $c->app->log->debug("require_auth: Authorization header = " . ($auth_header ? substr($auth_header, 0, 30) . "..." : "empty"));
        
        my $token = $auth_header;
        $token =~ s/^Bearer\s+//i;
        
        $c->app->log->debug("require_auth: token after processing = " . ($token ? substr($token, 0, 20) . "..." : "empty"));
        
        unless ($token) {
            $c->render(json => { error => 'Authentifizierung erforderlich' }, status => 401);
            return 0;
        }
        
        my $schema = $c->app->schema;
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        my $user = $auth_service->validate_session($token);
        
        $c->app->log->debug("require_auth: user = " . ($user ? $user->username : "undef"));
        
        unless ($user) {
            $c->render(json => { error => 'Ungültige oder abgelaufene Session' }, status => 401);
            return 0;
        }
        
        unless ($user->is_active) {
            $c->render(json => { error => 'Benutzer ist deaktiviert' }, status => 403);
            return 0;
        }
        
        $c->stash('current_user' => $user);
        return 1;
    });
    
    # Helper für Berechtigung prüfen
    $app->helper(require_permission => sub {
        my ($c, $resource, $action) = @_;
        
        my $user = $c->stash('current_user');
        unless ($user) {
            $c->render(json => { error => 'Authentifizierung erforderlich' }, status => 401);
            return 0;
        }
        
        my $schema = $c->app->schema;
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        
        unless ($auth_service->has_permission($user, $resource, $action)) {
            $c->render(json => { error => 'Keine Berechtigung für diese Aktion' }, status => 403);
            return 0;
        }
        
        return 1;
    });
}

1;
