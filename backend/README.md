# XBillr Backend

**Version 0.2**

Backend für XBillr Rechnungssoftware basierend auf Perl, Mojolicious und DBIx::Class.

## Technologie-Stack

- **Perl**: Version 5.30 oder höher
- **Mojolicious**: Web-Framework
- **DBIx::Class**: ORM für Datenbankzugriffe
- **MariaDB**: Datenbank
- **DBD::MariaDB**: Datenbanktreiber

## Installation

### Voraussetzungen

- Perl 5.30 oder höher
- MariaDB Server
- cpanminus (cpanm)

### Abhängigkeiten installieren

```bash
cd backend
cpanm --installdeps .
```

### Datenbank einrichten

1. MariaDB Server starten
2. Datenbank und Benutzer erstellen:

```sql
CREATE DATABASE xbillr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'xbillr_user'@'localhost' IDENTIFIED BY 'xbillr_pass';
GRANT ALL PRIVILEGES ON xbillr.* TO 'xbillr_user'@'localhost';
FLUSH PRIVILEGES;
```

3. Schema erstellen:

```bash
mysql -u xbillr_user -p xbillr < sql/schema.sql
```

### Konfiguration

Umgebungsvariablen setzen (optional):

```bash
export DB_DSN="dbi:MariaDB:database=xbillr;host=localhost;port=3307"
export DB_USER="xbillr_user"
export DB_PASSWORD="xbillr_pass"
```

Oder die Datei `config/xbillr.conf` anpassen.

## Starten der Anwendung

```bash
perl app.pl daemon
```

Die Anwendung läuft standardmäßig auf `http://localhost:3001`

## API Endpunkte

### Health Check
- `GET /api/health` - Prüft die Verbindung zur Datenbank

### Customers
- `GET /api/customers` - Alle Kunden abrufen
- `POST /api/customers` - Neuen Kunden erstellen
- `GET /api/customers/:id` - Kunde abrufen
- `PUT /api/customers/:id` - Kunde aktualisieren
- `DELETE /api/customers/:id` - Kunde löschen

### Invoices
- `GET /api/invoices` - Alle Rechnungen abrufen
- `GET /api/invoices/archived` - Archivierte Rechnungen abrufen
- `POST /api/invoices` - Neue Rechnung erstellen
- `GET /api/invoices/:id` - Rechnung abrufen
- `PUT /api/invoices/:id` - Rechnung aktualisieren
- `DELETE /api/invoices/:id` - Rechnung löschen
- `POST /api/invoices/:id/archive` - Rechnung archivieren
- `POST /api/invoices/:id/unarchive` - Rechnung dearchivieren
- `POST /api/invoices/archived/:id/duplicate` - Archivierte Rechnung duplizieren

### Time Entries
- `GET /api/time-entries/week/:year/:week` - Zeiteinträge für Woche
- `GET /api/time-entries/month/:year/:month` - Zeiteinträge für Monat
- `POST /api/time-entries` - Neuen Zeiteintrag erstellen
- `PUT /api/time-entries/:id` - Zeiteintrag aktualisieren
- `DELETE /api/time-entries/:id` - Zeiteintrag löschen

### Hourly Rates
- `GET /api/hourly-rates/customer/:customerId` - Stundensätze für Kunde
- `POST /api/hourly-rates` - Neuen Stundensatz erstellen
- `GET /api/hourly-rates/:id` - Stundensatz abrufen
- `PUT /api/hourly-rates/:id` - Stundensatz aktualisieren
- `DELETE /api/hourly-rates/:id` - Stundensatz löschen

### Supplier
- `GET /api/supplier` - Lieferant abrufen
- `PUT /api/supplier` - Lieferant aktualisieren/erstellen

### Logs
- `GET /api/logs` - Aktivitätsprotokolle abrufen

## Projektstruktur

```
backend/
├── app.pl                 # Hauptanwendung
├── cpanfile               # Abhängigkeiten
├── config/xbillr.conf            # Konfigurationsdatei
├── lib/
│   └── XBillr/
│       ├── Controller/    # Controller (API-Endpunkte)
│       ├── Model/         # DBIx::Class Modelle
│       │   └── DB/        # Datenbank-Schemas
│       └── Service/       # Service-Komponenten
├── templates/             # Templates (falls benötigt)
└── sql/
    └── schema.sql         # Datenbankschema
```

## Entwicklung

### Code-Struktur

- **Controller**: In `lib/XBillr/Controller/` - Handhaben HTTP-Requests
- **Model**: In `lib/XBillr/Model/DB/` - DBIx::Class Schemas für Datenbankzugriffe
- **Service**: In `lib/XBillr/Service/` - Geschäftslogik-Komponenten
- **Templates**: In `templates/` - Separate Template-Dateien (falls benötigt)

### Mojolicious Features

- Separate Controller-Dateien für jeden Endpunkt-Bereich
- DBIx::Class für Datenbankzugriffe
- JSON-API Responses
- CORS-Unterstützung

## Lizenz

MIT

