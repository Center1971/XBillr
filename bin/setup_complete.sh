#!/bin/bash
# Complete setup script for XBillr - fixes database and creates admin user

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "XBillr Complete Setup"
echo "=========================================="
echo ""

DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX}"

# Step 1: Initialize database schema
echo "Step 1: Initializing database schema..."
echo "Running schema.sql..."
docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr < backend/sql/schema.sql

echo ""
echo "Running user_management.sql..."
docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr < backend/sql/user_management.sql

# Step 2: Verify tables exist
echo ""
echo "Step 2: Verifying database..."
TABLES=$(docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr -e "SHOW TABLES;" | tail -n +2 | wc -l)
echo "Found $TABLES tables"

if [ "$TABLES" -lt 5 ]; then
    echo "ERROR: Not enough tables found. Database initialization may have failed."
    exit 1
fi

# Step 3: Create admin user
echo ""
echo "Step 3: Creating admin user..."
docker compose exec -T backend sh -c 'DB_DSN="dbi:MariaDB:database=xbillr;host=mariadb;port=3306" DB_USER="root" DB_PASSWORD="'$DB_ROOT_PASSWORD'" perl /app/scripts/create_admin.pl admin123 2>&1' | grep -E "(Admin|Benutzername|Passwort|erfolgreich|ERROR|FEHLER)" || true

echo ""
echo "=========================================="
echo "Setup complete!"
echo "=========================================="
echo ""
echo "You can now login with:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
