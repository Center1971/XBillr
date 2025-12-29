package XBillr::Controller::Permissions;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $permissions = $schema->resultset('Permission')->search({}, {
            order_by => ['resource', 'action'],
        });
        
        my @result = ();
        my %grouped = ();
        
        while (my $perm = $permissions->next) {
            my $resource = $perm->resource;
            unless ($grouped{$resource}) {
                $grouped{$resource} = [];
            }
            push @{$grouped{$resource}}, {
                id => $perm->id,
                name => $perm->name,
                description => $perm->description,
                resource => $perm->resource,
                action => $perm->action,
            };
        }
        
        # Konvertiere zu Array mit gruppierten Ressourcen
        foreach my $resource (sort keys %grouped) {
            push @result, {
                resource => $resource,
                permissions => $grouped{$resource},
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Permissions list error: $error");
        $c->render(json => { error => 'Fehler beim Laden der Rechte' }, status => 500);
    };
}

1;

