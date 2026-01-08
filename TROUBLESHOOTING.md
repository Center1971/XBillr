# Troubleshooting Login Issues

## Error: "Verbindungsfehler. Bitte versuchen Sie es erneut."

This error occurs when the frontend cannot connect to the backend API. Here are the most common causes and solutions:

### 1. Frontend opened via file:// (Most Common)

**Problem**: Opening HTML files directly from the filesystem (`file://`) causes CORS errors.

**Solution**: Serve the frontend via HTTP server:

```bash
# Option 1: Use the provided script
./bin/serve_frontend.sh

# Option 2: Manual Python server
cd frontend
python3 -m http.server 8080

# Then open: http://localhost:8080/login.html
```

### 2. Backend Not Running

**Check**: 
```bash
docker compose ps
```

**Solution**:
```bash
docker compose up -d
```

### 3. Backend Not Accessible

**Test**:
```bash
curl http://localhost:3002/api/health
```

**Solution**: Check backend logs:
```bash
docker compose logs backend
```

### 4. Database Not Initialized

**Check**:
```bash
docker compose exec mariadb mysql -uroot -p"u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX" xbillr -e "SHOW TABLES;"
```

**Solution**:
```bash
./bin/setup_complete.sh
```

### 5. Admin User Not Created

**Solution**:
```bash
docker compose exec backend sh -c 'DB_DSN="dbi:MariaDB:database=xbillr;host=mariadb;port=3306" DB_USER="root" DB_PASSWORD="u9UUgy2ZwASrTebZ8pAGaCPnVSJZ8NRX" perl /app/scripts/create_admin.pl admin123'
```

### 6. CORS Configuration

**Check**: Open browser developer console (F12) and look for CORS errors.

**Solution**: The backend should allow your origin. Check `docker-compose.yml`:
```yaml
ALLOWED_ORIGINS: http://localhost:3002,http://localhost:8080,http://127.0.0.1:3002,http://127.0.0.1:8080
```

## Quick Diagnostic

Run the diagnostic script:
```bash
./bin/test_login.sh
```

## Complete Setup

If nothing works, run the complete setup:
```bash
./bin/setup_complete.sh
```

Then serve the frontend:
```bash
./bin/serve_frontend.sh
```

And open: http://localhost:8080/login.html

## Browser Console

Always check the browser console (F12) for detailed error messages. The console will show:
- Network errors
- CORS errors
- API response errors
- JavaScript errors
