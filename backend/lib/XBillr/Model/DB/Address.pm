package XBillr::Model::DB::Address;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('addresses');
__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 36,
        is_nullable => 0,
    },
    street => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    building_number => {
        data_type => 'varchar',
        size => 20,
        is_nullable => 1,
    },
    address_line_1 => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    address_line_2 => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    post_code => {
        data_type => 'varchar',
        size => 20,
        is_nullable => 1,
    },
    town_name => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 1,
    },
    country_sub_division => {
        data_type => 'varchar',
        size => 100,
        is_nullable => 1,
    },
    country_id => {
        data_type => 'integer',
        is_nullable => 0,
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
__PACKAGE__->belongs_to('country_obj', 'XBillr::Model::DB::Country', 'country_id');
__PACKAGE__->has_many('customers', 'XBillr::Model::DB::Customer', 'address_id');

1;
