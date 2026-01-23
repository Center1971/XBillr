# iOS Integration (OAuth2/OIDC + PKCE)

## Recommended Libraries
- AppAuth-iOS
- URLSession for API calls

## Setup Steps
1. Register a custom URL scheme (e.g., `xbillr://oauth/callback`).
2. Use ASWebAuthenticationSession or SFAuthenticationSession to open the auth URL.
3. Generate PKCE verifier/challenge (S256).
4. Exchange the authorization code for tokens.
5. Store tokens in Keychain.

## URL Scheme Registration
Add to Info.plist:
```
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>xbillr</string>
    </array>
  </dict>
</array>
```

## Auth Endpoints
Use the issuer from `config/xbillr.conf`:
- Authorization: `{issuer}{authorization_endpoint}`
- Token: `{issuer}{token_endpoint}`

## API Calls
Attach `Authorization: Bearer <access_token>` to all `/api/*` calls.

## Tenant and Roles
Use `groups` and `resource_access` claims for UI context only. Server enforces authorization.
