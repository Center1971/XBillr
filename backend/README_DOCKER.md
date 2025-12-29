# Docker Setup für XBillr Backend

## Schnellstart

```bash
# Im Projekt-Root-Verzeichnis
docker-compose up -d
```

## Dockerfile Details

Das Dockerfile basiert auf `perl:5.36-slim` und:

1. Installiert System-Abhängigkeiten (build-essential, libmariadb-dev, etc.)
2. Installiert CPAN-Dependencies aus `cpanfile`
3. Kopiert Anwendungsdateien
4. Setzt Health Check
5. Startet Mojolicious auf Port 3001

## Entrypoint

Der `docker-entrypoint.sh` wartet auf die Datenbank-Verfügbarkeit bevor der Backend-Server startet.

## Build

```bash
# Image bauen
docker build -t xbillr-backend .

# Mit Cache
docker build -t xbillr-backend --cache-from xbillr-backend .
```

## Testen

```bash
# Container lokal testen
docker run --rm -p 3001:3001 \
  -e DB_DSN="dbi:MariaDB:database=xbillr;host=host.docker.internal;port=3307" \
  -e DB_USER="xbillr_user" \
  -e DB_PASSWORD="xbillr_pass" \
  xbillr-backend
```

## Troubleshooting

### CPAN-Dependencies installieren sich nicht

```bash
# Container bauen mit mehr Ausgabe
docker build --progress=plain --no-cache -t xbillr-backend .
```

### Health Check schlägt fehl

Prüfen Sie die Logs:
```bash
docker-compose logs backend
```

### Datenbank-Verbindung

Der Entrypoint wartet automatisch auf die Datenbank. Falls Probleme auftreten:
```bash
docker-compose exec backend bash
perl -e "use XBillr::Model::DB; ..."
```

