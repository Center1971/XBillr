package XBillr::Controller::Supplier;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;

sub get {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->first;
        my $auth_user = $c->auth_user || {};
        if ($supplier && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $supplier->name ne $tenant) {
                return $c->render(openapi => {}, status => 200);
            }
        }
        
        if ($supplier) {
            $c->render(openapi => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
            }, status => 200);
        } else {
            $c->render(openapi => {}, status => 200);
        }
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub create {
    my $c = shift;

    eval {
        my $schema = $c->app->schema;
        my $data = $c->req->json;
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $data->{name} && $data->{name} ne $tenant) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }

        my $existing = $schema->resultset('Supplier')->first;
        if ($existing) {
            return $c->render(openapi => { error => 'Ein Rechnungssteller existiert bereits. Bitte verwenden Sie die Bearbeitungsfunktion.' }, status => 400);
        }

        unless ($data->{name} && $data->{address} && $data->{zipCode} && $data->{city}) {
            return $c->render(openapi => { error => 'Name, Adresse, PLZ und Stadt sind erforderlich' }, status => 400);
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
            email => $data->{email},
            bank_account => $data->{bankAccount},
            bank_name => $data->{bankName},
            iban => $data->{iban},
            bic => $data->{bic},
            default_tax_rate => $data->{defaultTaxRate} || 19.00,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });

        $c->render(openapi => {
            id => $supplier->id,
            name => $supplier->name,
            address => $supplier->address,
            zipCode => $supplier->zip_code,
            city => $supplier->city,
            country => $supplier->country,
            taxId => $supplier->tax_id,
            vatId => $supplier->vat_id,
            email => $supplier->email,
            bankAccount => $supplier->bank_account,
            bankName => $supplier->bank_name,
            iban => $supplier->iban,
            bic => $supplier->bic,
            defaultTaxRate => $supplier->default_tax_rate,
        }, status => 201);
    } or do {
        $c->render(openapi => { error => $@ }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->first;
        my $auth_user = $c->auth_user || {};
        if ($supplier && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant = $c->current_tenant;
            if ($tenant && $supplier->name ne $tenant) {
                return $c->render(openapi => { error => 'Rechnungssteller nicht gefunden' }, status => 404);
            }
            if ($tenant && $data->{name} && $data->{name} ne $tenant) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
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
                email => $data->{email},
                bank_account => $data->{bankAccount},
                bank_name => $data->{bankName},
                iban => $data->{iban},
                bic => $data->{bic},
                default_tax_rate => $data->{defaultTaxRate} || 19.00,
                updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
            
            $c->render(openapi => {
                id => $supplier->id,
                name => $supplier->name,
                address => $supplier->address,
                zipCode => $supplier->zip_code,
                city => $supplier->city,
                country => $supplier->country,
                taxId => $supplier->tax_id,
                vatId => $supplier->vat_id,
                email => $supplier->email,
                bankAccount => $supplier->bank_account,
                bankName => $supplier->bank_name,
                iban => $supplier->iban,
                bic => $supplier->bic,
                defaultTaxRate => $supplier->default_tax_rate,
            }, status => 200);
        } else {
            $c->render(openapi => { error => 'Rechnungssteller nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

1;

