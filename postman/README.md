# Postman Collection for XBillr API

This directory contains the Postman collection for testing the XBillr API.

## Files

- `XBillr.postman_collection.json` - The Postman collection file

## Keeping the Collection in Sync

The Postman collection is automatically generated from `backend/openapi.yaml` to ensure it stays in sync with the API specification.

### Manual Sync

To manually sync the collection after making changes to `openapi.yaml`:

```bash
# Using Python script (recommended)
./scripts/sync-postman-collection.py

# Or using shell script
./scripts/sync-postman-collection.sh
```

### Prerequisites

Install the OpenAPI to Postman converter:

```bash
npm install -g openapi-to-postman-complete
```

### What Gets Preserved

The sync script preserves:
- **Custom variables** - All collection-level variables (baseUrl, access_token, OIDC settings, etc.)
- **OIDC authentication flows** - Custom OIDC login/logout flows and PKCE examples (if they exist in the old collection)

**Note:** The converter organizes endpoints under an `api` folder. If your old collection had custom OIDC flows in a top-level `Auth` folder, they will be merged into `api/auth`. If the folder structure differs significantly, you may need to manually re-add custom flows after the first sync.

### What Gets Updated

The sync script updates:
- All API endpoints from `openapi.yaml`
- Request/response schemas
- HTTP methods and URLs
- Request body examples
- Response examples

## Using the Collection

1. Import `XBillr.postman_collection.json` into Postman
2. Set the `baseUrl` variable to your API endpoint (default: `http://localhost:3002`)
3. For OAuth2/OIDC flows:
   - Update OIDC variables with your IAM configuration
   - Use the OIDC login flows in the Auth folder
4. For password grant (legacy):
   - Use "Login (Legacy)" request
   - The `access_token` variable will be set automatically

## Collection Structure

- **Auth** - Authentication endpoints (Health, Login, Logout, OIDC flows)
- **Customers** - Customer management endpoints
- **Invoices** - Invoice management endpoints
- **Time Entries** - Time entry management endpoints
- **Timesheets** - Timesheet management endpoints
- **Hourly Rates** - Hourly rate management endpoints
- **Supplier** - Supplier management endpoints
- **Logs** - Log viewing endpoints

## Variables

The collection includes the following variables:

- `baseUrl` - API base URL (default: `http://localhost:3002`)
- `access_token` - JWT access token (set automatically after login)
- `oidc_*` - OIDC configuration variables
- `*_id` - Resource IDs (customer_id, invoice_id, etc.)

## Notes

- The collection is generated from the OpenAPI spec, so it always reflects the current API
- Custom OIDC flows are preserved during sync
- Always commit the collection to version control after syncing
