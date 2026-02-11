package XBillr::Controller::TimeEntries;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use UUID::Tiny ':std';
use DateTime;
use DateTime::Format::MySQL;

sub get_by_week {
    my $c = shift;
    
    eval {
        # Route-Parameter werden aus dem Stash geholt
        my $year = $c->stash('year') || $c->param('year');
        my $week = $c->stash('week') || $c->param('week');
        
        if (!$year || !$week) {
            return $c->render(json => { error => 'Jahr und Woche müssen angegeben werden' }, status => 400);
        }
        
        $year = int($year);
        $week = int($week);
        
        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }
        
        my $entries = $schema->resultset('TimeEntry')->search({
            year => $year,
            week => $week,
            (@$tenant_ids ? (customer_id => { -in => $tenant_ids }) : ()),
        }, {
            order_by => 'date ASC'
        });
        
        my @result;
        while (my $entry = $entries->next) {
            push @result, {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_week: $error");
        $c->render(json => { error => 'Fehler beim Laden der Zeiteinträge', details => "$error" }, status => 500);
    };
}

sub get_by_month {
    my $c = shift;
    
    eval {
        # Route-Parameter werden aus dem Stash geholt
        my $year = $c->stash('year') || $c->param('year');
        my $month = $c->stash('month') || $c->param('month');
        
        if (!$year || !$month) {
            return $c->render(json => { error => 'Jahr und Monat müssen angegeben werden' }, status => 400);
        }
        
        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }
        
        # Suche nach Einträgen im angegebenen Jahr und Monat
        my $date_pattern = sprintf('%04d-%02d-%%', $year, $month);
        my $entries = $schema->resultset('TimeEntry')->search({
            date => { 'LIKE' => $date_pattern },
            (@$tenant_ids ? (customer_id => { -in => $tenant_ids }) : ()),
        }, {
            order_by => 'date ASC'
        });
        
        my @result;
        while (my $entry = $entries->next) {
            push @result, {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            };
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_month: $error");
        $c->render(json => { error => 'Fehler beim Laden der Zeiteinträge', details => "$error" }, status => 500);
    };
}

sub get {
    my $c = shift;

    eval {
        my $id = $c->stash('id') || $c->param('id');
        my $schema = $c->app->schema;
        my $entry = $schema->resultset('TimeEntry')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($entry && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $entry->customer_id } @$tenant_ids)) {
                return $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
            }
        }

        if ($entry) {
            $c->render(json => {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
        }
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get time entry by id: $error");
        $c->render(json => { error => 'Fehler beim Laden des Zeiteintrags', details => "$error" }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            unless (@$tenant_ids && grep { $_ eq $data->{customerId} } @$tenant_ids) {
                return $c->render(json => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        
        my $hourly_rate_id = $data->{hourlyRateId};
        my $hourly_rate = $schema->resultset('HourlyRate')->find($hourly_rate_id);

        if (!$hourly_rate) {
            my $customer = $schema->resultset('Customer')->find($data->{customerId});
            if (!$customer) {
                return $c->render(json => { error => 'Kunde nicht gefunden' }, status => 404);
            }

            my $today = DateTime->now->ymd;
            my $rate_type = 'HOURLY';
            my $rate_value = $customer->default_hourly_rate;
            my $description = 'Standard-Stundensatz';

            if ($customer->default_daily_rate) {
                my $existing_daily = $schema->resultset('HourlyRate')->search({
                    customer_id => $data->{customerId},
                    rate => $customer->default_daily_rate,
                    rate_type => 'DAILY',
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;

                if ($existing_daily) {
                    $hourly_rate_id = $existing_daily->id;
                    $hourly_rate = $existing_daily;
                } else {
                    $hourly_rate_id = create_uuid_as_string(UUID_V4);
                    $hourly_rate = $schema->resultset('HourlyRate')->create({
                        id => $hourly_rate_id,
                        customer_id => $data->{customerId},
                        rate => $customer->default_daily_rate,
                        rate_type => 'DAILY',
                        description => 'Standard-Tagessatz',
                        valid_from => $today,
                        valid_to => undef,
                        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    });
                }
            } else {
                my $existing_rate = $schema->resultset('HourlyRate')->search({
                    customer_id => $data->{customerId},
                    rate => $rate_value,
                    rate_type => $rate_type,
                    valid_from => { '<=' => $today },
                    -or => [
                        valid_to => undef,
                        valid_to => { '>=' => $today },
                    ],
                })->first;

                if ($existing_rate) {
                    $hourly_rate_id = $existing_rate->id;
                    $hourly_rate = $existing_rate;
                } else {
                    $hourly_rate_id = create_uuid_as_string(UUID_V4);
                    $hourly_rate = $schema->resultset('HourlyRate')->create({
                        id => $hourly_rate_id,
                        customer_id => $data->{customerId},
                        rate => $rate_value,
                        rate_type => $rate_type,
                        description => $description,
                        valid_from => $today,
                        valid_to => undef,
                        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
                    });
                }
            }
        }

        my $date = DateTime::Format::MySQL->parse_date($data->{date});
        my ($year, $week) = $date->week;

        my $entry = $schema->resultset('TimeEntry')->create({
            id => create_uuid_as_string(UUID_V4),
            customer_id => $data->{customerId},
            hourly_rate_id => $hourly_rate_id,
            date => $data->{date},
            hours => $data->{hours},
            description => $data->{description},
            week => $week,
            year => $year,
            created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        
        $c->render(json => {
            id => $entry->id,
            customerId => $entry->customer_id,
            hourlyRateId => $entry->hourly_rate_id,
            date => $entry->date,
            hours => $entry->hours,
            description => $entry->description,
            week => $entry->week,
            year => $entry->year,
            createdAt => $entry->created_at,
        }, status => 201);
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

sub update {
    my $c = shift;
    
    eval {
        my $id = $c->param('id');
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        my $entry = $schema->resultset('TimeEntry')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($entry && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $entry->customer_id } @$tenant_ids)) {
                return $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
            }
            unless (@$tenant_ids && grep { $_ eq $data->{customerId} } @$tenant_ids) {
                return $c->render(json => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        
        if ($entry) {
            my $date = DateTime::Format::MySQL->parse_date($data->{date});
            # Berechne Kalenderwoche nach ISO 8601
            my ($year, $week) = $date->week;
            
            $entry->update({
                customer_id => $data->{customerId},
                hourly_rate_id => $data->{hourlyRateId},
                date => $data->{date},
                hours => $data->{hours},
                description => $data->{description},
                week => $week,
                year => $year,
            });
            
            $c->render(json => {
                id => $entry->id,
                customerId => $entry->customer_id,
                hourlyRateId => $entry->hourly_rate_id,
                date => $entry->date,
                hours => $entry->hours,
                description => $entry->description,
                week => $entry->week,
                year => $entry->year,
                createdAt => $entry->created_at,
            }, status => 200);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
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
        my $entry = $schema->resultset('TimeEntry')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($entry && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $entry->customer_id } @$tenant_ids)) {
                return $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
            }
        }
        
        if ($entry) {
            $entry->delete;
            $c->render(json => {}, status => 204);
        } else {
            $c->render(json => { error => 'Zeiteintrag nicht gefunden' }, status => 404);
        }
    } or do {
        $c->render(json => { error => $@ }, status => 500);
    };
}

sub timesheet_pdf {
    my $c = shift;

    eval {
        require XBillr::Service::PDFService;
        my $customer_id = $c->stash('customer_id');
        my $date_from = $c->param('date_from');
        my $date_to = $c->param('date_to');
        my $archive = $c->param('archive') || 0;

        unless ($customer_id && $date_from && $date_to) {
            return $c->render(json => { error => 'Kunden-ID, Datum von und Datum bis müssen angegeben werden.' }, status => 400);
        }

        my $schema = $c->app->schema;
        my $auth_user = $c->auth_user || {};
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            unless (@$tenant_ids && grep { $_ eq $customer_id } @$tenant_ids) {
                return $c->render(json => { error => 'Tenant-Zuordnung stimmt nicht' }, status => 403);
            }
        }
        my $service = XBillr::Service::PDFService->new(schema => $schema);
        my $pdf_data = $service->generate_timesheet_pdf($customer_id, $date_from, $date_to);

        if ($archive) {
            $schema->resultset('Timesheet')->create({
                id => create_uuid_as_string(UUID_V4),
                customer_id => $customer_id,
                date_from => $date_from,
                date_to => $date_to,
                pdf_data => $pdf_data,
                archived => 0,
                created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
        }

        my $customer = $schema->resultset('Customer')->find($customer_id);
        my $filename = 'stundenzettel_' . ($customer ? ($customer->company || $customer->name || $customer_id) : $customer_id) . '_' . $date_from . '_' . $date_to . '.pdf';
        $filename =~ s/[^a-zA-Z0-9._-]/_/g;

        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="' . $filename . '"');
        $c->render(data => $pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error generating timesheet PDF: $error");
        $c->render(json => { error => 'Die Stundenzettel-PDF konnte nicht generiert werden.', details => "$error" }, status => 500);
    };
}

1;

