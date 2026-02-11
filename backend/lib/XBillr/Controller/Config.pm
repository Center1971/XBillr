package XBillr::Controller::Config;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Version;

sub frontend {
    my $c = shift;
    
    # Get frontend config from application config
    my $frontend_config = $c->app->config->{frontend} || {};
    my $iam_config = $c->app->config->{iam} || {};
    
    # Return safe configuration values for frontend
    # Never expose secrets or internal details
    $c->render(json => {
        apiBaseUrl => $frontend_config->{api_base_url} || '/api',
        appName => $frontend_config->{app_name} || 'XBillr',
        appVersion => $frontend_config->{app_version} || $XBillr::Version::VERSION,
        frontendUrl => $iam_config->{frontend_url} || 'http://localhost:8082',
        sessionIdleTimeoutMinutes => $frontend_config->{session_idle_timeout_minutes} // 30,
        # Add other safe config values as needed
    }, status => 200);
}

1;
