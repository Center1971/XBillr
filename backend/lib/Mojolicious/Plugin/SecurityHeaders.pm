package Mojolicious::Plugin::SecurityHeaders;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my ($self, $app, $config) = @_;
    
    $app->hook(after_dispatch => sub {
        my $c = shift;
        
        # Setze Sicherheits-Header
        for my $header (keys %{$config}) {
            $c->res->headers->header($header => $config->{$header});
        }
    });
}

1;

