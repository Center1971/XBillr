# Changelog

Alle wichtigen Änderungen an XBillr werden in dieser Datei dokumentiert.

## [0.3] - 2026-01-07

### Hinzugefügt
- **Management-Script `bin/xbillr`**: Zentrale Verwaltung für Backend und Frontend
  - Unterstützung für Production und Development Umgebungen
  - Start, Stop, Restart und Status-Befehle
  - Automatische PID-Datei-Verwaltung (`.backend.pid`, `.frontend.pid`)
  - Graceful Shutdown mit automatischer Prozess-Erkennung
  - Konfigurierbar über Umgebungsvariablen (XBILLR_*)
- **Hilfsskripte in `bin/`**:
  - `setup_complete.sh` - Vollständige Datenbank-Initialisierung
  - `init_database.sh` - Datenbank-Schema-Initialisierung
  - `create_admin.sh` - Admin-Benutzer erstellen
  - `diagnose_login.sh` - Login-Probleme diagnostizieren
  - `test_login.sh` - Login-Funktionalität testen
  - `fix_login_issues.sh` - Häufige Login-Probleme beheben
  - `serve_frontend.sh` - Frontend via HTTP-Server bereitstellen (mit automatischer Port-Suche)
  - `serve_frontend_simple.sh` - Alternative Frontend-Server-Implementierung
- **Projekt-Reorganisation**:
  - Frontend-Dateien nach `frontend/` verschoben
  - Runtime-Skripte nach `bin/` verschoben
  - Dokumentation nach `documentation/` verschoben
- **Dokumentation**:
  - `QUICKSTART.md` - Schnellstart-Anleitung
  - `TROUBLESHOOTING.md` - Fehlerbehebungs-Guide
  - Erweiterte Fehlermeldungen im Login-Formular

### Geändert
- **Port-Konfiguration**: Standard-Port von 3001 auf 3002 geändert
  - Backend läuft jetzt standardmäßig auf Port 3002
  - Alle Konfigurationsdateien, Dokumentation und HTML-Dateien aktualisiert
- **Datenbankverbindung**: 
  - `DB_DSN` in docker-compose.yml verwendet jetzt `mariadb` als Hostname (Docker Service Name)
  - Korrekte interne Docker-Netzwerk-Konfiguration
- **CORS-Konfiguration**:
  - Verbesserte CORS-Behandlung für verschiedene Origins
  - Unterstützung für `file://` Requests (mit Warnung)
  - Automatische Origin-Erkennung und -Validierung
  - Behebung des Konflikts zwischen `Access-Control-Allow-Credentials` und Wildcard-Origin
- **Backend-Konfiguration**:
  - `backend/app.pl`: Verbesserte CORS-Middleware
  - `backend/scripts/create_admin.pl`: Aktualisierte Standard-Credentials für Docker
  - `docker-compose.yml`: Erweiterte ALLOWED_ORIGINS mit mehreren Ports
- **Frontend**:
  - Verbesserte Fehlerbehandlung im Login-Formular
  - Detailliertere Fehlermeldungen für Verbindungsprobleme
  - Automatische Port-Suche für HTTP-Server

### Behoben
- **Login-Probleme**:
  - "Verbindungsfehler" bei Login behoben
  - CORS-Fehler bei direkter Datei-Öffnung (file://) mit klarer Fehlermeldung
  - Datenbankverbindungsfehler durch korrekte Docker Service-Namen
- **Datenbank-Initialisierung**:
  - Automatische Schema-Initialisierung wenn Tabellen fehlen
  - Admin-Benutzer-Erstellung mit korrekten Credentials
  - Behebung von DBIx::Class Warnungen (harmlos, aber unterdrückt)
- **Port-Konflikte**:
  - Automatische Erkennung und Behebung von Port-Konflikten
  - Graceful Shutdown bestehender Prozesse vor Neustart
- **PID-Datei-Management**:
  - Automatische Bereinigung von verwaisten PID-Dateien
  - Graceful Shutdown mit SIGTERM, Fallback auf SIGKILL
  - Metadaten in PID-Dateien (System-Modus, Port, Startzeit)

### Verbessert
- **Prozess-Management**:
  - Automatische Erkennung laufender Prozesse vor Start
  - Graceful Shutdown mit 5 Sekunden Wartezeit
  - Automatische Bereinigung bei Prozess-Ende
- **Konfiguration**:
  - Umgebungsvariablen mit XBILLR_*-Präfix für bessere Isolation
  - Konfigurierbare Ports für alle Services
  - Zentrale Konfiguration im `bin/xbillr` Script
- **Dokumentation**:
  - Umfassende Troubleshooting-Anleitung
  - Quick-Start-Guide für neue Benutzer
  - Klarere Fehlermeldungen und Diagnose-Tools

### Technische Details
- PID-Dateien enthalten Metadaten (System-Modus, Port, Startzeit)
- Frontend-Server sucht automatisch nach verfügbaren Ports (8080, 8081, 8082, 3000, 8000, 8888)
- Backend verwendet Docker Service Discovery für Datenbankverbindung
- Alle Skripte sind idempotent (können mehrfach ausgeführt werden)

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

