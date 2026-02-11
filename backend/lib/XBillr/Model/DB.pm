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
use XBillr::Model::DB::User;
use XBillr::Model::DB::Role;
use XBillr::Model::DB::Permission;
use XBillr::Model::DB::UserRole;
use XBillr::Model::DB::RolePermission;
use XBillr::Model::DB::UserSession;
use XBillr::Model::DB::Tenant;
use XBillr::Model::DB::Country;
use XBillr::Model::DB::Currency;
use XBillr::Model::DB::Address;

# Klassen explizit registrieren
__PACKAGE__->register_class('Customer', 'XBillr::Model::DB::Customer');
__PACKAGE__->register_class('Invoice', 'XBillr::Model::DB::Invoice');
__PACKAGE__->register_class('InvoiceItem', 'XBillr::Model::DB::InvoiceItem');
__PACKAGE__->register_class('TimeEntry', 'XBillr::Model::DB::TimeEntry');
__PACKAGE__->register_class('HourlyRate', 'XBillr::Model::DB::HourlyRate');
__PACKAGE__->register_class('Supplier', 'XBillr::Model::DB::Supplier');
__PACKAGE__->register_class('Timesheet', 'XBillr::Model::DB::Timesheet');
__PACKAGE__->register_class('ActivityLog', 'XBillr::Model::DB::ActivityLog');
__PACKAGE__->register_class('User', 'XBillr::Model::DB::User');
__PACKAGE__->register_class('Role', 'XBillr::Model::DB::Role');
__PACKAGE__->register_class('Permission', 'XBillr::Model::DB::Permission');
__PACKAGE__->register_class('UserRole', 'XBillr::Model::DB::UserRole');
__PACKAGE__->register_class('RolePermission', 'XBillr::Model::DB::RolePermission');
__PACKAGE__->register_class('UserSession', 'XBillr::Model::DB::UserSession');
__PACKAGE__->register_class('Tenant', 'XBillr::Model::DB::Tenant');
__PACKAGE__->register_class('Country', 'XBillr::Model::DB::Country');
__PACKAGE__->register_class('Currency', 'XBillr::Model::DB::Currency');
__PACKAGE__->register_class('Address', 'XBillr::Model::DB::Address');

__PACKAGE__->load_namespaces(
    default_resultset_class => '+XBillr::Model::ResultSet',
);

1;

