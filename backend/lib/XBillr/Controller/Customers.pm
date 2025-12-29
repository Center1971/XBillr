package XBillr::Controller::Customers;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $customers = $schema->resultset('Customer')->search(
            {},
            { order_by => 'name ASC' }
        );
        
        my @result;
        while (my $customer = $customers->next) {
            push @result, {
                id => $customer->id,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                taxId => $customer->tax_id,
                vatId => $customer->vat_id,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                createdAt => $customer->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@;
        $c->app->log->error("Error listing customers: $error");
        $c->render(
            json => { error => 'Die Kundenliste konnte nicht geladen werden. Bitte versuchen Sie es später erneut.' },
            status => 500
        );
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        
        # Input-Validierung
        my $validator = $c->app->validator;
        my @errors = $validator->validate_customer($data);
        
        if (@errors) {
            my @user_friendly_errors = map {
                if ($_ =~ /name/i) { "Bitte geben Sie einen Namen ein." }
                elsif ($_ =~ /address/i) { "Bitte geben Sie eine Adresse ein." }
                elsif ($_ =~ /zip|plz/i) { "Bitte geben Sie eine gültige Postleitzahl ein." }
                elsif ($_ =~ /city|stadt/i) { "Bitte geben Sie eine Stadt ein." }
                elsif ($_ =~ /email/i) { "Bitte geben Sie eine gültige E-Mail-Adresse ein." }
                else { "Bitte überprüfen Sie Ihre Eingaben." }
            } @errors;
            
            return $c->render(
                json => { error => 'Bitte korrigieren Sie die folgenden Fehler:', details => \@user_friendly_errors },
                status => 400
            );
        }
        
        # Sanitization
        my $security = $c->app->security;
        my $schema = $c->app->schema;
        
        my $customer = $schema->resultset('Customer')->create({
            id => create_uuid_as_string(UUID_V4),
            name => $security->sanitize_string($data->{name}, 255),
            address => $security->sanitize_string($data->{address}, 255),
            zip_code => $security->sanitize_string($data->{zipCode}, 20),
            city => $security->sanitize_string($data->{city}, 100),
            country => $security->sanitize_string($data->{country} // 'DE', 2),
            tax_id => defined $data->{taxId} ? $security->sanitize_string($data->{taxId}, 50) : undef,
            vat_id => defined $data->{vatId} ? $security->sanitize_string($data->{vatId}, 50) : undef,
            email => defined $data->{email} ? $security->sanitize_string($data->{email}, 255) : undef,
            payment_terms => $data->{paymentTerms},
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Customer created: " . $customer->id);
        
        $c->render(json => {
            id => $customer->id,
            name => $customer->name,
            address => $customer->address,
            zipCode => $customer->zip_code,
            city => $customer->city,
            country => $customer->country,
            taxId => $customer->tax_id,
            vatId => $customer->vat_id,
            email => $customer->email,
            paymentTerms => $customer->payment_terms,
            createdAt => $customer->created_at,
        }, status => 201);
    } or do {
        my $error = $@;
        $c->app->log->error("Error creating customer: $error");
        # Keine internen Details nach außen geben
        $c->render(
            json => { error => 'Der Kunde konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' },
            status => 500
        );
    };
}

sub get {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        
        # UUID-Validierung
        my $security = $c->app->security;
        unless ($security->validate_uuid($id)) {
            return $c->render(
                json => { error => 'Die angegebene ID ist ungültig. Bitte versuchen Sie es erneut.' },
                status => 400
            );
        }
        
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $c->render(json => {
                id => $customer->id,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                taxId => $customer->tax_id,
                vatId => $customer->vat_id,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                createdAt => $customer->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Der angeforderte Kunde wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        my $error = $@;
        $c->app->log->error("Error getting customer: $error");
        $c->render(
            json => { error => 'Die Kundendaten konnten nicht geladen werden. Bitte versuchen Sie es später erneut.' },
            status => 500
        );
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->update({
                name => $data->{name},
                address => $data->{address},
                zip_code => $data->{zipCode},
                city => $data->{city},
                country => $data->{country} // 'DE',
                tax_id => $data->{taxId},
                vat_id => $data->{vatId},
                email => $data->{email},
                payment_terms => $data->{paymentTerms},
            });
            
            $c->render(json => {
                id => $customer->id,
                name => $customer->name,
                address => $customer->address,
                zipCode => $customer->zip_code,
                city => $customer->city,
                country => $customer->country,
                taxId => $customer->tax_id,
                vatId => $customer->vat_id,
                email => $customer->email,
                paymentTerms => $customer->payment_terms,
                createdAt => $customer->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Der angeforderte Kunde wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $customer = $schema->resultset('Customer')->find($id);
        
        if ($customer) {
            $customer->delete;
            $c->render(json => {}, status => 204);
        } else {
            $c->render(json => { error => 'Der angeforderte Kunde wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

1;

