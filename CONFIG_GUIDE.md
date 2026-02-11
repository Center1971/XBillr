# XBillr Configuration Guide

## Quick Setup for Local Development vs Production

### Local Development (localhost:3002)

**1. Edit `config/xbillr.conf`:**
```perl
iam => {
    frontend_url => 'http://localhost:3002',  
    # api_public_base_url => undef,  # Comment out or set to undef
    clients => {
      web => {
        redirect_uri => 'http://localhost:3002/api/auth/oidc/callback',
      },
    },
},
```

**2. Add to Keycloak Valid Redirect URIs:**
- Go to: `https://iam.smetools.eu/admin/master/console/`
- Clients → `xbillr-web` → Settings
- Add: `http://localhost:3002/api/auth/oidc/callback`
- Add: `http://localhost:3002/*`  (wildcard for all local pages)

**3. Restart backend:**
```bash
cd /home/jeff/src/smetools/XBillr
lsof -ti:3002 | xargs kill -9
cd backend && morbo app.pl -l http://*:3002
```

**4. Access:** http://localhost:3002/login.html

---

### Production (Reverse Proxy)

**1. Edit `config/xbillr.conf`:**
```perl
iam => {
    frontend_url => 'https://xbillr.hurin.com',
    api_public_base_url => 'https://xbillr.hurin.com/api',
    clients => {
      web => {
        redirect_uri => 'http://localhost:3002/api/auth/oidc/callback',  # Not used when api_public_base_url is set
      },
    },
},
```

**2. Add to Keycloak Valid Redirect URIs:**
- Go to: `https://iam.smetools.eu/admin/master/console/`
- Clients → `xbillr-web` → Settings
- Add: `https://xbillr.hurin.com/api/auth/oidc/callback`
- Add: `https://xbillr.hurin.com/*`

**3. Nginx/Apache config:**
```nginx
# Nginx example
location / {
    root /path/to/XBillr/frontend;
    try_files $uri $uri/ /index.html;
}

location /api {
    proxy_pass http://localhost:3002/api;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}
```

**4. Access:** https://xbillr.hurin.com/

---

## Troubleshooting

### White page after login (local)
- Make sure `frontend_url` is set to `http://localhost:3002`
- Clear browser cookies and cache
- Check browser console for errors

### Redirect to localhost:3002 (production)
- Make sure `api_public_base_url` is set to your public URL
- Restart backend after config changes
- Verify the redirect URI is in Keycloak

### Session cookies not working
- For local: Everything must be on same origin (localhost:3002)
- For production: Make sure proxy passes cookies correctly

---

## Current Status

Your config is currently set for **PRODUCTION** (reverse proxy).
To use locally, follow the "Local Development" steps above.
