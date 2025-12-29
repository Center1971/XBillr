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
                createdAt => $supplier->created_at,
                updatedAt => $supplier->updated_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Der Rechnungssteller wurde noch nicht erfasst. Bitte erfassen Sie zuerst Ihre Firmendaten.' }, status => 404);
        }
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $supplier = $schema->resultset('Supplier')->first;
        
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
                default_tax_rate => $data->{defaultTaxRate},
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
                createdAt => $supplier->created_at,
                updatedAt => $supplier->updated_at,
            }, status => 200);
        } else {
            # Erstelle neuen Lieferanten
            my $new_supplier = $schema->resultset('Supplier')->create({
                id => create_uuid_as_string(UUID_V4),
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
                default_tax_rate => $data->{defaultTaxRate},
                logo => $data->{logo},
                created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
            
            $c->render(json => {
                id => $new_supplier->id,
                name => $new_supplier->name,
                address => $new_supplier->address,
                zipCode => $new_supplier->zip_code,
                city => $new_supplier->city,
                country => $new_supplier->country,
                taxId => $new_supplier->tax_id,
                vatId => $new_supplier->vat_id,
                email => $new_supplier->email,
                bankAccount => $new_supplier->bank_account,
                bankName => $new_supplier->bank_name,
                iban => $new_supplier->iban,
                bic => $new_supplier->bic,
                defaultTaxRate => $new_supplier->default_tax_rate,
                logo => $new_supplier->logo,
                createdAt => $new_supplier->created_at,
                updatedAt => $new_supplier->updated_at,
            }, status => 201);
        }
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

1;

