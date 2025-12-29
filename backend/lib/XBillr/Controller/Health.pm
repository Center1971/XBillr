package XBillr::Controller::Health;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Version;

sub check {
    my $c = shift;
    
    # Logge, dass der Health-Check aufgerufen wurde
    $c->app->log->info("Health check endpoint called");
    
    # Versuche Schema zu initialisieren - verwende eval für Fehlerbehandlung
    my $schema;
    my $error_msg;
    
    eval {
        $schema = $c->app->schema;
    };
    if ($@) {
        $error_msg = "Schema initialization failed: $@";
        # Kürze den Fehler für besseres Logging
        $error_msg =~ s/at \/.*$//;
        $error_msg =~ s/\n/ /g;
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection failed',
            details => $error_msg
        }, status => 500);
    }
    
    unless ($schema) {
        $error_msg = "Schema is undef - connection may have failed";
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection failed',
            details => $error_msg
        }, status => 500);
    }
    
    # Test database connection - verwende direkt SQL statt DBIx::Class ResultSet
    my $dbh;
    eval {
        $dbh = $schema->storage->dbh;
    };
    if ($@) {
        $error_msg = "DBH access failed: $@";
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection failed'
        }, status => 500);
    }
    
    unless ($dbh) {
        $error_msg = "DBH is undef";
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection failed'
        }, status => 500);
    }
    
    # Führe eine einfache SQL-Abfrage aus
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
}

1;

