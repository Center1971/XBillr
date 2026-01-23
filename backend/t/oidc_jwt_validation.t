use strict;
use warnings;
use Test::More;
use Test::Mojo;
use Mojolicious;
use Mojo::Server::Daemon;
use IO::Socket::INET;
use JSON qw(decode_json);

unless (eval { require Crypt::JWT; 1 }) {
    plan skip_all => 'Crypt::JWT not installed';
    exit 0;
}
Crypt::JWT->import(qw(encode_jwt));
unless (eval { require Crypt::PK::RSA; 1 }) {
    plan skip_all => 'Crypt::PK::RSA not installed';
    exit 0;
}

# Generate RSA key pair and JWKS
my $rsa = Crypt::PK::RSA->new;
$rsa->generate_key(256, 65537);
my $jwk_pub = $rsa->export_key_jwk('public');
$jwk_pub = decode_json($jwk_pub) unless ref $jwk_pub;
$jwk_pub->{kid} = 'testkey';

# Find free port
my $sock = IO::Socket::INET->new(
    LocalAddr => '127.0.0.1',
    LocalPort => 0,
    Proto => 'tcp',
    Listen => 1,
);
my $port = $sock->sockport;
close $sock;

# JWKS server
my $jwks_app = Mojolicious->new;
$jwks_app->routes->get('/jwks' => sub {
    my $c = shift;
    $c->render(json => { keys => [ $jwk_pub ] });
});

my $pid = fork();
if (!defined $pid) {
    die "fork failed";
}
if ($pid == 0) {
    my $daemon = Mojo::Server::Daemon->new(
        app => $jwks_app,
        listen => ["http://127.0.0.1:$port"],
    );
    $daemon->run;
    exit 0;
}

sleep 1;

END {
    if ($pid) {
        kill 'TERM', $pid;
        waitpid($pid, 0);
    }
}

my $issuer = "http://127.0.0.1:$port/realms/test";
my $audience = 'xbillr-web';

# Test app with Auth plugin
my $app = Mojolicious->new;
$app->config(iam => {
    issuer => $issuer,
    jwks_uri => "http://127.0.0.1:$port/jwks",
    authorization_endpoint => '/protocol/openid-connect/auth',
    token_endpoint => '/protocol/openid-connect/token',
    clients => {
        web => {
            client_id => $audience,
            audience => $audience,
        },
    },
});
$app->plugin('XBillr::Middleware::Auth');
my $api = $app->routes->under('/api')->to(cb => sub {
    my $c = shift;
    return $c->authenticate_request;
});
$api->get('/protected' => sub {
    my $c = shift;
    $c->render(json => { ok => 1 });
});

my $t = Test::Mojo->new($app);

my $token_ok = encode_jwt(
    payload => {
        iss => $issuer,
        aud => $audience,
        exp => time() + 300,
        sub => 'user-1',
        resource_access => {
            $audience => { roles => ['XBillr-User'] },
        },
        groups => ['tenant-acme'],
    },
    key => $rsa,
    alg => 'RS256',
    extra_headers => { kid => 'testkey' },
);

$t->get_ok('/api/protected' => { Authorization => "Bearer $token_ok" })
  ->status_is(200)
  ->json_is('/ok' => 1);

my $token_bad_aud = encode_jwt(
    payload => {
        iss => $issuer,
        aud => 'other-aud',
        exp => time() + 300,
        sub => 'user-2',
        resource_access => {
            $audience => { roles => ['XBillr-User'] },
        },
        groups => ['tenant-acme'],
    },
    key => $rsa,
    alg => 'RS256',
    extra_headers => { kid => 'testkey' },
);

$t->get_ok('/api/protected' => { Authorization => "Bearer $token_bad_aud" })
  ->status_is(401);

my $token_bad_role = encode_jwt(
    payload => {
        iss => $issuer,
        aud => $audience,
        exp => time() + 300,
        sub => 'user-3',
        resource_access => {
            $audience => { roles => ['OtherRole'] },
        },
        groups => ['tenant-acme'],
    },
    key => $rsa,
    alg => 'RS256',
    extra_headers => { kid => 'testkey' },
);

$t->get_ok('/api/protected' => { Authorization => "Bearer $token_bad_role" })
  ->status_is(403);

done_testing;
