# Android Integration (OAuth2/OIDC + PKCE)

## Recommended Libraries
- AppAuth for Android (net.openid:appauth)
- OkHttp or Retrofit for API calls

## Setup Steps
1. Configure a custom scheme redirect URI (e.g., `xbillr://oauth/callback`).
2. Add an intent filter in your Activity to receive the redirect.
3. Build the authorization request with PKCE (S256).
4. Exchange the authorization code for tokens.
5. Store tokens in EncryptedSharedPreferences or Jetpack Security.

## Manifest Intent Filter
```
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="xbillr" android:host="oauth" android:path="/callback" />
</intent-filter>
```

## Auth Endpoints
Use the issuer from `config/xbillr.conf`:
- Authorization: `{issuer}{authorization_endpoint}`
- Token: `{issuer}{token_endpoint}`

## API Calls
Attach `Authorization: Bearer <access_token>` to all `/api/*` calls.

## Tenant and Roles
Read `groups` and `resource_access` claims from the access token to display tenant context
and enforce UX hints, but backend remains the source of truth.
