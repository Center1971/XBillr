package XBillr::Component::InputValidator;

use strict;
use warnings;
use Mojo::Base -base;
use XBillr::Component::Security;

has 'security' => sub { XBillr::Component::Security->new };

sub validate_customer {
    my ($self, $data) = @_;
    my @errors;
    
    unless (defined $data->{name} && length($data->{name}) > 0 && length($data->{name}) <= 255) {
        push @errors, "Name ist erforderlich (max. 255 Zeichen)";
    }
    
    unless (defined $data->{address} && length($data->{address}) > 0 && length($data->{address}) <= 255) {
        push @errors, "Adresse ist erforderlich (max. 255 Zeichen)";
    }
    
    unless (defined $data->{zipCode} && length($data->{zipCode}) > 0 && length($data->{zipCode}) <= 20) {
        push @errors, "PLZ ist erforderlich (max. 20 Zeichen)";
    }
    
    unless (defined $data->{city} && length($data->{city}) > 0 && length($data->{city}) <= 100) {
        push @errors, "Stadt ist erforderlich (max. 100 Zeichen)";
    }
    
    if (defined $data->{email} && length($data->{email}) > 0) {
        unless ($self->security->validate_email($data->{email})) {
            push @errors, "Ungültige E-Mail-Adresse";
        }
    }
    
    if (defined $data->{paymentTerms}) {
        unless ($self->security->validate_integer($data->{paymentTerms}, 0, 365)) {
            push @errors, "Zahlungsziel muss zwischen 0 und 365 Tagen sein";
        }
    }
    
    return @errors;
}

sub validate_invoice {
    my ($self, $data) = @_;
    my @errors;
    
    unless ($self->security->validate_uuid($data->{customerId})) {
        push @errors, "Ungültige Kunden-ID";
    }
    
    unless ($self->security->validate_date($data->{dateFrom})) {
        push @errors, "Ungültiges Startdatum (Format: YYYY-MM-DD)";
    }
    
    unless ($self->security->validate_date($data->{dateTo})) {
        push @errors, "Ungültiges Enddatum (Format: YYYY-MM-DD)";
    }
    
    unless ($self->security->validate_decimal($data->{taxRate}, 0, 100)) {
        push @errors, "Steuersatz muss zwischen 0 und 100 sein";
    }
    
    unless ($self->security->validate_enum($data->{taxType}, 'VAT', 'REVERSE_CHARGE')) {
        push @errors, "Ungültiger Steuertyp (muss VAT oder REVERSE_CHARGE sein)";
    }
    
    return @errors;
}

sub validate_time_entry {
    my ($self, $data) = @_;
    my @errors;
    
    unless ($self->security->validate_uuid($data->{customerId})) {
        push @errors, "Ungültige Kunden-ID";
    }
    
    unless ($self->security->validate_uuid($data->{hourlyRateId})) {
        push @errors, "Ungültige Stundensatz-ID";
    }
    
    unless ($self->security->validate_date($data->{date})) {
        push @errors, "Ungültiges Datum (Format: YYYY-MM-DD)";
    }
    
    unless ($self->security->validate_decimal($data->{hours}, 0, 24)) {
        push @errors, "Stunden müssen zwischen 0 und 24 sein";
    }
    
    unless (defined $data->{description} && length($data->{description}) > 0) {
        push @errors, "Beschreibung ist erforderlich";
    }
    
    return @errors;
}

sub validate_hourly_rate {
    my ($self, $data) = @_;
    my @errors;
    
    unless ($self->security->validate_uuid($data->{customerId})) {
        push @errors, "Ungültige Kunden-ID";
    }
    
    unless ($self->security->validate_decimal($data->{rate}, 0, 1000000)) {
        push @errors, "Stundensatz muss zwischen 0 und 1.000.000 sein";
    }
    
    unless ($self->security->validate_enum($data->{rateType}, 'HOURLY', 'DAILY')) {
        push @errors, "Ungültiger Ratentyp (muss HOURLY oder DAILY sein)";
    }
    
    unless ($self->security->validate_date($data->{validFrom})) {
        push @errors, "Ungültiges Gültigkeitsdatum (Format: YYYY-MM-DD)";
    }
    
    return @errors;
}

1;

