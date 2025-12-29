package XBillr::Model::DB::RolePermission;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('role_permissions');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    role_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    permission_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    granted_by => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 1,
    },
    granted_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('role_permission_unique' => ['role_id', 'permission_id']);

__PACKAGE__->belongs_to(
    'role' => 'XBillr::Model::DB::Role',
    'role_id'
);

__PACKAGE__->belongs_to(
    'permission' => 'XBillr::Model::DB::Permission',
    'permission_id'
);

__PACKAGE__->belongs_to(
    'grantor' => 'XBillr::Model::DB::User',
    'granted_by'
);

1;

