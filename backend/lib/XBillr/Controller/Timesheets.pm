package XBillr::Controller::Timesheets;

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';
use DateTime;

sub list {
    my $c = shift;

    eval {
        my $schema = $c->app->schema;
        my $archived_only = $c->param('archived') || 0;
        my $auth_user = $c->auth_user || {};
        my $tenant_ids = [];
        if (($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            $tenant_ids = $c->tenant_customer_ids;
        }

        my $timesheets_rs = $schema->resultset('Timesheet')->search(
            $archived_only ? { archived => 1, (@$tenant_ids ? (customer_id => { -in => $tenant_ids }) : ()) }
                           : { (@$tenant_ids ? (customer_id => { -in => $tenant_ids }) : ()) },
            {
                order_by => { -desc => 'created_at' },
                join => 'customer',
                '+select' => ['customer.company', 'customer.name'],
                '+as' => ['customer_company', 'customer_name'],
            }
        );

        my @result;
        while (my $timesheet = $timesheets_rs->next) {
            my $customer = $timesheet->customer;
            push @result, {
                id => $timesheet->id,
                customerId => $timesheet->customer_id,
                customerName => $customer ? ($customer->company || $customer->name || 'Unbekannt') : 'Unbekannt',
                dateFrom => $timesheet->date_from,
                dateTo => $timesheet->date_to,
                description => $timesheet->description,
                archived => $timesheet->archived ? 1 : 0,
                archivedAt => $timesheet->archived_at,
                createdAt => $timesheet->created_at,
            };
        }

        $c->render(openapi => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error listing timesheets: $error");
        $c->render(openapi => { error => 'Die Stundenzettel konnten nicht geladen werden.', details => "$error" }, status => 500);
    };
}

sub pdf {
    my $c = shift;

    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($timesheet && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $timesheet->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
            }
        }

        unless ($timesheet) {
            return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }

        my $customer = $timesheet->customer;
        my $filename = 'stundenzettel_' . ($customer ? ($customer->company || $customer->name || $timesheet->customer_id) : $timesheet->customer_id) . '_' . $timesheet->date_from . '_' . $timesheet->date_to . '.pdf';
        $filename =~ s/[^a-zA-Z0-9._-]/_/g;

        $c->res->headers->content_type('application/pdf');
        $c->res->headers->header('Content-Disposition' => 'attachment; filename="' . $filename . '"');
        $c->render(data => $timesheet->pdf_data);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error getting timesheet PDF: $error");
        $c->render(openapi => { error => 'Die Stundenzettel-PDF konnte nicht geladen werden.', details => "$error" }, status => 500);
    };
}

sub archive {
    my $c = shift;

    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($timesheet && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $timesheet->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
            }
        }

        unless ($timesheet) {
            return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }

        $timesheet->update({
            archived => 1,
            archived_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });

        $c->render(openapi => { success => 1, message => 'Stundenzettel erfolgreich archiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error archiving timesheet: $error");
        $c->render(openapi => { error => 'Der Stundenzettel konnte nicht archiviert werden.', details => "$error" }, status => 500);
    };
}

sub unarchive {
    my $c = shift;

    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($timesheet && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $timesheet->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
            }
        }

        unless ($timesheet) {
            return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }

        $timesheet->update({
            archived => 0,
            archived_at => undef,
        });

        $c->render(openapi => { success => 1, message => 'Stundenzettel erfolgreich dearchiviert' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error unarchiving timesheet: $error");
        $c->render(openapi => { error => 'Der Stundenzettel konnte nicht dearchiviert werden.', details => "$error" }, status => 500);
    };
}

sub delete {
    my $c = shift;

    eval {
        my $id = $c->stash('id');
        my $schema = $c->app->schema;
        my $timesheet = $schema->resultset('Timesheet')->find($id);
        my $auth_user = $c->auth_user || {};
        if ($timesheet && ($auth_user->{type} || '') eq 'oidc') {
            return unless $c->require_tenant;
            my $tenant_ids = $c->tenant_customer_ids;
            if (@$tenant_ids && !(grep { $_ eq $timesheet->customer_id } @$tenant_ids)) {
                return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
            }
        }

        unless ($timesheet) {
            return $c->render(openapi => { error => 'Stundenzettel nicht gefunden' }, status => 404);
        }

        $timesheet->delete;
        $c->render(openapi => { success => 1, message => 'Stundenzettel erfolgreich gelöscht' }, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error deleting timesheet: $error");
        $c->render(openapi => { error => 'Der Stundenzettel konnte nicht gelöscht werden.', details => "$error" }, status => 500);
    };
}

1;
