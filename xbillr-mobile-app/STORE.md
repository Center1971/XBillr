# XBillr Mobile – Store-Readiness

Version: **1.0.1** (Android `versionCode` 2)

## Erledigt im Code

- HTTPS only, kein Cleartext / Mixed Content
- `allowBackup=false` + Data-Extraction-Rules
- FileProvider auf Cache/Files beschränkt
- Network Security Config
- Release: R8 minify + shrinkResources + ProGuard für Capacitor
- Signing über `android/keystore.properties` (Vorlage: `keystore.properties.example`)
- Deep Links: `xbillr-mobile://`, `eu.xbillr.mobile://`, HTTPS App Links `/app`
- Capacitor `allowNavigation` auf benötigte Hosts begrenzt
- iOS: URL-Schemes, ATS streng, `ITSAppUsesNonExemptEncryption=false`
- Start-URL: `https://www.xbillr.eu/app/`

## Vor Play Store / App Store (manuell)

### Android (Play Console)

1. Keystore erzeugen (einmalig):
   ```bash
   keytool -genkey -v -keystore android/keystore/xbillr-release.jks \
     -alias xbillr -keyalg RSA -keysize 2048 -validity 10000
   ```
2. `android/keystore.properties.example` → `android/keystore.properties` kopieren und Passwörter setzen  
   (**niemals** committen)
3. Sync & Release-Bundle:
   ```bash
   npm install && npx cap sync android
   cd android && ./gradlew bundleRelease
   ```
   AAB: `android/app/build/outputs/bundle/release/app-release.aab`
4. Play Console: App anlegen, Content Rating, Datenschutz-URL, Screenshots
5. Optional: Digital Asset Links für App Links unter `https://www.xbillr.eu/.well-known/assetlinks.json`

### iOS (App Store Connect)

1. In Xcode Team/Signing setzen (Bundle ID `eu.xbillr.mobile`)
2. `npx cap sync ios` → `App.xcworkspace` öffnen → **Archive**
3. Privacy Nutrition Labels: Account, Finanzdaten (Rechnungen), keine Tracking-SDKs
4. Export Compliance: Non-Exempt Encryption = No (bereits in Info.plist)

## Smoke-Test vor Upload

- [ ] App startet und lädt `www.xbillr.eu/app/`
- [ ] Keycloak-Login (`iam.smetools.eu`) bleibt in der WebView
- [ ] Logout / Session
- [ ] Kein Cleartext-HTTP
- [ ] Release-Build installierbar (kein Debug-Suffix)
