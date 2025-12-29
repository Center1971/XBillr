package XBillr::Model::DB::Supplier;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('suppliers');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    name => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    address => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    zip_code => {
        data_type => 'varchar',
        size => 20,
        is_nullable => 0,
    },
    city => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 0,
    },
    country => {
        data_type => 'varchar',
        size => 2,
        default_value => 'DE',
        is_nullable => 0,
    },
    tax_id => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 1,
    },
    vat_id => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 1,
    },
    hra_hrb_number => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 1,
    },
    email => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    bank_account => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 1,
    },
    bank_name => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    iban => {
        data_type => 'varchar',
        size => 34,
        is_nullable => 1,
    },
    bic => {
        data_type => 'varchar',
        size => 11,
        is_nullable => 1,
    },
    default_tax_rate => {
        data_type => 'double',
        is_nullable => 1,
    },
    logo => {
        data_type => 'text',
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
    updated_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');

1;

