package XBillr::Controller::Customers;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;
use XBillr::Service::PlanService;

# Resolve ISO 3166-1 alpha2 country code to countries.id (for addresses.country_id).
sub _country_alpha2_to_id {
    my ($schema, $alpha2) = @_;
    return undef unless $schema && $alpha2;
    my $country = $schema->resultset('Country')->search({ alpha2 => uc($alpha2) })->first;
    return $country ? $country->id : undef;
}

sub _address_to_hash {
    my ($addr_obj) = @_;
    return undef unless $addr_obj;
    return {
        street => $addr_obj->street,
        buildingNumber => $addr_obj->building_number,
        addressLine1 => $addr_obj->address_line_1,
        addressLine2 => $addr_obj->address_line_2,
        postCode => $addr_obj->post_code,
        townName => $addr_obj->town_name,
        countrySubDivision => $addr_obj->country_sub_division,
        country => $addr_obj->country_obj ? $addr_obj->country_obj->alpha2 : undef,
    };
}

sub list {
    my $c = shift;
    $c->app->log->info("DEBUG: Customers::list called");
    
    eval {
        $c->app->log->info("DEBUG: Customers::list - getting auth_user");
        my $auth_user = $c->auth_user || {};
        $c->app->log->info("DEBUG: Customers::list - auth_user type: " . ($auth_user->{type} || 'none'));
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            $c->app->log->info("DEBUG: Customers::list - calling require_tenant");
            return unless $c->require_tenant;
            $c->app->log->info("DEBUG: Customers::list - calling tenant_customer_ids");
            $tenant_ids = $c->tenant_customer_ids;
            $c->app->log->info("DEBUG: Customers::list - tenant_ids: " . scalar(@$tenant_ids) . " ids");
        }

        $c->app->log->info("DEBUG: Customers::list - getting schema");
        my $schema = $c->app->schema;
        $c->app->log->info("DEBUG: Customers::list - schema obtained");
        my @customers;
        if (@$tenant_ids) {
            @customers = $schema->resultset('Customer')->search({
                id => { -in => $tenant_ids },
            })->all;
        } elsif (($auth_user->{type} || '') eq 'oidc') {
            @customers = ();
        } else {
            @customers = $schema->resultset('Customer')->all;
        }
        my @result = map {
            my $addr_obj = $_->address_obj;
            my $addr_data = _address_to_hash($addr_obj);
            {
                id => $_->id,
                name => $_->name,
                address => $addr_data || $_->address,
                zipCode => $_->zip_code,
                city => $_->city,
                country => $_->country,
                email => $_->email,
                paymentTerms => $_->payment_terms,
            }
        } @customers;
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@;
        $c->app->log->error("Error listing customers: $error");
        $c->render(json => { error => 'Die Kundenliste konnte nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        
        # Validierung: Name ist erforderlich
        unless ($data->{name}) {
            return $c->render(json => { error => 'Name ist erforderlich' }, status => 400);
        }
        
        my $auth_user = $c->auth_user || {};
        my $tenant = undef;
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant = $c->current_tenant;
        }

        my $schema = $c->app->schema;
        
        # Plan enforcement: check customer limit
        if ($tenant) {
            my $plan_service = XBillr::Service::PlanService->new;
            my $plan = $c->current_tenant_plan;
            my $customer_count = $schema->resultset('Customer')->search({
                tenant => $tenant,
            })->count;
            my $limit_check = $plan_service->check_limit($plan, 'customers', $customer_count);
            unless ($limit_check->{allowed}) {
                return $c->render(json => { 
                    error => "Kundenlimit des aktuellen Tarifs ($plan) erreicht. Aktuell: $customer_count, Limit: $limit_check->{limit}" 
                }, status => 403);
            }
        }
        
        # Create address if address data is provided
        my $address_id = undef;
        if ($data->{address} && ref($data->{address}) eq 'HASH') {
            my $addr_data = $data->{address};
            my $country_code = $addr_data->{country} || 'DE';
            my $country_id = _country_alpha2_to_id($schema, $country_code);
            if ($country_id) {
                my $now = DateTime->now->strftime('%Y-%m-%d %H:%M:%S');
                my $address = $schema->resultset('Address')->create({
                    id => create_uuid_as_string(UUID_V4),
                    street => $addr_data->{street},
                    building_number => $addr_data->{buildingNumber},
                    address_line_1 => $addr_data->{addressLine1},
                    address_line_2 => $addr_data->{addressLine2},
                    post_code => $addr_data->{postCode},
                    town_name => $addr_data->{townName},
                    country_sub_division => $addr_data->{countrySubDivision},
                    country_id => $country_id,
                    created_at => $now,
                    updated_at => $now,
                });
                $address_id = $address->id;
            }
        }
        
        # Backward compatibility: if old address fields are provided, use them
        my $legacy_address = $data->{address};
        my $legacy_zip = $data->{zipCode};
        my $legacy_city = $data->{city};
        my $legacy_country = $data->{country} || 'DE';
        
        my $customer = $schema->resultset('Customer')->create({
            id => create_uuid_as_string(UUID_V4),
            name => $data->{name},
            address_id => $address_id,
            address => $legacy_address,
            zip_code => $legacy_zip,
            city => $legacy_city,
            country => $legacy_country,
            tax_id => $data->{taxId},
            vat_id => $data->{vatId},
            email => $data->{email},
            payment_terms => $data->{paymentTerms},
            tenant => $tenant,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Customer created: " . $customer->id);
        
        # Load address if exists
        my $address_data = _address_to_hash($customer->address_obj);
        
        $c->render(json => {
            id => $customer->id,
            name => $customer->name,
            address => $address_data || $customer->address,
            zipCode => $customer->zip_code,
            city => $customer->city,
            country => $customer->country,
            taxId => $customer->tax_id,
            vatId => $customer->vat_id,
            email => $customer->email,
            paymentTerms => $customer->payment_terms,
        }, status => 201);
    } or do {
        my $error = $@;
        $c->app->log->error("Error creating customer: $error");
        # Keine internen Details nach außen geben
        $c->render(json => { error => 'Der Kunde konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' }, status => 500);
    };
}

sub get {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $id } @$tenant_ids)) {
                return $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
            }
        }
        
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            my $address_data = _address_to_hash($customer->address_obj);
            $c->render(json => {
                id => $customer->id,
                name => $customer->name,
                address => $address_data || $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                taxId => $customer->tax_id,
                vatId => $customer->vat_id,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@;
        $c->app->log->error("Error getting customer: $error");
        $c->render(json => { error => 'Die Kundendaten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $id } @$tenant_ids)) {
                return $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
            }
            my $tenant = $c->current_tenant;
            if ($tenant && ($data->{company} || $data->{name}) && ($data->{company} || $data->{name}) ne $tenant) {
                return $c->render(json => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            # Handle address update
            my $address_id = $customer->address_id;
            if ($data->{address} && ref($data->{address}) eq 'HASH') {
                my $addr_data = $data->{address};
                my $country_code = $addr_data->{country} || 'DE';
                my $country_id = _country_alpha2_to_id($schema, $country_code);
                if ($country_id) {
                    my $now = DateTime->now->strftime('%Y-%m-%d %H:%M:%S');
                    if ($address_id) {
                        my $address = $schema->resultset('Address')->find($address_id);
                        if ($address) {
                            $address->update({
                                street => $addr_data->{street},
                                building_number => $addr_data->{buildingNumber},
                                address_line_1 => $addr_data->{addressLine1},
                                address_line_2 => $addr_data->{addressLine2},
                                post_code => $addr_data->{postCode},
                                town_name => $addr_data->{townName},
                                country_sub_division => $addr_data->{countrySubDivision},
                                country_id => $country_id,
                                updated_at => $now,
                            });
                        }
                    } else {
                        my $address = $schema->resultset('Address')->create({
                            id => create_uuid_as_string(UUID_V4),
                            street => $addr_data->{street},
                            building_number => $addr_data->{buildingNumber},
                            address_line_1 => $addr_data->{addressLine1},
                            address_line_2 => $addr_data->{addressLine2},
                            post_code => $addr_data->{postCode},
                            town_name => $addr_data->{townName},
                            country_sub_division => $addr_data->{countrySubDivision},
                            country_id => $country_id,
                            created_at => $now,
                            updated_at => $now,
                        });
                        $address_id = $address->id;
                    }
                }
            }
            
            # Backward compatibility
            my $legacy_address = $data->{address};
            my $legacy_zip = $data->{zipCode};
            my $legacy_city = $data->{city};
            my $legacy_country = $data->{country} || 'DE';
            
            $customer->update({
                name => $data->{name},
                address_id => $address_id,
                address => $legacy_address,
                zip_code => $legacy_zip,
                city => $legacy_city,
                country => $legacy_country,
                tax_id => $data->{taxId},
                vat_id => $data->{vatId},
                email => $data->{email},
                payment_terms => $data->{paymentTerms},
                updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
            
            $customer->discard_changes;
            my $address_data = _address_to_hash($customer->address_obj);
            
            $c->render(json => {
                id => $customer->id,
                name => $customer->name,
                address => $address_data || $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                taxId => $customer->tax_id,
                vatId => $customer->vat_id,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $id } @$tenant_ids)) {
                return $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
            }
        }
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
}

1;

