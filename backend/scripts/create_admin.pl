#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';
use XBillr::Model::DB;
use XBillr::Service::AuthService;
use UUID::Tiny ':std';
use DateTime;

# Datenbankverbindung
my $dsn = $ENV{DB_DSN} || "dbi:MariaDB:database=xbillr;host=localhost;port=3306";
my $user = $ENV{DB_USER} || "xbillr_user";
my $pass = $ENV{DB_PASSWORD} || "xbillr_pass";

$dsn =~ s/^dbi:mysql/dbi:MariaDB/i;

my $schema = XBillr::Model::DB->connect($dsn, $user, $pass, {
    RaiseError => 1,
    PrintError => 0,
});

# Auth Service
my $auth_service = XBillr::Service::AuthService->new(schema => $schema);

# Admin-Benutzer erstellen oder aktualisieren
my $admin_user = $schema->resultset('User')->find({ username => 'admin' });

my $password = $ARGV[0] || 'admin123';
my $password_hash = $auth_service->hash_password($password);

if ($admin_user) {
    print "Admin-Benutzer existiert bereits. Aktualisiere Passwort...\n";
    $admin_user->update({
        password_hash => $password_hash,
        is_active => 1,
        updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    print "Passwort aktualisiert.\n";
} else {
    print "Erstelle Admin-Benutzer...\n";
    $admin_user = $schema->resultset('User')->create({
        id => '00000000-0000-0000-0000-000000000001',
        username => 'admin',
        email => 'admin@xbillr.local',
        password_hash => $password_hash,
        first_name => 'Admin',
        last_name => 'User',
        is_active => 1,
        is_email_verified => 1,
        created_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
    });
    print "Admin-Benutzer erstellt.\n";
}

# Admin-Rolle zuweisen
my $admin_role = $schema->resultset('Role')->find({ name => 'admin' });
if ($admin_role) {
    my $user_role = $schema->resultset('UserRole')->find({
        user_id => $admin_user->id,
        role_id => $admin_role->id,
    });
    
    unless ($user_role) {
        print "Weise Admin-Rolle zu...\n";
        $schema->resultset('UserRole')->create({
            id => create_uuid_as_string(UUID_V4),
            user_id => $admin_user->id,
            role_id => $admin_role->id,
            assigned_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
        print "Admin-Rolle zugewiesen.\n";
    } else {
        print "Admin-Rolle bereits zugewiesen.\n";
    }
} else {
    print "FEHLER: Admin-Rolle nicht gefunden! Bitte zuerst user_management.sql ausführen.\n";
    exit 1;
}

print "\n=== Admin-Benutzer erfolgreich erstellt ===\n";
print "Benutzername: admin\n";
print "Passwort: " . $password . "\n";
print "E-Mail: admin\@xbillr.local\n";
print "\nWICHTIG: Bitte ändern Sie das Passwort nach dem ersten Login!\n";

