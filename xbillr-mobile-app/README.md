# XBillr Mobile App (Android & iOS)

Diese App lädt **https://xbillr.eu** in einer nativen Hülle und macht XBillr auf dem Smartphone nutzbar (Login, Kunden, Zeiterfassung, Rechnungen usw.).

## Voraussetzungen

- **Node.js** 18+
- **Android:** Android Studio, Android SDK
- **iOS:** Xcode (nur auf macOS), CocoaPods

## Projekt einrichten

```bash
cd xbillr-mobile-app
npm install
npx cap add android
npx cap add ios
npx cap sync
```

## Android bauen & starten

```bash
npx cap open android
```

In Android Studio: Gerät/Emulator wählen und **Run** (▶). Oder von der Kommandozeile:

```bash
npx cap run android
```

Release-APK/AAB für den Play Store: In Android Studio **Build → Generate Signed Bundle / APK** verwenden.

## iOS bauen & starten (nur macOS)

```bash
npx cap open ios
```

In Xcode: Simulator oder angeschlossenes iPhone wählen und **Run** (▶). Oder:

```bash
npx cap run ios
```

Für den App Store: In Xcode Signing & Capabilities konfigurieren und **Product → Archive** ausführen.

## Ablauf in der App

1. App startet und zeigt kurz „XBillr wird geladen …“
2. Automatische Weiterleitung zu **https://xbillr.eu/login.html**
3. Nutzung von XBillr wie im Browser (Login, Kunden, Zeiten, Rechnungen, Benutzerverwaltung usw.)
4. Alle Funktionen von xbillr.eu laufen in der App-WebView; Cookies und Session bleiben erhalten.

## Synchronisation mit xbillr.eu

Die App arbeitet **direkt mit dem Server xbillr.eu**. Es gibt keine lokale Kopie der Daten, die erst synchronisiert werden müsste:

- **Alle Eingaben** (Kunden, Zeiteinträge, Rechnungen, Einstellungen) werden **sofort auf xbillr.eu gespeichert**.
- **Gleiche Daten** erscheinen auf dem **Handy, im Browser am PC und bei anderen Nutzern** (je nach Berechtigung), sobald die Seite geladen wird.
- **Session:** Nach dem Login speichert die App die Session (Cookie) in der WebView. Solange Sie die App nicht deinstallieren oder „App-Daten löschen“, bleiben Sie angemeldet und alle Aktionen laufen weiterhin gegen xbillr.eu.

**Praktisch:** Was Sie in der App eingeben, ist unmittelbar mit xbillr.eu synchronisiert; was Sie am PC auf xbillr.eu ändern, sehen Sie beim nächsten Öffnen in der App. Eine manuelle Sync-Funktion ist nicht nötig.

Falls die Session verloren geht (z. B. nach „App-Daten löschen“): Einfach erneut anmelden – alle Daten liegen weiterhin auf xbillr.eu und sind sofort wieder verfügbar.

## Konfiguration

- **Ziel-URL:** In `www/index.html` steht die Weiterleitung auf `https://xbillr.eu/login.html`. Bei Bedarf auf eine andere Basis-URL (z. B. Test-Server) anpassen.
- **Erlaubte Domains:** In `capacitor.config.json` unter `server.allowNavigation` sind xbillr.eu und ggf. IAM/Keycloak-Domains eingetragen, damit die Navigation innerhalb der App bleibt.

## Hinweise

- Die App ist ein **WebView-Wrapper**: Es wird keine eigene native UI gebaut, sondern die bestehende Web-Oberfläche von xbillr.eu genutzt.
- Für Offline-Nutzung müsste xbillr.eu als PWA mit Service Worker ausgebaut werden; die aktuelle App setzt eine Internetverbindung voraus.
- OAuth/Keycloak-Login und lokaler Login (admin) funktionieren wie in der Browser-Version.
