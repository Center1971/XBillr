#!/bin/bash

# XBillr Datenbank-Setup-Script
# Bitte mit sudo ausführen: sudo ./setup-database.sh

echo "=== XBillr Datenbank-Setup ==="
echo ""

# Datenbank erstellen
echo "Erstelle Datenbank 'xbillr'..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS xbillr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Benutzer erstellen
echo "Erstelle Benutzer 'xbillr_user'..."
sudo mysql -e "CREATE USER IF NOT EXISTS 'xbillr_user'@'localhost' IDENTIFIED BY 'xbillr_pass';"

# Berechtigungen setzen
echo "Setze Berechtigungen..."
sudo mysql -e "GRANT ALL PRIVILEGES ON xbillr.* TO 'xbillr_user'@'localhost'; FLUSH PRIVILEGES;"

# Schema importieren
echo "Importiere Schema..."
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$PROJECT_ROOT/backend"
sudo mysql xbillr < sql/schema.sql

echo ""
echo "✅ Datenbank-Setup abgeschlossen!"
echo ""
echo "Teste Verbindung..."
mysql -u xbillr_user -pxbillr_pass xbillr -e "SHOW TABLES;" 2>&1 | head -10
