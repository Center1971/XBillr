package XBillr::Service::PDFService;

use strict;
use warnings;
use Mojo::Base -base;
use PDF::API2;
use DateTime;
use DateTime::Format::MySQL;
use Math::BigFloat;

has 'schema';

# Hilfsfunktion für Datumsformatierung DD.MM.YYYY
sub format_date_dd_mm_yyyy {
    my ($date_str) = @_;
    return '' unless $date_str;
    
    # Versuche verschiedene Formate zu parsen
    my $dt;
    if (ref($date_str) && $date_str->can('ymd')) {
        $dt = $date_str;
    } elsif ($date_str =~ /^(\d{4})-(\d{2})-(\d{2})/) {
        # Format: YYYY-MM-DD
        $dt = DateTime->new(year => $1, month => $2, day => $3);
    } elsif ($date_str =~ /^(\d{4})-(\d{2})-(\d{2})\s/) {
        # Format: YYYY-MM-DD HH:MM:SS
        $dt = DateTime::Format::MySQL->parse_datetime($date_str);
    } else {
        return $date_str; # Fallback: Original zurückgeben
    }
    
    return sprintf('%02d.%02d.%04d', $dt->day, $dt->month, $dt->year);
}

sub generate_invoice_pdf {
    my ($self, $invoice_id, $include_timesheet) = @_;
    
    my $schema = $self->schema;
    my $invoice = $schema->resultset('Invoice')->find($invoice_id);
    die "Rechnung nicht gefunden" unless $invoice;
    
    my $customer = $schema->resultset('Customer')->find($invoice->customer_id);
    die "Kunde nicht gefunden" unless $customer;
    
    my $supplier = $schema->resultset('Supplier')->first;
    die "Rechnungsempfänger nicht gefunden" unless $supplier;
    
    # Prüfe ob Reverse Charge aktiv ist
    my $reverse_charge = $customer->reverse_charge || 0;
    
    my $items_rs = $schema->resultset('InvoiceItem')->search({ invoice_id => $invoice_id });
    
    # Erstelle PDF
    my $pdf = PDF::API2->new;
    my $page = $pdf->page;
    my $gfx = $page->gfx;
    my $text = $page->text;
    
    # Fonts
    my $font_helvetica = $pdf->corefont('Helvetica');
    my $font_helvetica_bold = $pdf->corefont('Helvetica-Bold');
    
    my $y = 800;
    my $margin = 50;
    my $page_width = 595; # A4 width in points
    my $page_height = 842; # A4 height in points
    my $footer_y = 50; # Position für Fußzeile
    
    # Header: Rechnungsempfänger (rechts oben)
    $text->font($font_helvetica_bold, 14);
    my $supplier_name_width = $text->advancewidth($supplier->name);
    $text->translate($page_width - $margin - $supplier_name_width, $y);
    $text->text($supplier->name);
    $y -= 20;
    
    $text->font($font_helvetica, 9);
    my $supplier_address = $supplier->address;
    my $supplier_address_width = $text->advancewidth($supplier_address);
    $text->translate($page_width - $margin - $supplier_address_width, $y);
    $text->text($supplier_address);
    $y -= 15;
    
    my $supplier_city = $supplier->zip_code . ' ' . $supplier->city;
    my $supplier_city_width = $text->advancewidth($supplier_city);
    $text->translate($page_width - $margin - $supplier_city_width, $y);
    $text->text($supplier_city);
    $y -= 15;
    
    if ($supplier->email) {
        my $email_width = $text->advancewidth($supplier->email);
        $text->translate($page_width - $margin - $email_width, $y);
        $text->text($supplier->email);
        $y -= 15;
    }
    
    $y = 800; # Reset für linke Seite
    
    # Rechnungstitel
    $text->font($font_helvetica_bold, 24);
    $text->translate($margin, $y);
    $text->text('RECHNUNG');
    $y -= 40;
    
    # Rechnungsnummer und Datum
    $text->font($font_helvetica, 10);
    $text->translate($margin, $y);
    $text->text('Rechnungsnummer: ' . $invoice->invoice_number);
    $y -= 15;
    
    # Rechnungsdatum (aus created_at)
    my $invoice_date = $invoice->created_at;
    my $invoice_date_formatted = format_date_dd_mm_yyyy($invoice_date);
    if (!$invoice_date_formatted) {
        $invoice_date_formatted = format_date_dd_mm_yyyy($invoice->date_from);
    }
    $text->translate($margin, $y);
    $text->text('Rechnungsdatum: ' . $invoice_date_formatted);
    $y -= 15;
    
    # Leistungszeitraum
    $text->translate($margin, $y);
    $text->text('Leistungszeitraum: ' . format_date_dd_mm_yyyy($invoice->date_from) . ' - ' . format_date_dd_mm_yyyy($invoice->date_to));
    $y -= 15;
    
    # Zahlungsziel
    if ($invoice->due_date) {
        $text->translate($margin, $y);
        $text->text('Zahlungsziel: ' . format_date_dd_mm_yyyy($invoice->due_date) . ($invoice->payment_terms ? ' (' . $invoice->payment_terms . ' Tage)' : ''));
        $y -= 15;
    }
    $y -= 15;
    
    # Kunde
    $text->font($font_helvetica_bold, 12);
    $text->translate($margin, $y);
    $text->text('Rechnungsempfänger:');
    $y -= 20;
    
    $text->font($font_helvetica, 10);
    $text->translate($margin, $y);
    $text->text($customer->company || $customer->name);
    $y -= 15;
    $text->translate($margin, $y);
    $text->text($customer->address);
    $y -= 15;
    $text->translate($margin, $y);
    $text->text($customer->zip_code . ' ' . $customer->city);
    $y -= 40;
    
    # Positionen
    $text->font($font_helvetica_bold, 12);
    $text->translate($margin, $y);
    $text->text('Positionen:');
    $y -= 25;
    
    # Tabellenkopf - Spaltenpositionen definieren
    my $col_desc_x = $margin;                    # Beschreibung: links
    my $col_anzahl_right = $margin + 280;        # Anzahl: rechtsbündig bis 280px
    my $col_satz_right = $margin + 380;          # Satz: rechtsbündig bis 380px
    my $col_betrag_right = $page_width - $margin; # Betrag: rechtsbündig bis rechter Rand
    
    $text->font($font_helvetica_bold, 9);
    $text->translate($col_desc_x, $y);
    $text->text('Beschreibung');
    
    # Anzahl-Spalte: rechtsbündig ausrichten
    my $anzahl_label = 'Anzahl';
    my $anzahl_label_width = $text->advancewidth($anzahl_label);
    $text->translate($col_anzahl_right - $anzahl_label_width, $y);
    $text->text($anzahl_label);
    
    # Satz-Spalte: rechtsbündig ausrichten
    my $satz_label = 'Satz';
    my $satz_label_width = $text->advancewidth($satz_label);
    $text->translate($col_satz_right - $satz_label_width, $y);
    $text->text($satz_label);
    
    # Betrag-Spalte: rechtsbündig ausrichten
    my $betrag_label = 'Betrag';
    my $betrag_label_width = $text->advancewidth($betrag_label);
    $text->translate($col_betrag_right - $betrag_label_width, $y);
    $text->text($betrag_label);
    $y -= 20;
    
    # Linie
    $gfx->strokecolor('black');
    $gfx->move($margin, $y);
    $gfx->line($page_width - $margin, $y);
    $gfx->stroke;
    $y -= 15;
    
    # Positionen - sortiert nach RateType (DAILY zuerst, dann HOURLY)
    $text->font($font_helvetica, 9);
    
    # Lade alle Items in ein Array und sortiere sie
    my @items = ();
    while (my $item = $items_rs->next) {
        push @items, $item;
    }
    
    # Sortiere: DAILY zuerst, dann HOURLY
    @items = sort {
        my $a_type = $a->rate_type || '';
        my $b_type = $b->rate_type || '';
        if ($a_type eq 'DAILY' && $b_type ne 'DAILY') {
            return -1;
        } elsif ($a_type ne 'DAILY' && $b_type eq 'DAILY') {
            return 1;
        }
        return 0;
    } @items;
    
    foreach my $item (@items) {
        # Beschreibung (links) - für Tagessätze mit Datum
        my $description = $item->description || 'Position';
        
        # Wenn Tagessatz, füge Datum hinzu falls verfügbar
        if ($item->rate_type eq 'DAILY' && $item->time_entry_id) {
            # Versuche das Datum aus dem Zeiteintrag zu holen
            my $time_entry_ids = $item->time_entry_id;
            # Wenn mehrere IDs, nimm die erste
            my $first_id = (split(',', $time_entry_ids))[0];
            if ($first_id) {
                my $time_entry = $schema->resultset('TimeEntry')->find($first_id);
                if ($time_entry && $time_entry->date) {
                    my $entry_date = format_date_dd_mm_yyyy($time_entry->date);
                    $description = $description . ' (' . $entry_date . ')';
                }
            }
        }
        
        $text->translate($col_desc_x, $y);
        $text->text($description);
        
        # Anzahl (rechtsbündig unter der "Anzahl"-Spalte)
        # Bei Tagessätzen: zeige bereits die Anzahl der Tage (wird im InvoiceService als Tage gespeichert)
        # Bei Stundensätzen: zeige Stunden
        my $quantity_text;
        if ($item->rate_type eq 'DAILY') {
            # Bei Tagessätzen ist hours bereits die Anzahl der Tage
            $quantity_text = sprintf('%.2f', $item->hours || 0);
        } else {
            $quantity_text = sprintf('%.2f', $item->hours || 0);
        }
        my $quantity_width = $text->advancewidth($quantity_text);
        $text->translate($col_anzahl_right - $quantity_width, $y);
        $text->text($quantity_text);
        
        # Satz (rechtsbündig unter der "Satz"-Spalte)
        my $rate_text = sprintf('%.2f €', $item->rate || 0);
        my $rate_width = $text->advancewidth($rate_text);
        $text->translate($col_satz_right - $rate_width, $y);
        $text->text($rate_text);
        
        # Betrag (rechtsbündig, mit mehr Platz)
        my $amount_text = sprintf('%.2f €', $item->amount || 0);
        my $amount_width = $text->advancewidth($amount_text);
        $text->translate($col_betrag_right - $amount_width, $y);
        $text->text($amount_text);
        
        $y -= 20;
        
        # Prüfe ob noch Platz auf der Seite ist
        if ($y < $footer_y + 100) { # Genug Platz für Footer lassen
            # Neue Seite erstellen
            $page = $pdf->addpage();
            $gfx = $page->gfx;
            $text = $page->text;
            $y = 800; # Startposition auf neuer Seite
            
            # Optional: Wiederhole Header auf neuen Seiten
            # ... (hier könnte Logik für wiederholten Header stehen)
        }
    }
    
    $y -= 20;
    
    # Linie
    $gfx->strokecolor('black');
    $gfx->move($margin, $y);
    $gfx->line($page_width - $margin, $y);
    $gfx->stroke;
    $y -= 20;
    
    # Summen
    $text->font($font_helvetica, 10);
    
    # Berechne Zwischensumme aus den Positionen (zur Sicherheit)
    my $calculated_subtotal = 0;
    foreach my $item (@items) {
        $calculated_subtotal += $item->amount;
    }
    
    # Verwende den berechneten Wert oder den Wert aus der Datenbank
    my $display_subtotal = $calculated_subtotal > 0 ? $calculated_subtotal : ($invoice->subtotal || 0);
    
    my $subtotal_label = 'Zwischensumme:';
    my $subtotal_label_width = $text->advancewidth($subtotal_label);
    $text->translate($col_betrag_right - 150 - $subtotal_label_width, $y); # 150px Abstand zum Betrag
    $text->text($subtotal_label);
    $text->translate($col_betrag_right - $text->advancewidth(sprintf('%.2f €', $display_subtotal)), $y);
    $text->text(sprintf('%.2f €', $display_subtotal));
    $y -= 20;
    
    if ($invoice->tax_amount && $invoice->tax_amount > 0) {
        my $tax_label = 'MwSt (' . sprintf('%.0f', $invoice->tax_rate) . '%):';
        my $tax_label_width = $text->advancewidth($tax_label);
        $text->translate($col_betrag_right - 150 - $tax_label_width, $y);
        $text->text($tax_label);
        $text->translate($col_betrag_right - $text->advancewidth(sprintf('%.2f €', $invoice->tax_amount)), $y);
        $text->text(sprintf('%.2f €', $invoice->tax_amount));
        $y -= 20;
    }
    
    # Berechne Gesamtbetrag
    my $display_total = $display_subtotal + ($invoice->tax_amount || 0);
    
    $text->font($font_helvetica_bold, 12);
    my $total_label = 'Gesamtbetrag:';
    my $total_label_width = $text->advancewidth($total_label);
    $text->translate($col_betrag_right - 150 - $total_label_width, $y);
    $text->text($total_label);
    $text->translate($col_betrag_right - $text->advancewidth(sprintf('%.2f €', $display_total)), $y);
    $text->text(sprintf('%.2f €', $display_total));
    $y -= 30;
    
    # Reverse Charge Hinweis (wenn keine MwSt oder Reverse Charge aktiv)
    if ($invoice->tax_type eq 'NONE' || $invoice->tax_amount == 0 || $reverse_charge) {
        $text->font($font_helvetica, 9);
        $text->translate($margin, $y);
        $text->text('Hinweis: Die Rechnung unterliegt der Steuerschuldumkehr (Reverse Charge). Die Umsatzsteuer wird vom Leistungsempfänger geschuldet.');
        $y -= 20;
    }
    
    # Fußzeile mit Bankverbindung, Adresse und Steuerinformationen
    $y = $footer_y;
    
    # Linie über Fußzeile
    $gfx->move($margin, $y + 30);
    $gfx->line($page_width - $margin, $y + 30);
    $gfx->stroke;
    $y += 10;
    
    $text->font($font_helvetica, 8);
    
    # Linke Spalte: Adresse
    $text->translate($margin, $y);
    $text->text($supplier->name);
    $y -= 12;
    $text->translate($margin, $y);
    $text->text($supplier->address);
    $y -= 12;
    $text->translate($margin, $y);
    $text->text($supplier->zip_code . ' ' . $supplier->city);
    $y -= 12;
    if ($supplier->country) {
        $text->translate($margin, $y);
        $text->text($supplier->country);
        $y -= 12;
    }
    
    # Mittlere Spalte: Bankverbindung
    my $middle_x = $page_width / 2 - 50;
    $y = $footer_y + 10;
    if ($supplier->bank_name) {
        $text->translate($middle_x, $y);
        $text->text('Bank: ' . $supplier->bank_name);
        $y -= 12;
    }
    if ($supplier->iban) {
        $text->translate($middle_x, $y);
        $text->text('IBAN: ' . $supplier->iban);
        $y -= 12;
    }
    if ($supplier->bic) {
        $text->translate($middle_x, $y);
        $text->text('BIC: ' . $supplier->bic);
        $y -= 12;
    }
    
    # Rechte Spalte: Steuerinformationen
    my $right_x = $page_width - $margin - 150;
    $y = $footer_y + 10;
    if ($supplier->tax_id) {
        $text->translate($right_x, $y);
        $text->text('Steuernummer: ' . $supplier->tax_id);
        $y -= 12;
    }
    if ($supplier->vat_id) {
        $text->translate($right_x, $y);
        $text->text('USt-IdNr.: ' . $supplier->vat_id);
        $y -= 12;
    }
    if ($supplier->hra_hrb_number) {
        $text->translate($right_x, $y);
        $text->text('HRA/HRB: ' . $supplier->hra_hrb_number);
        $y -= 12;
    }
    
    # Wenn Stundenzettel angehängt werden soll, füge ihn hinzu
    if ($include_timesheet) {
        eval {
            my $timesheet_pdf_data = $self->generate_timesheet_pdf($invoice->customer_id, $invoice->date_from, $invoice->date_to);
            if ($timesheet_pdf_data) {
                # Erstelle ein neues PDF-Objekt aus dem Stundenzettel
                my $timesheet_pdf = PDF::API2->open_scalar($timesheet_pdf_data);
                
                # Füge alle Seiten des Stundenzettels zur Rechnung hinzu
                my $page_count = $timesheet_pdf->pages;
                for my $page_num (1 .. $page_count) {
                    my $timesheet_page = $timesheet_pdf->openpage($page_num);
                    my $new_page = $pdf->page;
                    $new_page->mediabox($timesheet_page->mediabox);
                    $new_page->gfx->formimage($timesheet_page, 0, 0, 1);
                }
            }
        } or do {
            # Fehler beim Anhängen des Stundenzettels - ignoriere und fahre fort
            warn "Fehler beim Anhängen des Stundenzettels: $@";
        };
    }
    
    return $pdf->stringify;
}

sub generate_timesheet_pdf {
    my ($self, $customer_id, $date_from, $date_to) = @_;
    
    my $schema = $self->schema;
    my $customer = $schema->resultset('Customer')->find($customer_id);
    die "Kunde nicht gefunden" unless $customer;
    
    my $supplier = $schema->resultset('Supplier')->first;
    die "Rechnungsempfänger nicht gefunden" unless $supplier;
    
    # Lade Zeiteinträge für den Zeitraum
    my $time_entries_rs = $schema->resultset('TimeEntry')->search({
        customer_id => $customer_id,
        date => {
            -between => [$date_from, $date_to]
        }
    }, {
        order_by => 'date ASC'
    });
    
    # Prüfe ob Zeiteinträge vorhanden sind
    if ($time_entries_rs->count == 0) {
        die "Keine Zeiteinträge für den gewählten Zeitraum gefunden";
    }
    
    # Erstelle PDF im Querformat (Landscape)
    my $pdf = PDF::API2->new;
    # A4 Querformat: Breite 842pt, Höhe 595pt
    my $page = $pdf->page(842, 595); # Breite x Höhe für Querformat
    my $gfx = $page->gfx;
    my $text = $page->text;
    
    # Fonts
    my $font_helvetica = $pdf->corefont('Helvetica');
    my $font_helvetica_bold = $pdf->corefont('Helvetica-Bold');
    
    my $y = 550; # Startposition für Querformat (Höhe ist jetzt 595pt)
    my $margin = 50;
    my $page_width = 842; # A4 Querformat Breite in points
    my $page_height = 595; # A4 Querformat Höhe in points
    my $footer_y = 50;
    
    # Header: Rechnungsempfänger (rechts oben)
    $text->font($font_helvetica_bold, 14);
    my $supplier_name_width = $text->advancewidth($supplier->name);
    $text->translate($page_width - $margin - $supplier_name_width, $y);
    $text->text($supplier->name);
    $y -= 20;
    
    $text->font($font_helvetica, 9);
    my $supplier_address = $supplier->address;
    my $supplier_address_width = $text->advancewidth($supplier_address);
    $text->translate($page_width - $margin - $supplier_address_width, $y);
    $text->text($supplier_address);
    $y -= 15;
    
    my $supplier_city = $supplier->zip_code . ' ' . $supplier->city;
    my $supplier_city_width = $text->advancewidth($supplier_city);
    $text->translate($page_width - $margin - $supplier_city_width, $y);
    $text->text($supplier_city);
    $y -= 15;
    
    if ($supplier->email) {
        my $email_width = $text->advancewidth($supplier->email);
        $text->translate($page_width - $margin - $email_width, $y);
        $text->text($supplier->email);
        $y -= 15;
    }
    
    $y = 550; # Reset für linke Seite (Querformat)
    
    # Titel
    $text->font($font_helvetica_bold, 24);
    $text->translate($margin, $y);
    $text->text('STUNDENZETTEL');
    $y -= 40;
    
    # Kunde
    $text->font($font_helvetica_bold, 12);
    $text->translate($margin, $y);
    $text->text('Kunde:');
    $y -= 20;
    
    $text->font($font_helvetica, 10);
    $text->translate($margin, $y);
    $text->text($customer->company || $customer->name);
    $y -= 15;
    $text->translate($margin, $y);
    $text->text($customer->address);
    $y -= 15;
    $text->translate($margin, $y);
    $text->text($customer->zip_code . ' ' . $customer->city);
    $y -= 30;
    
    # Zeitraum
    $text->font($font_helvetica, 10);
    $text->translate($margin, $y);
    $text->text('Zeitraum: ' . format_date_dd_mm_yyyy($date_from) . ' - ' . format_date_dd_mm_yyyy($date_to));
    $y -= 30;
    
    # Tabelle
    $text->font($font_helvetica_bold, 9);
    
    # Tabellenkopf - Spaltenpositionen definieren (Querformat)
    # A4 Querformat Breite: 842pt, Margin: 50pt auf jeder Seite = 742pt verfügbar
    my $col_date_x = $margin;                    # Datum: links, 50pt
    my $col_desc_x = $margin + 70;              # Beschreibung: ab 120pt
    my $col_desc_max = $margin + 350;           # Beschreibung max bis 400pt (280pt Breite)
    my $col_hours_right = $margin + 450;        # Stunden: rechtsbündig bis 500pt
    my $col_rate_right = $margin + 580;         # Satz: rechtsbündig bis 630pt
    my $col_amount_right = $page_width - $margin; # Betrag: rechtsbündig bis 792pt
    
    $text->translate($col_date_x, $y);
    $text->text('Datum');
    
    $text->translate($col_desc_x, $y);
    $text->text('Beschreibung');
    
    my $hours_label = 'Stunden';
    my $hours_label_width = $text->advancewidth($hours_label);
    $text->translate($col_hours_right - $hours_label_width, $y);
    $text->text($hours_label);
    
    # Satz-Spalte (rechtsbündig)
    my $rate_label = 'Satz';
    my $rate_label_width = $text->advancewidth($rate_label);
    $text->translate($col_rate_right - $rate_label_width, $y);
    $text->text($rate_label);
    
    # Betrag-Spalte (rechtsbündig, ganz rechts)
    my $amount_label = 'Betrag';
    my $amount_label_width = $text->advancewidth($amount_label);
    $text->translate($col_amount_right - $amount_label_width, $y);
    $text->text($amount_label);
    $y -= 20;
    
    # Linie
    $gfx->strokecolor('black');
    $gfx->move($margin, $y);
    $gfx->line($page_width - $margin, $y);
    $gfx->stroke;
    $y -= 15;
    
    # Zeiteinträge
    $text->font($font_helvetica, 9);
    my $total_hours = 0;
    my $total_amount = 0;
    
    while (my $entry = $time_entries_rs->next) {
        # Prüfe ob noch Platz auf der Seite ist
        if ($y < $footer_y + 100) {
            # Neue Seite erstellen (Querformat)
            $page = $pdf->addpage(842, 595);
            $gfx = $page->gfx;
            $text = $page->text;
            $y = 550; # Startposition für Querformat
        }
        
        # Lade Stundensatz
        my $rate = $schema->resultset('HourlyRate')->find($entry->hourly_rate_id);
        my $rate_type = $rate ? ($rate->rate_type || 'HOURLY') : 'HOURLY';
        my $rate_value = $rate ? $rate->rate : 0;
        my $hours = $entry->hours || 0;
        my $amount = $rate_type eq 'DAILY' ? $rate_value : ($hours * $rate_value);
        
        $total_hours += $hours;
        $total_amount += $amount;
        
        # Datum
        $text->translate($col_date_x, $y);
        $text->text(format_date_dd_mm_yyyy($entry->date));
        
        # Beschreibung (mit maximaler Breite, wird gekürzt falls zu lang)
        my $description = $entry->description || '-';
        my $desc_width = $text->advancewidth($description);
        # Kürze Beschreibung falls zu lang (max 280pt = col_desc_max - col_desc_x)
        if ($desc_width > ($col_desc_max - $col_desc_x)) {
            my $max_width = $col_desc_max - $col_desc_x;
            # Versuche die Beschreibung zu kürzen
            my $shortened = '';
            my $current_width = 0;
            my $ellipsis_width = $text->advancewidth('...');
            for my $char (split //, $description) {
                my $char_width = $text->advancewidth($char);
                if ($current_width + $char_width + $ellipsis_width > $max_width) {
                    last;
                }
                $shortened .= $char;
                $current_width += $char_width;
            }
            $description = $shortened . '...';
        }
        $text->translate($col_desc_x, $y);
        $text->text($description);
        
        # Stunden
        my $hours_text = sprintf('%.2f', $hours);
        my $hours_width = $text->advancewidth($hours_text);
        $text->translate($col_hours_right - $hours_width, $y);
        $text->text($hours_text);
        
        # Satz (rechtsbündig, feste Position)
        my $rate_text = sprintf('%.2f €/%s', $rate_value, $rate_type eq 'DAILY' ? 'Tag' : 'h');
        my $rate_width = $text->advancewidth($rate_text);
        $text->translate($col_rate_right - $rate_width, $y);
        $text->text($rate_text);
        
        # Betrag (rechtsbündig, ganz rechts, feste Position)
        my $amount_text = sprintf('%.2f €', $amount);
        my $amount_width = $text->advancewidth($amount_text);
        $text->translate($col_amount_right - $amount_width, $y);
        $text->text($amount_text);
        
        $y -= 20;
    }
    
    # Gesamtsumme
    $y -= 10;
    $gfx->move($margin, $y);
    $gfx->line($page_width - $margin, $y);
    $gfx->stroke;
    $y -= 20;
    
    $text->font($font_helvetica_bold, 10);
    $text->translate($col_desc_x, $y);
    $text->text('Gesamt:');
    
    # Gesamt-Stunden (rechtsbündig)
    my $total_hours_text = sprintf('%.2f', $total_hours);
    my $total_hours_width = $text->advancewidth($total_hours_text);
    $text->translate($col_hours_right - $total_hours_width, $y);
    $text->text($total_hours_text);
    
    # Gesamt-Betrag (rechtsbündig, ganz rechts)
    my $total_amount_text = sprintf('%.2f €', $total_amount);
    my $total_amount_width = $text->advancewidth($total_amount_text);
    $text->translate($col_amount_right - $total_amount_width, $y);
    $text->text($total_amount_text);
    
    $y -= 50;
    
    # Genehmigungsfeld
    $text->font($font_helvetica, 9);
    $text->translate($margin, $y);
    $text->text('Genehmigt durch:');
    $y -= 30;
    
    # Linie für Name
    $gfx->strokecolor('black');
    $gfx->move($margin, $y);
    $gfx->line($margin + 200, $y);
    $gfx->stroke;
    $y -= 5;
    $text->font($font_helvetica, 8);
    $text->translate($margin, $y);
    $text->text('Name');
    $y -= 25;
    
    # Linie für Unterschrift
    $gfx->move($margin, $y);
    $gfx->line($margin + 200, $y);
    $gfx->stroke;
    $y -= 5;
    $text->translate($margin, $y);
    $text->text('Unterschrift');
    
    return $pdf->stringify;
}

1;
