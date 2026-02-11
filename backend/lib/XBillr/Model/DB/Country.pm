package XBillr::Model::DB::Country;

use strict;
use warnings;
use base 'DBIx::Class::Core';

__PACKAGE__->table('countries');
__PACKAGE__->add_columns(
    id => {
        data_type => 'integer',
        is_auto_increment => 1,
        is_nullable => 0,
    },
    alpha2 => {
        data_type => 'char',
        size => 2,
        is_nullable => 0,
    },
    alpha3 => {
        data_type => 'char',
        size => 3,
        is_nullable => 0,
    },
    numeric => {
        data_type => 'char',
        size => 3,
        is_nullable => 0,
        accessor => 'numeric_code',  # Provide an accessor to avoid conflict with reserved keyword
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
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['alpha2']);
__PACKAGE__->add_unique_constraint(['alpha3']);
__PACKAGE__->has_many('addresses', 'XBillr::Model::DB::Address', 'country_id');
__PACKAGE__->has_many('country_currencies', 'XBillr::Model::DB::CountryCurrency', 'country_id');

1;
