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
        
        my $entries = $schema->resultset('TimeEntry')->search({
            year => $year,
            week => $week,
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
        
        # Suche nach Einträgen im angegebenen Jahr
        my $entries = $schema->resultset('TimeEntry')->search({
            year => $year,
        });
        
        my @result;
        while (my $entry = $entries->next) {
            # Parse das Datum und prüfe, ob es im angegebenen Monat liegt
            my $date_str = $entry->date;
            if ($date_str =~ /^(\d{4})-(\d{2})-\d{2}/) {
                my $entry_year = $1;
                my $entry_month = int($2);
                
                # Prüfe, ob Jahr und Monat übereinstimmen
                if ($entry_year == $year && $entry_month == $month) {
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
            }
        }
        
        $c->render(json => \@result, status => 200);
    } or do {
        my $error = $@ || 'Unbekannter Fehler';
        $c->app->log->error("Error in get_by_month: $error");
        $c->render(json => { error => 'Fehler beim Laden der Zeiteinträge', details => "$error" }, status => 500);
    };
}

sub create {
    my $c = shift;
    
    eval {
        my $data = $c->req->json;
        my $schema = $c->app->schema;
        
        my $date = DateTime::Format::MySQL->parse_date($data->{date});
        # Berechne Kalenderwoche nach ISO 8601
        my ($year, $week) = $date->week;
        
        my $entry = $schema->resultset('TimeEntry')->create({
            id => create_uuid_as_string(UUID_V4),
            customer_id => $data->{customerId},
            hourly_rate_id => $data->{hourlyRateId},
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

1;

