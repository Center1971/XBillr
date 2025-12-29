package XBillr::Model::DB::Invoice;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('invoices');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    invoice_number => {
        data_type => 'varchar',
        size => 50,
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
    subtotal => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    tax_rate => {
        data_type => 'decimal',
        size => [5, 2],
        is_nullable => 0,
    },
    tax_amount => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    total => {
        data_type => 'decimal',
        size => [10, 2],
        is_nullable => 0,
    },
    tax_type => {
        data_type => 'varchar',
        size => 20,
        is_nullable => 0,
    },
    status => {
        data_type => 'varchar',
        size => 20,
        default_value => 'DRAFT',
        is_nullable => 0,
    },
    payment_terms => {
        data_type => 'integer',
        is_nullable => 1,
    },
    due_date => {
        data_type => 'date',
        is_nullable => 1,
    },
    xrechnung_xml => {
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
        datetime_undef_if_invalid => 1,
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['invoice_number']);
__PACKAGE__->belongs_to('customer', 'XBillr::Model::DB::Customer', 'customer_id');
__PACKAGE__->has_many('invoice_items', 'XBillr::Model::DB::InvoiceItem', 'invoice_id');

1;

