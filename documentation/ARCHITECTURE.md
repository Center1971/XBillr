# XBillr Systemarchitektur

## Übersicht

XBillr ist eine vollständige Rechnungssoftware nach dem XRechnung-Standard für Freelancer. Das System besteht aus einem Perl/Mojolicious Backend und einem React Frontend.

## API & Sicherheit

- **OpenAPI-first**: `backend/openapi.yaml` ist die Quelle der Wahrheit für Clients und Routing.
- **OpenAPI-Validierung**: Mojolicious nutzt `Mojolicious::Plugin::OpenAPI` für Request/Response-Validierung.
- **OAuth2/OIDC**: Zugriff über JWT Bearer Tokens (Keycloak), Rollen aus `resource_access`.

## Systemarchitektur

```
┌─────────────────────────────────────────────────────────────┐
│                        Frontend (React)                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   React App  │  │ Material-UI  │  │  TypeScript   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│           │                                                  │
│           │ HTTP/REST API                                    │
└───────────┼──────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│              Backend (Perl/Mojolicious)                     │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Mojolicious Web Framework               │   │
│  │  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │  Controller  │  │   Routes     │                │   │
│  │  └──────────────┘  └──────────────┘                │   │
│  └──────────────────────────────────────────────────────┘   │
│           │                                                  │
│           ▼                                                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Service Layer                            │   │
│  │  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │InvoiceService │  │  PDFService  │                │   │
│  │  └──────────────┘  └──────────────┘                │   │
│  └──────────────────────────────────────────────────────┘   │
│           │                                                  │
│           ▼                                                  │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              DBIx::Class ORM                         │   │
│  │  ┌──────────────┐  ┌──────────────┐                │   │
│  │  │   Models      │  │  ResultSets   │                │   │
│  │  └──────────────┘  └──────────────┘                │   │
│  └──────────────────────────────────────────────────────┘   │
│           │                                                  │
│           │ SQL                                              │
└───────────┼──────────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────────────────────┐
│                    MariaDB Datenbank                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  customers   │  │  invoices    │  │ time_entries │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │hourly_rates  │  │invoice_items  │  │  suppliers   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│  ┌──────────────┐                                          │
│  │activity_logs │                                          │
│  └──────────────┘                                          │
└─────────────────────────────────────────────────────────────┘
```

## Komponenten

### Frontend (React)

**Technologie:**
- React 18+
- TypeScript
- Material-UI
- React Router

**Hauptkomponenten:**
- `CustomersPage` - Kundenverwaltung
- `InvoicesPage` - Rechnungsübersicht
- `InvoiceDetailPage` - Rechnungsdetails
- `TimeEntriesPage` - Zeiterfassung
- `HourlyRatesPage` - Stundensatzverwaltung
- `SupplierPage` - Lieferantendaten

**API-Client:**
- REST API Client für Backend-Kommunikation
- JSON-basierte Kommunikation

### Backend (Perl/Mojolicious)

**Technologie:**
- Perl 5.30+
- Mojolicious 9.0+
- DBIx::Class (ORM)
- MariaDB Datenbanktreiber

**Architektur-Schichten:**

#### 1. Controller Layer
- **Zweck:** HTTP-Request-Verarbeitung
- **Dateien:**
  - `XBillr::Controller::Customers` - Kunden-API
  - `XBillr::Controller::Invoices` - Rechnungs-API
  - `XBillr::Controller::TimeEntries` - Zeiterfassungs-API
  - `XBillr::Controller::HourlyRates` - Stundensatz-API
  - `XBillr::Controller::Supplier` - Lieferanten-API
  - `XBillr::Controller::Health` - Health Check
  - `XBillr::Controller::Logs` - Aktivitätsprotokolle

#### 2. Service Layer
- **Zweck:** Geschäftslogik
- **Dateien:**
  - `XBillr::Service::InvoiceService` - Rechnungserstellung, Archivierung, Duplizierung

#### 3. Model Layer (DBIx::Class)
- **Zweck:** Datenbankzugriff
- **Dateien:**
  - `XBillr::Model::DB` - Hauptschema
  - `XBillr::Model::DB::Customer` - Kundenmodell
  - `XBillr::Model::DB::Invoice` - Rechnungsmodell
  - `XBillr::Model::DB::InvoiceItem` - Rechnungspostenmodell
  - `XBillr::Model::DB::TimeEntry` - Zeiteintragsmodell
  - `XBillr::Model::DB::HourlyRate` - Stundensatzmodell
  - `XBillr::Model::DB::Supplier` - Lieferantenmodell
  - `XBillr::Model::DB::ActivityLog` - Aktivitätsprotokollmodell

### Datenbank (MariaDB)

**Schema-Struktur:**

```
customers (1) ──< (N) hourly_rates
customers (1) ──< (N) time_entries
customers (1) ──< (N) invoices
invoices (1) ──< (N) invoice_items
time_entries (N) ──> (1) hourly_rates
```

**Tabellen:**
- `customers` - Kundenstammdaten
- `suppliers` - Lieferantenstammdaten
- `hourly_rates` - Stundensätze pro Kunde
- `time_entries` - Zeiteinträge
- `invoices` - Rechnungen
- `invoice_items` - Rechnungsposten
- `activity_logs` - Aktivitätsprotokolle

## API-Endpunkte

### Customers
- `GET /api/customers` - Alle Kunden
- `POST /api/customers` - Neuen Kunden erstellen
- `GET /api/customers/:id` - Kunde abrufen
- `PUT /api/customers/:id` - Kunde aktualisieren
- `DELETE /api/customers/:id` - Kunde löschen

### Invoices
- `GET /api/invoices` - Alle Rechnungen
- `GET /api/invoices/archived` - Archivierte Rechnungen
- `POST /api/invoices` - Neue Rechnung erstellen
- `GET /api/invoices/:id` - Rechnung abrufen
- `PUT /api/invoices/:id` - Rechnung aktualisieren
- `DELETE /api/invoices/:id` - Rechnung löschen
- `POST /api/invoices/:id/archive` - Rechnung archivieren
- `POST /api/invoices/:id/unarchive` - Rechnung dearchivieren
- `POST /api/invoices/archived/:id/duplicate` - Rechnung duplizieren

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

## Datenfluss

### Rechnungserstellung

```
1. Frontend sendet POST /api/invoices
   ↓
2. Invoices Controller empfängt Request
   ↓
3. InvoiceService.create_invoice() wird aufgerufen
   ↓
4. Service holt TimeEntries für Zeitraum
   ↓
5. Service gruppiert nach HourlyRates
   ↓
6. Service berechnet Beträge (Subtotal, Tax, Total)
   ↓
7. Service erstellt Invoice via DBIx::Class
   ↓
8. Service erstellt InvoiceItems via DBIx::Class
   ↓
9. Controller gibt Invoice als JSON zurück
   ↓
10. Frontend zeigt neue Rechnung an
```

### Zeiterfassung

```
1. Frontend sendet POST /api/time-entries
   ↓
2. TimeEntries Controller empfängt Request
   ↓
3. Controller berechnet Kalenderwoche aus Datum
   ↓
4. Controller erstellt TimeEntry via DBIx::Class
   ↓
5. Controller gibt TimeEntry als JSON zurück
   ↓
6. Frontend aktualisiert Zeiterfassungsliste
```

## Sicherheit

- CORS konfiguriert für Cross-Origin Requests
- SQL-Injection-Schutz durch DBIx::Class Prepared Statements
- Input-Validierung auf Controller-Ebene
- Fehlerbehandlung mit try-catch-Blöcken

## Deployment

### Backend
- Port: 3002 (konfigurierbar)
- Prozess-Manager: Mojolicious daemon
- Datenbank: MariaDB auf Port 3307

### Frontend
- Port: 3000 (Development)
- Build: npm run build
- Static Hosting: nginx/apache

## Erweiterungen

### Geplante Features
- PDF-Generierung für Rechnungen
- XRechnung XML-Generierung
- Stundenzettel-PDF-Generierung
- E-Mail-Versand von Rechnungen
- Export-Funktionen (CSV, Excel)

## Technologie-Stack Übersicht

| Komponente | Technologie | Version |
|------------|-------------|---------|
| Frontend | React | 18+ |
| Frontend | TypeScript | 4.9+ |
| Frontend | Material-UI | 5+ |
| Backend | Perl | 5.30+ |
| Backend | Mojolicious | 9.0+ |
| Backend | DBIx::Class | 0.082840+ |
| Datenbank | MariaDB | 10.5+ |
| API | REST/JSON | - |

## Dateistruktur

```
xbillr/
├── backend/
│   ├── app.pl                 # Hauptanwendung
│   ├── cpanfile               # Abhängigkeiten
│   ├── config/xbillr.conf            # Konfiguration
│   ├── lib/
│   │   └── XBillr/
│   │       ├── Controller/    # API-Controller
│   │       ├── Model/         # DBIx::Class Modelle
│   │       │   └── DB/
│   │       └── Service/       # Service-Komponenten
│   ├── templates/             # Templates (optional)
│   └── sql/
│       └── schema.sql         # Datenbankschema
└── frontend/
    ├── src/
    │   ├── pages/             # React-Seiten
    │   ├── components/        # React-Komponenten
    │   └── api/               # API-Client
    └── public/                # Statische Dateien
```


