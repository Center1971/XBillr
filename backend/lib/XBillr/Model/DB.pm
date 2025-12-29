package XBillr::Model::DB;

use strict;
use warnings;
use base 'DBIx::Class::Schema';

# Model-Klassen explizit laden
use XBillr::Model::DB::Customer;
use XBillr::Model::DB::Invoice;
use XBillr::Model::DB::InvoiceItem;
use XBillr::Model::DB::TimeEntry;
use XBillr::Model::DB::HourlyRate;
use XBillr::Model::DB::Supplier;
use XBillr::Model::DB::Timesheet;
use XBillr::Model::DB::ActivityLog;

# Klassen explizit registrieren
__PACKAGE__->register_class('Customer', 'XBillr::Model::DB::Customer');
__PACKAGE__->register_class('Invoice', 'XBillr::Model::DB::Invoice');
__PACKAGE__->register_class('InvoiceItem', 'XBillr::Model::DB::InvoiceItem');
__PACKAGE__->register_class('TimeEntry', 'XBillr::Model::DB::TimeEntry');
__PACKAGE__->register_class('HourlyRate', 'XBillr::Model::DB::HourlyRate');
__PACKAGE__->register_class('Supplier', 'XBillr::Model::DB::Supplier');
__PACKAGE__->register_class('Timesheet', 'XBillr::Model::DB::Timesheet');
__PACKAGE__->register_class('ActivityLog', 'XBillr::Model::DB::ActivityLog');

__PACKAGE__->load_namespaces(
    default_resultset_class => '+XBillr::Model::ResultSet',
);

1;

