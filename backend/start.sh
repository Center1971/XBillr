#!/bin/bash

# XBillr Backend Start-Script

cd "$(dirname "$0")"

# local::lib einrichten
eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)

# Umgebungsvariablen
export DB_DSN="${DB_DSN:-dbi:MariaDB:database=xbillr;host=localhost;port=3307}"
export DB_USER="${DB_USER:-xbillr_user}"
export DB_PASSWORD="${DB_PASSWORD:-xbillr_pass}"
export ALLOWED_ORIGINS="${ALLOWED_ORIGINS:-http://localhost:3000}"
export PERL5LIB="$HOME/perl5/lib/perl5:$PWD/lib:$PERL5LIB"

# Port freigeben falls belegt
lsof -ti:3002 | xargs kill -9 2>/dev/null

# Backend starten
echo "Starte XBillr Backend..."
echo "DB_DSN: $DB_DSN"
echo "Backend URL: http://localhost:3002"
echo ""

perl app.pl daemon -l http://*:3002

