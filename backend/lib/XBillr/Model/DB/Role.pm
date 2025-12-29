package XBillr::Model::DB::Role;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('roles');
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
    is_system_role => {
        data_type => 'boolean',
        is_nullable => 0,
        default_value => 0,
    },
    created_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    updated_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('name_unique' => ['name']);

__PACKAGE__->has_many(
    'user_roles' => 'XBillr::Model::DB::UserRole',
    'role_id'
);

__PACKAGE__->has_many(
    'role_permissions' => 'XBillr::Model::DB::RolePermission',
    'role_id'
);

__PACKAGE__->many_to_many(
    'permissions' => 'role_permissions',
    'permission'
);

__PACKAGE__->many_to_many(
    'users' => 'user_roles',
    'user'
);

1;

