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
        }, status => 503);
    }
    
    unless ($schema) {
        $error_msg = "Schema is undef - connection may have failed. Check database configuration and ensure database is running.";
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection not available',
            details => $error_msg,
            suggestion => 'Please check: 1) Database server is running, 2) Connection parameters in config/xbillr.conf are correct, 3) Database xbillr exists and schema is initialized'
        }, status => 503);
    }
    
    # Test database connection by executing a query - this will force lazy connection
    # DBIx::Class uses lazy connections, so we need to execute a query to establish it
    my $count = 0;
    eval {
        # Force connection by executing a query through DBIx::Class
        # This will establish the connection if it hasn't been established yet
        $count = $schema->resultset('Customer')->count;
        $c->app->log->debug("Health check: Got customer count via DBIx::Class: $count");
        
        # Now try to get dbh for additional verification (optional)
        my $dbh = eval { $schema->storage->dbh };
        if ($dbh) {
            $c->app->log->debug("Health check: Database handle is now available");
        } else {
            $c->app->log->warn("Health check: Database handle still not available, but queries work");
        }
    };
    if ($@) {
        $error_msg = "Query failed: $@";
        $error_msg =~ s/at \/.*$//;
        $error_msg =~ s/\n/ /g;
        $c->app->log->error("Health check - $error_msg");
        return $c->render(json => { 
            status => 'error', 
            version => $XBillr::Version::VERSION,
            error => 'Database connection failed',
            details => $error_msg
        }, status => 503);
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

