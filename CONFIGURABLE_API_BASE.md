# Configurable API Base URL - Implementation Summary

**Date**: 2026-01-23  
**Version**: 0.5

## Overview

The XBillr frontend now dynamically loads its API base URL from the backend configuration, allowing seamless deployment across different environments (development, staging, production) without changing frontend code.

## What Changed

### 1. Backend: New `/api/config` Endpoint

**File**: `backend/lib/XBillr/Controller/Config.pm` (NEW)

A new controller endpoint that serves frontend configuration:

```perl
sub frontend {
    my $c = shift;
    
    my $frontend_config = $c->app->config->{frontend} || {};
    my $iam_config = $c->app->config->{iam} || {};
    
    $c->render(json => {
        apiBaseUrl => $frontend_config->{api_base_url} || '/api',
        appName => $frontend_config->{app_name} || 'XBillr',
        appVersion => $frontend_config->{app_version} || $XBillr::Version::VERSION,
        frontendUrl => $iam_config->{frontend_url} || 'http://localhost:8082',
    }, status => 200);
}
```

**Route**: `GET /api/config` (no authentication required)

**Response Example**:
```json
{
  "apiBaseUrl": "/api",
  "appName": "XBillr",
  "appVersion": "0.5",
  "frontendUrl": "http://localhost:8082"
}
```

### 2. Configuration: New `frontend` Section

**File**: `config/xbillr.conf`

```perl
frontend => {
  # API Base URL for frontend to use
  # Use '/api' for relative paths (recommended with reverse proxy)
  # Or 'https://api.yourdomain.com/api' for absolute URLs
  api_base_url => '/api',
  
  # Application name and version
  app_name => 'XBillr',
  app_version => '0.5',
},
```

### 3. Frontend: Dynamic Config Loading

All three frontend files now dynamically load configuration:

#### Files Updated:
- `frontend/login.html`
- `frontend/index.html`
- `frontend/test-api.html`

#### Implementation Pattern:
```javascript
// Global config loaded from backend
let API_BASE = '/api'; // Default fallback (relative path)
let appConfig = null;

// Load configuration from backend
async function loadConfig() {
    try {
        // Always use relative path for config endpoint
        const response = await fetch('/api/config');
        if (response.ok) {
            appConfig = await response.json();
            API_BASE = appConfig.apiBaseUrl || '/api';
            console.log('Loaded config:', { apiBaseUrl: API_BASE });
        }
    } catch (error) {
        console.warn('Failed to load config, using default:', error);
        // Keep default relative path
    }
}

// Initialize app: load config, then proceed
async function init() {
    await loadConfig();
    // ... rest of initialization
}

init();
```

### 4. OpenAPI Specification

**File**: `backend/openapi.yaml`

Added new endpoint documentation:

```yaml
/api/config:
  get:
    tags: [Config]
    summary: Get frontend configuration
    description: Returns configuration values needed by the frontend
    security: []
    responses:
      '200':
        description: Configuration values
        content:
          application/json:
            schema:
              type: object
              properties:
                apiBaseUrl:
                  type: string
                  example: /api
                appName:
                  type: string
                  example: XBillr
                appVersion:
                  type: string
                  example: 0.5
                frontendUrl:
                  type: string
                  example: http://localhost:8082
```

### 5. Documentation Updates

- **CHANGELOG.md**: Added entry for configurable API base URL feature
- **SERVER-SETUP.md**: Added configuration examples for both development and production
- **OpenAPI Docs**: Regenerated with new `/api/config` endpoint
- **Postman Collection**: Updated with new endpoint

## Configuration Examples

### Development (Direct Access)

For development without reverse proxy, you can use absolute URLs:

```perl
frontend => {
  api_base_url => 'http://localhost:3002/api',
  app_name => 'XBillr',
  app_version => '0.5',
},
```

### Development (With CORS)

Or use relative paths (frontend must run on same domain or CORS must be configured):

```perl
frontend => {
  api_base_url => '/api',
  app_name => 'XBillr',
  app_version => '0.5',
},
```

### Production (With Reverse Proxy) ⭐ RECOMMENDED

Use relative paths with reverse proxy:

```perl
frontend => {
  api_base_url => '/api',  # Relative path - works with any domain
  app_name => 'XBillr',
  app_version => '0.5',
},
```

**Apache/Nginx Configuration**:
```apache
# Serve frontend at root
DocumentRoot /opt/xbillr/frontend

# Proxy API requests to backend
<Location /api>
    ProxyPass http://127.0.0.1:3002/api
    ProxyPassReverse http://127.0.0.1:3002/api
</Location>
```

### Production (Different Domain)

If API is on a different domain:

```perl
frontend => {
  api_base_url => 'https://api.xbillr.eu/api',  # Absolute URL
  app_name => 'XBillr',
  app_version => '0.5',
},
```

## Benefits

✅ **Environment-Independent Frontend**: Same frontend code works in dev, staging, and production  
✅ **No Code Changes**: Change API URL via config file only  
✅ **Reverse Proxy Friendly**: Relative paths work seamlessly with reverse proxies  
✅ **Fallback Mechanism**: Frontend has sensible defaults if config fetch fails  
✅ **Type Safety**: OpenAPI spec documents the config endpoint  
✅ **Security**: No sensitive data exposed (only public URLs)

## Testing

### 1. Test Config Endpoint

```bash
# Check if config endpoint works
curl http://localhost:3002/api/config

# Expected output:
# {
#   "apiBaseUrl": "/api",
#   "appName": "XBillr",
#   "appVersion": "0.5",
#   "frontendUrl": "http://localhost:8082"
# }
```

### 2. Test Frontend Loading

1. Open browser dev console
2. Navigate to `http://localhost:8082/login.html`
3. Check console logs for: `Loaded config: { apiBaseUrl: "/api" }`
4. Verify all API calls use the configured base URL

### 3. Test Different Environments

**Development**:
```perl
api_base_url => 'http://localhost:3002/api'
```

**Staging**:
```perl
api_base_url => 'https://staging-api.xbillr.eu/api'
```

**Production**:
```perl
api_base_url => '/api'  # With reverse proxy
```

## Migration Notes

### Before (Hardcoded URLs):
```javascript
const API_BASE = 'http://localhost:3002/api';
```

### After (Dynamic Config):
```javascript
let API_BASE = '/api'; // Default
await loadConfig();    // Loads from /api/config
```

### No Breaking Changes

- Fallback to relative path if config fails
- Works with existing deployments
- Backward compatible

## Troubleshooting

### Config Not Loading

**Symptom**: Console shows "Failed to load config"  
**Solution**: Check backend is running and `/api/config` endpoint is accessible

### Wrong API URL

**Symptom**: API calls fail with 404/CORS errors  
**Solution**: Verify `api_base_url` in `config/xbillr.conf` matches your reverse proxy setup

### CORS Issues

**Symptom**: CORS policy errors in browser console  
**Solution**: Use reverse proxy with relative paths OR configure CORS headers in backend

## Related Files

### Backend
- `backend/lib/XBillr/Controller/Config.pm` - Config controller
- `backend/app.pl` - Route registration
- `backend/openapi.yaml` - API specification

### Frontend
- `frontend/login.html` - Login page
- `frontend/index.html` - Main application
- `frontend/test-api.html` - API testing page

### Configuration
- `config/xbillr.conf` - Central configuration file

### Documentation
- `documentation/CHANGELOG.md` - Change history
- `documentation/SERVER-SETUP.md` - Setup instructions
- `documentation/api/index.html` - API documentation (generated)
- `postman/XBillr.postman_collection.json` - API tests (generated)

## Next Steps

1. ✅ **Implemented**: Dynamic API base URL loading
2. ✅ **Updated**: All frontend files (login, index, test-api)
3. ✅ **Documented**: OpenAPI spec, CHANGELOG, SERVER-SETUP
4. ✅ **Generated**: API docs and Postman collection
5. 🔄 **Test**: Verify in development and production environments
6. 🔄 **Deploy**: Update production config if needed

---

**Questions or Issues?**  
Check `documentation/SERVER-SETUP.md` for detailed setup instructions.
