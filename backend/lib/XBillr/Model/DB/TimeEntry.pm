package XBillr::Model::DB::TimeEntry;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('time_entries');
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
    hourly_rate_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    date => {
        data_type => 'date',
        is_nullable => 0,
    },
    hours => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    description => {
        data_type => 'text',
        is_nullable => 0,
    },
    week => {
        data_type => 'integer',
        is_nullable => 0,
    },
    year => {
        data_type => 'integer',
        is_nullable => 0,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('customer', 'XBillr::Model::DB::Customer', 'customer_id');
__PACKAGE__->belongs_to('hourly_rate', 'XBillr::Model::DB::HourlyRate', 'hourly_rate_id');

1;

