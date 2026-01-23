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
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            unless (@$tenant_ids && grep { $_ eq $customer_id } @$tenant_ids) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
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

        my $customer = $schema->resultset('Customer')->find($customer_id);
        if ($customer) {
            my $has_hourly_default = 0;
            my $has_daily_default = 0;
            for my $r (@result) {
                $has_hourly_default = 1 if $r->{rateType} eq 'HOURLY' && $r->{description} eq 'Standard-Stundensatz';
                $has_daily_default = 1 if $r->{rateType} eq 'DAILY' && $r->{description} eq 'Standard-Tagessatz';
            }

            if ($customer->default_hourly_rate && !$has_hourly_default) {
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
                    push @result, {
                        id => create_uuid_as_string(UUID_V4),
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

            if ($customer->default_daily_rate && !$has_daily_default) {
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
                    push @result, {
                        id => create_uuid_as_string(UUID_V4),
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
        
        $c->render(openapi => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_customer: $error");
        $c->render(openapi => { error => 'Fehler beim Laden der Stundensätze', details => "$error" }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            unless (@$tenant_ids && grep { $_ eq $data->{customerId} } @$tenant_ids) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        
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
        
        $c->render(openapi => {
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
        $c->render(openapi => { error => $@, details => $@ }, status => 500);
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
        my $auth_user = $c->auth_user || {};
        if ($rate && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $rate->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
            }
        }
        
        if ($rate) {
            $c->render(openapi => {
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
            $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::get: $error");
        $c->render(openapi => { error => 'Fehler beim Laden des Stundensatzes', details => "$error" }, status => 500);
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
        my $auth_user = $c->auth_user || {};
        if ($rate && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $rate->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
            }
            unless (@$tenant_ids && grep { $_ eq $data->{customerId} } @$tenant_ids) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        
        if ($rate) {
            $rate->update({
                customer_id => $data->{customerId},
                rate => $data->{rate},
                rate_type => $data->{rateType},
                description => $data->{description},
                valid_from => $data->{validFrom},
                valid_to => $data->{validTo},
            });
            
            $c->render(openapi => {
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
            $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::update: $error");
        $c->render(openapi => { error => 'Fehler beim Aktualisieren des Stundensatzes', details => "$error" }, status => 500);
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
        my $auth_user = $c->auth_user || {};
        if ($rate && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $rate->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
            }
        }
        
        if ($rate) {
            $rate->delete;
            $c->render(openapi => {}, status => 204);
        } else {
            $c->render(openapi => { error => 'Stundensatz nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in HourlyRates::delete: $error");
        $c->render(openapi => { error => 'Fehler beim Löschen des Stundensatzes', details => "$error" }, status => 500);
    };
}

1;

