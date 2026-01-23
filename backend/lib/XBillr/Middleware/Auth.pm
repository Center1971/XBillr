package XBillr::Middleware::Auth;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';
use Crypt::JWT qw(decode_jwt);
use Mojo::JSON qw(decode_json);
use Mojo::UserAgent;
use MIME::Base64 qw(decode_base64url);
use XBillr::Service::AuthService;

sub register {
    my ($self, $app, $conf) = @_;

    my $jwks_cache = {
        fetched_at => 0,
        ttl => 300,
        keys => {},
    };

    my $normalize_scopes = sub {
        my ($scopes_raw) = @_;
        return [] unless defined $scopes_raw;
        my @scopes = map {
            my $scope = $_;
            $scope =~ s/^\s+|\s+$//g;
            $scope;
        } split /,/, $scopes_raw;
        @scopes = grep { length $_ } @scopes;
        return \@scopes;
    };

    my $iam_config = sub {
        my $conf = $app->config->{iam} || {};
        my $issuer = $conf->{issuer} || 'https://keycloak.hurin.com/realms/xbillr';
        return {
            issuer => $issuer,
            authorization_endpoint => $conf->{authorization_endpoint} || '/protocol/openid-connect/auth',
            token_endpoint => $conf->{token_endpoint} || '/protocol/openid-connect/token',
            jwks_uri => $conf->{jwks_uri} || '/protocol/openid-connect/certs',
            scopes => $normalize_scopes->($conf->{scopes} || 'openid,profile,email'),
            clients => $conf->{clients} || {},
        };
    };

    my $jwks_url = sub {
        my $iam = $iam_config->();
        my $jwks_uri = $iam->{jwks_uri} || '';
        return $jwks_uri if $jwks_uri =~ m{^https?://}i;
        my $issuer = $iam->{issuer};
        $issuer =~ s{/$}{};
        $jwks_uri =~ s{^/}{};
        return "$issuer/$jwks_uri";
    };

    my $fetch_jwks = sub {
        my $url = $jwks_url->();
        my $ua = Mojo::UserAgent->new;
        $ua->max_redirects(3);
        $ua->inactivity_timeout(10);
        my $res = $ua->get($url)->result;
        return unless $res->is_success;
        my $jwks = $res->json || eval { decode_json($res->body) } || {};
        return unless $jwks->{keys} && ref $jwks->{keys} eq 'ARRAY';
        my %keys_by_kid = map { $_->{kid} => $_ } grep { $_->{kid} } @{$jwks->{keys}};
        $jwks_cache->{keys} = \%keys_by_kid;
        $jwks_cache->{fetched_at} = time();
        return \%keys_by_kid;
    };

    my $get_jwk = sub {
        my ($kid) = @_;
        my $now = time();
        my $needs_refresh = ($now - $jwks_cache->{fetched_at}) > $jwks_cache->{ttl};
        my $keys = $jwks_cache->{keys};
        if ($needs_refresh || ($kid && !$keys->{$kid})) {
            $keys = $fetch_jwks->() || $jwks_cache->{keys};
        }
        return $kid ? $keys->{$kid} : (values %$keys)[0];
    };

    my $decode_header = sub {
        my ($token) = @_;
        my ($header_b64) = split /\./, $token;
        return unless $header_b64;
        my $decoded = eval { decode_base64url($header_b64) };
        return unless $decoded;
        my $header = eval { decode_json($decoded) };
        return $header if $header && ref $header eq 'HASH';
        return;
    };

    my $extract_roles = sub {
        my ($claims) = @_;
        my $resource_access = $claims->{resource_access} || {};
        my $iam = $iam_config->();
        my @clients = ();
        push @clients, $iam->{clients}{web}{client_id} if $iam->{clients}{web}{client_id};
        push @clients, $iam->{clients}{mobile}{client_id} if $iam->{clients}{mobile}{client_id};
        push @clients, qw(XBillr XBillr-Mobile) unless @clients;
        my @roles;
        for my $client (@clients) {
            my $client_access = $resource_access->{$client} || {};
            my $client_roles = $client_access->{roles};
            push @roles, @{$client_roles} if $client_roles && ref $client_roles eq 'ARRAY';
        }
        @roles = grep { $_ =~ /^XBillr-/ } @roles;
        my %seen = map { $_ => 1 } @roles;
        return [sort keys %seen];
    };

    my $extract_groups = sub {
        my ($claims) = @_;
        my $groups = $claims->{groups};
        return [] unless $groups && ref $groups eq 'ARRAY';
        return [sort @$groups];
    };

    my $audience_ok = sub {
        my ($claims) = @_;
        my $iam = $iam_config->();
        my @allowed;
        if ($iam->{clients}{web} && $iam->{clients}{web}{audience}) {
            push @allowed, $iam->{clients}{web}{audience};
        }
        if ($iam->{clients}{mobile} && $iam->{clients}{mobile}{audience}) {
            push @allowed, $iam->{clients}{mobile}{audience};
        }
        return 1 unless @allowed;
        my $aud = $claims->{aud};
        return 0 unless $aud;
        my @aud_list = ref($aud) eq 'ARRAY' ? @{$aud} : ($aud);
        for my $candidate (@aud_list) {
            return 1 if grep { $_ eq $candidate } @allowed;
        }
        return 0;
    };

    # Helper für aktuellen Benutzer (Session oder OIDC)
    $app->helper(current_user => sub {
        my $c = shift;
        return $c->stash('current_user');
    });

    $app->helper(auth_user => sub {
        my $c = shift;
        return $c->stash('auth_user');
    });

    $app->helper(current_tenant => sub {
        my $c = shift;
        my $auth_user = $c->stash('auth_user') || {};
        my $groups = $auth_user->{groups} || [];
        return $groups->[0] if $groups && ref $groups eq 'ARRAY' && @$groups;
        return undef;
    });

    $app->helper(require_tenant => sub {
        my $c = shift;
        my $tenant = $c->current_tenant;
        unless ($tenant) {
            $c->render(json => { error => 'Tenant-Zuordnung fehlt' }, status => 403);
            return 0;
        }
        return 1;
    });

    $app->helper(tenant_customer_ids => sub {
        my $c = shift;
        return $c->stash('tenant_customer_ids')
            if $c->stash('tenant_customer_ids');
        my $tenant = $c->current_tenant;
        return [] unless $tenant;
        my $schema = $c->app->schema;
        my $customers = $schema->resultset('Customer')->search({
            -or => [
                company => $tenant,
                name => $tenant,
            ],
        });
        my @ids;
        while (my $customer = $customers->next) {
            push @ids, $customer->id;
        }
        $c->stash('tenant_customer_ids' => \@ids);
        return \@ids;
    });

    # Helper für Authentifizierung prüfen (Session oder JWT)
    $app->helper(require_auth => sub {
        my $c = shift;
        return $c->authenticate_request;
    });

    $app->helper(validate_jwt_token => sub {
        my ($c, $token) = @_;
        my $header = $decode_header->($token) || {};
        my $kid = $header->{kid};
        my $jwk = $get_jwk->($kid);

        return { error => 'no_jwk' } unless $jwk;

        my $iam = $iam_config->();
        my $claims;
        eval {
            $claims = decode_jwt(
                token => $token,
                key => $jwk,
                accepted_alg => ['RS256', 'RS384', 'RS512'],
                verify_exp => 1,
                verify_iss => $iam->{issuer},
            );
        };

        return { error => 'invalid' } unless $claims;
        return { error => 'aud' } unless $audience_ok->($claims);

        my $roles = $extract_roles->($claims);
        return { error => 'roles' } unless $roles && @{$roles};

        return {
            claims => $claims,
            roles => $roles,
            groups => $extract_groups->($claims),
        };
    });

    $app->helper(authenticate_request => sub {
        my $c = shift;

        my $auth_header = $c->req->headers->header('Authorization') || '';
        unless ($auth_header) {
            $auth_header = $c->req->headers->header('authorization') || '';
        }
        unless ($auth_header) {
            my $headers_hash = $c->req->headers->to_hash;
            foreach my $key (keys %$headers_hash) {
                next unless lc($key) eq 'authorization';
                my $value = $headers_hash->{$key};
                $auth_header = ref($value) eq 'ARRAY' ? $value->[0] : $value;
                last;
            }
        }
        unless ($auth_header) {
            my $raw_request = $c->req->to_string;
            if ($raw_request =~ /Authorization:\s*(.+?)(?:\r?\n|$)/i) {
                $auth_header = $1;
                $auth_header =~ s/\s+$//;
            }
        }

        my $token = $auth_header || '';
        $token =~ s/^Bearer\s+//i;
        $token =~ s/^\s+|\s+$//g;

        # Check for session-based authentication first (BFF pattern)
        my $user_info = $c->session('user_info');
        if ($user_info && $user_info->{sub}) {
            # User is authenticated via session cookie
            $c->stash(auth_user => {
                type => 'oidc',
                subject => $user_info->{sub},
                username => $user_info->{username},
                email => $user_info->{email},
                claims => {
                    given_name => $user_info->{given_name},
                    family_name => $user_info->{family_name},
                },
                roles => $user_info->{roles} || [],
                groups => $user_info->{groups} || [],
            });
            return 1;
        }

        # Fall back to token-based authentication
        unless ($token) {
            my $session = $c->session('oidc') || {};
            $token = $session->{access_token} || '';
        }

        unless ($token) {
            $c->render(json => { error => 'Authentifizierung erforderlich' }, status => 401);
            return 0;
        }

        my $looks_like_jwt = ($token =~ tr/././) == 2;

        if ($looks_like_jwt) {
            my $validated = $c->validate_jwt_token($token);
            if ($validated->{error}) {
                $c->app->log->warn("OIDC: token validation failed: $validated->{error}");
                my $status = $validated->{error} eq 'roles' ? 403 : 401;
                my $message = $validated->{error} eq 'roles'
                    ? 'Keine Berechtigung für diese Aktion'
                    : 'Ungültiges Zugriffstoken';
                $c->render(json => { error => $message }, status => $status);
                return 0;
            }

            my $claims = $validated->{claims};
            my $roles = $validated->{roles};
            my $groups = $validated->{groups} || [];
            my $auth_user = {
                type => 'oidc',
                subject => $claims->{sub},
                username => $claims->{preferred_username} || $claims->{username} || $claims->{email},
                email => $claims->{email},
                roles => $roles,
                groups => $groups,
                claims => $claims,
            };

            $c->stash(auth_user => $auth_user);
            return 1;
        }

        my $schema = $c->app->schema;
        my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
        my $user = $auth_service->validate_session($token);

        unless ($user) {
            $c->render(json => { error => 'Ungültige oder abgelaufene Session' }, status => 401);
            return 0;
        }

        unless ($user->is_active) {
            $c->render(json => { error => 'Benutzer ist deaktiviert' }, status => 403);
            return 0;
        }

        $c->stash('current_user' => $user);
        $c->stash(auth_user => {
            type => 'session',
            subject => $user->id,
            username => $user->username,
            email => $user->email,
            roles => [],
        });
        return 1;
    });
    
    # Helper für Berechtigung prüfen
    $app->helper(require_permission => sub {
        my ($c, $resource, $action) = @_;

        my $auth_user = $c->stash('auth_user');
        unless ($auth_user) {
            $c->render(json => { error => 'Authentifizierung erforderlich' }, status => 401);
            return 0;
        }

        if ($auth_user->{type} && $auth_user->{type} eq 'oidc') {
            my %roles = map { $_ => 1 } @{$auth_user->{roles} || []};
            return 1 if $roles{'XBillr-Admin'};
            if ($action eq 'view') {
                return 1 if $roles{'XBillr-Tenant-Admin'} || $roles{'XBillr-User'} || $roles{'XBillr-Viewer'};
                return 1 if grep { $_ =~ /^XBillr-/ } keys %roles;
            }
            if ($action =~ /^(create|update|delete)$/) {
                return 1 if $roles{'XBillr-Tenant-Admin'};
            }
            $c->render(json => { error => 'Keine Berechtigung für diese Aktion' }, status => 403);
            return 0;
        }

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

    $app->helper(require_roles => sub {
        my ($c, $roles) = @_;
        my $auth_user = $c->stash('auth_user');
        unless ($auth_user) {
            $c->render(json => { error => 'Authentifizierung erforderlich' }, status => 401);
            return 0;
        }
        my %user_roles = map { $_ => 1 } @{$auth_user->{roles} || []};
        for my $role (@{$roles || []}) {
            return 1 if $user_roles{$role};
        }
        $c->render(json => { error => 'Keine Berechtigung für diese Aktion' }, status => 403);
        return 0;
    });
}

1;
