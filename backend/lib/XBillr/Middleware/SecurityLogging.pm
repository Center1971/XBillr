package XBillr::Middleware::SecurityLogging;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ($self, $app) = @_;
    
    # Logge alle Requests mit Sicherheitsrelevanz
    $app->hook(before_dispatch => sub {
        my $c = shift;
        
        my $method = $c->req->method;
        my $path = $c->req->url->path->to_string;
        my $ip = $c->tx->remote_address;
        
        # Logge verdächtige Requests
        if ($path =~ /\.\./ || $path =~ /\/etc\// || $path =~ /\/proc\//) {
            $c->app->log->warn("Suspicious path access attempt from $ip: $path");
        }
        
        # Logge POST/PUT/DELETE Requests
        if ($method =~ /^(POST|PUT|DELETE)$/) {
            $c->app->log->info("$method request from $ip: $path");
        }
    });
    
    # Logge Fehler
    $app->hook(after_dispatch => sub {
        my $c = shift;
        
        if ($c->res->code >= 400) {
            my $ip = $c->tx->remote_address;
            my $path = $c->req->url->path->to_string;
            my $code = $c->res->code;
            
            $c->app->log->warn("HTTP $code from $ip: $path");
        }
    });
}

1;

