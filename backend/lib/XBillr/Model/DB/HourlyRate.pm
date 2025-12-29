package XBillr::Model::DB::HourlyRate;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('hourly_rates');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    customer_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    rate => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    rate_type => {
        data_type => 'varchar',
        size => 10,
        is_nullable => 0,
    },
    description => {
        data_type => 'text',
        is_nullable => 1,
    },
    valid_from => {
        data_type => 'date',
        is_nullable => 0,
    },
    valid_to => {
        data_type => 'date',
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('customer', 'XBillr::Model::DB::Customer', 'customer_id');
__PACKAGE__->has_many('time_entries', 'XBillr::Model::DB::TimeEntry', 'hourly_rate_id');

1;

