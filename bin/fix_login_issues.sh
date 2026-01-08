#!/bin/bash
# Fix common login issues

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "Fixing Login Issues"
echo "=========================================="
echo ""

# 1. Ensure containers are running
echo "1. Starting containers..."
docker compose up -d

# 2. Wait for backend to be healthy
echo ""
echo "2. Waiting for backend to be ready..."
sleep 5

# 3. Create admin user if it doesn't exist
echo ""
echo "3. Ensuring admin user exists..."
docker compose exec -T backend perl /app/scripts/create_admin.pl admin123 || {
    echo "   Creating admin user via database..."
    docker compose exec -T mariadb mysql -uroot -p"${DB_PASSWORD:-u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX}" xbillr << 'EOF'
-- Create admin user if not exists
INSERT INTO users (
    id, username, email, password_hash, first_name, last_name, is_active, is_email_verified, created_at, updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'admin',
    'admin@xbillr.local',
    '$pbkdf2-sha1$10000$dGVzdA==$hash_placeholder',
    'Admin',
    'User',
    1,
    1,
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE updated_at = NOW();
EOF
    echo "   Note: You may need to run create_admin.pl to set the correct password hash"
}

# 4. Rebuild backend to apply CORS fixes
echo ""
echo "4. Rebuilding backend with CORS fixes..."
docker compose build backend
docker compose up -d backend

echo ""
echo "=========================================="
echo "Fix complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Run: ./bin/diagnose_login.sh"
echo "2. If opening HTML files directly, use a web server:"
echo "   cd frontend && python3 -m http.server 8080"
echo "   Then open: http://localhost:8080/login.html"
echo "3. Or serve via nginx/apache"
