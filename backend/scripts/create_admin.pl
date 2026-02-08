#!/usr/bin/env perl

use strict;
use warnings;
use lib 'lib';
use XBillr::Model::DB;
use XBillr::Service::AuthService;
use UUID::Tiny ':std';
use DateTime;
use DBI;

# Datenbankverbindung
# Use environment variables from docker-compose.yml (set in container)
my $dsn = $ENV{DB_DSN} || "dbi:MariaDB:database=xbillr;host=mariadb;port=3306";
my $user = $ENV{DB_USER} || "root";
my $pass = $ENV{DB_PASSWORD} || "u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX";

# Debug: Print connection info (without password)
print "Connecting to database: $dsn\n";
print "User: $user\n";

$dsn =~ s/^dbi:mysql/dbi:MariaDB/i;

# First, test basic DBI connection with timeout
print "Testing database connection...\n";
my $test_dbh;
eval {
    local $SIG{ALRM} = sub { die "Connection timeout\n" };
    alarm(10);  # 10 second timeout
    $test_dbh = DBI->connect($dsn, $user, $pass, {
        RaiseError => 0,
        PrintError => 0,
    });
    alarm(0);
};
if ($@ || !$test_dbh) {
    my $error = $@ || ($DBI::errstr || "Unknown error");
    print "ERROR: Failed to connect to database: $error\n";
    print "Please check:\n";
    print "  - Database is running\n";
    print "  - DB_DSN, DB_USER, DB_PASSWORD are correct\n";
    print "  - Network connectivity to database host\n";
    exit 1;
}
print "Database connection test successful.\n";
$test_dbh->disconnect();

# Suppress DBIx::Class warnings for MariaDB (they're harmless)
local $SIG{__WARN__} = sub {
    my $msg = shift;
    return if $msg =~ /undetermined_driver|MariaDB|This version of DBIC|DBIC_DRIVER|sql_limit_dialect/;
    warn $msg;
};

print "Connecting with DBIx::Class...\n";
my $schema;
eval {
    local $SIG{ALRM} = sub { die "DBIx::Class connection timeout\n" };
    alarm(30);  # 30 second timeout for DBIx::Class (may need to load schema)
    $schema = XBillr::Model::DB->connect($dsn, $user, $pass, {
        RaiseError => 1,
        PrintError => 0,
        on_connect_do => [
            'SET NAMES utf8mb4',
            'SET CHARACTER SET utf8mb4',
        ],
    });
    alarm(0);
};
if ($@ || !$schema) {
    my $error = $@ || "Unknown error";
    print "ERROR: Failed to connect with DBIx::Class: $error\n";
    exit 1;
}
print "DBIx::Class connection established.\n";

# Check if users table exists
print "Checking if users table exists...\n";
my $dbh = $schema->storage->dbh;
my $users_table_exists = 0;
eval {
    my $sth = $dbh->prepare("SHOW TABLES LIKE 'users'");
    $sth->execute();
    my $row = $sth->fetchrow_arrayref();
    $users_table_exists = 1 if $row && $row->[0] eq 'users';
    $sth->finish();
};
if ($@) {
    print "WARNING: Could not check for users table: $@\n";
}

unless ($users_table_exists) {
    print "\n";
    print "ERROR: The 'users' table does not exist in the database!\n";
    print "\n";
    print "The database schema needs to be initialized. Please run:\n";
    print "\n";
    print "  Option 1: Use the init script:\n";
    print "    bin/init_database.sh\n";
    print "\n";
    print "  Option 2: Use the complete setup script:\n";
    print "    bin/setup_complete.sh\n";
    print "\n";
    print "  Option 3: Manually run the SQL files:\n";
    print "    docker compose exec -T mariadb mysql -uroot -p\"\$DB_ROOT_PASSWORD\" xbillr < backend/sql/schema.sql\n";
    print "    docker compose exec -T mariadb mysql -uroot -p\"\$DB_ROOT_PASSWORD\" xbillr < backend/sql/user_management.sql\n";
    print "\n";
    exit 1;
}
print "Users table found.\n";

# Check if roles table exists
print "Checking if roles table exists...\n";
my $roles_table_exists = 0;
eval {
    my $sth = $dbh->prepare("SHOW TABLES LIKE 'roles'");
    $sth->execute();
    my $row = $sth->fetchrow_arrayref();
    $roles_table_exists = 1 if $row && $row->[0] eq 'roles';
    $sth->finish();
};
unless ($roles_table_exists) {
    print "\n";
    print "ERROR: The 'roles' table does not exist in the database!\n";
    print "\n";
    print "The user_management.sql schema needs to be run. Please run:\n";
    print "\n";
    print "  docker compose exec -T mariadb mysql -uroot -p\"\$DB_ROOT_PASSWORD\" xbillr < backend/sql/user_management.sql\n";
    print "\n";
    exit 1;
}
print "Roles table found.\n";

# Auth Service
print "Initializing AuthService...\n";
my $auth_service = XBillr::Service::AuthService->new(schema => $schema);
print "AuthService initialized.\n";

# Admin-Benutzer erstellen oder aktualisieren
print "Checking for existing admin user...\n";
my $admin_user;
eval {
    $admin_user = $schema->resultset('User')->find({ username => 'admin' });
};
if ($@) {
    print "ERROR: Failed to query users table: $@\n";
    exit 1;
}
print "User query completed.\n";

my $password = $ARGV[0] || 'admin123';
print "Hashing password...\n";
my $password_hash = $auth_service->hash_password($password);
print "Password hashed.\n";

if ($admin_user) {
    print "Admin-Benutzer existiert bereits. Aktualisiere Passwort...\n";
    eval {
        $admin_user->update({
            password_hash => $password_hash,
            is_active => 1,
            updated_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
        });
    };
    if ($@) {
        print "ERROR: Failed to update admin user: $@\n";
        exit 1;
    }
    print "Passwort aktualisiert.\n";
} else {
    print "Erstelle Admin-Benutzer...\n";
    eval {
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
    };
    if ($@) {
        print "ERROR: Failed to create admin user: $@\n";
        exit 1;
    }
    print "Admin-Benutzer erstellt.\n";
}

# Admin-Rolle zuweisen
print "Checking for admin role...\n";
my $admin_role;
eval {
    $admin_role = $schema->resultset('Role')->find({ name => 'admin' });
};
if ($@) {
    print "ERROR: Failed to query roles table: $@\n";
    exit 1;
}

if ($admin_role) {
    print "Admin role found. Checking user role assignment...\n";
    my $user_role;
    eval {
        $user_role = $schema->resultset('UserRole')->find({
            user_id => $admin_user->id,
            role_id => $admin_role->id,
        });
    };
    if ($@) {
        print "ERROR: Failed to query user_roles table: $@\n";
        exit 1;
    }
    
    unless ($user_role) {
        print "Weise Admin-Rolle zu...\n";
        eval {
            $schema->resultset('UserRole')->create({
                id => create_uuid_as_string(UUID_V4),
                user_id => $admin_user->id,
                role_id => $admin_role->id,
                assigned_at => DateTime->now->strftime('%Y-%m-%d %H:%M:%S'),
            });
        };
        if ($@) {
            print "ERROR: Failed to create user role: $@\n";
            exit 1;
        }
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

