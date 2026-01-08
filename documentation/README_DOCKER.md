# XBillr Docker Quick Start

## Schnellstart

```bash
# 1. Umgebungsvariablen einrichten
cp .env.example .env

# 2. Container starten
./bin/docker-start.sh

# Oder manuell:
docker-compose up -d
```

## Zugriff

- **Backend API**: http://localhost:3002
- **Health Check**: http://localhost:3002/api/health
- **Datenbank**: localhost:3397

## Wichtige Befehle

```bash
# Logs anzeigen
docker-compose logs -f

# Container stoppen
docker-compose stop

# Container entfernen
docker-compose down

# Container neu bauen
docker-compose build --no-cache
```

Siehe `documentation/DOCKER.md` für detaillierte Dokumentation.

