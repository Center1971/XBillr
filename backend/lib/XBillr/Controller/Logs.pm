package XBillr::Controller::Logs;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $logs = $schema->resultset('ActivityLog')->search(
            {},
            { order_by => { -desc => 'created_at' } }
        );
        
        my @result;
        while (my $log = $logs->next) {
            push @result, {
                id => $log->id,
                action => $log->action,
                entityType => $log->entity_type,
                entityId => $log->entity_id,
                details => $log->details,
                createdAt => $log->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

1;

