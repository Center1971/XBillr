package XBillr::Model::DB::Customer;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('customers');
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
    address_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 1,
    },
    address => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    zip_code => {
        data_type => 'varchar',
        size => 20,
        is_nullable => 1,
    },
    city => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    },
    country => {
        data_type => 'varchar',
        size => 2,
        default_value => 'DE',
        is_nullable => 1,
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
    email => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    payment_terms => {
        data_type => 'integer',
        is_nullable => 1,
    },
    tenant => {
        data_type => 'varchar',
        size => 255,
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
__PACKAGE__->belongs_to('address_obj', 'XBillr::Model::DB::Address', 'address_id');
__PACKAGE__->has_many('hourly_rates', 'XBillr::Model::DB::HourlyRate', 'customer_id');
__PACKAGE__->has_many('time_entries', 'XBillr::Model::DB::TimeEntry', 'customer_id');
__PACKAGE__->has_many('invoices', 'XBillr::Model::DB::Invoice', 'customer_id');

1;

