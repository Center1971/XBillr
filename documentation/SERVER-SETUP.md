# XBillr Server Setup Guide

This guide describes how to install and run XBillr for **development** and **production** environments.

## Prerequisites

- Linux Server (Ubuntu/Debian recommended)
- Perl 5.26 or higher
- MariaDB/MySQL Database
- Docker and Docker Compose (optional for containerized deployment)
- **Keycloak 26.5.1** or compatible IAM (for OAuth2/OIDC authentication)

---

## Development Setup

Development setup is designed for local development and testing with hot-reloading.

### 1. Install Prerequisites

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y perl cpanminus mariadb-server docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl start mariadb
```

### 2. Clone/Extract Project

```bash
cd /home/jeff/src/smetools/XBillr
```

### 3. Configure Database

```bash
# Create database
sudo mysql -e "CREATE DATABASE IF NOT EXISTS xbillr;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'xbillr_user'@'localhost' IDENTIFIED BY 'your_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON xbillr.* TO 'xbillr_user'@'localhost';"

# Initialize schema
sudo mysql xbillr < backend/sql/schema.sql
sudo mysql xbillr < backend/sql/user_management.sql
```

### 4. Configure IAM (Keycloak)

Edit `config/xbillr.conf`:

```perl
iam => {
  issuer => 'https://iam.smetools.eu/realms/SME%20Tools%20-%20Test',
  authorization_endpoint => '/protocol/openid-connect/auth',
  token_endpoint => '/protocol/openid-connect/token',
  jwks_uri => '/protocol/openid-connect/certs',
  scopes => 'openid profile email',
  tls_verify => 1,
  auto_provision => 0,  # Enable after DB is working
  store_session_tokens => 0,  # Keep cookies small
  frontend_url => 'http://localhost:8082',
  
  clients => {
    web => {
      client_id => 'xbillr-web',
      redirect_uri => 'http://localhost:3002/api/auth/oidc/callback',
      audience => 'xbillr-web',
      client_secret => 'YOUR_CLIENT_SECRET_FROM_KEYCLOAK',
    },
  },
},

# Frontend Configuration
frontend => {
  # API Base URL for frontend (use relative path '/api' for reverse proxy)
  api_base_url => '/api',  # or 'http://localhost:3002/api' for direct access
  app_name => 'XBillr',
  app_version => '0.5',
},
```

**Note**: The `api_base_url` in the `frontend` section is served to the frontend via `/api/config` endpoint:
- **Development (no reverse proxy)**: Use `'http://localhost:3002/api'` or keep `'/api'` with CORS headers
- **Production (with reverse proxy)**: Use `'/api'` (relative path) - recommended!
- Frontend dynamically loads this config on page load

### 5. Install Perl Dependencies

```bash
cd backend
cpanm --installdeps --notest .
```

### 6. Start Development Environment

```bash
# From project root
./bin/xbillr start devel
```

This will start:
- **Backend** on `http://localhost:3002` (via morbo - hot reload enabled)
- **Frontend** on `http://localhost:8082` (static file server)

### 7. Access Application

- **Frontend**: http://localhost:8082/login.html
- **Backend API**: http://localhost:3002/api/health
- **Logs**: `logs/xbillr.log` (project root)

### 8. Configure Keycloak Client

In Keycloak Admin Console:
1. Create client `xbillr-web` in realm `SME Tools - Test`
2. Set **Client authentication**: ON (confidential client)
3. Set **Authentication flow**: Standard flow ONLY
4. Add **Valid Redirect URIs**: `http://localhost:3002/api/auth/oidc/callback`, `http://localhost:3002/*`
5. Add **Web Origins**: `http://localhost:8082`, `http://localhost:3002`, `+`
6. Copy **Client Secret** to `config/xbillr.conf`

---

## Production Setup

Production setup uses Docker containers with Hypnotoad for high-performance.

### 1. Prepare Server

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo systemctl enable docker
sudo systemctl start docker

# Create directory
sudo mkdir -p /opt/xbillr
cd /opt/xbillr
```

### 2. Deploy Application

```bash
# Extract/clone XBillr
unzip xbillr-*.zip  # or git clone
cd XBillr
```

### 3. Configure for Production

Edit `config/xbillr.conf`:

```perl
{
  hypnotize => {
    listen => ['http://*:3002'],
    workers => 4,  # Adjust based on CPU cores
  },
  
  log => {
    level => 'warn',  # Less verbose in production
    path => '../logs/xbillr.log',  # Relative to backend/, resolves to project root ./logs/
  },
  
  database => {
    dsn => 'dbi:MariaDB:database=xbillr;host=db;port=3306',
    user => 'xbillr_user',
    password => 'SECURE_DB_PASSWORD',
  },
  
  iam => {
    issuer => 'https://iam.yourdomain.com/realms/YourRealm',
    authorization_endpoint => '/protocol/openid-connect/auth',
    token_endpoint => '/protocol/openid-connect/token',
    jwks_uri => '/protocol/openid-connect/certs',
    scopes => 'openid profile email',
    tls_verify => 1,  # MUST be 1 in production
    auto_provision => 1,  # Auto-create users from IAM
    store_session_tokens => 0,
    frontend_url => 'https://xbillr.yourdomain.com',
    
    clients => {
      web => {
        client_id => 'xbillr-web-prod',
        redirect_uri => 'https://www.xbillr.eu/api/auth/oidc/callback',
        audience => 'xbillr-web-prod',
        client_secret => 'SECURE_CLIENT_SECRET',
        # OR use private_key_jwt:
        # private_key_pem => '-----BEGIN PRIVATE KEY-----\n...',
      },
      mobile => {
        client_id => 'xbillr-mobile-prod',
        redirect_uri => 'xbillr://oauth/callback',
        audience => 'xbillr-mobile-prod',
        pkce_required => 1,
      },
    },
  },
  
  frontend => {
    # API Base URL - use relative path with reverse proxy
    api_base_url => '/api',  # RECOMMENDED for production with reverse proxy
    app_name => 'XBillr',
    app_version => '0.5',
  },
  
  email => {
    smtp_host => 'smtp.yourdomain.com',
    smtp_port => 587,
    smtp_user => 'noreply@yourdomain.com',
    smtp_password => 'SECURE_SMTP_PASSWORD',
    smtp_from => 'noreply@yourdomain.com',
    smtp_from_name => 'XBillr',
    app_url => 'https://xbillr.yourdomain.com',
  },
}
```

### 4. Start with Docker Compose

```bash
# Production mode
./bin/xbillr start prod

# Or manually:
docker compose -f docker-compose.prod.yml up -d
```

### 5. Setup Nginx Reverse Proxy

```nginx
# /etc/nginx/sites-available/xbillr
server {
    listen 443 ssl http2;
    server_name xbillr.yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/xbillr.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/xbillr.yourdomain.com/privkey.pem;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    
    # Frontend
    location / {
        root /opt/xbillr/frontend;
        try_files $uri $uri/ /index.html;
        
        # Enable CORS for session cookies
        add_header Access-Control-Allow-Credentials true;
    }
    
    # Backend API
    location /api {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Important for session cookies
        proxy_cookie_path / /;
        proxy_cookie_domain localhost $host;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name xbillr.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

### 6. Enable and Start Nginx

```bash
sudo ln -s /etc/nginx/sites-available/xbillr /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 7. Setup SSL with Let's Encrypt

```bash
sudo apt-get install -y certbot python3-certbot-nginx
sudo certbot --nginx -d xbillr.yourdomain.com
```

### 8. Configure Keycloak for Production

In Keycloak Admin Console:
1. Create client `xbillr-web-prod`
2. Set **Client authentication**: ON
3. Set **Authentication flow**: Standard flow ONLY
4. Add **Valid Redirect URIs**: 
   - `https://api.yourdomain.com/api/auth/oidc/callback`
   - `https://api.yourdomain.com/*`
5. Add **Valid Post Logout Redirect URIs**:
   - `https://xbillr.yourdomain.com/login.html`
6. Add **Web Origins**: `https://xbillr.yourdomain.com`, `+`
7. Copy **Client Secret** to production config

---

## Management Scripts

### Start/Stop/Restart

```bash
# Development
./bin/xbillr start devel
./bin/xbillr stop devel
./bin/xbillr restart devel
./bin/xbillr logs devel

# Production
./bin/xbillr start prod
./bin/xbillr stop prod
./bin/xbillr restart prod
./bin/xbillr logs prod
```

### Database Management

```bash
# Initialize schema
./bin/init_database.sh

# Setup complete (schema + admin user)
./bin/setup_complete.sh
```

---

## Security Checklist

### Development
- ✅ Use `tls_verify: 1` if testing with real Keycloak
- ⚠️ `tls_verify: 0` only for local Keycloak without valid certs
- ✅ Never commit secrets to git
- ✅ Use different client secrets for dev/prod

### Production
- ✅ **HTTPS only** (TLS 1.2+)
- ✅ `tls_verify: 1` (MUST be enabled)
- ✅ Strong database passwords
- ✅ Strong client secrets (32+ chars, random)
- ✅ Firewall configured (ports 80, 443 only)
- ✅ Regular database backups
- ✅ Log rotation configured
- ✅ Security headers (see nginx config)
- ✅ Keycloak over HTTPS
- ✅ Session cookies: HTTP-only, Secure, SameSite=Lax

See `backend/SECURITY.md` for detailed security hardening.

---

## Troubleshooting

### Backend won't start

```bash
# Check logs
tail -f logs/xbillr.log

# Check syntax
cd backend && perl -c app.pl

# Check dependencies
cd backend && cpanm --installdeps --notest .
```

### Database connection failed

```bash
# Test connection
mysql -u xbillr_user -p -h localhost xbillr -e "SELECT 1;"

# Check config
cat config/xbillr.conf | grep -A 5 database
```

### OAuth2 login fails

```bash
# Check Keycloak is accessible
curl -I https://iam.smetools.eu/realms/SME%20Tools%20-%20Test

# Check client config in Keycloak
# - Valid Redirect URIs must match exactly
# - Client authentication must be ON
# - Standard flow must be enabled
# - Client secret must match config

# Check backend logs
tail -f logs/xbillr.log | grep -i oidc
```

### 401 Unauthorized after login

```bash
# Check session cookie is being sent
# In browser console: document.cookie

# Check user_info in session
# Backend logs should show session data

# Verify middleware is checking session
grep -n "user_info" backend/lib/XBillr/Middleware/Auth.pm
```

### Cookie too large

```bash
# Ensure store_session_tokens is disabled
cat config/xbillr.conf | grep store_session_tokens
# Should be: store_session_tokens => 0
```

---

## Monitoring

### Health Check

```bash
curl http://localhost:3002/api/health
```

### Check Running Processes

```bash
# Development
ps aux | grep morbo

# Production
docker compose ps
```

### View Logs

```bash
# Development
tail -f logs/xbillr.log
tail -f logs/xbillr-backend.log

# Production (Docker)
docker compose logs -f backend
```

---

## Support

Further information:
- `README.md` - General information
- `QUICKSTART.md` - Quick start guide
- `documentation/ARCHITECTURE.md` - Architecture documentation
- `OAUTH2_IMPLEMENTATION.md` - OAuth2 flow details
- `backend/SECURITY.md` - Security hardening guide
- `documentation/mobile/` - Mobile app integration
