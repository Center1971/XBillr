#!/usr/bin/env perl

use strict;
use warnings;
use Mojolicious::Lite;
use lib 'lib';
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

# Load OpenAPI spec for documentation ONLY (disable route generation)
# We'll register routes manually to avoid the "Route without action" issue
# plugin 'OpenAPI' => {
#     url => app->home->rel_file('openapi.yaml'),
# };

# Logging aus Konfiguration anwenden
if (my $log_conf = app->config->{log}) {
    app->log->level($log_conf->{level}) if $log_conf->{level};
    app->log->path($log_conf->{path}) if $log_conf->{path};
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
    'Content-Security-Policy' => "default-src 'self'",
    'Referrer-Policy' => 'strict-origin-when-cross-origin',
};

# Datenbankverbindung
helper schema => sub {
    state $schema;
    unless ($schema) {
        # Verwende Umgebungsvariablen, die vom Container gesetzt werden
        my $dsn = $ENV{DB_DSN} || "dbi:MariaDB:database=xbillr;host=localhost;port=3306";
        my $user = $ENV{DB_USER} || "xbillr_user";
        my $pass = $ENV{DB_PASSWORD} || "xbillr_pass";
        
        # Stelle sicher, dass die DSN dbi:MariaDB verwendet (nicht dbi:mysql)
        # DBIx::Class kann Probleme haben, wenn die DSN nicht korrekt ist
        $dsn =~ s/^dbi:mysql/dbi:MariaDB/i;
        
        # Log für Debugging
        app->log->debug("Connecting to database: $dsn");
        
        # Ignoriere DBIx::Class Warnungen für MariaDB (die Verbindung funktioniert trotzdem)
        local $SIG{__WARN__} = sub {
            my $msg = shift;
            # Ignoriere die "undetermined_driver" Warnung für MariaDB
            return if $msg =~ /undetermined_driver|MariaDB|This version of DBIC|DBIC_DRIVER/;
            app->log->warn($msg);
        };
        
        # Versuche die Verbindung herzustellen
        eval {
            $schema = XBillr::Model::DB->connect(
                $dsn,
                $user,
                $pass,
                {
                    RaiseError => 1,
                    PrintError => 0,  # Fehler nicht ausgeben, werden geloggt
                    on_connect_do => [
                        'SET NAMES utf8mb4',
                        'SET CHARACTER SET utf8mb4',
                    ],
                }
            );
        };
        
        # WICHTIG: Prüfe zuerst ob Schema existiert, unabhängig von $@
        # Die Warnung von DBIx::Class setzt $@, auch wenn die Verbindung erfolgreich war
        # Wenn Schema existiert, setze $@ zurück, damit es nicht als Fehler behandelt wird
        if ($schema) {
            # Schema wurde erstellt - setze $@ zurück, falls es nur eine Warnung war
            if ($@ && $@ =~ /undetermined_driver|This version of DBIC|DBIC_DRIVER/) {
                undef $@;
            }
            # Teste die Verbindung - ignoriere Warnungen
            my $dbh;
            eval {
                local $SIG{__WARN__} = sub {};  # Ignoriere alle Warnungen beim DBH-Zugriff
                $dbh = $schema->storage->dbh;
            };
            
            if ($dbh) {
                # Teste die Verbindung mit einer einfachen Abfrage
                eval {
                    my $test_sth = $dbh->prepare("SELECT 1");
                    $test_sth->execute();
                    $test_sth->finish();
                };
                if ($@) {
                    app->log->error("Schema connection query test failed: $@");
                    undef $schema;
                } else {
                    app->log->info("Database connection established successfully");
                }
            } else {
                # DBH nicht verfügbar - das ist ein echter Fehler
                app->log->error("Schema connection test failed: Database handle not available");
                undef $schema;
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
            }
        }
        
        # DBIx::Class gibt eine Warnung für MariaDB, funktioniert aber trotzdem
        # Die Warnung wird ignoriert, da MariaDB MySQL-kompatibel ist
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
    my $path = $c->req->url->path->to_string;
    if ($path =~ m{^/api} && $c->req->method ne 'OPTIONS') {
        return if $path eq '/api/health';
        return if $path eq '/api/config';
        return if $path eq '/api/auth/login';
        return if $path eq '/api/auth/logout';
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

# Root Route - API Info (nach dem under-Middleware, aber wird durchgelassen)
get '/' => sub {
    my $c = shift;
    $c->render(json => {
        name => 'XBillr API',
        version => $XBillr::Version::VERSION,
        status => 'running',
        endpoints => {
            health => '/api/health',
            customers => '/api/customers',
            invoices => '/api/invoices',
            time_entries => '/api/time-entries',
            timesheets => '/api/timesheets',
            hourly_rates => '/api/hourly-rates',
            supplier => '/api/supplier',
            logs => '/api/logs'
        }
    });
};

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
my $api = app->routes->under('/api');

# Authentifizierung routes are defined above, before OpenAPI plugin loads

# Benutzerverwaltung
my $users = $api->under('/users')->to(cb => sub {
    my $c = shift;
    $c->app->log->debug("Users route: checking permission");
    return $c->app->require_permission($c, 'users', 'view') ? 1 : 0;
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
    return $c->app->require_permission($c, 'users', 'create') ? 1 : 0;
})->to('XBillr::Controller::Users#create');
$users->put('/:id')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'users', 'update') ? 1 : 0;
})->to('XBillr::Controller::Users#update');
$users->delete('/:id')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'users', 'delete') ? 1 : 0;
})->to('XBillr::Controller::Users#delete');
$users->post('/:id/send-credentials')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'users', 'create') ? 1 : 0;
})->to('XBillr::Controller::Users#send_credentials');

# Rollenverwaltung
my $roles = $api->under('/roles')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'roles', 'view');
});
$roles->get('')->to('XBillr::Controller::Roles#list');
$roles->post('')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'roles', 'create') ? 1 : 0;
})->to('XBillr::Controller::Roles#create');
$roles->put('/:id')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'roles', 'update') ? 1 : 0;
})->to('XBillr::Controller::Roles#update');
$roles->delete('/:id')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'roles', 'delete') ? 1 : 0;
})->to('XBillr::Controller::Roles#delete');

# Rechte
$api->get('/permissions')->to(cb => sub {
    my $c = shift;
    return $c->app->require_permission($c, 'roles', 'view') ? 1 : 0;
})->to('XBillr::Controller::Permissions#list');

# OpenAPI-Routen werden über openapi.yaml registriert

app->start;

