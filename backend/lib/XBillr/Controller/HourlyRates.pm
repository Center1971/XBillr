package XBillr::Controller::HourlyRates;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;

sub get_by_customer {
    my $c = shift;
    
    eval {
        # Route-Parameter wird aus dem Stash geholt (Mojolicious speichert Route-Parameter im Stash)
        my $customer_id = $c->stash('customerId');
        
        if (!$customer_id) {
            return $c->render(json => { error => 'Kunden-ID fehlt' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $today = DateTime->now->ymd;
        
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
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_customer: $error");
        $c->render(json => { error => 'Fehler beim Laden der Stundensätze', details => "$error" }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        my $rate = $schema->resultset('HourlyRate')->create({
            id => create_uuid_as_string(UUID_V4),
            customer_id => $data->{customerId},
            rate => $data->{rate},
            rate_type => $data->{rateType},
            description => $data->{description},
            valid_from => $data->{validFrom},
            valid_to => $data->{validTo},
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => {
            id => $rate->id,
            customerId => $rate->customer_id,
            rate => $rate->rate,
            rateType => $rate->rate_type,
            description => $rate->description,
            validFrom => $rate->valid_from,
            validTo => $rate->valid_to,
            createdAt => $rate->created_at,
        }, status => 201);
    } or do {
        $c->render(json => { error => $@, details => $@ }, status => 500);
    };
}

sub get {
    my $c = shift;
    
    eval {
        # Route-Parameter werden im Stash gespeichert
        my $id = $c->stash('id') || $c->param('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Stundensatz-ID fehlt' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $rate = $schema->resultset('HourlyRate')->find($id);
        
        if ($rate) {
            $c->render(json => {
                id => $rate->id,
                customerId => $rate->customer_id,
                rate => $rate->rate,
                rateType => $rate->rate_type,
                description => $rate->description,
                validFrom => $rate->valid_from,
                validTo => $rate->valid_to,
                createdAt => $rate->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::get: $error");
        $c->render(json => { error => 'Fehler beim Laden des Stundensatzes', details => "$error" }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        # Route-Parameter werden im Stash gespeichert
        my $id = $c->stash('id') || $c->param('id');
        my $data = $c->req->json;
        
        unless ($id) {
            return $c->render(json => { error => 'Stundensatz-ID fehlt' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $rate = $schema->resultset('HourlyRate')->find($id);
        
        if ($rate) {
            $rate->update({
                customer_id => $data->{customerId},
                rate => $data->{rate},
                rate_type => $data->{rateType},
                description => $data->{description},
                valid_from => $data->{validFrom},
                valid_to => $data->{validTo},
            });
            
            $c->render(json => {
                id => $rate->id,
                customerId => $rate->customer_id,
                rate => $rate->rate,
                rateType => $rate->rate_type,
                description => $rate->description,
                validFrom => $rate->valid_from,
                validTo => $rate->valid_to,
                createdAt => $rate->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::update: $error");
        $c->render(json => { error => 'Fehler beim Aktualisieren des Stundensatzes', details => "$error" }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        # Route-Parameter werden im Stash gespeichert
        my $id = $c->stash('id') || $c->param('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Stundensatz-ID fehlt' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $rate = $schema->resultset('HourlyRate')->find($id);
        
        if ($rate) {
            $rate->delete;
            $c->render(json => {}, status => 204);
        } else {
            $c->render(json => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::delete: $error");
        $c->render(json => { error => 'Fehler beim Löschen des Stundensatzes', details => "$error" }, status => 500);
    };
}

1;

