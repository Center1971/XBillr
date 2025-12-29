package XBillr::Model::DB::UserRole;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    user_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    role_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    assigned_by => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 1,
    },
    assigned_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('user_role_unique' => ['user_id', 'role_id']);

__PACKAGE__->belongs_to(
    'user' => 'XBillr::Model::DB::User',
    'user_id'
);

__PACKAGE__->belongs_to(
    'role' => 'XBillr::Model::DB::Role',
    'role_id'
);

__PACKAGE__->belongs_to(
    'assigner' => 'XBillr::Model::DB::User',
    'assigned_by'
);

1;

