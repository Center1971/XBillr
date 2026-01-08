# Docker Setup für XBillr

## Voraussetzungen

- Docker Engine 20.10+
- Docker Compose 2.0+
- Mindestens 2GB freier RAM
- Mindestens 1GB freier Speicherplatz

## Schnellstart

### 1. Umgebungsvariablen konfigurieren

```bash
cp .env.example .env
# Bearbeiten Sie .env nach Bedarf
```

### 2. Container starten

```bash
docker-compose up -d
```

### 3. Status prüfen

```bash
docker-compose ps
```

### 4. Logs anzeigen

```bash
# Alle Logs
docker-compose logs -f

# Nur Backend-Logs
docker-compose logs -f backend

# Nur Datenbank-Logs
docker-compose logs -f mariadb
```

## Verfügbare Services

### Backend
- **URL**: http://localhost:3002
- **Health Check**: http://localhost:3002/api/health
- **Port**: 3002 (konfigurierbar über `BACKEND_PORT`)

### MariaDB
- **Port**: 3307 (konfigurierbar über `DB_PORT`)
- **Datenbank**: xbillr
- **User**: xbillr_user (konfigurierbar)
- **Password**: xbillr_pass (konfigurierbar)

## Befehle

### Container starten
```bash
docker-compose up -d
```

### Container stoppen
```bash
docker-compose stop
```

### Container entfernen (Daten bleiben erhalten)
```bash
docker-compose down
```

### Container entfernen inkl. Volumes (ACHTUNG: Löscht Daten!)
```bash
docker-compose down -v
```

### Container neu bauen
```bash
docker-compose build --no-cache
```

### In Backend-Container einsteigen
```bash
docker-compose exec backend bash
```

### Datenbank-Backup erstellen
```bash
docker-compose exec mariadb mysqldump -u xbillr_user -pxbillr_pass xbillr > backup.sql
```

### Datenbank-Backup wiederherstellen
```bash
docker-compose exec -T mariadb mysql -u xbillr_user -pxbillr_pass xbillr < backup.sql
```

## Umgebungsvariablen

Erstellen Sie eine `.env` Datei im Projektverzeichnis:

```bash
# Datenbank
DB_ROOT_PASSWORD=rootpass
DB_USER=xbillr_user
DB_PASSWORD=secure_password_here
DB_PORT=3307

# Backend
BACKEND_PORT=3002
ALLOWED_ORIGINS=http://localhost:3000,https://yourdomain.com
```

## Produktions-Deployment

Für Produktion verwenden Sie die zusätzliche Produktions-Konfiguration:

```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

**Wichtige Produktions-Hinweise:**

1. **Sichere Passwörter**: Ändern Sie alle Standard-Passwörter
2. **HTTPS**: Verwenden Sie einen Reverse Proxy (nginx/traefik) mit SSL
3. **Secrets**: Verwenden Sie Docker Secrets oder einen Secret-Manager
4. **Backups**: Richten Sie regelmäßige Datenbank-Backups ein
5. **Monitoring**: Überwachen Sie Container-Logs und Ressourcen
6. **Updates**: Halten Sie Images aktuell

## Troubleshooting

### Container startet nicht

```bash
# Logs prüfen
docker-compose logs backend

# Container-Status prüfen
docker-compose ps

# Container neu bauen
docker-compose build --no-cache
docker-compose up -d
```

### Datenbank-Verbindungsfehler

```bash
# Prüfen ob MariaDB läuft
docker-compose ps mariadb

# Datenbank-Logs prüfen
docker-compose logs mariadb

# Datenbank-Verbindung testen
docker-compose exec backend perl -e "use XBillr::Model::DB; my \$s = XBillr::Model::DB->connect('dbi:MariaDB:database=xbillr;host=mariadb', 'xbillr_user', 'xbillr_pass'); print 'OK\n';"
```

### Port bereits belegt

Ändern Sie die Ports in der `.env` Datei:
```bash
BACKEND_PORT=3002
DB_PORT=3308
```

### Datenbank zurücksetzen

```bash
# Container stoppen
docker-compose down

# Volume entfernen
docker volume rm xbillr_mariadb_data

# Neu starten
docker-compose up -d
```

## Volumes

- `mariadb_data`: Persistente Datenbank-Daten
- `./backend/log`: Backend-Logs (bind mount)

## Netzwerk

Alle Container sind im `xbillr-network` Netzwerk und können sich über Service-Namen erreichen:
- Backend erreicht Datenbank über `mariadb:3306`
- Externe Zugriffe über konfigurierte Ports

## Health Checks

Beide Services haben Health Checks:
- **MariaDB**: Prüft Datenbank-Verbindung
- **Backend**: Prüft `/api/health` Endpoint

Status prüfen:
```bash
docker-compose ps
```

## Performance-Tuning

### MariaDB Optimierung

Für bessere Performance können Sie MariaDB-Parameter in `docker-compose.yml` anpassen:

```yaml
mariadb:
  command:
    - --max-connections=200
    - --innodb-buffer-pool-size=512M
    - --query-cache-size=128M
```

### Backend Ressourcen

Limits in `docker-compose.yml` setzen:

```yaml
backend:
  deploy:
    resources:
      limits:
        cpus: '1'
        memory: 512M
      reservations:
        cpus: '0.5'
        memory: 256M
```

## Sicherheit

- **Passwörter**: Verwenden Sie starke Passwörter in `.env`
- **Netzwerk**: In Produktion keine Ports nach außen öffnen
- **Updates**: Regelmäßig Images aktualisieren
- **Secrets**: Verwenden Sie Docker Secrets für sensible Daten

