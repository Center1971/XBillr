# XBillr

**Version 0.4**

Eine vollständige Rechnungssoftware nach dem XRechnung-Standard des IT-Planungsrats für Freelancer.

## Features

1. ✅ **Kundenverwaltung**: Stundensätze für verschiedene Kunden verwalten
2. ✅ **Zeiterfassung**: Wöchentliche Stundenzettel ausfüllen
3. ✅ **Rechnungsgenerierung**: Rechnungen für ausgewählte Zeiträume generieren
4. ✅ **Steuerbehandlung**: Mehrwertsteuer oder Reverse Charge Verfahren
5. ✅ **Rechnungssuche**: Rechnungen indizieren und nach verschiedenen Kriterien durchsuchen
6. ✅ **Mobile-Support**: Web-basiert mit responsivem Design für iOS/Android

## Technologie-Stack

- **Backend**: Perl + Mojolicious + DBIx::Class
- **Frontend**: React + TypeScript + Material-UI
- **Datenbank**: MariaDB
- **XRechnung**: XML-Generierung nach IT-Planungsrat Standard (XRechnung 3.0)
- **API**: OpenAPI 3.1 + OAuth2/OIDC (Keycloak)

## Installation

### Voraussetzungen

- Perl 5.30 oder höher
- MariaDB Server
- Node.js (Version 18 oder höher) für Frontend
- npm oder yarn

### Backend Setup

Siehe [backend/README.md](backend/README.md) für Details.

```bash
cd backend
cpanm --installdeps .
mysql -u root -p < sql/schema.sql
perl app.pl daemon
```

Das Backend läuft standardmäßig auf `http://localhost:3002`

### API-Dokumentation

- OpenAPI-Spezifikation: `backend/openapi.yaml`
- Gebündelte Dokumentation: `documentation/api/openapi.bundle.yaml`
- Lokal anzeigen: `/usr/bin/scalar document serve backend/openapi.yaml`

### Frontend Setup

```bash
cd frontend
npm install

# Optional: API URL konfigurieren
# Erstellen Sie eine .env Datei mit:
# REACT_APP_API_URL=http://localhost:3002/api

npm start
```

Das Frontend läuft standardmäßig auf `http://localhost:3000`

## Verwendung

### 1. Kunden erfassen

- Navigieren Sie zu "Kunden"
- Klicken Sie auf "Neuer Kunde"
- Geben Sie Name, Adresse, PLZ, Stadt und optional USt-IdNr. ein
- Speichern Sie den Kunden

### 2. Stundensätze definieren

- Navigieren Sie zu "Stundensätze"
- Wählen Sie einen Kunden aus
- Geben Sie den Stundensatz, Beschreibung und Gültigkeitszeitraum ein
- Speichern Sie den Stundensatz

### 3. Zeiterfassung

- Navigieren Sie zu "Zeiterfassung"
- Wählen Sie Jahr und Kalenderwoche
- Klicken Sie auf "Neuer Eintrag"
- Geben Sie Kunde, Datum, Stunden und Beschreibung ein
- Speichern Sie den Eintrag

### 4. Rechnung erstellen

- Navigieren Sie zu "Rechnungen"
- Klicken Sie auf "Neue Rechnung"
- Wählen Sie Kunde, Zeitraum und Steuerart (MwSt. oder Reverse Charge)
- Bei MwSt. geben Sie den Steuersatz ein (z.B. 19%)
- Die Rechnung wird automatisch aus den Zeiteinträgen generiert

### 5. Rechnungen durchsuchen

- Klicken Sie auf "Suchen" in der Rechnungsübersicht
- Filtern Sie nach Kunde, Zeitraum, Rechnungsnummer oder Status
- Klicken Sie auf eine Rechnung für Details

### 6. XRechnung XML exportieren

- Öffnen Sie eine Rechnung
- Klicken Sie auf "XRechnung XML" zum Download
- Die XML-Datei entspricht dem XRechnung 3.0 Standard

## Mobile Nutzung

Die Anwendung ist vollständig responsive und kann auf mobilen Geräten (iOS/Android) über den Browser genutzt werden.

## Lizenz

MIT

## Entwicklerdokumentation

- Doxygen-Konfiguration: `documentation/Doxyfile`
- LaTeX-Ausgabe: `documentation/doxygen/latex` (nach Doxygen-Lauf)
