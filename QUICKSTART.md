# XBillr Quick Start Guide

## Prerequisites

- Docker and Docker Compose installed
- Ports 3002 and 8080 available

## Step 1: Start Backend

```bash
cd /home/jeff/src/aigenerated/XBillr-main
docker compose up -d
```

Wait for containers to be healthy:
```bash
docker compose ps
```

## Step 2: Initialize Database

```bash
./bin/setup_complete.sh
```

This will:
- Create database schema
- Create user management tables
- Create admin user (username: `admin`, password: `admin123`)

## Step 3: Serve Frontend

**IMPORTANT**: Do NOT open HTML files directly! Use an HTTP server:

```bash
./bin/serve_frontend.sh
```

This starts a Python HTTP server on port 8080.

## Step 4: Login

1. Open browser: http://localhost:8080/login.html
2. Username: `admin`
3. Password: `admin123`

## Troubleshooting

### "Verbindungsfehler" Error

**Most Common Cause**: Opening HTML file directly (file://)

**Solution**: Always use HTTP server:
```bash
./bin/serve_frontend.sh
```

### Backend Not Running

```bash
docker compose ps
docker compose up -d
docker compose logs backend
```

### Database Issues

```bash
# Reinitialize database
./bin/setup_complete.sh

# Or manually
docker compose exec -T mariadb mysql -uroot -p"u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX" xbillr < backend/sql/schema.sql
docker compose exec -T mariadb mysql -uroot -p"u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX" xbillr < backend/sql/user_management.sql
```

### Test Login API

```bash
curl -X POST http://localhost:3002/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## Useful Commands

```bash
# Check backend status
docker compose ps

# View backend logs
docker compose logs -f backend

# Restart backend
docker compose restart backend

# Stop everything
docker compose down

# Start everything
docker compose up -d
```

## Browser Console

Always check browser console (F12) for detailed errors:
- Network tab: See API requests/responses
- Console tab: See JavaScript errors
- Application tab: Check localStorage for session token
