package XBillr::Service::PlanService;

use strict;
use warnings;
use Mojo::Base -base;
use Config::File;
use File::Spec;

has 'plans_config' => sub {
    my $self = shift;
    my $config_path = File::Spec->catfile(
        File::Spec->rel2abs(File::Spec->updir()),
        'config', 'plans.conf'
    );
    
    # Fallback to relative path if absolute doesn't work
    unless (-f $config_path) {
        $config_path = File::Spec->catfile('config', 'plans.conf');
    }
    
    unless (-f $config_path) {
        # Try from backend directory
        $config_path = File::Spec->catfile('..', 'config', 'plans.conf');
    }
    
    my $config = Config::File->new($config_path);
    unless ($config) {
        die "Cannot load plans configuration from $config_path";
    }
    
    return $config;
};

has 'plans' => sub {
    my $self = shift;
    return $self->plans_config->AsHash;
};

sub get_plan {
    my ($self, $plan_name) = @_;
    $plan_name ||= 'free';
    my $plans = $self->plans;
    return $plans->{$plan_name} if exists $plans->{$plan_name};
    
    # Fallback to free plan if plan doesn't exist
    return $plans->{free} || {};
}

sub get_plan_limit {
    my ($self, $plan_name, $limit_type) = @_;
    my $plan = $self->get_plan($plan_name);
    return $plan->{$limit_type} if exists $plan->{$limit_type};
    return 0;
}

sub check_limit {
    my ($self, $plan_name, $limit_type, $current_count) = @_;
    my $limit = $self->get_plan_limit($plan_name, $limit_type);
    return {
        allowed => ($limit == 0 || $current_count < $limit),
        limit => $limit,
        current => $current_count,
        remaining => ($limit == 0 ? -1 : ($limit - $current_count)),
    };
}

sub is_feature_enabled {
    my ($self, $plan_name, $feature) = @_;
    my $plan = $self->get_plan($plan_name);
    return $plan->{$feature} ? 1 : 0;
}

1;
