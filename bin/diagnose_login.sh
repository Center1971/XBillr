#!/bin/bash
# Diagnostic script for login issues

echo "=========================================="
echo "XBillr Login Diagnostic"
echo "=========================================="
echo ""

# Check if containers are running
echo "1. Checking Docker containers..."
cd "$(dirname "$0")/.."
if docker compose ps | grep -q "xbillr-backend.*Up"; then
    echo "   ✓ Backend container is running"
else
    echo "   ✗ Backend container is NOT running"
    echo "   Run: docker compose up -d"
    exit 1
fi

# Check if backend is accessible
echo ""
echo "2. Testing backend API..."
if curl -s http://localhost:3002/api/health > /dev/null 2>&1; then
    echo "   ✓ Backend API is accessible"
    curl -s http://localhost:3002/api/health | head -3
else
    echo "   ✗ Backend API is NOT accessible"
    echo "   Check: docker compose logs backend"
    exit 1
fi

# Check if admin user exists
echo ""
echo "3. Checking admin user in database..."
ADMIN_EXISTS=$(docker compose exec -T mariadb mysql -uroot -p"${DB_PASSWORD:-u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX}" xbillr -e "SELECT COUNT(*) FROM users WHERE username='admin';" 2>/dev/null | tail -1)
if [ "$ADMIN_EXISTS" = "1" ]; then
    echo "   ✓ Admin user exists"
else
    echo "   ✗ Admin user does NOT exist"
    echo "   Creating admin user..."
    docker compose exec backend perl /app/scripts/create_admin.pl admin123
fi

# Test login API
echo ""
echo "4. Testing login API..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3002/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin123"}' 2>&1)

if echo "$LOGIN_RESPONSE" | grep -q "session_token"; then
    echo "   ✓ Login API works correctly"
    echo "   Response: $(echo "$LOGIN_RESPONSE" | head -1)"
else
    echo "   ✗ Login API failed"
    echo "   Response: $LOGIN_RESPONSE"
fi

# Check CORS configuration
echo ""
echo "5. Checking CORS configuration..."
ALLOWED_ORIGINS=$(docker compose exec -T backend printenv ALLOWED_ORIGINS 2>/dev/null || echo "http://localhost:3002")
echo "   ALLOWED_ORIGINS: $ALLOWED_ORIGINS"
echo ""
echo "   NOTE: If opening HTML files directly (file://), CORS will fail."
echo "   Solution: Serve frontend via HTTP server or update ALLOWED_ORIGINS"

echo ""
echo "=========================================="
echo "Diagnostic complete!"
echo "=========================================="
