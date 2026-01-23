package XBillr::Controller::Invoices;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use XBillr::Service::InvoiceService;

sub list {
    my $c = shift;
    
    eval {
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }
        my $schema = $c->app->schema;
        my $invoices;
        if (@$tenant_ids) {
            $invoices = $schema->resultset('Invoice')->search({
                customer_id => { -in => $tenant_ids },
            }, { order_by => { -desc => 'created_at' } });
        } elsif (($auth_user->{type} || '') eq 'oidc') {
            $invoices = $schema->resultset('Invoice')->search({ id => '__none__' });
        } else {
            $invoices = $schema->resultset('Invoice')->search({}, { order_by => { -desc => 'created_at' } });
        }
        
        my @result;
        while (my $invoice = $invoices->next) {
            push @result, $c->_invoice_to_hash($invoice);
        }
        
        $c->render(openapi => \@result, status => 200);
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub list_archived {
    my $c = shift;
    
    eval {
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }
        my $schema = $c->app->schema;
        my $search = { archived => 1 };
        $search->{customer_id} = { -in => $tenant_ids } if @$tenant_ids;
        $search->{id} = '__none__' if (($auth_user->{type} || '') eq 'oidc') && !@$tenant_ids;
        my $invoices = $schema->resultset('Invoice')->search($search, { order_by => { -desc => 'created_at' } });
        
        my @result;
        while (my $invoice = $invoices->next) {
            push @result, $c->_invoice_to_hash($invoice);
        }
        
        $c->render(openapi => \@result, status => 200);
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub open_posts {
    my $c = shift;

    eval {
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }
        my $schema = $c->app->schema;
        my $invoices_rs = $schema->resultset('Invoice')->search(
            {
                archived => 1,
                due_date => { '!=' => undef },
                (@$tenant_ids ? (customer_id => { -in => $tenant_ids }) : ()),
            },
            {
                order_by => { -asc => 'created_at' },
                join => 'customer',
                '+select' => ['customer.company', 'customer.name'],
                '+as' => ['customer_company', 'customer_name'],
            }
        );

        my @result;
        while (my $invoice = $invoices_rs->next) {
            my $customer = $invoice->customer;
            push @result, {
                id => $invoice->id,
                invoiceNumber => $invoice->invoice_number,
                customerId => $invoice->customer_id,
                customerName => $customer ? ($customer->company || $customer->name || 'Unbekannt') : 'Unbekannt',
                createdAt => $invoice->created_at,
                total => $invoice->total,
                dueDate => $invoice->due_date,
                paymentTerms => $invoice->payment_terms,
            };
        }

        $c->render(openapi => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error listing open posts: $error");
        $c->render(openapi => { error => 'Die offenen Posten konnten nicht geladen werden.', details => "$error" }, status => 500);
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
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            unless (@$tenant_ids && grep { $_ eq $data->{customerId} } @$tenant_ids) {
                return $c->render(openapi => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
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
        
        $c->render(openapi => $c->_invoice_to_hash($invoice), status => 201);
    } or do {
        my $error = $@;
        $c->app->log->error("Error creating invoice: $error");
        
        # Generische Fehlermeldungen ohne interne Details
        if ($error =~ /nicht gefunden/ || $error =~ /Keine Zeiteinträge/) {
            $c->render(openapi => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte überprüfen Sie, ob alle erforderlichen Daten vorhanden sind.' }, status => 400);
        } else {
            $c->render(openapi => { error => 'Die Rechnung konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' }, status => 500);
        }
    };
}

sub get {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
        
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
            
            $c->render(openapi => $result, status => 200);
        } else {
            $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
        
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
            
            $c->render(openapi => $c->_invoice_to_hash($invoice), status => 200);
        } else {
            $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }
    } or do {
        $c->render(openapi => { error => 'Die Daten konnten nicht verarbeitet werden. Bitte versuchen Sie es später erneut.' }, status => 500);
    };
}

sub xml {
    my $c = shift;

    eval {
        require XBillr::Service::XRechnungService;
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die XML-Datei konnte nicht generiert werden.' }, status => 404);
            }
        }
        my $service = XBillr::Service::XRechnungService->new(schema => $schema);

        my $xml = $service->generate_xrechnung_xml($id);

        if ($invoice) {
            $invoice->update({ xrechnung_xml => $xml });
        }

        $c->res->headers->content_type('application/xml; charset=utf-8');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="rechnung_' . ($invoice ? $invoice->invoice_number : $id) . '.xml"');
        $c->render(data => $xml);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating XML: $error");
        $c->render(openapi => { error => 'Die XML-Datei konnte nicht generiert werden.' }, status => 500);
    };
}

sub pdf {
    my $c = shift;

    eval {
        require XBillr::Service::PDFService;
        my $id = $c->stash('id');
        my $include_timesheet = $c->param('include_timesheet') || 0;
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die PDF-Datei konnte nicht generiert werden.' }, status => 404);
            }
        }
        my $service = XBillr::Service::PDFService->new(schema => $schema);

        my $pdf_data = $service->generate_invoice_pdf($id, $include_timesheet);

        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="rechnung_' . ($invoice ? $invoice->invoice_number : $id) . '.pdf"');
        $c->render(data => $pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating PDF: $error");
        $c->render(openapi => { error => 'Die PDF-Datei konnte nicht generiert werden.' }, status => 500);
    };
}

sub correct {
    my $c = shift;

    eval {
        my $id = $c->stash('id');
        my $data = $c->req->json;

        unless ($id) {
            return $c->render(openapi => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }

        my $schema = $c->app->schema;
        my $original_invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($original_invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $original_invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }

        unless ($original_invoice) {
            return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        }

        unless ($original_invoice->archived) {
            return $c->render(openapi => { error => 'Nur archivierte Rechnungen können korrigiert werden.' }, status => 400);
        }

        my $service = XBillr::Service::InvoiceService->new(schema => $schema);

        my $customer_id = $data->{customerId} || $original_invoice->customer_id;
        my $date_from = $data->{dateFrom} || $original_invoice->date_from;
        my $date_to = $data->{dateTo} || $original_invoice->date_to;
        my $tax_rate = $data->{taxRate} || $original_invoice->tax_rate;
        my $tax_type = $data->{taxType} || $original_invoice->tax_type;
        my $payment_terms = $data->{paymentTerms} || $original_invoice->payment_terms;

        my $new_invoice = $service->create_invoice({
            customer_id => $customer_id,
            date_from => $date_from,
            date_to => $date_to,
            tax_rate => $tax_rate,
            tax_type => $tax_type,
            payment_terms => $payment_terms,
            include_timesheet => 0,
        });

        my $original_number = $original_invoice->invoice_number;
        my $corrected_number = $original_number . '-KOR';

        my $existing_correction = $schema->resultset('Invoice')->search({
            invoice_number => $corrected_number
        })->first;

        if ($existing_correction) {
            my $counter = 1;
            my $new_corrected_number;
            do {
                $new_corrected_number = $corrected_number . '-' . $counter;
                $existing_correction = $schema->resultset('Invoice')->search({
                    invoice_number => $new_corrected_number
                })->first;
                $counter++;
            } while ($existing_correction);
            $corrected_number = $new_corrected_number;
        }

        $new_invoice->update({
            invoice_number => $corrected_number
        });

        $c->app->log->info("Invoice corrected: $id -> " . $new_invoice->id . " ($corrected_number)");

        $c->render(openapi => {
            id => $new_invoice->id,
            invoiceNumber => $corrected_number,
            message => 'Korrektur-Rechnung erfolgreich erstellt'
        }, status => 201);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error creating corrected invoice: $error");
        if ($error =~ /nicht gefunden/ || $error =~ /Keine Zeiteinträge/) {
            $c->render(openapi => { error => 'Die Korrektur-Rechnung konnte nicht erstellt werden. Bitte überprüfen Sie, ob alle erforderlichen Daten vorhanden sind.' }, status => 400);
        } else {
            $c->render(openapi => { error => 'Die Korrektur-Rechnung konnte nicht erstellt werden. Bitte versuchen Sie es erneut.' }, status => 500);
        }
    };
}

sub delete {
    my $c = shift;
    
    eval {
        # Example RBAC guard for privileged operation
        my $auth_user = $c->stash('auth_user');
        if ($auth_user && $auth_user->{type} && $auth_user->{type} eq 'oidc') {
            return unless $c->require_roles(['XBillr-Admin', 'XBillr-Tenant-Admin']);
            return unless $c->require_tenant;
        }

        my $id = $c->stash('id') || $c->param('id');
        
        unless ($id) {
            return $c->render(openapi => { error => 'Rechnungs-ID fehlt.' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
        
        unless ($invoice) {
            return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
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
        
        $c->render(openapi => { message => 'Rechnung erfolgreich gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting invoice: $error");
        $c->app->log->error("Stack trace: " . $error->can('as_string') ? $error->as_string : $error);
        $c->render(openapi => { error => 'Die Rechnung konnte nicht gelöscht werden. Bitte versuchen Sie es später erneut.', details => "$error" }, status => 500);
    };
}

sub archive {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        $service->archive_invoice($id);
        $c->render(openapi => { message => 'Rechnung erfolgreich archiviert' }, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/) {
            $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        } else {
            $c->render(openapi => { error => 'Die Rechnung konnte nicht archiviert werden. Bitte versuchen Sie es erneut.', details => "$error" }, status => 500);
        }
    };
}

sub unarchive {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
        my $service = XBillr::Service::InvoiceService->new(
            schema => $schema
        );
        
        $service->unarchive_invoice($id);
        $c->render(openapi => { message => 'Rechnung erfolgreich dearchiviert' }, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/) {
            $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
        } else {
            $c->render(openapi => { error => 'Die Rechnung konnte nicht dearchiviert werden. Bitte versuchen Sie es erneut.', details => "$error" }, status => 500);
        }
    };
}

sub duplicate {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $schema = $c->app->schema;
        my $invoice = $schema->resultset('Invoice')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($invoice && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $invoice->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Die angeforderte Rechnung wurde nicht gefunden.' }, status => 404);
            }
        }
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
        
        $c->render(openapi => $result, status => 200);
    } or do {
        my $error = $@;
        if ($error =~ /nicht gefunden/ || $error =~ /Nur archivierte/) {
            $c->render(openapi => { error => $error }, status => 400);
        } else {
            $c->render(openapi => { error => $error }, status => 500);
        }
    };
}

sub _invoice_to_hash {
    my ($c, $invoice) = @_;
    my $customer = $invoice->customer;
    my $customer_name = '';
    if ($customer) {
        $customer_name = $customer->company || $customer->name || 'Unbekannt';
    }
    return {
        id => $invoice->id,
        invoiceNumber => $invoice->invoice_number,
        customerId => $invoice->customer_id,
        customerName => $customer_name,
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

