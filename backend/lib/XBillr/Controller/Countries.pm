package XBillr::Controller::Countries;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        unless ($schema) {
            $c->app->log->error("Countries list: Schema is not available");
            return $c->render(json => { error => 'Database connection not available' }, status => 503);
        }
        
        # Force connection by executing a query - DBIx::Class uses lazy connections
        my $count = eval { $schema->resultset('Country')->count };
        if ($@) {
            my $err = $@;
            $err =~ s/at \/.*$//;
            $err =~ s/\n/ /g;
            $c->app->log->error("Countries list: Error counting countries: $err");
            return $c->render(json => { error => 'Could not access countries table', details => $err }, status => 500);
        }
        
        $c->app->log->debug("Countries list: Found $count countries");
        
        my @countries = $schema->resultset('Country')->search(
            {},
            {
                order_by => 'name_de ASC'
            }
        )->all;
        
        # Get user language preference (default to 'de' for German)
        my $lang = $c->param('lang') || $c->req->headers->header('Accept-Language') || 'de';
        $lang = 'de' if $lang !~ /^en/i;  # Default to German unless explicitly English
        
        my @result = map {
            my $numeric_val;
            eval {
                $numeric_val = $_->get_column('numeric');
            };
            if ($@) {
                eval {
                    $numeric_val = $_->numeric_code;
                };
            }
            {
                id => $_->id,
                alpha2 => $_->alpha2,
                alpha3 => $_->alpha3,
                numeric => $numeric_val || '',
                nameDe => $_->name_de,
                nameEn => $_->name_en,
                name => ($lang =~ /^en/i) ? $_->name_en : $_->name_de,  # Return appropriate name based on language
            }
        } @countries;
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unknown error';
        $c->app->log->error("Error listing countries: $error");
        $c->render(json => { error => 'Countries could not be loaded' }, status => 500);
    };
}

1;
