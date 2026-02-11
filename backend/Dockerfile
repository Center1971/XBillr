FROM perl:5.36-slim

# Metadaten
LABEL maintainer="XBillr Team"
LABEL description="XBillr Backend - Perl/Mojolicious API"
LABEL version="0.2"

# Arbeitsverzeichnis setzen
WORKDIR /app

# Unterdrücke tar-Warnungen für unbekannte Header (z. B. macOS xattr)
ENV TAR_OPTIONS="--warning=no-unknown-keyword"

# System-Abhängigkeiten installieren
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libmariadb-dev \
    libssl-dev \
    cpanminus \
    && rm -rf /var/lib/apt/lists/*

# CPAN-Dependencies installieren
COPY cpanfile ./
# Installiere zuerst Mojolicious (enthält bereits Test::Mojo)
# Erstelle temporäre cpanfile ohne Test-Abhängigkeiten für Produktions-Build
RUN cpanm --notest Mojolicious && \
    cpanm --notest CryptX Crypt::PK::RSA Crypt::JWT && \
    sed '/^on '\''test'\'' => sub {/,/^};$/d' cpanfile > cpanfile.prod && \
    cpanm --installdeps --notest --cpanfile cpanfile.prod . && \
    rm -rf /root/.cpanm /tmp/* cpanfile.prod

# Anwendungsdateien kopieren
COPY . .

# Verzeichnisse für Logs erstellen
RUN mkdir -p /app/log /app/logs

# Entrypoint-Script kopieren und ausführbar machen
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Port freigeben
EXPOSE 3002

# Health Check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:3002/api/health || exit 1

# Entrypoint setzen
ENTRYPOINT ["docker-entrypoint.sh"]

# Startbefehl
CMD ["perl", "app.pl", "daemon", "-l", "http://*:3002"]

