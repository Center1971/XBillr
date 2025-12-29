package XBillr::Model::DB::ActivityLog;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('activity_logs');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    action => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 0,
    },
    entity_type => {
        data_type => 'varchar',
        size => 50,
        is_nullable => 0,
    },
    entity_id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 1,
    },
    details => {
        data_type => 'text',
        is_nullable => 1,
    },
    created_at => {
        data_type => 'datetime',
        datetime_undef_if_invalid => 1,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('id');

1;

