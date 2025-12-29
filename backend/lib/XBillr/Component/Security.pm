package XBillr::Component::Security;

use strict;
use warnings;
use Mojo::Base -base;
use Mojo::Util qw(trim);
use Scalar::Util qw(looks_like_number);

# Input-Validierung und Sanitization
sub sanitize_string {
    my ($self, $str, $max_length) = @_;
    return undef unless defined $str;
    
    $str = trim($str);
    $str =~ s/[<>\"']//g;  # Entferne potenziell gefährliche Zeichen
    $str =~ s/\x00//g;     # Entferne Null-Bytes
    
    if (defined $max_length && length($str) > $max_length) {
        $str = substr($str, 0, $max_length);
    }
    
    return $str;
}

sub validate_uuid {
    my ($self, $uuid) = @_;
    return 0 unless defined $uuid;
    return $uuid =~ /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
}

sub validate_email {
    my ($self, $email) = @_;
    return 0 unless defined $email;
    return $email =~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
}

sub validate_decimal {
    my ($self, $value, $min, $max) = @_;
    return 0 unless defined $value;
    return 0 unless looks_like_number($value);
    
    my $num = $value + 0;
    if (defined $min && $num < $min) {
        return 0;
    }
    if (defined $max && $num > $max) {
        return 0;
    }
    
    return 1;
}

sub validate_integer {
    my ($self, $value, $min, $max) = @_;
    return 0 unless defined $value;
    return 0 unless $value =~ /^-?\d+$/;
    
    my $num = int($value);
    if (defined $min && $num < $min) {
        return 0;
    }
    if (defined $max && $num > $max) {
        return 0;
    }
    
    return 1;
}

sub validate_date {
    my ($self, $date) = @_;
    return 0 unless defined $date;
    return $date =~ /^\d{4}-\d{2}-\d{2}$/;
}

sub validate_enum {
    my ($self, $value, @allowed) = @_;
    return 0 unless defined $value;
    return grep { $_ eq $value } @allowed;
}

# Rate Limiting Helper
sub check_rate_limit {
    my ($self, $c, $key, $max_requests, $window_seconds) = @_;
    
    $max_requests //= 100;
    $window_seconds //= 60;
    
    my $cache_key = "rate_limit:$key";
    my $cache = $c->app->cache // {};
    
    my $count = $cache->{$cache_key} // 0;
    my $reset_time = $cache->{"${cache_key}:reset"} // time();
    
    if (time() > $reset_time) {
        $count = 0;
        $reset_time = time() + $window_seconds;
    }
    
    if ($count >= $max_requests) {
        return 0;  # Rate limit exceeded
    }
    
    $count++;
    $cache->{$cache_key} = $count;
    $cache->{"${cache_key}:reset"} = $reset_time;
    
    return 1;
}

# IP-Adresse extrahieren (berücksichtigt Proxy)
sub get_client_ip {
    my ($self, $c) = @_;
    
    # Prüfe X-Forwarded-For Header (wenn hinter Proxy)
    my $forwarded = $c->req->headers->header('X-Forwarded-For');
    if ($forwarded) {
        my @ips = split /,\s*/, $forwarded;
        return $ips[0] if @ips;
    }
    
    # Prüfe X-Real-IP Header
    my $real_ip = $c->req->headers->header('X-Real-IP');
    return $real_ip if $real_ip;
    
    # Fallback auf direkte Verbindung
    return $c->tx->remote_address;
}

1;

