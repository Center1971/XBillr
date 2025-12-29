package XBillr::Model::DB::UserSession;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('user_sessions');
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
    session_token => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    ip_address => {
        data_type => 'varchar',
        size => 45,
        is_nullable => 1,
    },
    user_agent => {
        data_type => 'text',
        is_nullable => 1,
    },
    expires_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    created_at => {
        data_type => 'datetime',
        is_nullable => 0,
    },
    last_activity => {
        data_type => 'datetime',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint('session_token_unique' => ['session_token']);

__PACKAGE__->belongs_to(
    'user' => 'XBillr::Model::DB::User',
    'user_id'
);

1;

