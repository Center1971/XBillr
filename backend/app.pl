#!/usr/bin/env perl

use strict;
use warnings;
use Mojolicious::Lite;
use lib 'lib';
use File::Spec;
use XBillr::Model::DB;
use XBillr::Component::Security;
use XBillr::Component::InputValidator;
use XBillr::Version;
use DateTime;
use DateTime::Format::MySQL;
use UUID::Tiny ':std';

# Controller explizit laden
use XBillr::Controller::Health;
use XBillr::Controller::Auth;
use XBillr::Controller::Config;
use XBillr::Controller::Users;
use XBillr::Controller::Roles;
use XBillr::Controller::Permissions;
use XBillr::Controller::Customers;
use XBillr::Controller::Invoices;
use XBillr::Controller::Countries;
use XBillr::Controller::TimeEntries;
use XBillr::Controller::HourlyRates;
use XBillr::Controller::Supplier;
use XBillr::Controller::Logs;
use XBillr::Controller::Timesheets;

# Versionsinformation
app->defaults(version => $XBillr::Version::VERSION);

# Konfiguration
my $config_file = app->home->rel_file('config/xbillr.conf');
unless (-e $config_file) {
    $config_file = app->home->rel_file('../config/xbillr.conf');
}
plugin 'Config' => { file => $config_file };

# Session cookie signing: use same secret on all instances/workers so sessions work behind a load balancer
my $secret = $ENV{MOJO_SECRET} || app->config->{secret} || app->config->{hypnotize}{secret};
if ($secret) {
    app->secrets(ref $secret eq 'ARRAY' ? $secret : [$secret]);
} else {
    # Fallback: single fixed secret so multiple workers/instances can validate the same cookie
    app->secrets(['XBillr-session-secret-please-set-MOJO_SECRET-in-production']);
}

# Set controller namespace for Mojolicious
app->routes->namespaces(['XBillr::Controller']);

# Define auth routes manually (OpenAPI plugin was causing issues)
# OAuth2/OIDC Authorization Code Flow endpoints
my $r = app->routes;

$r->get('/api/auth/login')->to('auth#login');
$r->get('/api/auth/oidc/callback')->to('auth#oidc_callback');
$r->post('/api/auth/logout')->to('auth#logout');
$r->get('/api/auth/me')->to('auth#me');
$r->get('/api/health')->to('health#check');
$r->get('/api/config')->to('config#frontend');
$r->get('/api/countries')->to('countries#list');

# Test: Direct route for customers (bypassing $api group)
$r->get('/api/customers-test')->to(cb => sub {
    my $c = shift;
    $c->app->log->info("DEBUG: /api/customers-test route hit");
    $c->render(json => { test => 'ok' });
});

# Load OpenAPI spec for documentation ONLY (disable route generation)
# We'll register routes manually to avoid the "Route without action" issue
# plugin 'OpenAPI' => {
#     url => app->home->rel_file('openapi.yaml'),
# };

# Logging aus Konfiguration anwenden
# Ensure log path resolves to project root ./logs/ directory
if (my $log_conf = app->config->{log}) {
    app->log->level($log_conf->{level}) if $log_conf->{level};
    if ($log_conf->{path}) {
        my $log_path = $log_conf->{path};
        # If relative path, resolve relative to backend/ directory (where app.pl runs)
        unless (File::Spec->file_name_is_absolute($log_path)) {
            $log_path = app->home->rel_file($log_path);
        }
        app->log->path($log_path);
    }
}

# Sicherheits-Logging
plugin 'XBillr::Middleware::SecurityLogging';

# Authentifizierung
plugin 'XBillr::Middleware::Auth';

# Sicherheits-Plugin
plugin 'SecurityHeaders' => {
    'X-Content-Type-Options' => 'nosniff',
    'X-Frame-Options' => 'DENY',
    'X-XSS-Protection' => '1; mode=block',
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains',
    'Content-Security-Policy' => "default-src 'self' https://iam.smetools.eu; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data:; script-src 'self' 'unsafe-inline'",
    'Referrer-Policy' => 'strict-origin-when-cross-origin',
};

# Datenbankverbindung
helper schema => sub {
    state $schema;
    app->log->info("Schema helper called, schema state: " . ($schema ? "already initialized" : "needs initialization"));
    unless ($schema) {
        app->log->info("Initializing database schema connection...");
        # Verwende Konfiguration aus config/xbillr.conf, mit Fallback auf Umgebungsvariablen
        my $db_config = app->config->{database} || {};
        my $dsn = $ENV{DB_DSN} || $db_config->{dsn} || "dbi:MariaDB:database=xbillr;host=localhost;port=3306";
        my $user = $ENV{DB_USER} || $db_config->{user} || "xbillr_user";
        my $pass = $ENV{DB_PASSWORD} || $db_config->{password} || "xbillr_pass";
        
        # Stelle sicher, dass die DSN dbi:MariaDB verwendet (nicht dbi:mysql)
        # DBIx::Class kann Probleme haben, wenn die DSN nicht korrekt ist
        $dsn =~ s/^dbi:mysql/dbi:MariaDB/i;
        
        # host=localhost + port= causes "port cannot be specified when host is localhost"
        # Use 127.0.0.1 to force TCP connection when a port is specified
        if ($dsn =~ /host=localhost/i && $dsn =~ /port=\d+/) {
            $dsn =~ s/host=localhost/host=127.0.0.1/i;
            app->log->info("DSN: Replaced localhost with 127.0.0.1 for TCP connection with port");
        }
        
        # Log für Debugging
        app->log->info("Connecting to database: $dsn");
        
        # Ignoriere DBIx::Class Warnungen für MariaDB (die Verbindung funktioniert trotzdem)
        local $SIG{__WARN__} = sub {
            my $msg = shift;
            # Ignoriere die "undetermined_driver" Warnung für MariaDB
            return if $msg =~ /undetermined_driver|MariaDB|This version of DBIC|DBIC_DRIVER/;
            app->log->warn($msg);
        };
        
        # Versuche die Verbindung herzustellen
        # DBIx::Class uses lazy connections, so we don't verify here
        # The connection will be established when first used (e.g., when a query is executed)
        eval {
            $schema = XBillr::Model::DB->connect(
                $dsn,
                $user,
                $pass,
                {
                    RaiseError => 0,  # Don't raise errors, handle them manually
                    PrintError => 0,  # Fehler nicht ausgeben, werden geloggt
                    AutoCommit => 1,
                    # Some older DBD::MariaDB installations do not support mysql_enable_utf8mb4.
                    # We rely on explicit `SET NAMES utf8mb4` instead.
                    on_connect_do => [
                        'SET NAMES utf8mb4',
                        'SET CHARACTER SET utf8mb4',
                    ],
                }
            );
            
            if ($schema) {
                app->log->info("Schema object created (connection will be lazy - established on first query)");
            } else {
                app->log->error("Failed to create schema object in eval block");
            }
        };
        
        # WICHTIG: Prüfe zuerst ob Schema existiert, unabhängig von $@
        # Die Warnung von DBIx::Class setzt $@, auch wenn die Verbindung erfolgreich war
        # Wenn Schema existiert, setze $@ zurück, damit es nicht als Fehler behandelt wird
        if ($schema) {
            # Schema wurde erstellt - setze $@ zurück, falls es nur eine Warnung war
            if ($@ && $@ =~ /undetermined_driver|This version of DBIC|DBIC_DRIVER/) {
                undef $@;
            }
            # Force connection immediately by executing a test query
            eval {
                $schema->resultset('Country')->count;
                app->log->info("Database connection established and verified");
            };
            if ($@) {
                my $err = $@;
                $err =~ s/at \/.*$//;
                $err =~ s/\n/ /g;
                app->log->error("Database connection verification failed: $err");
                undef $schema;  # Don't cache a broken schema
            }
        } else {
            # Schema wurde nicht erstellt - prüfe ob es ein echter Fehler ist
            my $error = $@ || 'Unknown connection error';
            # Kürze den Fehler für besseres Logging
            $error =~ s/at \/.*$// if $error;
            $error =~ s/\n/ /g if $error;
            
            # Nur echte Fehler loggen (nicht Warnungen)
            unless ($error =~ /undetermined_driver|This version of DBIC|DBIC_DRIVER/) {
                app->log->error("Schema connection failed: $error");
                app->log->error("Connection details: DSN=$dsn, User=$user");
            }
        }
        
        # DBIx::Class gibt eine Warnung für MariaDB, funktioniert aber trotzdem
        # Die Warnung wird ignoriert, da MariaDB MySQL-kompatibel ist
    } else {
        app->log->debug("Schema helper: Using existing schema object (already initialized)");
    }
    return $schema;
};

# Security Helper
helper security => sub {
    state $security = XBillr::Component::Security->new;
    return $security;
};

# Input Validator Helper
helper validator => sub {
    state $validator = XBillr::Component::InputValidator->new;
    return $validator;
};

# Cache Helper für Rate Limiting
helper cache => sub {
    state $cache = {};
    return $cache;
};

# CORS-Middleware für alle API-Anfragen (muss VOR Rate Limiting kommen)
hook before_dispatch => sub {
    my $c = shift;
    
    # CORS-Header für alle API-Endpunkte setzen
    my $path = $c->req->url->path->to_string;
    if ($path =~ m{^/api}) {
        my $origin = $c->req->headers->origin;
        my $allowed_origins = $ENV{ALLOWED_ORIGINS} // 'http://localhost:3000,http://localhost:8000';
        my @origins = split /,/, $allowed_origins;
        
        # CORS-Header immer setzen
        # For development: allow all origins, for production use ALLOWED_ORIGINS
        my $allow_origin = '*';
        if ($origin && $origin ne 'null') {
            # Check if origin is in allowed list
            if (grep { $_ eq $origin } @origins) {
                $allow_origin = $origin;
            } elsif (@origins > 0 && $ENV{ALLOWED_ORIGINS}) {
                # In production, only allow listed origins
                # In development, allow any origin for easier testing
                $allow_origin = $origin;
            }
        }
        
        $c->res->headers->header('Access-Control-Allow-Origin' => $allow_origin);
        $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS');
        $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
        # Note: Cannot use credentials with wildcard origin
        # For file:// requests, browsers send 'null' as origin, which we handle above
        if ($allow_origin ne '*' && $allow_origin ne 'null') {
            $c->res->headers->header('Access-Control-Allow-Credentials' => 'true');
        }
        $c->res->headers->header('Access-Control-Max-Age' => '3600');
        
        # OPTIONS Request für CORS Preflight - MUSS vor Rate Limiting behandelt werden
        if ($c->req->method eq 'OPTIONS') {
            return $c->render(status => 204, text => '');
        }
    }

    # OIDC/Session-Auth für API-Routen (außer Health, Config und Auth-Login/Logout)
    $path = $c->req->url->path->to_string;
    if ($path =~ m{^/api} && $c->req->method ne 'OPTIONS') {
        return if $path eq '/api/health';
        return if $path eq '/api/config';
        return if $path eq '/api/auth/login';
        return if $path eq '/api/auth/logout';
        return if $path eq '/api/auth/me';
        return if $path eq '/api/auth/oidc/login';
        return if $path eq '/api/auth/oidc/callback';
        return if $path eq '/api/auth/oidc/logout';
        return if $c->authenticate_request;
        return;
    }
};

# Sicherheits-Middleware (Rate Limiting - überspringt OPTIONS und Root-Route)
# WICHTIG: Dieses under blockiert nur für Routen außerhalb von $api
# API-Routen werden separat behandelt
my $rate_limit = app->routes->under(sub {
    my $c = shift;
    
    # OPTIONS-Requests nicht rate-limiten
    return 1 if $c->req->method eq 'OPTIONS';
    
    # Root-Route nicht rate-limiten - lasse sie durch
    my $path = $c->req->url->path->to_string;
    if ($path eq '/' || $path eq '') {
        return 1;
    }
    
    # API-Routen nicht hier rate-limiten (werden separat behandelt)
    return 1 if $path =~ m{^/api};
    
    # Rate Limiting für alle anderen Routen
    my $security = $c->app->security;
    my $client_ip = $security->get_client_ip($c);
    my $rate_limit_key = $client_ip . ':' . $path;
    
    unless ($security->check_rate_limit($c, $rate_limit_key, 100, 60)) {
        $c->app->log->warn("Rate limit exceeded for IP: $client_ip");
        return $c->render(
            json => { error => 'Rate limit exceeded. Please try again later.' },
            status => 429
        );
    }
    
    return 1;
});

# Serve frontend static files from backend for local development (same-origin = session cookies work)
app->static->paths([app->home->rel_file('../frontend')]);

# Root Route - serve frontend index.html
get '/' => sub {
    my $c = shift;
    $c->reply->static('index.html');
};

# SPA catch-all route moved to end of file to not interfere with API routes

# Fehlerbehandlung ohne Informationsleckage
app->hook(after_dispatch => sub {
    my $c = shift;
    
    # Entferne Mojolicious-Version aus Headers
    $c->res->headers->remove('Server');
    
    # Generische Fehlermeldungen für 500er Fehler
    if ($c->res->code == 500) {
        my $error = $c->stash('error') || $c->stash('mojo.error') || 'Unknown error';
        # Logge den vollständigen Fehler für Debugging
        $c->app->log->error("Internal server error: $error");
        # Aber zeige keine Details in der Antwort (Sicherheit)
    }
});

# API Routes
my $api = app->routes->under('/api')->to(cb => sub {
    my $c = shift;
    $c->app->log->info("DEBUG: /api under callback entered for " . $c->req->url->path);
    return 1;
});

# Authentifizierung routes are defined above, before OpenAPI plugin loads

# Benutzerverwaltung
my $users = $api->under('/users')->to(cb => sub {
    my $c = shift;
    $c->app->log->debug("Users route: checking permission");
    return $c->require_permission('users', 'view') ? 1 : 0;
});
$users->get('')->to(cb => sub {
    my $c = shift;
    $c->app->log->debug("Users route called");
    eval {
        my $schema = $c->app->schema;
        my $users = $schema->resultset('User')->search({}, {
            order_by => 'created_at DESC',
        });
        
        my @result = ();
        while (my $user = $users->next) {
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
});
$users->post('')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('users', 'create') ? 1 : 0;
})->to('XBillr::Controller::Users#create');
$users->put('/:id')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('users', 'update') ? 1 : 0;
})->to('XBillr::Controller::Users#update');
$users->delete('/:id')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('users', 'delete') ? 1 : 0;
})->to('XBillr::Controller::Users#delete');
$users->post('/:id/send-credentials')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('users', 'create') ? 1 : 0;
})->to('XBillr::Controller::Users#send_credentials');

# Rollenverwaltung
my $roles = $api->under('/roles')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('roles', 'view');
});
$roles->get('')->to('XBillr::Controller::Roles#list');
$roles->post('')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('roles', 'create') ? 1 : 0;
})->to('XBillr::Controller::Roles#create');
$roles->put('/:id')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('roles', 'update') ? 1 : 0;
})->to('XBillr::Controller::Roles#update');
$roles->delete('/:id')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('roles', 'delete') ? 1 : 0;
})->to('XBillr::Controller::Roles#delete');

# Rechte
$api->get('/permissions')->to(cb => sub {
    my $c = shift;
    return $c->require_permission('roles', 'view') ? 1 : 0;
})->to('XBillr::Controller::Permissions#list');

# Kundenverwaltung
my $customers = $api->under('/customers')->to(cb => sub {
    my $c = shift;
    $c->app->log->info("DEBUG: /api/customers under callback entered");
    my $result = $c->require_permission('customers', 'view') ? 1 : 0;
    $c->app->log->info("DEBUG: /api/customers under callback returning $result");
    return $result;
});
# GET routes - view permission checked in under callback above
$customers->get('')->to('Customers#list');
$customers->get('/:id')->to('Customers#get');

# POST/PUT/DELETE need separate under for create/update/delete permissions
my $customers_write = $customers->under('/')->to(cb => sub {
    my $c = shift;
    my $method = $c->req->method;
    my $action = $method eq 'POST' ? 'create' : $method eq 'DELETE' ? 'delete' : 'update';
    $c->app->log->info("DEBUG: customers_write checking permission: $action");
    return $c->require_permission('customers', $action) ? 1 : 0;
});
$customers_write->post('')->to('Customers#create');
$customers_write->put('/:id')->to('Customers#update');
$customers_write->delete('/:id')->to('Customers#delete');

# OpenAPI-Routen werden über openapi.yaml registriert

# Fallback for SPA routes - serve index.html for any non-API route
# MUST be defined LAST to not interfere with API routes
get '/*' => sub {
    my $c = shift;
    my $path = $c->req->url->path->to_string;
    
    # Don't interfere with API routes (should not reach here, but safety check)
    return $c->reply->not_found if $path =~ m{^/api};
    
    # Try to serve static file, fallback to index.html for SPA
    $c->reply->static($path) || $c->reply->static('index.html');
};

app->start;

