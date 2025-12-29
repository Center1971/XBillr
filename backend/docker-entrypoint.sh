#!/bin/bash

# Docker Entrypoint für XBillr Backend

set -e

echo "Starting XBillr Backend..."

# Warte auf Datenbank
echo "Waiting for database..."
# Extrahiere Host und Port aus DB_DSN falls vorhanden, sonst verwende Standardwerte
if [ -n "$DB_DSN" ]; then
    DB_HOST=$(echo "$DB_DSN" | sed -n 's/.*host=\([^;]*\).*/\1/p')
    DB_PORT=$(echo "$DB_DSN" | sed -n 's/.*port=\([^;]*\).*/\1/p')
    DB_NAME=$(echo "$DB_DSN" | sed -n 's/.*database=\([^;]*\).*/\1/p')
else
    DB_HOST=${DB_HOST:-mariadb}
    DB_PORT=${DB_PORT:-3306}
    DB_NAME=${DB_NAME:-xbillr}
fi
DB_HOST=${DB_HOST:-mariadb}
DB_PORT=${DB_PORT:-3306}
DB_NAME=${DB_NAME:-xbillr}
until perl -e "use DBI; DBI->connect('dbi:MariaDB:database=${DB_NAME};host=${DB_HOST};port=${DB_PORT}', '${DB_USER}', '${DB_PASSWORD}') or die" 2>/dev/null; do
    echo "Database is unavailable - sleeping"
    sleep 2
done

echo "Database is up - executing command"

# Führe den übergebenen Befehl aus
exec "$@"

