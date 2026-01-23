# XBillr Mobile Integration Guide

## Overview
XBillr uses OAuth 2.1 / OpenID Connect with Keycloak. Mobile clients authenticate via the
Authorization Code Flow with PKCE (S256). The API expects a Bearer access token on all
`/api/*` endpoints (except `/api/health`).

## IAM Configuration
Source of truth: `config/xbillr.conf` (`iam` block).

Key values for mobile clients:
- `issuer`: Keycloak issuer URL
- `authorization_endpoint`: `/protocol/openid-connect/auth`
- `token_endpoint`: `/protocol/openid-connect/token`
- `jwks_uri`: `/protocol/openid-connect/certs`
- `clients.mobile.client_id`
- `clients.mobile.redirect_uri`

## Authentication Flow (PKCE)
1. Generate PKCE code verifier and S256 code challenge.
2. Open the authorization URL in the system browser (or ASWebAuthenticationSession / Custom Tabs).
3. Handle the redirect to your app scheme (e.g., `xbillr://oauth/callback`) and extract `code`.
4. Exchange the authorization code for tokens at the token endpoint.
5. Store `access_token` and `refresh_token` securely.
6. Send API requests with `Authorization: Bearer <access_token>`.

### Authorization URL (example)
```
{issuer}{authorization_endpoint}?
  response_type=code&
  client_id=xbillr-mobile&
  redirect_uri=xbillr://oauth/callback&
  scope=openid%20profile%20email&
  code_challenge_method=S256&
  code_challenge=<S256(code_verifier)>
```

### Token Exchange (example)
```
POST {issuer}{token_endpoint}
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
client_id=xbillr-mobile&
redirect_uri=xbillr://oauth/callback&
code=<authorization_code>&
code_verifier=<code_verifier>
```

## Token Handling
- Persist tokens in secure storage (Keychain / Keystore).
- Refresh tokens using `grant_type=refresh_token` before expiry.
- On 401 responses, refresh the token and retry once.

## Tenants and Groups
Tenants are IAM groups and appear in the JWT `groups` claim. The backend scopes data by
matching the tenant group name to customer names (`company` or `name`). Ensure each user
belongs to at least one tenant group.

## Roles
Roles are delivered via `resource_access[<client_id>].roles` and must use the `XBillr-` prefix:
- `XBillr-Admin`
- `XBillr-Tenant-Admin`
- `XBillr-User`
- `XBillr-Viewer`

## API Usage
- Base URL: `http://<host>:3002`
- Health: `GET /api/health` (public)
- All other endpoints: Bearer token required

## Security Notes
- Always use HTTPS in production.
- Never embed client secrets in mobile apps.
- Use PKCE S256, not plaintext.

## Troubleshooting
- 401: access token missing/expired/invalid.
- 403: role or tenant group missing.
- 404: resource outside tenant scope.

See `ANDROID.md` and `IOS.md` for platform-specific steps.
