package XBillr::Model::DB::Currency;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('currencies');
__PACKAGE__->add_columns(
    alpha4 => {
        data_type => 'char',
        size => 4,
        is_nullable => 0,
    },
    numeric => {
        data_type => 'char',
        size => 3,
        is_nullable => 0,
    },
    name_de => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    name_en => {
        data_type => 'varchar',
        size => 255,
        is_nullable => 0,
    },
    country_alpha2 => {
        data_type => 'char',
        size => 2,
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('alpha4');
__PACKAGE__->add_unique_constraint(['numeric']);
__PACKAGE__->belongs_to('country', 'XBillr::Model::DB::Country', 'country_alpha2');

1;
