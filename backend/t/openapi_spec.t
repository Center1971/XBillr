use strict;
use warnings;
use Test::More;
use JSON::Validator;
use Mojo::File qw(path);

my $spec_path = path(__FILE__)->dirname->dirname->child('openapi.yaml')->to_string;
my $validator = JSON::Validator->new;
my $schema = eval { $validator->schema($spec_path) };
ok(!$@, 'Loaded OpenAPI spec');

my @errors = ();
if ($schema && $schema->can('errors')) {
    @errors = $schema->errors;
    diag($_->message) for @errors;
}

is(scalar @errors, 0, 'OpenAPI spec is valid');

done_testing;
