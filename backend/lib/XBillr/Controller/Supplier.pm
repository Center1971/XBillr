package XBillr::Controller::Supplier;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;
use XBillr::Service::PlanService;

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        my $tenant = undef;
        
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant = $c->current_tenant;
        }
        
        my $search = {};
        $search->{tenant} = $tenant if $tenant;
        
        my $suppliers = $schema->resultset('Supplier')->search($search, {
            order_by => 'created_at DESC',
        });
        
        my @result = ();
        while (my $supplier = $suppliers->next) {
            push @result, {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                hraHrbNumber => $supplier->hra_hrb_number,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
                logo => $supplier->logo,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error listing suppliers: $error");
        $c->render(json => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub get {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->find($id);
        my $auth_user = $c->auth_user || {};
        
        if ($supplier && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $supplier->tenant ne $tenant) {
                return $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
            }
        }
        
        if ($supplier) {
            $c->render(json => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                hraHrbNumber => $supplier->hra_hrb_number,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
                logo => $supplier->logo,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error getting supplier: $error");
        $c->render(json => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub create {
    my $c = shift;

    eval {
        my $schema = $c->app->schema;
        my $data = $c->req->json;
        my $auth_user = $c->auth_user || {};
        my $tenant = undef;
        
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant = $c->current_tenant;
        }

        unless ($data->{name} && $data->{address} && $data->{zipCode} && $data->{city}) {
            return $c->render(json => { error => 'Name, Adresse, PLZ und Stadt sind erforderlich' }, status => 400);
        }

        # Ensure tenant exists and has free plan by default
        if ($tenant) {
            my $tenant_record = $schema->resultset('Tenant')->find({ name => $tenant });
            unless ($tenant_record) {
                # Create tenant with free plan
                $tenant_record = $schema->resultset('Tenant')->create({
                    id => create_uuid_as_string(UUID_V4),
                    name => $tenant,
                    plan => 'free',
                    created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                });
            }
        }

        my $supplier = $schema->resultset('Supplier')->create({
            id => create_uuid_as_string(UUID_V4),
            name => $data->{name},
            address => $data->{address},
            zip_code => $data->{zipCode},
            city => $data->{city},
            country => $data->{country} || 'DE',
            tax_id => $data->{taxId},
            vat_id => $data->{vatId},
            hra_hrb_number => $data->{hraHrbNumber},
            email => $data->{email},
            bank_account => $data->{bankAccount},
            bank_name => $data->{bankName},
            iban => $data->{iban},
            bic => $data->{bic},
            default_tax_rate => $data->{defaultTaxRate} || 19.00,
            logo => $data->{logo},
            tenant => $tenant,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });

        $c->render(json => {
            id => $supplier->id,
            name => $supplier->name,
            address => $supplier->address,
            zipCode => $supplier->zip_code,
            city => $supplier->city,
            country => $supplier->country,
            taxId => $supplier->tax_id,
            vatId => $supplier->vat_id,
            hraHrbNumber => $supplier->hra_hrb_number,
            email => $supplier->email,
            bankAccount => $supplier->bank_account,
            bankName => $supplier->bank_name,
            iban => $supplier->iban,
            bic => $supplier->bic,
            defaultTaxRate => $supplier->default_tax_rate,
            logo => $supplier->logo,
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error creating supplier: $error");
        $c->render(json => { error => 'Die Daten konnten nicht gespeichert werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->find($id);
        my $auth_user = $c->auth_user || {};
        
        if ($supplier && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $supplier->tenant ne $tenant) {
                return $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
            }
        }
        
        if ($supplier) {
            $supplier->update({
                name => $data->{name},
                address => $data->{address},
                zip_code => $data->{zipCode},
                city => $data->{city},
                country => $data->{country} // 'DE',
                tax_id => $data->{taxId},
                vat_id => $data->{vatId},
                hra_hrb_number => $data->{hraHrbNumber},
                email => $data->{email},
                bank_account => $data->{bankAccount},
                bank_name => $data->{bankName},
                iban => $data->{iban},
                bic => $data->{bic},
                default_tax_rate => $data->{defaultTaxRate} || 19.00,
                logo => $data->{logo},
                updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
            
            $c->render(json => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                hraHrbNumber => $supplier->hra_hrb_number,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
                logo => $supplier->logo,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error updating supplier: $error");
        $c->render(json => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->find($id);
        my $auth_user = $c->auth_user || {};
        
        if ($supplier && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $supplier->tenant ne $tenant) {
                return $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
            }
        }
        
        if ($supplier) {
            $supplier->delete;
            $c->render(json => { success => 1, message => 'Supplier erfolgreich gelöscht' }, status => 200);
        } else {
            $c->render(json => { error => 'Supplier nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting supplier: $error");
        $c->render(json => { error => 'Die Daten konnten nicht gelöscht werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

1;
