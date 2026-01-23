package XBillr::Controller::Customers;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;

sub list {
    my $c = shift;
    
    eval {
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }

        my $schema = $c->app->schema;
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
            {
                id => $_->id,
                company => $_->company,
                name => $_->name,
                address => $_->address,
                zipCode => $_->zip_code,
                city => $_->city,
                country => $_->country,
                email => $_->email,
                paymentTerms => $_->payment_terms,
                defaultHourlyRate => $_->default_hourly_rate,
                defaultDailyRate => $_->default_daily_rate,
                taxRate => $_->tax_rate,
                reverseCharge => $_->reverse_charge ? 1 : 0,
            }
        } @customers;
        
        $c->render(openapi => \@result, status => 200);
    } or do {
        my $error = $@;
        $c->app->log->error("Error listing customers: $error");
        $c->render(openapi => { error => 'Die Kundenliste konnte nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        
        # Minimale Validierung (kompatibel zu bestehender API)
        unless ($data->{name} && $data->{address} && $data->{zipCode} && $data->{city}) {
            return $c->render(openapi => { error => 'Ansprechpartner, Adresse, PLZ und Stadt sind erforderlich' }, status => 400);
        }
        
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && ($data->{company} || $data->{name}) && ($data->{company} || $data->{name}) ne $tenant) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }

        my $schema = $c->app->schema;
        
        my $customer = $schema->resultset('Customer')->create({
            id => create_uuid_as_string(UUID_V4),
            company => $data->{company},
            name => $data->{name},
            address => $data->{address},
            zip_code => $data->{zipCode},
            city => $data->{city},
            country => $data->{country} || 'DE',
            email => $data->{email},
            payment_terms => $data->{paymentTerms},
            default_hourly_rate => $data->{defaultHourlyRate},
            default_daily_rate => $data->{defaultDailyRate},
            tax_rate => $data->{taxRate} || 19.00,
            reverse_charge => $data->{reverseCharge} ? 1 : 0,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Customer created: " . $customer->id);
        
        $c->render(openapi => {
            id => $customer->id,
            company => $customer->company,
            name => $customer->name,
            address => $customer->address,
            zipCode => $customer->zip_code,
            city => $customer->city,
            country => $customer->country,
            email => $customer->email,
            paymentTerms => $customer->payment_terms,
            defaultHourlyRate => $customer->default_hourly_rate,
            defaultDailyRate => $customer->default_daily_rate,
            taxRate => $customer->tax_rate,
            reverseCharge => $customer->reverse_charge ? 1 : 0,
        }, status => 201);
    } or do {
        my $error = $@;
        $c->app->log->error("Error creating customer: $error");
        # Keine internen Details nach außen geben
        $c->render(openapi => { error => 'Der Kunde konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' }, status => 500);
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
                return $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
            }
        }
        
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $c->render(openapi => {
                id => $customer->id,
                company => $customer->company,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                defaultHourlyRate => $customer->default_hourly_rate,
                defaultDailyRate => $customer->default_daily_rate,
                taxRate => $customer->tax_rate,
                reverseCharge => $customer->reverse_charge ? 1 : 0,
            }, status => 200);
        } else {
            $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@;
        $c->app->log->error("Error getting customer: $error");
        $c->render(openapi => { error => 'Die Kundendaten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
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
                return $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
            }
            my $tenant = $c->current_tenant;
            if ($tenant && ($data->{company} || $data->{name}) && ($data->{company} || $data->{name}) ne $tenant) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->update({
                company => $data->{company},
                name => $data->{name},
                address => $data->{address},
                zip_code => $data->{zipCode},
                city => $data->{city},
                country => $data->{country} // 'DE',
                email => $data->{email},
                payment_terms => $data->{paymentTerms},
                default_hourly_rate => $data->{defaultHourlyRate},
                default_daily_rate => $data->{defaultDailyRate},
                tax_rate => $data->{taxRate} || 19.00,
                reverse_charge => $data->{reverseCharge} ? 1 : 0,
            });
            
            $c->render(openapi => {
                id => $customer->id,
                company => $customer->company,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                defaultHourlyRate => $customer->default_hourly_rate,
                defaultDailyRate => $customer->default_daily_rate,
                taxRate => $customer->tax_rate,
                reverseCharge => $customer->reverse_charge ? 1 : 0,
            }, status => 200);
        } else {
            $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(openapi => { error => $@ }, status => 500);
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
                return $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
            }
        }
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->delete;
            $c->render(openapi => { success => 1 }, status => 200);
        } else {
            $c->render(openapi => { error => 'Kunde nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(openapi => { error => $@ }, status => 500);
    };
}

1;

