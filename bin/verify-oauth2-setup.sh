#!/bin/bash
# verify-oauth2-setup.sh
# Verify OAuth2/OIDC implementation and documentation

echo "🔍 XBillr OAuth2 Setup Verification"
echo "==================================="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1 (missing)"
        return 1
    fi
}

check_removed() {
    if [ ! -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 (removed)"
        return 0
    else
        echo -e "${YELLOW}!${NC} $1 (should be removed)"
        return 1
    fi
}

echo "📄 Documentation Files"
echo "---------------------"
check_file "documentation/CHANGELOG.md"
check_file "documentation/SERVER-SETUP.md"
check_file "documentation/mobile/CURSOR_PROMPT.md"
check_file "documentation/mobile/README.md"
check_file "OAUTH2_IMPLEMENTATION.md"
check_file "DOCUMENTATION_UPDATE_SUMMARY.md"
echo ""

echo "🔧 Configuration Files"
echo "---------------------"
check_file "config/xbillr.conf"
check_file "backend/openapi.yaml"
echo ""

echo "📦 Generated Files"
echo "-----------------"
check_file "documentation/api/index.html"
check_file "postman/XBillr.postman_collection.json"
echo ""

echo "🗑️  Removed Scripts"
echo "------------------"
check_removed "bin/diagnose_login.sh"
check_removed "bin/fix_login_issues.sh"
check_removed "bin/test_login.sh"
echo ""

echo "🔐 OAuth2 Configuration"
echo "----------------------"
if grep -q "frontend_url" config/xbillr.conf; then
    echo -e "${GREEN}✓${NC} frontend_url configured"
else
    echo -e "${RED}✗${NC} frontend_url missing"
fi

if grep -q "store_session_tokens => 0" config/xbillr.conf; then
    echo -e "${GREEN}✓${NC} store_session_tokens disabled (recommended)"
else
    echo -e "${YELLOW}!${NC} store_session_tokens not disabled"
fi

if grep -q "tls_verify => 1" config/xbillr.conf; then
    echo -e "${GREEN}✓${NC} tls_verify enabled"
else
    echo -e "${YELLOW}!${NC} tls_verify not enabled"
fi
echo ""

echo "🚀 Backend Routes"
echo "----------------"
if grep -q "namespaces.*XBillr::Controller" backend/app.pl; then
    echo -e "${GREEN}✓${NC} Controller namespace configured"
else
    echo -e "${RED}✗${NC} Controller namespace missing"
fi

if grep -q "/api/auth/login.*to.*auth#login" backend/app.pl; then
    echo -e "${GREEN}✓${NC} OAuth2 login route registered"
else
    echo -e "${RED}✗${NC} OAuth2 login route missing"
fi

if grep -q "/api/auth/oidc/callback.*to.*auth#oidc_callback" backend/app.pl; then
    echo -e "${GREEN}✓${NC} OAuth2 callback route registered"
else
    echo -e "${RED}✗${NC} OAuth2 callback route missing"
fi
echo ""

echo "🎨 Frontend Updates"
echo "------------------"
if grep -q "Bei SME Tools anmelden" frontend/login.html; then
    echo -e "${GREEN}✓${NC} Keycloak login button present"
else
    echo -e "${RED}✗${NC} Keycloak login button missing"
fi

if grep -q "credentials: 'include'" frontend/index.html; then
    echo -e "${GREEN}✓${NC} Session cookie support enabled"
else
    echo -e "${YELLOW}!${NC} Session cookie support may be missing"
fi
echo ""

echo "📊 Summary"
echo "---------"
echo "Check the items above. All ✓ should be green."
echo "Items marked ! are warnings - may need attention."
echo "Items marked ✗ are errors - require fixing."
echo ""
echo "For detailed information, see: OAUTH2_IMPLEMENTATION.md"
echo "For changes, see: documentation/CHANGELOG.md"
