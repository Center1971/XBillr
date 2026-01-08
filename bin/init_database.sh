#!/bin/bash
# Initialize XBillr database schema

set -e

cd "$(dirname "$0")/.."

DB_ROOT_PASSWORD="${DB_ROOT_PASSWORD:-u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX}"

echo "=========================================="
echo "Initializing XBillr Database"
echo "=========================================="
echo ""

# Check if database exists
echo "1. Checking database..."
DB_EXISTS=$(docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" -e "SHOW DATABASES LIKE 'xbillr';" 2>/dev/null | grep -c xbillr || echo "0")

if [ "$DB_EXISTS" = "0" ]; then
    echo "   Creating database..."
    docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS xbillr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>&1
    echo "   ✓ Database created"
else
    echo "   ✓ Database exists"
fi

# Check if tables exist
echo ""
echo "2. Checking tables..."
TABLE_COUNT=$(docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr -e "SHOW TABLES;" 2>/dev/null | wc -l || echo "0")

if [ "$TABLE_COUNT" -lt 2 ]; then
    echo "   Tables not found. Initializing schema..."
    
    # Run schema.sql
    echo "   Running schema.sql..."
    docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr < backend/sql/schema.sql 2>&1 | grep -v "Warning" || true
    
    # Check if user_management.sql exists and run it
    if [ -f "backend/sql/user_management.sql" ]; then
        echo "   Running user_management.sql..."
        docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr < backend/sql/user_management.sql 2>&1 | grep -v "Warning" || true
    fi
    
    echo "   ✓ Schema initialized"
else
    echo "   ✓ Tables already exist ($((TABLE_COUNT - 1)) tables)"
fi

# Verify users table exists
echo ""
echo "3. Verifying users table..."
USERS_TABLE=$(docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr -e "SHOW TABLES LIKE 'users';" 2>/dev/null | grep -c users || echo "0")

if [ "$USERS_TABLE" = "0" ]; then
    echo "   ✗ ERROR: users table not found!"
    echo "   Please check if user_management.sql was run"
    exit 1
else
    echo "   ✓ users table exists"
fi

# Check if roles table exists (needed for admin)
echo ""
echo "4. Verifying roles table..."
ROLES_TABLE=$(docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr -e "SHOW TABLES LIKE 'roles';" 2>/dev/null | grep -c roles || echo "0")

if [ "$ROLES_TABLE" = "0" ]; then
    echo "   ✗ WARNING: roles table not found!"
    echo "   Running user_management.sql..."
    if [ -f "backend/sql/user_management.sql" ]; then
        docker compose exec -T mariadb mysql -uroot -p"$DB_ROOT_PASSWORD" xbillr < backend/sql/user_management.sql 2>&1 | grep -v "Warning" || true
        echo "   ✓ user_management.sql executed"
    else
        echo "   ✗ ERROR: user_management.sql not found!"
        exit 1
    fi
else
    echo "   ✓ roles table exists"
fi

echo ""
echo "=========================================="
echo "Database initialization complete!"
echo "=========================================="
echo ""
echo "Next step: Create admin user"
echo "Run: ./bin/create_admin.sh admin123"
