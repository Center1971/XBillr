package XBillr::Model::DB::Timesheet;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('timesheets');
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
    date_from => {
        data_type => 'date',
        is_nullable => 0,
    },
    date_to => {
        data_type => 'date',
        is_nullable => 0,
    },
    pdf_data => {
        data_type => 'longblob',
        is_nullable => 1,
    },
    description => {
        data_type => 'text',
        is_nullable => 1,
    },
    archived => {
        data_type => 'boolean',
        default_value => 0,
        is_nullable => 0,
    },
    archived_at => {
        data_type => 'datetime',
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('customer', 'XBillr::Model::DB::Customer', 'customer_id');

1;

