package XBillr::Model::DB::Permission;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('permissions');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    name => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 0,
    },
    description => {
        data_type => 'text',
        is_nullable => 1,
    },
    resource => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 0,
    },
    action => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 0,
    },
    created_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('name_unique' => ['name']);

__PACKAGE__->has_many(
    'role_permissions' => 'XBillr::Model::DB::RolePermission',
    'permission_id'
);

__PACKAGE__->many_to_many(
    'roles' => 'role_permissions',
    'role'
);

1;

