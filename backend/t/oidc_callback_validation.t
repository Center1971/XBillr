use strict;
use warnings;
use Test::More;
use Test::Mojo;
use Mojolicious;
use lib '/home/jeff/src/smetools/XBillr/backend/lib';
use XBillr::Controller::Auth;

BEGIN {
    no warnings 'redefine';
    my $orig = \&Mojolicious::Controller::render;
    *Mojolicious::Controller::render = sub {
        my ($c, @args) = @_;
        if (@args % 2 == 0) {
            my %args = @args;
            if (exists $args{openapi}) {
                $args{json} = delete $args{openapi};
            }
            return $orig->($c, %args);
        }
        return $orig->($c, @args);
    };
}

my $app = Mojolicious->new;
$app->plugin('Config', { file => '/home/jeff/src/smetools/XBillr/config/xbillr.conf' });
$app->plugin('XBillr::Middleware::Auth');

$app->routes->get('/api/auth/oidc/callback' => sub {
    my $c = shift;
    my $controller = XBillr::Controller::Auth->new;
    $controller->{app} = $c->app;
    $controller->{stash} = $c->stash;
    $controller->{tx} = $c->tx;
    $controller->{req} = $c->req;
    $controller->{res} = $c->res;
    $controller->oidc_callback($c);
});

my $t = Test::Mojo->new($app);

# Call callback with bad state (no session established)
$t->get_ok('/api/auth/oidc/callback?code=abc&state=wrong')
  ->status_is(400)
  ->json_like('/error' => qr/Login-Status/);

done_testing;
