#!/bin/bash
# Test login functionality

set -e

cd "$(dirname "$0")/.."

echo "=========================================="
echo "Testing Login Functionality"
echo "=========================================="
echo ""

# 1. Check containers
echo "1. Checking Docker containers..."
if docker compose ps | grep -q "xbillr-backend.*Up"; then
    echo "   ✓ Backend container is running"
else
    echo "   ✗ Backend container is NOT running"
    echo "   Run: docker compose up -d"
    exit 1
fi

# 2. Test health endpoint
echo ""
echo "2. Testing backend health endpoint..."
HEALTH_RESPONSE=$(curl -s http://localhost:3002/api/health 2>&1)
if echo "$HEALTH_RESPONSE" | grep -q "status\|ok\|healthy"; then
    echo "   ✓ Backend is responding"
    echo "   Response: $HEALTH_RESPONSE"
else
    echo "   ✗ Backend is NOT responding"
    echo "   Response: $HEALTH_RESPONSE"
    echo "   Check: docker compose logs backend"
    exit 1
fi

# 3. Test login API
echo ""
echo "3. Testing login API..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:3002/api/auth/login \
    -H "Content-Type: application/json" \
    -H "Origin: http://localhost:8080" \
    -d '{"username":"admin","password":"admin123"}' 2>&1)

if echo "$LOGIN_RESPONSE" | grep -q "session_token\|success"; then
    echo "   ✓ Login API works"
    echo "   Response: $(echo "$LOGIN_RESPONSE" | head -c 200)"
else
    echo "   ✗ Login API failed"
    echo "   Response: $LOGIN_RESPONSE"
    
    # Check if admin user exists
    echo ""
    echo "   Checking if admin user exists..."
    ADMIN_COUNT=$(docker compose exec -T mariadb mysql -uroot -p"${DB_ROOT_PASSWORD:-u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX}" xbillr -e "SELECT COUNT(*) FROM users WHERE username='admin';" 2>/dev/null | tail -1 || echo "0")
    if [ "$ADMIN_COUNT" = "0" ]; then
        echo "   ✗ Admin user does NOT exist"
        echo "   Run: ./bin/setup_complete.sh"
    else
        echo "   ✓ Admin user exists"
    fi
fi

# 4. Check CORS
echo ""
echo "4. Testing CORS..."
CORS_HEADERS=$(curl -s -X OPTIONS http://localhost:3002/api/auth/login \
    -H "Origin: http://localhost:8080" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: Content-Type" \
    -v 2>&1 | grep -i "access-control")

if echo "$CORS_HEADERS" | grep -qi "access-control-allow-origin"; then
    echo "   ✓ CORS headers present"
    echo "   $CORS_HEADERS"
else
    echo "   ⚠ CORS headers may be missing"
fi

echo ""
echo "=========================================="
echo "Diagnostic complete!"
echo "=========================================="
echo ""
echo "IMPORTANT: If opening HTML files directly (file://), CORS will fail!"
echo "Solution: Serve frontend via HTTP server:"
echo "  cd frontend && python3 -m http.server 8080"
echo "  Then open: http://localhost:8080/login.html"
