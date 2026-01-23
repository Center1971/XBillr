# Cursor Prompt: Implement XBillr Mobile Auth (Android/iOS)

You are implementing OAuth2/OpenID Connect login for XBillr mobile apps.
Use Authorization Code Flow with PKCE (S256). The app must authenticate against Keycloak
and call the XBillr API with a Bearer access token.

## Requirements
- Use system browser authentication (ASWebAuthenticationSession on iOS, Custom Tabs/AppAuth on Android).
- Generate PKCE code verifier and S256 code challenge.
- Handle deep link redirect `xbillr://oauth/callback`.
- Exchange `code` for tokens at the token endpoint.
- Store tokens securely (Keychain / Android Keystore).
- Refresh token before expiry (`grant_type=refresh_token`).
- Attach `Authorization: Bearer <access_token>` to all `/api/*` calls.
- Parse JWT claims for UI context:
  - `groups` contains tenant groups (use first for display).
  - `resource_access[client_id].roles` contains roles with prefix `XBillr-`.
- On 401: refresh once and retry.

## IAM Configuration
Get current values from backend `config/xbillr.conf` (`iam.clients.mobile` section):

- **Issuer**: `https://iam.smetools.eu/realms/SME%20Tools%20-%20Test`
- **Authorization endpoint**: `/protocol/openid-connect/auth`
- **Token endpoint**: `/protocol/openid-connect/token`
- **JWKS URI**: `/protocol/openid-connect/certs`
- **Client ID**: `xbillr-mobile`
- **Redirect URI**: `xbillr://oauth/callback`
- **Scopes**: `openid profile email`
- **PKCE**: Required (S256 method)

## Implementation Steps

### 1. Generate PKCE Parameters
```
code_verifier = random_string(43-128 chars, A-Za-z0-9-._~)
code_challenge = base64url(SHA256(code_verifier))
```

### 2. Build Authorization URL
```
GET {issuer}/protocol/openid-connect/auth?
  response_type=code&
  client_id=xbillr-mobile&
  redirect_uri=xbillr://oauth/callback&
  scope=openid profile email&
  state=<random_string>&
  code_challenge=<code_challenge>&
  code_challenge_method=S256
```

### 3. Launch System Browser
- iOS: Use `ASWebAuthenticationSession`
- Android: Use Chrome Custom Tabs or AppAuth library

### 4. Handle Redirect Callback
```
xbillr://oauth/callback?code=<auth_code>&state=<state>
```
- Verify `state` matches what you sent
- Extract `code` parameter

### 5. Exchange Code for Tokens
```
POST {issuer}/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
client_id=xbillr-mobile&
redirect_uri=xbillr://oauth/callback&
code=<auth_code>&
code_verifier=<code_verifier>
```

Response:
```json
{
  "access_token": "eyJhbG...",
  "refresh_token": "eyJhbG...",
  "id_token": "eyJhbG...",
  "expires_in": 300,
  "token_type": "Bearer"
}
```

### 6. Store Tokens Securely
- iOS: Keychain
- Android: EncryptedSharedPreferences or Android Keystore

### 7. Use Access Token for API Calls
```
GET http://<backend_host>:3002/api/customers
Authorization: Bearer <access_token>
```

### 8. Refresh Token Before Expiry
```
POST {issuer}/protocol/openid-connect/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&
client_id=xbillr-mobile&
refresh_token=<refresh_token>
```

### 9. Parse JWT Claims for User Context
Decode `access_token` JWT (don't validate locally, backend does that):
- `sub`: User ID
- `preferred_username`: Username
- `email`: Email address
- `given_name`, `family_name`: Name
- `groups`: Array of tenant groups (use first for current tenant)
- `resource_access.xbillr-mobile.roles`: Array of roles with `XBillr-` prefix

## Deliverables
- Auth service class/module
- Token storage abstraction
- HTTP client interceptor for Bearer token
- Deep link handling
- Minimal UI flow (login/logout)
