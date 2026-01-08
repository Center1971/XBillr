# Changelog

Alle wichtigen Änderungen an XBillr werden in dieser Datei dokumentiert.

## [0.2] - 2025-12-19

### Hinzugefügt
- Docker-Container-Support mit docker-compose
- Umfassendes Security-Hardening
  - Input-Validierung und Sanitization
  - Rate Limiting
  - Sicherheits-Header
  - Verbesserte Fehlerbehandlung
  - Sicherheits-Logging
- DBIx::Class ORM für Datenbankzugriffe
- Mojolicious Web-Framework
- Separate Service-Komponenten
- Umfassende API-Dokumentation

### Geändert
- Backend von Java/Spring Boot zu Perl/Mojolicious migriert
- Datenbank von SQLite zu MariaDB migriert
- Projektname von XRechnung zu XBillr geändert

### Sicherheit
- SQL-Injection-Schutz durch DBIx::Class
- XSS-Schutz durch Content-Security-Policy
- CSRF-Schutz durch Origin-Validierung
- Rate Limiting implementiert
- Sicherheits-Header hinzugefügt
- Fehlerbehandlung ohne Informationsleckage

## [0.1] - Initial Release

### Hinzugefügt
- Grundlegende Rechnungsfunktionalität
- Kundenverwaltung
- Zeiterfassung
- Rechnungsgenerierung
- XRechnung XML-Export

