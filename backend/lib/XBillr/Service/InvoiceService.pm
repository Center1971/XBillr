package XBillr::Service::InvoiceService;

use strict;
use warnings;
use Mojo::Base -base;
use XBillr::Model::DB;
use DateTime;
use Math::BigFloat;
use UUID::Tiny ':std';

has 'schema';

sub create_invoice {
    my ($self, $params) = @_;
    
    my $customer_id = $params->{customer_id};
    my $date_from = DateTime::Format::MySQL->parse_date($params->{date_from});
    my $date_to = DateTime::Format::MySQL->parse_date($params->{date_to});
    my $tax_rate = Math::BigFloat->new($params->{tax_rate});
    my $tax_type = $params->{tax_type};
    my $payment_terms = $params->{payment_terms};
    my $include_timesheet = $params->{include_timesheet} // 0;
    
    my $schema = $self->schema;
    
    # Hole Zeiteinträge für den Zeitraum
    my $time_entries = $schema->resultset('TimeEntry')->search({
        customer_id => $customer_id,
        date => {
            -between => [$date_from->ymd, $date_to->ymd]
        }
    });
    
    if ($time_entries->count == 0) {
        die "Keine Zeiteinträge für den gewählten Zeitraum gefunden";
    }
    
    # Verwende alle Zeiteinträge
    my @entries = $time_entries->all;
    
    # Erstelle Invoice Items
    my @items;
    my $subtotal = Math::BigFloat->new(0);
    
    # Gruppiere Einträge nach RateType und Rate-Wert
    # DAILY: alle Einträge mit gleichem Rate-Wert werden zusammengefasst
    # HOURLY: alle Einträge mit gleichem Rate-Wert werden zusammengefasst
    my %daily_entries_by_rate = ();  # rate -> [entries]
    my %hourly_entries_by_rate = ();  # rate -> [entries]
    
    for my $entry (@entries) {
        my $rate = $schema->resultset('HourlyRate')->find($entry->hourly_rate_id);
        die "Stundensatz nicht gefunden" unless $rate;
        
        my $rate_type = $rate->rate_type;
        my $rate_value = $rate->rate;
        
        if ($rate_type eq 'DAILY') {
            # Tagessatz: gruppiere nach Rate-Wert
            if (!exists $daily_entries_by_rate{$rate_value}) {
                $daily_entries_by_rate{$rate_value} = [];
            }
            push @{$daily_entries_by_rate{$rate_value}}, $entry;
        } else {
            # Stundensatz: gruppiere nach Rate-Wert
            if (!exists $hourly_entries_by_rate{$rate_value}) {
                $hourly_entries_by_rate{$rate_value} = [];
            }
            push @{$hourly_entries_by_rate{$rate_value}}, $entry;
        }
    }
    
    # Erstelle Positionen für Tagessätze (zusammengefasst nach Rate-Wert)
    for my $rate_value (sort keys %daily_entries_by_rate) {
        my @daily_entries = @{$daily_entries_by_rate{$rate_value}};
        my $rate = $schema->resultset('HourlyRate')->find($daily_entries[0]->hourly_rate_id);
        my $rate_value_bf = Math::BigFloat->new($rate_value);
        
        # Summiere alle Stunden für diesen Rate-Wert
        my $total_hours = Math::BigFloat->new(0);
        my @time_entry_ids = ();
        
        for my $entry (@daily_entries) {
            $total_hours += Math::BigFloat->new($entry->hours);
            push @time_entry_ids, $entry->id;
        }
        
        # Berechne Anzahl der Tage (Stunden / 8)
        my $days = $total_hours / 8;
        
        # Berechne Betrag
        my $amount = ($days * $rate_value_bf)->round(2);
        $subtotal += $amount;
        
        push @items, {
            id => create_uuid_as_string(UUID_V4),
            time_entry_id => join(',', @time_entry_ids),
            description => 'Tagessatz',
            hours => $days->as_number,  # Speichere Anzahl der Tage, nicht Stunden
            rate => $rate_value_bf->as_number,
            amount => $amount->as_number,
            rate_type => 'DAILY',
        };
    }
    
    # Erstelle Positionen für Stundensätze (zusammengefasst nach Rate-Wert)
    for my $rate_value (sort keys %hourly_entries_by_rate) {
        my @hourly_entries = @{$hourly_entries_by_rate{$rate_value}};
        my $rate = $schema->resultset('HourlyRate')->find($hourly_entries[0]->hourly_rate_id);
        my $rate_value_bf = Math::BigFloat->new($rate_value);
        
        # Summiere alle Stunden für diesen Rate-Wert
        my $total_hours = Math::BigFloat->new(0);
        my @time_entry_ids = ();
        
        for my $entry (@hourly_entries) {
            $total_hours += Math::BigFloat->new($entry->hours);
            push @time_entry_ids, $entry->id;
        }
        
        # Berechne Betrag
        my $amount = ($total_hours * $rate_value_bf)->round(2);
        $subtotal += $amount;
        
        push @items, {
            id => create_uuid_as_string(UUID_V4),
            time_entry_id => join(',', @time_entry_ids),
            description => 'Stundensatz',
            hours => $total_hours->as_number,
            rate => $rate_value_bf->as_number,
            amount => $amount->as_number,
            rate_type => 'HOURLY',
        };
    }
    
    # Berechne Steuer und Gesamtbetrag
    my $tax_amount = $tax_type eq 'VAT' 
        ? ($subtotal * $tax_rate / 100)->round(2)
        : Math::BigFloat->new(0);
    my $total = ($subtotal + $tax_amount)->round(2);
    
    # Generiere Rechnungsnummer
    my $invoice_number = $self->_generate_invoice_number($schema);
    
    # Erstelle Rechnung
    my $invoice = $schema->resultset('Invoice')->create({
        id => create_uuid_as_string(UUID_V4),
        invoice_number => $invoice_number,
        customer_id => $customer_id,
        date_from => $date_from->ymd,
        date_to => $date_to->ymd,
        subtotal => $subtotal->as_number,
        tax_rate => $tax_rate->as_number,
        tax_amount => $tax_amount->as_number,
        total => $total->as_number,
        tax_type => $tax_type,
        status => 'DRAFT',
        payment_terms => $payment_terms,
        due_date => $self->_calculate_due_date($customer_id, $payment_terms),
        archived => 0,
        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    
    # Speichere Invoice Items
    for my $item (@items) {
        $schema->resultset('InvoiceItem')->create({
            %$item,
            invoice_id => $invoice->id,
        });
    }
    
    return $invoice;
}

sub _generate_invoice_number {
    my ($self, $schema) = @_;
    my $year = DateTime->now->year;
    my $count = $schema->resultset('Invoice')->count + 1;
    return sprintf("RE-%s-%03d", $year, $count);
}

sub _calculate_due_date {
    my ($self, $customer_id, $payment_terms) = @_;
    my $schema = $self->schema;
    
    if ($payment_terms && $payment_terms > 0) {
        return DateTime->now->add(days => $payment_terms)->ymd;
    }
    
    my $customer = $schema->resultset('Customer')->find($customer_id);
    if ($customer && $customer->payment_terms) {
        return DateTime->now->add(days => $customer->payment_terms)->ymd;
    }
    
    return DateTime->now->add(days => 14)->ymd; # Standard: 14 Tage
}

sub get_all_invoices {
    my ($self, $archived) = @_;
    my $schema = $self->schema;
    
    if ($archived) {
        return $schema->resultset('Invoice')->search({ archived => 1 });
    } else {
        return $schema->resultset('Invoice')->search({ archived => 0 });
    }
}

sub get_archived_invoices {
    my ($self) = @_;
    return $self->get_all_invoices(1);
}

sub archive_invoice {
    my ($self, $id) = @_;
    my $schema = $self->schema;
    
    my $invoice = $schema->resultset('Invoice')->find($id);
    die "Rechnung nicht gefunden" unless $invoice;
    
    $invoice->update({
        archived => 1,
        archived_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
}

sub unarchive_invoice {
    my ($self, $id) = @_;
    my $schema = $self->schema;
    
    my $invoice = $schema->resultset('Invoice')->find($id);
    die "Rechnung nicht gefunden" unless $invoice;
    
    $invoice->update({
        archived => 0,
        archived_at => undef,
    });
}

sub duplicate_archived_invoice {
    my ($self, $id) = @_;
    my $schema = $self->schema;
    
    my $original = $schema->resultset('Invoice')->find($id);
    die "Rechnung nicht gefunden" unless $original;
    
    die "Nur archivierte Rechnungen können dupliziert werden" unless $original->archived;
    
    my $new_invoice = $schema->resultset('Invoice')->create({
        id => create_uuid_as_string(UUID_V4),
        invoice_number => $original->invoice_number . '-KORR',
        customer_id => $original->customer_id,
        date_from => $original->date_from,
        date_to => $original->date_to,
        subtotal => $original->subtotal,
        tax_rate => $original->tax_rate,
        tax_amount => $original->tax_amount,
        total => $original->total,
        tax_type => $original->tax_type,
        status => 'DRAFT',
        payment_terms => $original->payment_terms,
        due_date => DateTime->now->add(
            days => $original->payment_terms || 14
        )->ymd,
        archived => 0,
        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    
    # Kopiere Invoice Items
    my $items = $schema->resultset('InvoiceItem')->search({ invoice_id => $id });
    while (my $item = $items->next) {
        $schema->resultset('InvoiceItem')->create({
            id => create_uuid_as_string(UUID_V4),
            invoice_id => $new_invoice->id,
            time_entry_id => $item->time_entry_id,
            description => $item->description,
            hours => $item->hours,
            rate => $item->rate,
            amount => $item->amount,
            rate_type => $item->rate_type,
        });
    }
    
    return $new_invoice;
}

sub get_invoice_items {
    my ($self, $invoice_id) = @_;
    my $schema = $self->schema;
    return $schema->resultset('InvoiceItem')->search({ invoice_id => $invoice_id });
}

1;

