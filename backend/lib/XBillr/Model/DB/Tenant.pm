package XBillr::Model::DB::Tenant;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('tenants');
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
    plan => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 0,
        default_value => 'free',
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
__PACKAGE__->add_unique_constraint('name_unique' => ['name']);

1;
