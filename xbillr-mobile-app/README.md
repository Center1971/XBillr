# XBillr Mobile App (Android & iOS)

Native Capacitor-App mit lokaler SPA (`www/`), Keycloak-PKCE-Login und Offline-Cache/Sync gemäß ANFORDERUNGEN.

## Funktionen

- Stammdaten, Profil, Kunden, Rechnungen (Status-Aktionen)
- Offline: Cache + Sync-Queue (Last-Write-Wins beim Wieder-Online)
- Rechnungen: nur aktuelles Jahr im Cache

## Einrichtung

```bash
cd xbillr-mobile-app
npm install
npx cap sync
```

### Android

```bash
npx cap open android
```

Release / Store: siehe [STORE.md](./STORE.md) und [README-ANDROID.md](./README-ANDROID.md).

### iOS

```bash
cd ios/App && pod install && cd ../..
npx cap open ios
```

In Xcode **`App.xcworkspace`** öffnen (nicht `.xcodeproj`).

## Konfiguration

| Setting | Wert |
|--------|------|
| App-ID | `eu.xbillr.mobile` |
| API | `https://www.xbillr.eu/api` |
| Keycloak Client | `xbillr-mobile` |
| Redirect URI | `xbillr-mobile://oauth/callback` |

In Keycloak muss `xbillr-mobile://oauth/callback` als gültige Redirect-URI eingetragen sein.
