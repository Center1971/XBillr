# XBillr Mobile – Build-Anleitung

## Android (APK/AAB)

1. **Entwicklung:**  
   `npx cap open android` → in Android Studio Emulator oder Gerät starten.

2. **Release-APK (z. B. zum direkten Installieren):**
   - Android Studio: **Build → Build Bundle(s) / APK(s) → Build APK(s)**  
   - Oder: **Build → Generate Signed Bundle / APK** (für Play Store: AAB wählen), Keystore anlegen/auswählen, dann bauen.  
   - APK liegt danach in `android/app/build/outputs/apk/`.

3. **Von der Kommandozeile (Debug-APK):**  
   `cd android && ./gradlew assembleDebug`  
   → APK: `app/build/outputs/apk/debug/app-debug.apk`

## iOS (nur auf macOS mit Xcode)

1. **CocoaPods (einmalig):**  
   `cd ios/App && pod install`

2. **Entwicklung:**  
   `npx cap open ios` → in Xcode Simulator oder iPhone starten.

3. **Release / App Store:**  
   In Xcode: Signing & Capabilities konfigurieren (Team, Bundle ID), dann **Product → Archive**.  
   Über **Distribute App** als Ad-Hoc, Enterprise oder App Store verteilen.

## Nach Änderungen an www/ oder capacitor.config.json

Immer ausführen:

```bash
npx cap sync
```

Danach Android/iOS in Android Studio bzw. Xcode neu bauen.
