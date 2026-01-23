use strict;
use warnings;
use Test::More;
use Test::Mojo;
use Mojolicious::Lite;

plugin 'XBillr::Middleware::Auth';

my $api = app->routes->under('/api')->to(cb => sub {
    my $c = shift;
    return $c->authenticate_request;
});

$api->get('/customers' => sub {
    my $c = shift;
    $c->render(json => { ok => 1 });
});

my $t = Test::Mojo->new;

$t->get_ok('/api/customers')
  ->status_is(401)
  ->json_is('/error' => 'Authentifizierung erforderlich');

done_testing;
