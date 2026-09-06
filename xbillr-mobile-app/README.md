# XBillr Mobile App (Android & iOS)

Native Hülle (Capacitor) für **https://www.xbillr.eu/app/**  
Login über Keycloak (`iam.smetools.eu`).

## Voraussetzungen

- Node.js 18+
- Android Studio (SDK 35) bzw. Xcode + CocoaPods

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
| Start-URL | `https://www.xbillr.eu/app/` |
| Navigation | `www.xbillr.eu`, `xbillr.eu`, `iam.smetools.eu` |

Nach Änderungen an `www/` oder `capacitor.config.json`:

```bash
npx cap sync
```

## Store

Checkliste und Signing: **[STORE.md](./STORE.md)**
