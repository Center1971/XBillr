package XBillr::Controller::Auth;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Service::AuthService;
use XBillr::Service::EmailService;
use UUID::Tiny ':std';
use DateTime;
use Mojo::URL;
use Mojo::UserAgent;
use Mojo::Util qw(b64_encode);
use Digest::SHA qw(sha256);
use MIME::Base64 qw(encode_base64url);
use Crypt::JWT qw(encode_jwt);

sub login {
    my $c = shift;
    
    # Lokaler Login (admin/admin123) wenn ?local=1
    if ($c->param('local')) {
        my $return_to = $c->param('return_to') || 'http://localhost:8080/index.html';
        return $c->redirect_to($c->url_for('local_login')->query(return_to => $return_to));
    }
    
    # Redirect to OAuth2/OIDC Authorization Code Flow
    $c->app->log->info("Login: Redirecting to OIDC authorization endpoint");
    
    my $iam = $c->app->config->{iam} || {};
    my $clients = $iam->{clients} || {};
    my $client = $clients->{web} || {};

    my $issuer = $iam->{issuer} || '';
    my $auth_endpoint = $iam->{authorization_endpoint} || '/protocol/openid-connect/auth';
    my $authorization_url = $auth_endpoint =~ m{^https?://}i
        ? $auth_endpoint
        : ($issuer =~ s{/$}{}r) . $auth_endpoint;

    my $state = create_uuid_as_string(UUID_V4);
    my $nonce = create_uuid_as_string(UUID_V4);
    my $scopes = $iam->{scopes} || 'openid profile email';
    $scopes =~ s/,\s*/ /g;

    $c->session(oidc_state => $state);
    $c->session(oidc_nonce => $nonce);
    $c->session(oidc_return_to => $c->param('return_to') || '/');
    $c->session(oidc_client => 'web');

    my %query = (
        response_type => 'code',
        client_id => $client->{client_id} || '',
        redirect_uri => $client->{redirect_uri} || '',
        scope => $scopes,
        state => $state,
        nonce => $nonce,
    );

    my $url = Mojo::URL->new($authorization_url)->query(\%query);
    return $c->redirect_to($url->to_string);
}

# Einfaches HTML-Formular für Benutzername/Passwort (ohne Keycloak)
sub local_login_form {
    my $c = shift;
    my $return_to = $c->param('return_to') || 'http://localhost:8080/index.html';
    my $error = $c->param('error') || '';
    my $api_base = $c->req->url->to_abs->base->to_string;
    $api_base =~ s{/$}{};
    my $action = "$api_base/api/auth/login";
    $c->render(
        inline => '<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>XBillr – Lokale Anmeldung</title>
<style>body{font-family:sans-serif;max-width:320px;margin:2rem auto;padding:1rem;}
input{width:100%%;padding:0.5rem;margin:0.25rem 0;} button{width:100%%;padding:0.6rem;margin-top:0.5rem;background:#0d6efd;color:#fff;border:0;cursor:pointer;}
.error{color:red;font-size:0.9rem;}</style></head>
<body>
<h1>XBillr – Lokale Anmeldung</h1>
<% if ($error) { %><p class="error"><%= $error %></p><% } %>
<form method="post" action="<%= $action %>">
<input type="hidden" name="return_to" value="<%= $return_to %>">
<label>Benutzername</label><input type="text" name="username" required autocomplete="username">
<label>Passwort</label><input type="password" name="password" required autocomplete="current-password">
<button type="submit">Anmelden</button>
</form>
</body></html>',
        return_to => $return_to,
        error => $error,
        action => $action,
    );
}

# POST Login (Benutzername/Passwort) – setzt Session-Cookie
sub login_post {
    my $c = shift;
    my $username = $c->param('username') || ($c->req->json && $c->req->json->{username});
    my $password = $c->param('password') || ($c->req->json && $c->req->json->{password});
    my $return_to = $c->param('return_to') || ($c->req->json && $c->req->json->{return_to}) || 'http://localhost:8080/index.html';
    
    unless ($username && $password) {
        return $c->redirect_to($c->url_for('local_login')->query(return_to => $return_to, error => 'Benutzername und Passwort erforderlich'));
    }
    
    my $schema = $c->app->schema or return $c->render(json => { error => 'Datenbank nicht verfügbar' }, status => 503);
    my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
    my $result = $auth_service->login($username, $password, $c->tx->remote_address || '', $c->req->headers->user_agent || '');
    
    unless ($result->{success}) {
        my $err = $result->{error} || 'Anmeldung fehlgeschlagen';
        return $c->redirect_to($c->url_for('local_login')->query(return_to => $return_to, error => $err));
    }
    
    # Session-Cookie setzen (HttpOnly, 7 Tage)
    $c->cookie(xbillr_session => $result->{session_token}, {
        path => '/',
        max_age => 7 * 24 * 3600,
        httponly => 1,
        samesite => 'Lax',
    });
    
    # Redirect zum Frontend
    return $c->redirect_to($return_to);
}

sub oidc_login {
    my $c = shift;

    my $iam = $c->app->config->{iam} || {};
    my $clients = $iam->{clients} || {};
    my $client_type = $c->param('client') || 'web';
    my $client = $clients->{$client_type} || $clients->{web} || {};

    my $issuer = $iam->{issuer} || '';
    my $auth_endpoint = $iam->{authorization_endpoint} || '/protocol/openid-connect/auth';
    my $authorization_url = $auth_endpoint =~ m{^https?://}i
        ? $auth_endpoint
        : ($issuer =~ s{/$}{}r) . $auth_endpoint;

    my $state = create_uuid_as_string(UUID_V4);
    my $nonce = create_uuid_as_string(UUID_V4);
    my $scopes = $iam->{scopes} || 'openid,profile,email';
    $scopes =~ s/,\s*/ /g;

    $c->session(oidc_state => $state);
    $c->session(oidc_nonce => $nonce);
    $c->session(oidc_return_to => $c->param('return_to') || '/');
    $c->session(oidc_client => $client_type);

    my %query = (
        response_type => 'code',
        client_id => $client->{client_id} || '',
        redirect_uri => $client->{redirect_uri} || '',
        scope => $scopes,
        state => $state,
        nonce => $nonce,
    );

    if ($client->{pkce_required}) {
        my $verifier = encode_base64url(_random_bytes(32));
        my $challenge = encode_base64url(sha256($verifier));
        $c->session(oidc_code_verifier => $verifier);
        $query{code_challenge} = $challenge;
        $query{code_challenge_method} = 'S256';
    }

    my $url = Mojo::URL->new($authorization_url)->query(\%query);
    return $c->redirect_to($url->to_string);
}

sub oidc_callback {
    my $c = shift;

    my $code = $c->param('code') || '';
    my $state = $c->param('state') || '';
    my $expected_state = $c->session('oidc_state') || '';

    unless ($code && $state && $state eq $expected_state) {
        $c->app->log->warn("OIDC callback: invalid state");
        return $c->render(json => { error => 'Ungültiger Login-Status' }, status => 400);
    }

    my $iam = $c->app->config->{iam} || {};
    my $clients = $iam->{clients} || {};
    my $client_type = $c->session('oidc_client') || 'web';
    my $client = $clients->{$client_type} || $clients->{web} || {};

    my $issuer = $iam->{issuer} || '';
    my $token_endpoint = $iam->{token_endpoint} || '/protocol/openid-connect/token';
    my $token_url = $token_endpoint =~ m{^https?://}i
        ? $token_endpoint
        : ($issuer =~ s{/$}{}r) . $token_endpoint;

    my $client_id = $client->{client_id} || '';
    my $client_secret = $client->{client_secret} || '';
    my $redirect_uri = $client->{redirect_uri} || '';
    my $private_key_pem = $client->{private_key_pem} || '';

    unless ($client_id && $redirect_uri) {
        return $c->render(json => { error => 'IAM-Konfiguration unvollständig' }, status => 500);
    }

    unless ($client_secret || $private_key_pem) {
        return $c->render(json => { error => 'Client-Authentifizierung nicht konfiguriert' }, status => 500);
    }

    my %form = (
        grant_type => 'authorization_code',
        code => $code,
        redirect_uri => $redirect_uri,
        client_id => $client_id,
    );

    # Support both client_secret and private_key_jwt authentication
    if ($private_key_pem) {
        my $now = time();
        my $assertion = encode_jwt(
            payload => {
                iss => $client_id,
                sub => $client_id,
                aud => $token_url,
                iat => $now,
                exp => $now + 300,
                jti => create_uuid_as_string(UUID_V4),
            },
            key => $private_key_pem,
            alg => 'RS256',
        );
        $form{client_assertion_type} = 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer';
        $form{client_assertion} = $assertion;
    } elsif ($client_secret) {
        $form{client_secret} = $client_secret;
    }

    if ($client->{pkce_required}) {
        my $verifier = $c->session('oidc_code_verifier') || '';
        $form{code_verifier} = $verifier if $verifier;
    }

    my $ua = _oidc_user_agent($iam);
    my $res = $ua->post($token_url => form => \%form)->result;

    unless ($res->is_success) {
        my $status = $res->code || 'unknown';
        my $body = $res->body || '';
        $c->app->log->error("OIDC token exchange failed ($status): $body");
        return $c->render(json => { error => 'Tokenaustausch fehlgeschlagen' }, status => 502);
    }

    my $payload = $res->json || {};
    my $access_token = $payload->{access_token} || '';
    my $refresh_token = $payload->{refresh_token};
    my $id_token = $payload->{id_token};
    my $expires_in = $payload->{expires_in} || 3600;

    unless ($access_token) {
        return $c->render(json => { error => 'Zugriffstoken fehlt' }, status => 502);
    }

    my $validated = $c->validate_jwt_token($access_token);
    if ($validated->{error}) {
        my $status = $validated->{error} eq 'roles' ? 403 : 401;
        my $message = $validated->{error} eq 'roles'
            ? 'Keine Berechtigung für diese Aktion'
            : 'Ungültiges Zugriffstoken';
        return $c->render(json => { error => $message }, status => $status);
    }

    my $claims = $validated->{claims};
    my $roles = $validated->{roles} || [];
    my $groups = $validated->{groups} || [];

    # Store tokens in session only if configured (can cause cookie overflow)
    if ($iam->{store_session_tokens}) {
        my $expires_at = time() + $expires_in;
        $c->session(oidc => {
            access_token => $access_token,
            refresh_token => $refresh_token,
            id_token => $id_token,
            expires_at => $expires_at,
        });
    }
    
    # Always store user info in session for authentication
    $c->session(expiration => $expires_in);
    $c->session(user_info => {
        sub => $claims->{sub},
        username => $claims->{preferred_username} || $claims->{username} || $claims->{email},
        email => $claims->{email},
        given_name => $claims->{given_name},
        family_name => $claims->{family_name},
        roles => $roles,
        groups => $groups,
    });

    # Auto-provision local user if enabled
    if ($iam->{auto_provision}) {
        eval {
            my $schema = $c->app->schema;
            my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
            my $username = $claims->{preferred_username} || $claims->{username} || $claims->{email};
            my $email = $claims->{email};
            
            my $local_user = $schema->resultset('User')->find({ username => $username })
                || $schema->resultset('User')->find({ email => $email });
            
            unless ($local_user) {
                $local_user = $schema->resultset('User')->create({
                    id => create_uuid_as_string(UUID_V4),
                    username => $username,
                    email => $email,
                    password_hash => $auth_service->hash_password(create_uuid_as_string(UUID_V4)),
                    first_name => $claims->{given_name},
                    last_name => $claims->{family_name},
                    is_active => 1,
                    is_email_verified => 1,
                    created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
                $c->app->log->info("Auto-provisioned user: $username");
            }
        };
        if ($@) {
            $c->app->log->error("Auto-provision failed: $@");
        }
    }

    # Clean up OIDC session state
    $c->session(oidc_state => undef);
    $c->session(oidc_nonce => undef);
    $c->session(oidc_code_verifier => undef);

    # Redirect to frontend with full URL
    my $return_path = $c->session('oidc_return_to') || '/index.html';
    $c->session(oidc_return_to => undef);
    
    my $frontend_url = $iam->{frontend_url} || 'http://localhost:8082';
    my $redirect_url = $frontend_url . $return_path;
    
    return $c->redirect_to($redirect_url);
}

sub oidc_logout {
    my $c = shift;

    $c->session(expires => 1);
    $c->session(oidc => undef);
    $c->render(openapi => { success => 1, message => 'Abmeldung erfolgreich' }, status => 200);
}

sub _oidc_user_agent {
    my ($iam) = @_;
    my $ua = Mojo::UserAgent->new;
    $ua->inactivity_timeout(10);
    if (defined $iam->{tls_verify} && !$iam->{tls_verify}) {
        $ua->insecure(1);
    }
    return $ua;
}

sub logout {
    my $c = shift;
    
    eval {
        # Get tokens from session if they exist
        my $oidc = $c->session('oidc');
        my $access_token = $oidc->{access_token} if $oidc;
        
        # Clear session
        $c->session(expires => 1);
        $c->session(oidc => undef);
        $c->session(user_info => undef);
        
        # TODO: Optionally call Keycloak's logout endpoint
        # to invalidate the tokens in the IdP
        
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
        # Check for OIDC session first (BFF pattern)
        my $user_info = $c->session('user_info');
        
        if ($user_info) {
            # Session-authenticated user
            my @roles = map { { name => $_ } } @{$user_info->{roles} || []};
            
            $c->render(json => {
                id => $user_info->{sub},
                username => $user_info->{username},
                email => $user_info->{email},
                firstName => $user_info->{given_name} || '',
                lastName => $user_info->{family_name} || '',
                roles => \@roles,
                permissions => [],
                groups => $user_info->{groups} || [],
            }, status => 200);
            return;
        }
        
        # Fall back to auth_user from middleware (Bearer token auth)
        my $auth_user = $c->stash('auth_user');
        
        if ($auth_user && $auth_user->{type} && $auth_user->{type} eq 'oidc') {
            # OIDC Bearer token authentication
            my @roles = map { { name => $_ } } @{$auth_user->{roles} || []};
            
            $c->render(json => {
                id => $auth_user->{subject},
                username => $auth_user->{username},
                email => $auth_user->{email},
                firstName => $auth_user->{claims}->{given_name} || '',
                lastName => $auth_user->{claims}->{family_name} || '',
                roles => \@roles,
                permissions => [],
                groups => $auth_user->{groups} || [],
            }, status => 200);
            return;
        }
        
        # Legacy database authentication
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

sub _random_bytes {
    my ($len) = @_;
    my $data = '';
    if (open my $fh, '<:raw', '/dev/urandom') {
        read $fh, $data, $len;
        close $fh;
    }
    $data ||= create_uuid_as_string(UUID_V4) . time() . rand();
    return $data;
}

1;

