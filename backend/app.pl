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

# Versionsinformation
app->defaults(version => $XBillr::Version::VERSION);

# Konfiguration
plugin 'Config';

# Sicherheits-Logging
plugin 'XBillr::Middleware::SecurityLogging';

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
    if ($c->req->url->path->to_string =~ m{^/api}) {
        my $origin = $c->req->headers->origin;
        my $allowed_origins = $ENV{ALLOWED_ORIGINS} // 'http://localhost:3000,http://localhost:8000';
        my @origins = split /,/, $allowed_origins;
        
        # CORS-Header immer setzen
        if ($origin && grep { $_ eq $origin } @origins) {
            $c->res->headers->header('Access-Control-Allow-Origin' => $origin);
        } elsif ($origin) {
            # Origin vorhanden aber nicht erlaubt - trotzdem für lokale Entwicklung erlauben
            $c->res->headers->header('Access-Control-Allow-Origin' => $origin);
        } else {
            # Für API-Aufrufe ohne Origin
            $c->res->headers->header('Access-Control-Allow-Origin' => '*');
        }
        
        $c->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, PUT, DELETE, OPTIONS');
        $c->res->headers->header('Access-Control-Allow-Headers' => 'Content-Type, Authorization');
        $c->res->headers->header('Access-Control-Allow-Credentials' => 'true');
        $c->res->headers->header('Access-Control-Max-Age' => '3600');
        
        # OPTIONS Request für CORS Preflight - MUSS vor Rate Limiting behandelt werden
        if ($c->req->method eq 'OPTIONS') {
            return $c->render(status => 204, text => '');
        }
    }
};

# Sicherheits-Middleware (Rate Limiting - überspringt OPTIONS und Root-Route)
under sub {
    my $c = shift;
    
    # OPTIONS-Requests nicht rate-limiten
    return 1 if $c->req->method eq 'OPTIONS';
    
    # Root-Route nicht rate-limiten - lasse sie durch
    my $path = $c->req->url->path->to_string;
    if ($path eq '/' || $path eq '') {
        return 1;
    }
    
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
};

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

# Health Check - verwende Controller direkt als Callback
$api->get('/health' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $dbh;
        my $error_msg;
        
        eval {
            $dbh = $schema->storage->dbh;
        };
        if ($@ || !$dbh) {
            $error_msg = $@ || 'Database handle not available';
            $c->app->log->error("Health check - $error_msg");
            return $c->render(json => { 
                status => 'error', 
                version => $XBillr::Version::VERSION,
                error => 'Database connection failed',
                details => $error_msg
            }, status => 500);
        }
        
        # Test database connection
        my $count = 0;
        eval {
            my $sth = $dbh->prepare("SELECT COUNT(*) FROM customers");
            $sth->execute();
            my $row = $sth->fetchrow_arrayref();
            $count = $row->[0] if $row;
        };
        if ($@) {
            $error_msg = "Query failed: $@";
            $c->app->log->error("Health check - $error_msg");
            return $c->render(json => { 
                status => 'error', 
                version => $XBillr::Version::VERSION,
                error => 'Database connection failed'
            }, status => 500);
        }
        
        $c->render(json => { 
            status => 'ok',
            version => $XBillr::Version::VERSION,
            timestamp => time(),
            database => 'connected',
            customers => $count
        }, status => 200);
    } or do {
        my $error = $@ || 'Unknown error';
        $c->app->log->error("Health check error: $error");
        $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Health check failed',
            details => "$error"
        }, status => 500);
    };
});

# Customers
my $customers = $api->under('/customers');
$customers->get('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my @customers = $schema->resultset('Customer')->all;
        $c->render(json => [map {
            {
                id => $_->id,
                company => $_->company,
                name => $_->name,
                address => $_->address,
                zipCode => $_->zip_code,
                city => $_->city,
                country => $_->country,
                email => $_->email,
                paymentTerms => $_->payment_terms,
                defaultHourlyRate => $_->default_hourly_rate,
                defaultDailyRate => $_->default_daily_rate,
                taxRate => $_->tax_rate,
                reverseCharge => $_->reverse_charge ? 1 : 0,
            }
        } @customers], status => 200);
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$customers->post('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $data = $c->req->json;
        
        # Validierung
        unless ($data->{name} && $data->{address} && $data->{zipCode} && $data->{city}) {
            return $c->render(json => { error => 'Ansprechpartner, Adresse, PLZ und Stadt sind erforderlich' }, status => 400);
        }
        
        # UUID generieren
        use UUID::Tiny ':std';
        my $id = create_uuid_as_string(UUID_V4);
        
        # Kunde erstellen
        my $customer = $schema->resultset('Customer')->create({
            id => $id,
            company => $data->{company},
            name => $data->{name},
            address => $data->{address},
            zip_code => $data->{zipCode},
            city => $data->{city},
            country => $data->{country} || 'DE',
            email => $data->{email},
            payment_terms => $data->{paymentTerms},
            default_hourly_rate => $data->{defaultHourlyRate},
            default_daily_rate => $data->{defaultDailyRate},
            tax_rate => $data->{taxRate} || 19.00,
            reverse_charge => $data->{reverseCharge} ? 1 : 0,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => {
            id => $customer->id,
            company => $customer->company,
            name => $customer->name,
            address => $customer->address,
            zipCode => $customer->zip_code,
            city => $customer->city,
            country => $customer->country,
            email => $customer->email,
            paymentTerms => $customer->payment_terms,
            defaultHourlyRate => $customer->default_hourly_rate,
            defaultDailyRate => $customer->default_daily_rate,
            taxRate => $customer->tax_rate,
            reverseCharge => $customer->reverse_charge ? 1 : 0,
        }, status => 201);
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$customers->get('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $c->render(json => {
                id => $customer->id,
                company => $customer->company,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                defaultHourlyRate => $customer->default_hourly_rate,
                defaultDailyRate => $customer->default_daily_rate,
                taxRate => $customer->tax_rate,
                reverseCharge => $customer->reverse_charge ? 1 : 0,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$customers->put('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->update({
                company => $data->{company},
                name => $data->{name},
                address => $data->{address},
                zip_code => $data->{zipCode},
                city => $data->{city},
                country => $data->{country} || 'DE',
                email => $data->{email},
                payment_terms => $data->{paymentTerms},
                default_hourly_rate => $data->{defaultHourlyRate},
                default_daily_rate => $data->{defaultDailyRate},
                tax_rate => $data->{taxRate} || 19.00,
                reverse_charge => $data->{reverseCharge} ? 1 : 0,
            });
            
            $c->render(json => {
                id => $customer->id,
                company => $customer->company,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                defaultHourlyRate => $customer->default_hourly_rate,
                defaultDailyRate => $customer->default_daily_rate,
                taxRate => $customer->tax_rate,
                reverseCharge => $customer->reverse_charge ? 1 : 0,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$customers->delete('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->delete;
            $c->render(json => { success => 1 }, status => 200);
        } else {
            $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});

# Invoices
my $invoices = $api->under('/invoices');
# Offene Posten - nicht archivierte Rechnungen mit Zahlungsziel
# WICHTIG: Diese Route muss VOR der Route '/:id' stehen!
$invoices->get('/open-posts' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        
        # Hole alle archivierten Rechnungen mit Zahlungsziel
        my $invoices_rs = $schema->resultset('Invoice')->search(
            {
                archived => 1,
                due_date => { '!=' => undef },
            },
            {
                order_by => { -asc => 'created_at' },
                join => 'customer',
                '+select' => ['customer.company', 'customer.name'],
                '+as' => ['customer_company', 'customer_name'],
            }
        );
        
        my @result = ();
        while (my $invoice = $invoices_rs->next) {
            my $customer = $invoice->customer;
            push @result, {
                id => $invoice->id,
                invoiceNumber => $invoice->invoice_number,
                customerId => $invoice->customer_id,
                customerName => $customer ? ($customer->company || $customer->name || 'Unbekannt') : 'Unbekannt',
                createdAt => $invoice->created_at,
                total => $invoice->total,
                dueDate => $invoice->due_date,
                paymentTerms => $invoice->payment_terms,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error listing open posts: $error");
        $c->render(json => { error => 'Die offenen Posten konnten nicht geladen werden.', details => "$error" }, status => 500);
    };
});
$invoices->get('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        # Lade ALLE Rechnungen (sowohl archivierte als auch nicht-archivierte)
        # Sortiert nach Erstellungsdatum (neueste zuerst)
        my $invoices_rs = $schema->resultset('Invoice')->search({}, {
            order_by => { -desc => 'created_at' }
        });
        
        my @result;
        while (my $invoice = $invoices_rs->next) {
            # Hole Kundendaten für Anzeige
            my $customer = $invoice->customer;
            my $customer_name = '';
            if ($customer) {
                $customer_name = $customer->company || $customer->name || 'Unbekannt';
            }
            
            push @result, {
                id => $invoice->id,
                invoiceNumber => $invoice->invoice_number,
                customerId => $invoice->customer_id,
                customerName => $customer_name,
                dateFrom => $invoice->date_from,
                dateTo => $invoice->date_to,
                subtotal => $invoice->subtotal,
                taxRate => $invoice->tax_rate,
                taxAmount => $invoice->tax_amount,
                total => $invoice->total,
                taxType => $invoice->tax_type,
                status => $invoice->status,
                paymentTerms => $invoice->payment_terms,
                dueDate => $invoice->due_date,
                xrechnungXml => $invoice->xrechnung_xml,
                archived => $invoice->archived ? 1 : 0,
                archivedAt => $invoice->archived_at,
                createdAt => $invoice->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in invoices list: $error");
        $c->app->log->error("Stack trace: " . ($error->{stack} || 'N/A'));
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
    };
});
$invoices->get('/archived')->to('XBillr::Controller::Invoices#list_archived');
# POST Route als direkter Callback implementiert
$invoices->post('' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::InvoiceService;
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(schema => $schema);
        
        my $invoice = $service->create_invoice({
            customer_id => $data->{customerId},
            date_from => $data->{dateFrom},
            date_to => $data->{dateTo},
            tax_rate => $data->{taxRate},
            tax_type => $data->{taxType},
            payment_terms => $data->{paymentTerms},
            include_timesheet => $data->{includeTimesheet} // 0,
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice created: " . $invoice->id);
        
        $c->render(json => {
            id => $invoice->id,
            invoiceNumber => $invoice->invoice_number,
            customerId => $invoice->customer_id,
            dateFrom => $invoice->date_from,
            dateTo => $invoice->date_to,
            subtotal => $invoice->subtotal,
            taxRate => $invoice->tax_rate,
            taxAmount => $invoice->tax_amount,
            total => $invoice->total,
            taxType => $invoice->tax_type,
            status => $invoice->status,
            paymentTerms => $invoice->payment_terms,
            dueDate => $invoice->due_date,
            xrechnungXml => $invoice->xrechnung_xml,
            archived => $invoice->archived ? 1 : 0,
            archivedAt => $invoice->archived_at,
            createdAt => $invoice->created_at,
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error creating invoice: $error");
        
        # Generische Fehlermeldungen ohne interne Details
        if ($error =~ /nicht gefunden/ || $error =~ /Keine Zeiteinträge/) {
            $c->render(
                json => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte überprüfen Sie, ob alle erforderlichen Daten vorhanden sind.' },
                status => 400
            );
        } else {
            $c->render(
                json => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte versuchen Sie es erneut.', details => "$error" },
                status => 500
            );
        }
    };
});
# GET /:id Route als direkter Callback
$invoices->get('/:id' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::InvoiceService;
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        
        if ($invoice) {
            my $service = XBillr::Service::InvoiceService->new(schema => $schema);
            my $items_rs = $service->get_invoice_items($id);
            
            my $result = {
                id => $invoice->id,
                invoiceNumber => $invoice->invoice_number,
                customerId => $invoice->customer_id,
                dateFrom => $invoice->date_from,
                dateTo => $invoice->date_to,
                subtotal => $invoice->subtotal,
                taxRate => $invoice->tax_rate,
                taxAmount => $invoice->tax_amount,
                total => $invoice->total,
                taxType => $invoice->tax_type,
                status => $invoice->status,
                paymentTerms => $invoice->payment_terms,
                dueDate => $invoice->due_date,
                xrechnungXml => $invoice->xrechnung_xml,
                archived => $invoice->archived ? 1 : 0,
                archivedAt => $invoice->archived_at,
                createdAt => $invoice->created_at,
                items => [],
            };
            
            while (my $item = $items_rs->next) {
                push @{$result->{items}}, {
                    id => $item->id,
                    invoiceId => $item->invoice_id,
                    timeEntryId => $item->time_entry_id,
                    description => $item->description,
                    hours => $item->hours,
                    rate => $item->rate,
                    amount => $item->amount,
                    rateType => $item->rate_type,
                };
            }
            
            $c->render(json => $result, status => 200);
        } else {
            $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get invoice: $error");
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
});
# XML Export
$invoices->get('/:id/xml' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::XRechnungService;
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $service = XBillr::Service::XRechnungService->new(schema => $schema);
        
        my $xml = $service->generate_xrechnung_xml($id);
        
        # Speichere XML in der Datenbank
        my $invoice = $schema->resultset('Invoice')->find($id);
        if ($invoice) {
            $invoice->update({ xrechnung_xml => $xml });
        }
        
        $c->res->headers->content_type('application/xml; charset=utf-8');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="rechnung_' . $invoice->invoice_number . '.xml"');
        $c->render(data => $xml);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating XML: $error");
        $c->render(json => { error => 'Die XML-Datei konnte nicht generiert werden.' }, status => 500);
    };
});
# PDF Export
$invoices->get('/:id/pdf' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::PDFService;
        my $id = $c->stash('id');
        my $include_timesheet = $c->param('include_timesheet') || 0;
        my $schema = $c->app->schema;
        my $service = XBillr::Service::PDFService->new(schema => $schema);
        
        my $pdf_data = $service->generate_invoice_pdf($id, $include_timesheet);
        
        my $invoice = $schema->resultset('Invoice')->find($id);
        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="rechnung_' . ($invoice ? $invoice->invoice_number : $id) . '.pdf"');
        $c->render(data => $pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating PDF: $error");
        $c->render(json => { error => 'Die PDF-Datei konnte nicht generiert werden.' }, status => 500);
    };
});
$invoices->put('/:id')->to('XBillr::Controller::Invoices#update');
$invoices->post('/:id/correct' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::InvoiceService;
        my $id = $c->stash('id');
        my $data = $c->req->json;
        
        unless ($id) {
            return $c->render(json => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $original_invoice = $schema->resultset('Invoice')->find($id);
        
        unless ($original_invoice) {
            return $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
        
        unless ($original_invoice->archived) {
            return $c->render(json => { error => 'Nur archivierte Rechnungen können korrigiert werden.' }, status => 400);
        }
        
        # Erstelle neue Rechnung mit korrigierten Daten
        my $service = XBillr::Service::InvoiceService->new(schema => $schema);
        
        # Verwende die übergebenen Daten oder die Originaldaten
        my $customer_id = $data->{customerId} || $original_invoice->customer_id;
        my $date_from = $data->{dateFrom} || $original_invoice->date_from;
        my $date_to = $data->{dateTo} || $original_invoice->date_to;
        my $tax_rate = $data->{taxRate} || $original_invoice->tax_rate;
        my $tax_type = $data->{taxType} || $original_invoice->tax_type;
        my $payment_terms = $data->{paymentTerms} || $original_invoice->payment_terms;
        
        # Erstelle neue Rechnung
        my $new_invoice = $service->create_invoice({
            customer_id => $customer_id,
            date_from => $date_from,
            date_to => $date_to,
            tax_rate => $tax_rate,
            tax_type => $tax_type,
            payment_terms => $payment_terms,
            include_timesheet => 0,
        });
        
        # Ändere Rechnungsnummer zu Originalnummer + "-KOR"
        my $original_number = $original_invoice->invoice_number;
        my $corrected_number = $original_number . '-KOR';
        
        # Prüfe ob bereits eine Korrektur mit dieser Nummer existiert
        my $existing_correction = $schema->resultset('Invoice')->search({
            invoice_number => $corrected_number
        })->first;
        
        if ($existing_correction) {
            # Wenn bereits eine Korrektur existiert, füge einen Zähler hinzu
            my $counter = 1;
            my $new_corrected_number;
            do {
                $new_corrected_number = $corrected_number . '-' . $counter;
                $existing_correction = $schema->resultset('Invoice')->search({
                    invoice_number => $new_corrected_number
                })->first;
                $counter++;
            } while ($existing_correction);
            $corrected_number = $new_corrected_number;
        }
        
        # Aktualisiere Rechnungsnummer
        $new_invoice->update({
            invoice_number => $corrected_number
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice corrected: $id -> " . $new_invoice->id . " ($corrected_number)");
        
        $c->render(json => {
            id => $new_invoice->id,
            invoiceNumber => $corrected_number,
            message => 'Korrektur-Rechnung erfolgreich erstellt'
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error creating corrected invoice: $error");
        if ($error =~ /nicht gefunden/ || $error =~ /Keine Zeiteinträge/) {
            $c->render(json => { error => 'Die Korrektur-Rechnung konnte nicht erstellt werden. Bitte überprüfen Sie, ob alle erforderlichen Daten vorhanden sind.' }, status => 400);
        } else {
            $c->render(json => { error => 'Die Korrektur-Rechnung konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' }, status => 500);
        }
    };
});
$invoices->delete('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        
        unless ($invoice) {
            return $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
        
        # Lösche zuerst alle Invoice Items (Cascade Delete)
        eval {
            my $items = $schema->resultset('InvoiceItem')->search({ invoice_id => $id });
            while (my $item = $items->next) {
                $item->delete;
            }
        };
        if ($@) {
            $c->app->log->warn("Error deleting invoice items: $@");
            # Weiter mit dem Löschen der Rechnung
        }
        
        # Lösche dann die Rechnung
        $invoice->delete;
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice deleted: " . $id);
        
        $c->render(json => { message => 'Rechnung erfolgreich gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting invoice: $error");
        $c->render(json => { error => 'Die Rechnung konnte nicht gelöscht werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
    };
});
$invoices->post('/:id/archive' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::InvoiceService;
        my $id = $c->stash('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(schema => $schema);
        
        $service->archive_invoice($id);
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice archived: " . $id);
        
        $c->render(json => { message => 'Rechnung erfolgreich archiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error archiving invoice: $error");
        if ($error =~ /nicht gefunden/) {
            $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        } else {
            $c->render(json => { error => 'Die Rechnung konnte nicht archiviert werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
        }
    };
});
$invoices->post('/:id/unarchive' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::InvoiceService;
        my $id = $c->stash('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(schema => $schema);
        
        $service->unarchive_invoice($id);
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice unarchived: " . $id);
        
        $c->render(json => { message => 'Rechnung erfolgreich dearchiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error unarchiving invoice: $error");
        if ($error =~ /nicht gefunden/) {
            $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        } else {
            $c->render(json => { error => 'Die Rechnung konnte nicht dearchiviert werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
        }
    };
});
$invoices->post('/archived/:id/duplicate')->to('XBillr::Controller::Invoices#duplicate');

# Time Entries
my $time_entries = $api->under('/time-entries');
# WICHTIG: Spezifischere Routen müssen VOR /:id kommen!
# Stundenzettel PDF Export (MUSS ganz oben stehen, vor allen anderen Routen!)
$time_entries->get('/timesheet/:customer_id/pdf' => sub {
    my $c = shift;
    eval {
        use XBillr::Service::PDFService;
        use UUID::Tiny ':std';
        my $customer_id = $c->stash('customer_id');
        my $date_from = $c->param('date_from');
        my $date_to = $c->param('date_to');
        my $archive = $c->param('archive') || 0;
        
        unless ($customer_id && $date_from && $date_to) {
            return $c->render(json => { error => 'Kunden-ID, Datum von und Datum bis müssen angegeben werden.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $service = XBillr::Service::PDFService->new(schema => $schema);
        
        my $pdf_data = $service->generate_timesheet_pdf($customer_id, $date_from, $date_to);
        
        # Wenn archiviert werden soll, speichere den Stundenzettel in der Datenbank
        if ($archive) {
            my $timesheet_id = create_uuid_as_string(UUID_V4);
            $schema->resultset('Timesheet')->create({
                id => $timesheet_id,
                customer_id => $customer_id,
                date_from => $date_from,
                date_to => $date_to,
                pdf_data => $pdf_data,
                archived => 0,
                created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
        }
        
        my $customer = $schema->resultset('Customer')->find($customer_id);
        my $filename = 'stundenzettel_' . ($customer ? ($customer->company || $customer->name || $customer_id) : $customer_id) . '_' . $date_from . '_' . $date_to . '.pdf';
        $filename =~ s/[^a-zA-Z0-9._-]/_/g; # Bereinige Dateinamen
        
        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="' . $filename . '"');
        $c->render(data => $pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating timesheet PDF: $error");
        $c->render(json => { error => 'Die Stundenzettel-PDF konnte nicht generiert werden.', details => "$error" }, status => 500);
    };
});
# Timesheets API
my $timesheets = $api->under('/timesheets');
$timesheets->get('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $archived_only = $c->param('archived') || 0;
        
        my $timesheets_rs = $schema->resultset('Timesheet')->search(
            $archived_only ? { archived => 1 } : {},
            {
                order_by => { -desc => 'created_at' },
                join => 'customer',
                '+select' => ['customer.company', 'customer.name'],
                '+as' => ['customer_company', 'customer_name'],
            }
        );
        
        my @result = ();
        while (my $timesheet = $timesheets_rs->next) {
            my $customer = $timesheet->customer;
            push @result, {
                id => $timesheet->id,
                customerId => $timesheet->customer_id,
                customerName => $customer ? ($customer->company || $customer->name || 'Unbekannt') : 'Unbekannt',
                dateFrom => $timesheet->date_from,
                dateTo => $timesheet->date_to,
                description => $timesheet->description,
                archived => $timesheet->archived ? 1 : 0,
                archivedAt => $timesheet->archived_at,
                createdAt => $timesheet->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error listing timesheets: $error");
        $c->render(json => { error => 'Die Stundenzettel konnten nicht geladen werden.', details => "$error" }, status => 500);
    };
});
$timesheets->get('/:id/pdf' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        
        unless ($timesheet) {
            return $c->render(json => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }
        
        my $customer = $timesheet->customer;
        my $filename = 'stundenzettel_' . ($customer ? ($customer->company || $customer->name || $timesheet->customer_id) : $timesheet->customer_id) . '_' . $timesheet->date_from . '_' . $timesheet->date_to . '.pdf';
        $filename =~ s/[^a-zA-Z0-9._-]/_/g;
        
        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="' . $filename . '"');
        $c->render(data => $timesheet->pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error getting timesheet PDF: $error");
        $c->render(json => { error => 'Die Stundenzettel-PDF konnte nicht geladen werden.', details => "$error" }, status => 500);
    };
});
$timesheets->post('/:id/archive' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        
        unless ($timesheet) {
            return $c->render(json => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }
        
        $timesheet->update({
            archived => 1,
            archived_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => { success => 1, message => 'Stundenzettel erfolgreich archiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error archiving timesheet: $error");
        $c->render(json => { error => 'Der Stundenzettel konnte nicht archiviert werden.', details => "$error" }, status => 500);
    };
});
$timesheets->post('/:id/unarchive' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        
        unless ($timesheet) {
            return $c->render(json => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }
        
        $timesheet->update({
            archived => 0,
            archived_at => undef,
        });
        
        $c->render(json => { success => 1, message => 'Stundenzettel erfolgreich dearchiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error unarchiving timesheet: $error");
        $c->render(json => { error => 'Der Stundenzettel konnte nicht dearchiviert werden.', details => "$error" }, status => 500);
    };
});
$timesheets->delete('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        
        unless ($timesheet) {
            return $c->render(json => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }
        
        $timesheet->delete;
        
        $c->render(json => { success => 1, message => 'Stundenzettel erfolgreich gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting timesheet: $error");
        $c->render(json => { error => 'Der Stundenzettel konnte nicht gelöscht werden.', details => "$error" }, status => 500);
    };
});

$time_entries->get('/week/:year/:week')->to('XBillr::Controller::TimeEntries#get_by_week');
# GET /month/:year/:month Route als direkter Callback implementiert
$time_entries->get('/month/:year/:month' => sub {
    my $c = shift;
    eval {
        # Route-Parameter werden aus dem Stash geholt
        my $year = $c->stash('year');
        my $month = $c->stash('month');
        
        if (!$year || !$month) {
            return $c->render(json => { error => 'Jahr und Monat müssen angegeben werden' }, status => 400);
        }
        
        # Konvertiere zu Integer
        $year = int($year);
        $month = int($month);
        
        my $schema = $c->app->schema;
        
        # Suche nach Einträgen im angegebenen Jahr und Monat
        # Verwende SQL LIKE für Datumssuche (effizienter)
        my $date_pattern = sprintf('%04d-%02d-%%', $year, $month);
        
        my $entries = $schema->resultset('TimeEntry')->search({
            date => { 'LIKE' => $date_pattern },
        }, {
            order_by => 'date ASC'
        });
        
        my @result;
        while (my $entry = $entries->next) {
            push @result, {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_month route: $error");
        $c->render(json => { error => 'Fehler beim Laden der Zeiteinträge', details => "$error" }, status => 500);
    };
});
# GET /:id Route für einzelnen Zeiteintrag (MUSS nach spezifischeren Routen kommen!)
$time_entries->get('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $entry = $schema->resultset('TimeEntry')->find($id);
        
        if ($entry) {
            $c->render(json => {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get time entry by id: $error");
        $c->render(json => { error => 'Fehler beim Laden des Zeiteintrags', details => "$error" }, status => 500);
    };
});
# POST Route als direkter Callback implementiert
$time_entries->post('' => sub {
    my $c = shift;
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        # Prüfe, ob hourlyRateId existiert, falls nicht, erstelle einen HourlyRate-Eintrag
        my $hourly_rate_id = $data->{hourlyRateId};
        my $hourly_rate = $schema->resultset('HourlyRate')->find($hourly_rate_id);
        
        if (!$hourly_rate) {
            # HourlyRate existiert nicht - könnte ein temporärer Standard-Satz sein
            # Prüfe, ob es ein Kunde mit Standard-Sätzen ist
            my $customer = $schema->resultset('Customer')->find($data->{customerId});
            if (!$customer) {
                return $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
            }
            
            # Versuche, einen passenden HourlyRate-Eintrag zu finden oder zu erstellen
            my $today = DateTime->now->ymd;
            my $rate_type = 'HOURLY'; # Standard
            my $rate_value = $customer->default_hourly_rate;
            my $description = 'Standard-Stundensatz';
            
            # Prüfe zuerst, ob es ein Tagessatz sein könnte
            # Lade alle verfügbaren Rates für diesen Kunden
            my $all_rates = $schema->resultset('HourlyRate')->search({
                customer_id => $data->{customerId},
                valid_from => { '<=' => $today },
                -or => [
                    valid_to => undef,
                    valid_to => { '>=' => $today },
                ],
            });
            
            # Prüfe ob ein Tagessatz mit dem default_daily_rate existiert
            if ($customer->default_daily_rate) {
                my $existing_daily = $schema->resultset('HourlyRate')->search({
                    customer_id => $data->{customerId},
                    rate => $customer->default_daily_rate,
                    rate_type => 'DAILY',
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;
                
                if ($existing_daily) {
                    $hourly_rate_id = $existing_daily->id;
                    $hourly_rate = $existing_daily;
                } else {
                    # Erstelle einen neuen Tagessatz-Eintrag
                    $hourly_rate_id = create_uuid_as_string(UUID_V4);
                    $hourly_rate = $schema->resultset('HourlyRate')->create({
                        id => $hourly_rate_id,
                        customer_id => $data->{customerId},
                        rate => $customer->default_daily_rate,
                        rate_type => 'DAILY',
                        description => 'Standard-Tagessatz',
                        valid_from => $today,
                        valid_to => undef,
                        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    });
                }
            } else {
                # Kein Tagessatz vorhanden, verwende Stundensatz
                # Prüfe, ob es bereits einen passenden HourlyRate gibt
                my $existing_rate = $schema->resultset('HourlyRate')->search({
                    customer_id => $data->{customerId},
                    rate => $rate_value,
                    rate_type => $rate_type,
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;
                
                if ($existing_rate) {
                    $hourly_rate_id = $existing_rate->id;
                    $hourly_rate = $existing_rate;
                } else {
                    # Erstelle einen neuen HourlyRate-Eintrag
                    $hourly_rate_id = create_uuid_as_string(UUID_V4);
                    $hourly_rate = $schema->resultset('HourlyRate')->create({
                        id => $hourly_rate_id,
                        customer_id => $data->{customerId},
                        rate => $rate_value,
                        rate_type => $rate_type,
                        description => $description,
                        valid_from => $today,
                        valid_to => undef,
                        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    });
                }
            }
        }
        
        my $date = DateTime::Format::MySQL->parse_date($data->{date});
        # Berechne Kalenderwoche nach ISO 8601
        my ($year, $week) = $date->week;
        
        my $entry = $schema->resultset('TimeEntry')->create({
            id => create_uuid_as_string(UUID_V4),
            customer_id => $data->{customerId},
            hourly_rate_id => $hourly_rate_id,
            date => $data->{date},
            hours => $data->{hours},
            description => $data->{description},
            week => $week,
            year => $year,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => {
            id => $entry->id,
            customerId => $entry->customer_id,
            hourlyRateId => $entry->hourly_rate_id,
            date => $entry->date,
            hours => $entry->hours,
            description => $entry->description,
            week => $entry->week,
            year => $entry->year,
            createdAt => $entry->created_at,
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in create time entry route: $error");
        $c->render(json => { error => 'Fehler beim Erstellen des Zeiteintrags', details => "$error" }, status => 500);
    };
});
# PUT Route als direkter Callback implementiert
$time_entries->put('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $entry = $schema->resultset('TimeEntry')->find($id);
        
        if ($entry) {
            my $date = DateTime::Format::MySQL->parse_date($data->{date});
            # Berechne Kalenderwoche nach ISO 8601
            my ($year, $week) = $date->week;
            
            $entry->update({
                customer_id => $data->{customerId},
                hourly_rate_id => $data->{hourlyRateId},
                date => $data->{date},
                hours => $data->{hours},
                description => $data->{description},
                week => $week,
                year => $year,
            });
            
            $c->render(json => {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in update time entry route: $error");
        $c->render(json => { error => 'Fehler beim Aktualisieren des Zeiteintrags', details => "$error" }, status => 500);
    };
});
# DELETE Route als direkter Callback implementiert
$time_entries->delete('/:id' => sub {
    my $c = shift;
    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $entry = $schema->resultset('TimeEntry')->find($id);
        
        if ($entry) {
            $entry->delete;
            $c->render(json => {}, status => 204);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in delete time entry route: $error");
        $c->render(json => { error => 'Fehler beim Löschen des Zeiteintrags', details => "$error" }, status => 500);
    };
});

# Hourly Rates
my $hourly_rates = $api->under('/hourly-rates');
# Spezifische Route muss VOR der generischen Route kommen - verwende direkten Callback
$hourly_rates->get('/customer/:customerId' => sub {
    my $c = shift;
    eval {
        my $customer_id = $c->stash('customerId');
        
        if (!$customer_id) {
            return $c->render(json => { error => 'Kunden-ID fehlt' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $today = DateTime->now->ymd;
        
        # Lade explizite Stundensätze aus der hourly_rates Tabelle
        my $rates = $schema->resultset('HourlyRate')->search({
            customer_id => $customer_id,
            valid_from => { '<=' => $today },
            -or => [
                valid_to => undef,
                valid_to => { '>=' => $today },
            ],
        });
        
        my @result;
        while (my $rate = $rates->next) {
            push @result, {
                id => $rate->id,
                customerId => $rate->customer_id,
                rate => $rate->rate,
                rateType => $rate->rate_type,
                description => $rate->description,
                validFrom => $rate->valid_from,
                validTo => $rate->valid_to,
                createdAt => $rate->created_at,
            };
        }
        
        # Füge immer die Standard-Sätze vom Kunden hinzu, falls vorhanden
        # (auch wenn bereits explizite Stundensätze vorhanden sind)
        my $customer = $schema->resultset('Customer')->find($customer_id);
        if ($customer) {
            # Prüfe, ob bereits ein Standard-Stundensatz in den Ergebnissen ist
            my $has_hourly_default = 0;
            my $has_daily_default = 0;
            foreach my $r (@result) {
                if ($r->{rateType} eq 'HOURLY' && $r->{description} eq 'Standard-Stundensatz') {
                    $has_hourly_default = 1;
                }
                if ($r->{rateType} eq 'DAILY' && $r->{description} eq 'Standard-Tagessatz') {
                    $has_daily_default = 1;
                }
            }
            
            # Füge Standard-Stundensatz hinzu, falls vorhanden und noch nicht in den Ergebnissen
            if ($customer->default_hourly_rate && !$has_hourly_default) {
                # Prüfe ob bereits ein HourlyRate mit diesem Wert existiert
                my $existing_hourly = $schema->resultset('HourlyRate')->search({
                    customer_id => $customer_id,
                    rate => $customer->default_hourly_rate,
                    rate_type => 'HOURLY',
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;
                
                if ($existing_hourly) {
                    push @result, {
                        id => $existing_hourly->id,
                        customerId => $customer_id,
                        rate => $existing_hourly->rate,
                        rateType => $existing_hourly->rate_type,
                        description => $existing_hourly->description || 'Standard-Stundensatz',
                        validFrom => $existing_hourly->valid_from,
                        validTo => $existing_hourly->valid_to,
                        createdAt => $existing_hourly->created_at,
                    };
                } else {
                    my $temp_id = create_uuid_as_string(UUID_V4);
                    push @result, {
                        id => $temp_id,
                        customerId => $customer_id,
                        rate => $customer->default_hourly_rate,
                        rateType => 'HOURLY',
                        description => 'Standard-Stundensatz',
                        validFrom => $today,
                        validTo => undef,
                        createdAt => $today . ' 00:00:00',
                    };
                }
            }
            
            # Füge Standard-Tagessatz hinzu, falls vorhanden und noch nicht in den Ergebnissen
            if ($customer->default_daily_rate && !$has_daily_default) {
                # Prüfe ob bereits ein HourlyRate mit diesem Wert existiert
                my $existing_daily = $schema->resultset('HourlyRate')->search({
                    customer_id => $customer_id,
                    rate => $customer->default_daily_rate,
                    rate_type => 'DAILY',
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;
                
                if ($existing_daily) {
                    push @result, {
                        id => $existing_daily->id,
                        customerId => $customer_id,
                        rate => $existing_daily->rate,
                        rateType => $existing_daily->rate_type,
                        description => $existing_daily->description || 'Standard-Tagessatz',
                        validFrom => $existing_daily->valid_from,
                        validTo => $existing_daily->valid_to,
                        createdAt => $existing_daily->created_at,
                    };
                } else {
                    my $daily_temp_id = create_uuid_as_string(UUID_V4);
                    push @result, {
                        id => $daily_temp_id,
                        customerId => $customer_id,
                        rate => $customer->default_daily_rate,
                        rateType => 'DAILY',
                        description => 'Standard-Tagessatz',
                        validFrom => $today,
                        validTo => undef,
                        createdAt => $today . ' 00:00:00',
                    };
                }
            }
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_customer route: $error");
        $c->render(json => { error => 'Fehler beim Laden der Stundensätze', details => "$error" }, status => 500);
    };
});
$hourly_rates->post('')->to('XBillr::Controller::HourlyRates#create');
# Generische Route kommt nach der spezifischen
$hourly_rates->get('/:id')->to('XBillr::Controller::HourlyRates#get');
$hourly_rates->put('/:id')->to('XBillr::Controller::HourlyRates#update');
$hourly_rates->delete('/:id')->to('XBillr::Controller::HourlyRates#delete');

# Supplier (Rechnungssteller)
my $supplier = $api->under('/supplier');
$supplier->get('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->first;
        
        if ($supplier) {
            $c->render(json => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
            }, status => 200);
        } else {
            $c->render(json => {}, status => 200);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$supplier->post('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $data = $c->req->json;
        
        # Prüfen ob bereits ein Supplier existiert
        my $existing = $schema->resultset('Supplier')->first;
        if ($existing) {
            return $c->render(json => { error => 'Ein Rechnungssteller existiert bereits. Bitte verwenden Sie die Bearbeitungsfunktion.' }, status => 400);
        }
        
        # Validierung
        unless ($data->{name} && $data->{address} && $data->{zipCode} && $data->{city}) {
            return $c->render(json => { error => 'Name, Adresse, PLZ und Stadt sind erforderlich' }, status => 400);
        }
        
        # UUID generieren
        use UUID::Tiny ':std';
        my $id = create_uuid_as_string(UUID_V4);
        
        # Supplier erstellen
        my $supplier = $schema->resultset('Supplier')->create({
            id => $id,
            name => $data->{name},
            address => $data->{address},
            zip_code => $data->{zipCode},
            city => $data->{city},
            country => $data->{country} || 'DE',
            tax_id => $data->{taxId},
            vat_id => $data->{vatId},
            email => $data->{email},
            bank_account => $data->{bankAccount},
            bank_name => $data->{bankName},
            iban => $data->{iban},
            bic => $data->{bic},
            default_tax_rate => $data->{defaultTaxRate} || 19.00,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => {
            id => $supplier->id,
            name => $supplier->name,
            address => $supplier->address,
            zipCode => $supplier->zip_code,
            city => $supplier->city,
            country => $supplier->country,
            taxId => $supplier->tax_id,
            vatId => $supplier->vat_id,
            email => $supplier->email,
            bankAccount => $supplier->bank_account,
            bankName => $supplier->bank_name,
            iban => $supplier->iban,
            bic => $supplier->bic,
            defaultTaxRate => $supplier->default_tax_rate,
        }, status => 201);
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});
$supplier->put('' => sub {
    my $c = shift;
    eval {
        my $schema = $c->app->schema;
        my $data = $c->req->json;
        my $supplier = $schema->resultset('Supplier')->first;
        
        if ($supplier) {
            $supplier->update({
                name => $data->{name},
                address => $data->{address},
                zip_code => $data->{zipCode},
                city => $data->{city},
                country => $data->{country} || 'DE',
                tax_id => $data->{taxId},
                vat_id => $data->{vatId},
                email => $data->{email},
                bank_account => $data->{bankAccount},
                bank_name => $data->{bankName},
                iban => $data->{iban},
                bic => $data->{bic},
                default_tax_rate => $data->{defaultTaxRate} || 19.00,
                updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
            
            $c->render(json => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Rechnungssteller nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
});

# Logs
my $logs = $api->under('/logs');
$logs->get('')->to('XBillr::Controller::Logs#list');

app->start;

