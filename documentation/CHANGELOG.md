# Changelog

Alle wichtigen Änderungen an XBillr werden in dieser Datei dokumentiert.

## [0.6] - 2026-01-27

### Hinzugefügt
- **Custom Keycloak Theme (SME Tools)**
  - Vollständiges Theme mit SME Tools Branding (Logo, Farben, Layout)
  - Gradient-Hintergrund (lila: #667eea → #764ba2) passend zur Corporate Identity
  - Unterstützte Seiten: Login, Registrierung, Passwort-Reset, E-Mail-Verifizierung, Fehlerseiten
  - Mehrsprachigkeit: Deutsch und Englisch (200+ übersetzte Strings)
  - Company-Feld in Registrierungsformular integriert
  - Theme-Struktur in `frontend/keycloak/themes/smetools/`
- **Keycloak Company Provisioner Extension**
  - Custom Event Listener SPI für automatische Company-Group-Verwaltung
  - Automatische Gruppenerstellung basierend auf Company-Feld bei Registrierung
  - Automatische Zuweisung von Benutzern zu Company-Gruppen
  - Client-Rollen-Assignment für `xbillr-web` und `xbillr-mobile`
  - Maven-Projekt in `frontend/keycloak/providers/`
  - JAR-Deployment via Docker Volume Mount
- **Keycloak Docker Integration**
  - Keycloak und PostgreSQL Services in docker-compose.yml
  - Volume-Mounts für Themes (`./themes`) und Providers (`./providers`)
  - Health Checks und automatische Abhängigkeiten
  - Konfiguration via Umgebungsvariablen (.env)
- **Dokumentation**
  - Theme-Installationsanleitung (README.md, THEME_SUMMARY.md)
  - Automatisches Installationsskript (`install-theme.sh`)
  - Preview-HTML für Theme-Testing ohne Keycloak-Installation
  - Comprehensive Provider-Entwicklungsanleitung
  - Troubleshooting-Guide für Provider-Installation
  - Apache Reverse-Proxy Konfiguration für Production

### Geändert
- **Theme-Optimierungen**
  - Social Provider Sektion wird nur bei konfigurierten Providern angezeigt
  - Null-safe Freemarker Templates mit Default-Werten
  - Responsive Design für Mobile und Desktop
  - Konsistente Button- und Input-Styles
- **Registrierung**
  - Company-Feld als erstes Feld im Registrierungsformular
  - Speicherung als User-Attribut (`user.attributes.company`)
  - Validierung und Fehlerbehandlung
- **Docker-Konfiguration**
  - Read-only Volume Mounts für Sicherheit
  - Separate PostgreSQL-Instanz für Keycloak
  - Keycloak Network für Service-Isolation
  - Environment-Variable-Konfiguration

### Behoben
- **Keycloak Theme Fehler**
  - Freemarker `locale` Variable null-safe (wrap in parentheses für Default-Wert)
  - Leere "Or sign in with:" Sektion bei fehlenden Social Providers entfernt
  - Template-Rendering-Fehler durch fehlende Variablen behoben
  - Service Provider Interface (SPI) Registrierung korrigiert
- **Provider-Deployment**
  - JAR-Datei-Pfad in Docker-Volume korrekt konfiguriert
  - META-INF/services Datei für Event Listener korrekt platziert
  - Maven Build-Prozess für Resources optimiert
  - Cache-Clearing nach Provider-Updates

### Sicherheit
- ✅ Read-only Volume Mounts für Themes und Providers
- ✅ Sichere Company-Group-Verwaltung mit Keycloak
- ✅ Kein direkter Dateisystem-Zugriff im Container
- ✅ HTTPS-ready mit Apache Reverse Proxy Konfiguration
- ✅ Environment-basierte Secrets (keine Hardcoded Passwords)

### Technische Details
- **Theme-Struktur**: Freemarker Templates (.ftl), CSS, Images, Message Bundles
- **Provider-Technologie**: Java 17, Keycloak SPI 26.5.1, Maven 3.x
- **Theme-Vererbung**: Parent Theme `keycloak`, Import `common/keycloak`
- **Event Listener ID**: `company-provisioner`
- **Unterstützte Keycloak-Versionen**: 26.x (tested with 26.5.1)

### Migrationshinweise
- Für bestehende Installationen:
  1. Theme-Dateien nach `keycloak/themes/smetools/` kopieren
  2. Provider-JAR nach `keycloak/providers/` kopieren
  3. Docker-Compose aktualisieren mit Keycloak-Services
  4. Keycloak-Container neustarten
  5. In Realm Settings → Themes → Login theme: `smetools` auswählen
  6. In Realm Settings → Events → Event Listeners: `company-provisioner` hinzufügen

### Bekannte Einschränkungen
- Provider benötigt Keycloak-Neustart nach Updates
- Company-Groups werden nur bei Neuregistrierung erstellt
- Client-Rollen werden automatisch mit Präfix `group-` erstellt
- Theme-Änderungen erfordern Cache-Clearing (`rm -rf /opt/keycloak/data/cache/`)

## [0.5] - 2026-01-23

### Hinzugefügt
- **OAuth2/OIDC Authorization Code Flow**: Implementierung des Best-Practice BFF-Patterns
  - Login redirects to Keycloak (keine Credentials mehr in XBillr)
  - Session-basierte Authentifizierung mit HTTP-only Cookies
  - JWT-Validierung (Signature, iss, aud, exp, roles)
  - Support für client_secret und private_key_jwt Authentifizierung
  - Tenant-Isolation via `groups` Claim
- **Session Management**: Secure Cookie-basierte Sessions (SameSite=Lax, HTTP-only)
- **Auto-Provisioning**: Optionale automatische User-Erstellung aus IAM (deaktiviert per default)
- **Frontend OAuth**: Login-Button für Keycloak-Redirect statt Passwort-Form
- **Documentation**: OAUTH2_IMPLEMENTATION.md mit vollständiger Flow-Dokumentation
- **Config Endpoint**: `/api/config` liefert Frontend-Konfiguration (API Base URL, App-Name, Version)
  - Konfigurierbare `api_base_url` in `config/xbillr.conf` (Sektion `frontend`)
  - Dynamisches Laden der Config in allen Frontend-Dateien
  - Unterstützt relative Pfade (`/api`) und absolute URLs für verschiedene Umgebungen

### Geändert
- **Authentifizierung**: Vollständiger Wechsel von Password Grant zu Authorization Code Flow
  - `/api/auth/login` ist jetzt GET und redirected zu Keycloak
  - `/api/auth/oidc/callback` handhabt Code-Exchange und Token-Validierung
  - Frontend verwendet `credentials: 'include'` statt localStorage tokens
- **Session Storage**: Tokens werden nicht mehr im Cookie gespeichert (Cookie-Overflow-Fix)
  - Nur `user_info` wird in Session gespeichert
  - Optional: `store_session_tokens` für Token-Storage
- **Routing**: Manuelle Route-Registration (OpenAPI Plugin temporär disabled)
  - Controller-Namespace explizit gesetzt
  - Auth-Routes vor OpenAPI-Plugin registriert
- **Health Controller**: Umstellung von `render(openapi => ...)` auf `render(json => ...)`
- **Middleware**: `authenticate_request` prüft Session-Auth vor Token-Auth
- **Configuration**: 
  - `frontend_url` für korrekte Redirects
  - `tls_verify` für TLS-Verifizierung (default: 1)
  - `auto_provision` disabled per default

### Entfernt
- **Password-basiertes Login**: Keine Username/Password-Form mehr im Frontend
- **localStorage Tokens**: Keine Client-seitigen Token-Speicherung mehr
- **Password Grant**: Resource Owner Password Credentials Flow entfernt
- **Obsolete Scripts**: diagnose_login.sh, fix_login_issues.sh, test_login.sh

### Sicherheit
- ✅ Keine Credentials in XBillr Frontend/Backend
- ✅ Tokens nur server-seitig (HTTP-only Cookies)
- ✅ CSRF-Protection via `state` Parameter
- ✅ JWT-Validierung (sig, iss, aud, exp, roles)
- ✅ Tenant-Isolation via Groups
- ✅ TLS-Verifizierung enabled

### Bekannte Probleme
- OpenAPI Plugin temporär disabled (Routing-Konflikt)
- Database-Verbindung in Health-Endpoint fehlerhaft
- Auto-Provisioning benötigt funktionierende DB-Verbindung

## [0.4] - 2026-01-16

### Hinzugefügt
- OpenAPI 3.1 Spezifikation in `backend/openapi.yaml`
- Scalar API-Dokumentation in `documentation/api/`
- OIDC/OAuth2 Konfiguration in `config/xbillr.conf`
- JWT-basierte Authentifizierung inkl. Rollenextraktion für Web- und Mobile-Clients
- Postman Collection in `postman/` für alle API-Endpunkte inkl. OIDC
- Mobile-Integrationsdokumentation in `documentation/mobile/`

### Geändert
- API-Routing über `Mojolicious::Plugin::OpenAPI` mit `render(openapi => ...)`
- Invoices/TimeEntries/HourlyRates/Supplier/Logs/Health Controller auf OpenAPI-Responses umgestellt
- Dokumentation aktualisiert (API, Auth, OpenAPI-first Architektur)
- Konfiguration konsolidiert in `config/xbillr.conf`

### Entfernt
- Veraltete HTML-Dokumente in `documentation/`
- Doppelte Docker-Kurzbeschreibung

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

