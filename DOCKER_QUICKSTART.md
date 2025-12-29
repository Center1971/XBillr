# XBillr Docker Quick Start Guide

## 🚀 Schnellstart

```bash
# 1. Umgebungsvariablen einrichten
cp .env.example .env

# 2. Container starten
./docker-start.sh

# Oder manuell:
docker-compose up -d
```

## 📍 Zugriff

- **Backend API**: http://localhost:3001
- **Health Check**: http://localhost:3001/api/health
- **Datenbank**: localhost:3307

## 🔧 Wichtige Befehle

```bash
# Logs anzeigen
docker-compose logs -f

# Container stoppen
docker-compose stop

# Container entfernen (Daten bleiben erhalten)
docker-compose down

# Container entfernen inkl. Daten (ACHTUNG!)
docker-compose down -v

# Container neu bauen
docker-compose build --no-cache
docker-compose up -d
```

## 📋 Services

- **mariadb**: MariaDB Datenbank (Port 3307)
- **backend**: Perl/Mojolicious Backend (Port 3001)

## 🔐 Konfiguration

Bearbeiten Sie `.env` für:
- Datenbank-Passwörter
- Ports
- Erlaubte CORS-Origins

## 📚 Weitere Informationen

Siehe `DOCKER.md` für detaillierte Dokumentation.
