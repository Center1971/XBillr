package XBillr::Controller::Invoices;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Service::InvoiceService;

sub list {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        my $invoices = $service->get_all_invoices(0);
        
        my @result;
        while (my $invoice = $invoices->next) {
            push @result, $c->_invoice_to_hash($invoice);
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub list_archived {
    my $c = shift;
    
    eval {
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        my $invoices = $service->get_archived_invoices;
        
        my @result;
        while (my $invoice = $invoices->next) {
            push @result, $c->_invoice_to_hash($invoice);
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        
        # Input-Validierung
        my $validator = $c->app->validator;
        my @errors = $validator->validate_invoice($data);
        
        if (@errors) {
            return $c->render(
                json => { error => 'Validierungsfehler', details => \@errors },
                status => 400
            );
        }
        
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        my $invoice = $service->create_invoice({
            customer_id => $data->{customerId},
            date_from => $data->{dateFrom},
            date_to => $data->{dateTo},
            tax_rate => $data->{taxRate},
            tax_type => $data->{taxType},
            payment_terms => $data->{paymentTerms},
            include_timesheet => $data->{includeTimesheet} // 0,
        });
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice created: " . $invoice->id);
        
        $c->render(json => $c->_invoice_to_hash($invoice), status => 201);
    } or do {
        my $error = $@;
        $c->app->log->error("Error creating invoice: $error");
        
        # Generische Fehlermeldungen ohne interne Details
        if ($error =~ /nicht gefunden/ || $error =~ /Keine Zeiteinträge/) {
            $c->render(
                json => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte überprüfen Sie, ob alle erforderlichen Daten vorhanden sind.' },
                status => 400
            );
        } else {
            $c->render(
                json => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' },
                status => 500
            );
        }
    };
}

sub get {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        
        if ($invoice) {
            my $service = XBillr::Service::InvoiceService->new(
                schema => $schema
            );
            my $items = $service->get_invoice_items($id);
            
            my $result = $c->_invoice_to_hash($invoice);
            $result->{items} = [];
            while (my $item = $items->next) {
                push @{$result->{items}}, {
                    id => $item->id,
                    invoiceId => $item->invoice_id,
                    timeEntryId => $item->time_entry_id,
                    description => $item->description,
                    hours => $item->hours,
                    rate => $item->rate,
                    amount => $item->amount,
                    rateType => $item->rate_type,
                };
            }
            
            $c->render(json => $result, status => 200);
        } else {
            $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        
        if ($invoice) {
            $invoice->update({
                invoice_number => $data->{invoiceNumber},
                customer_id => $data->{customerId},
                date_from => $data->{dateFrom},
                date_to => $data->{dateTo},
                subtotal => $data->{subtotal},
                tax_rate => $data->{taxRate},
                tax_amount => $data->{taxAmount},
                total => $data->{total},
                tax_type => $data->{taxType},
                status => $data->{status},
                payment_terms => $data->{paymentTerms},
                due_date => $data->{dueDate},
            });
            
            $c->render(json => $c->_invoice_to_hash($invoice), status => 200);
        } else {
            $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(json => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub delete {
    my $c = shift;
    
    eval {
        my $id = $c->stash('id') || $c->param('id');
        
        unless ($id) {
            return $c->render(json => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        
        unless ($invoice) {
            return $c->render(json => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
        
        # Lösche zuerst alle Invoice Items (Cascade Delete)
        eval {
            my $items = $schema->resultset('InvoiceItem')->search({ invoice_id => $id });
            while (my $item = $items->next) {
                $item->delete;
            }
        };
        if ($@) {
            $c->app->log->warn("Error deleting invoice items: $@");
            # Weiter mit dem Löschen der Rechnung
        }
        
        # Lösche dann die Rechnung
        $invoice->delete;
        
        # Sicherheits-Logging
        $c->app->log->info("Invoice deleted: " . $id);
        
        $c->render(json => { message => 'Rechnung erfolgreich gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting invoice: $error");
        $c->app->log->error("Stack trace: " . $error->can('as_string') ? $error->as_string : $error);
        $c->render(json => { error => 'Die Rechnung konnte nicht gelöscht werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
    };
}

sub archive {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        $service->archive_invoice($id);
        $c->render(json => {}, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/) {
            $c->render(json => { error => $error }, status => 404);
        } else {
            $c->render(json => { error => $error }, status => 500);
        }
    };
}

sub unarchive {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        $service->unarchive_invoice($id);
        $c->render(json => {}, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/) {
            $c->render(json => { error => $error }, status => 404);
        } else {
            $c->render(json => { error => $error }, status => 500);
        }
    };
}

sub duplicate {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        my $new_invoice = $service->duplicate_archived_invoice($id);
        my $items = $service->get_invoice_items($new_invoice->id);
        
        my $result = $c->_invoice_to_hash($new_invoice);
        $result->{items} = [];
        while (my $item = $items->next) {
            push @{$result->{items}}, {
                id => $item->id,
                invoiceId => $item->invoice_id,
                timeEntryId => $item->time_entry_id,
                description => $item->description,
                hours => $item->hours,
                rate => $item->rate,
                amount => $item->amount,
                rateType => $item->rate_type,
            };
        }
        
        $c->render(json => $result, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/ || $error =~ /Nur archivierte/) {
            $c->render(json => { error => $error }, status => 400);
        } else {
            $c->render(json => { error => $error }, status => 500);
        }
    };
}

sub _invoice_to_hash {
    my ($c, $invoice) = @_;
    return {
        id => $invoice->id,
        invoiceNumber => $invoice->invoice_number,
        customerId => $invoice->customer_id,
        dateFrom => $invoice->date_from,
        dateTo => $invoice->date_to,
        subtotal => $invoice->subtotal,
        taxRate => $invoice->tax_rate,
        taxAmount => $invoice->tax_amount,
        total => $invoice->total,
        taxType => $invoice->tax_type,
        status => $invoice->status,
        paymentTerms => $invoice->payment_terms,
        dueDate => $invoice->due_date,
        xrechnungXml => $invoice->xrechnung_xml,
        archived => $invoice->archived ? 1 : 0,
        archivedAt => $invoice->archived_at,
        createdAt => $invoice->created_at,
    };
}

1;

