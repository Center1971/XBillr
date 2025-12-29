package XBillr::Model::DB::User;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    username => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 0,
    },
    email => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    password_hash => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    first_name => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    },
    last_name => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    },
    is_active => {
        data_type => 'boolean',
        is_nullable => 0,
        default_value => 1,
    },
    is_email_verified => {
        data_type => 'boolean',
        is_nullable => 0,
        default_value => 0,
    },
    last_login => {
        data_type => 'datetime',
        is_nullable => 1,
    },
    failed_login_attempts => {
        data_type => 'integer',
        is_nullable => 0,
        default_value => 0,
    },
    locked_until => {
        data_type => 'datetime',
        is_nullable => 1,
    },
    password_reset_token => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    password_reset_expires => {
        data_type => 'datetime',
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    updated_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    created_by => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('username_unique' => ['username']);
__PACKAGE__->add_unique_constraint('email_unique' => ['email']);

__PACKAGE__->has_many(
    'user_roles' => 'XBillr::Model::DB::UserRole',
    'user_id'
);

__PACKAGE__->has_many(
    'roles' => 'XBillr::Model::DB::Role',
    { 'foreign.id' => 'self.user_roles.role_id' },
    { cascade_delete => 0 }
);

__PACKAGE__->has_many(
    'sessions' => 'XBillr::Model::DB::UserSession',
    'user_id'
);

__PACKAGE__->belongs_to(
    'creator' => 'XBillr::Model::DB::User',
    'created_by'
);

1;

