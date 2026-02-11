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

## OIDC / Keycloak: "Token-Endpoint nicht erreichbar" or "Can't resolve"

**Symptom**: After clicking login you are sent to Keycloak, but after entering credentials the callback fails with HTTP 500 and the log shows:
- `Can't resolve: Der Name oder der Dienst ist nicht bekannt at lib/XBillr/Controller/Auth.pm`
- or "Token-Endpoint nicht erreichbar (IAM-Host nicht auflösbar …)"

**Cause**: The **backend** (the machine/container running the API) cannot resolve or reach the IAM issuer host (e.g. `iam.smetools.eu`). The browser can reach Keycloak, but the server-side token exchange POST goes from the backend to the token URL; if the backend has no DNS or no route to that host, the request fails.

**What to do**:

1. **From the backend host, check DNS and connectivity**:
   ```bash
   # Resolve the IAM host (see config: iam.issuer in xbillr.conf)
   getent hosts iam.smetools.eu
   # or
   ping -c1 iam.smetools.eu
   ```
   If this fails, fix DNS (e.g. add nameserver in `/etc/resolv.conf`) or network/firewall so the backend can reach the IAM host.

2. **Docker/containers**: If the backend runs in a container, ensure the container has DNS (e.g. use host network, or Docker’s default DNS). Test from inside the container:
   ```bash
   docker compose exec backend sh -c 'getent hosts iam.smetools.eu'
   ```

3. **Local/dev with Keycloak on the same machine**: Use an issuer URL the backend can resolve (e.g. `http://127.0.0.1:8080/realms/...` or `http://keycloak:8080/...` in Docker) and set `iam.issuer` (and optionally full `token_endpoint`/`authorization_endpoint`/`jwks_uri` URLs) in `config/xbillr.conf` accordingly.

## 401 when saving (e.g. new customer) or "randomly" after login

**Symptom**: After logging in, some requests (e.g. POST /api/customers) return HTTP 401; the error may appear "randomly" (sometimes works, sometimes not).

**Cause**: Session cookies are signed with a secret. If you run **multiple backend instances** (e.g. behind a load balancer or several Docker containers), each instance must use the **same** secret. Otherwise the instance that didn’t handle the login callback can’t validate the session cookie and returns 401. The backend logs a line like `Auth 401: no session user_info and no Bearer token for /api/customers` when the session cookie is missing or invalid.

**What to do**:

1. Set a **shared secret** for all backend instances:
   - In `config/xbillr.conf`: add `secret => 'your-long-random-secret-here'` (use a long random string).
   - Or set the environment variable **MOJO_SECRET** to the same value for every backend container/process (e.g. in Docker Compose or your process manager).
2. Restart all backend instances so they load the new secret.
3. Users may need to log in again after the change (existing session cookies were signed with the old secret).

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
