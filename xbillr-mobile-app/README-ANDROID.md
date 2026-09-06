# XBillr Android (Capacitor)

WebView-App für **https://www.xbillr.eu/app/** (Login: Keycloak / SME Tools).

## Voraussetzungen

- Node.js 18+
- Android Studio mit SDK **35**

## Schnellstart (Debug)

```bash
cd xbillr-mobile-app
npm install
npx cap sync android
npx cap open android
```

## Release / Play Store

Siehe **[STORE.md](./STORE.md)**.

Kurz:

```bash
cp android/keystore.properties.example android/keystore.properties
# Passwörter und storeFile eintragen, Keystore anlegen
npm install && npx cap sync android
cd android && ./gradlew bundleRelease
```

AAB: `android/app/build/outputs/bundle/release/app-release.aab`

Debug-APK:

```bash
cd android && ./gradlew assembleDebug
```
→ `app/build/outputs/apk/debug/app-debug.apk` (Application-ID: `eu.xbillr.mobile.debug`)
