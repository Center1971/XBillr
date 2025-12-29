#!/bin/bash

# XBillr Docker Start-Script

set -e

echo "=========================================="
echo "XBillr Docker Setup"
echo "=========================================="

# Prüfe ob Docker installiert ist
if ! command -v docker &> /dev/null; then
    echo "FEHLER: Docker ist nicht installiert!"
    echo "Installieren Sie Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Prüfe ob Docker Compose installiert ist
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "FEHLER: Docker Compose ist nicht installiert!"
    echo "Installieren Sie Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

# Prüfe ob .env existiert
if [ ! -f .env ]; then
    echo "Erstelle .env Datei aus .env.example..."
    cp .env.example .env
    echo "Bitte bearbeiten Sie .env und setzen Sie sichere Passwörter!"
    echo ""
fi

# Baue Images
echo "Baue Docker Images..."
docker-compose build

# Starte Container
echo "Starte Container..."
docker-compose up -d

# Warte auf Health Checks
echo "Warte auf Health Checks..."
sleep 10

# Prüfe Status
echo ""
echo "Container-Status:"
docker-compose ps

echo ""
echo "=========================================="
echo "XBillr ist gestartet!"
echo "=========================================="
echo ""
echo "Backend: http://localhost:3001"
echo "Health Check: http://localhost:3001/api/health"
echo ""
echo "Logs anzeigen: docker-compose logs -f"
echo "Container stoppen: docker-compose stop"
echo "Container entfernen: docker-compose down"
echo ""

