# XBillr Server Setup Anleitung

Diese Anleitung beschreibt, wie Sie XBillr auf einem Server installieren und starten.

## Voraussetzungen

- Linux-Server (Ubuntu/Debian empfohlen)
- Perl 5.36 oder höher
- MariaDB/MySQL Datenbank
- cpanminus (cpanm)
- Optional: Docker und Docker Compose

## Option 1: Docker-Deployment (Empfohlen)

### 1. Docker und Docker Compose installieren

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo systemctl enable docker
```

### 2. Projekt entpacken

```bash
unzip xbillr-server-*.zip
cd xbillr
```

### 3. Umgebungsvariablen konfigurieren

```bash
cp .env.example .env
nano .env  # Bearbeiten Sie die Datenbankverbindung
```

### 4. Mit Docker starten

```bash
chmod +x bin/docker-start.sh
./bin/docker-start.sh
```

Die Anwendung läuft dann auf:
- Frontend: http://localhost:8082
- Backend API: http://localhost:3002

## Option 2: Manuelle Installation

### 1. Projekt entpacken

```bash
unzip xbillr-server-*.zip
cd xbillr
```

### 2. Datenbank einrichten

```bash
# MariaDB/MySQL installieren
sudo apt-get install -y mariadb-server

# Datenbank erstellen
mysql -u root -p < backend/sql/schema.sql

# Optional: Zusätzliche Felder hinzufügen
mysql -u root -p xbillr < backend/sql/add_customer_fields.sql
```

### 3. Perl-Abhängigkeiten installieren

```bash
cd backend

# cpanminus installieren
curl -L https://cpanmin.us | perl - App::cpanminus

# Perl-Module installieren
eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)
export PERL5LIB="$HOME/perl5/lib/perl5:$PWD/lib:$PERL5LIB"
cpanm --installdeps --notest .

# Mojolicious installieren (falls Test::Mojo Fehler auftritt)
cpanm --notest Mojolicious
cpanm --notest Test::Mojo || true
cpanm --installdeps --notest .
```

### 4. Konfiguration

```bash
# Backend-Konfiguration
cp backend/xbillr.conf.example backend/xbillr.conf
nano backend/xbillr.conf  # Datenbankverbindung anpassen
```

### 5. Backend starten

```bash
cd backend
eval $(perl -I ~/perl5/lib/perl5 -Mlocal::lib)
export PERL5LIB="$HOME/perl5/lib/perl5:$PWD/lib:$PERL5LIB"

# Entwicklungsserver
morbo app.pl -l http://*:3002

# Produktionsserver (mit Hypnotoad)
hypnotoad app.pl
```

### 6. Frontend bereitstellen

```bash
# Mit einem Webserver (z.B. nginx)
sudo apt-get install -y nginx
sudo cp index.html /var/www/html/
sudo systemctl restart nginx

# Oder mit einem einfachen Python-HTTP-Server
python3 -m http.server 8082
```

## Produktions-Deployment

### Mit Nginx als Reverse Proxy

```nginx
# /etc/nginx/sites-available/xbillr
server {
    listen 80;
    server_name your-domain.com;

    # Frontend
    location / {
        root /var/www/xbillr;
        try_files $uri /index.html;
    }

    # Backend API
    location /api {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Systemd Service für Backend

```ini
# /etc/systemd/system/xbillr.service
[Unit]
Description=XBillr Backend API
After=network.target mariadb.service

[Service]
Type=simple
User=www-data
WorkingDirectory=/opt/xbillr/backend
Environment="PERL5LIB=/opt/xbillr/backend/lib:/home/www-data/perl5/lib/perl5"
ExecStart=/usr/bin/perl /opt/xbillr/backend/app.pl daemon -l http://*:3002
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl enable xbillr
sudo systemctl start xbillr
```

## Sicherheit

- Ändern Sie Standard-Passwörter
- Verwenden Sie HTTPS (Let's Encrypt)
- Konfigurieren Sie eine Firewall
- Regelmäßige Backups der Datenbank
- Siehe `backend/SECURITY.md` für weitere Details

## Troubleshooting

### Backend startet nicht

```bash
# Prüfen Sie die Logs
tail -f backend/log/development.log

# Prüfen Sie die Perl-Module
perl -c backend/app.pl

# Prüfen Sie die Datenbankverbindung
mysql -u xbillr_user -p xbillr -e "SELECT 1;"
```

### Port bereits belegt

```bash
# Prüfen Sie, welcher Prozess Port 3002 verwendet
sudo lsof -i :3002

# Beenden Sie den Prozess oder ändern Sie den Port in app.pl
```

## Support

Weitere Informationen finden Sie in:
- `README.md` - Allgemeine Informationen
- `INSTALLATION.txt` - Detaillierte Installationsanleitung
- `START.md` - Schnellstart-Anleitung
- `ARCHITECTURE.md` - Architektur-Dokumentation

