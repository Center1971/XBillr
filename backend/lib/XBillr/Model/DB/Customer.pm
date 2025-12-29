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
    company => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
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
    email => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    payment_terms => {
        data_type => 'integer',
        is_nullable => 1,
    },
    default_hourly_rate => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 1,
    },
    default_daily_rate => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 1,
    },
    tax_rate => {
        data_type => 'decimal',
        size => [5, 2],
        default_value => '19.00',
        is_nullable => 1,
    },
    reverse_charge => {
        data_type => 'boolean',
        default_value => 0,
        is_nullable => 0,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('hourly_rates', 'XBillr::Model::DB::HourlyRate', 'customer_id');
__PACKAGE__->has_many('time_entries', 'XBillr::Model::DB::TimeEntry', 'customer_id');
__PACKAGE__->has_many('invoices', 'XBillr::Model::DB::Invoice', 'customer_id');

1;

