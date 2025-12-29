# XBillr Start-Anleitung

## Option 1: Mit Docker (Empfohlen)

### Voraussetzungen
- Docker und Docker Compose installiert
- Port 3001 und 3307 frei

### Starten

```bash
cd /home/thomas/xbillr

# 1. Umgebungsvariablen einrichten
cp .env.example .env

# 2. Container starten
docker-compose up -d

# 3. Logs prüfen
docker-compose logs -f backend

# 4. Im Browser öffnen
# http://localhost:3001/api/health
```

### Probleme beheben

**Port bereits belegt:**
```bash
# Port in .env ändern
BACKEND_PORT=3002
DB_PORT=3308
```

**Docker Build fehlgeschlagen:**
```bash
# Dependencies manuell installieren
docker-compose exec backend bash
cpanm --installdeps .
```

## Option 2: Lokale Installation

### Voraussetzungen
- Perl 5.30+
- MariaDB Server
- cpanminus

### Installation

```bash
cd /home/thomas/xbillr/backend

# 1. CPAN-Dependencies installieren
cpanm --installdeps .

# 2. Datenbank einrichten
mysql -u root -p < sql/schema.sql

# 3. Umgebungsvariablen setzen
export DB_DSN="dbi:MariaDB:database=xbillr;host=localhost;port=3307"
export DB_USER="xbillr_user"
export DB_PASSWORD="xbillr_pass"

# 4. Backend starten
perl app.pl daemon
```

## API Test-Seite

Eine Test-Seite ist verfügbar unter:
- `test-api.html` - Öffnen Sie diese Datei im Browser

## Verfügbare URLs

- **Backend API**: http://localhost:3001
- **Health Check**: http://localhost:3001/api/health
- **API Dokumentation**: Siehe backend/README.md

## Hilfe

Bei Problemen:
1. Prüfen Sie die Logs: `docker-compose logs -f`
2. Prüfen Sie die Container: `docker-compose ps`
3. Prüfen Sie die Ports: `netstat -tulpn | grep -E '3001|3307'`

