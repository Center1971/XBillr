package XBillr::Model::DB::InvoiceItem;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('invoice_items');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    invoice_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    time_entry_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    description => {
        data_type => 'text',
        is_nullable => 0,
    },
    hours => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    rate => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    amount => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    rate_type => {
        data_type => 'varchar',
        size => 10,
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('invoice', 'XBillr::Model::DB::Invoice', 'invoice_id');

1;

