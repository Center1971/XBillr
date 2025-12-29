# Sicherheitsrichtlinien für XBillr Backend

## Implementierte Sicherheitsmaßnahmen

### 1. Input-Validierung und Sanitization
- Alle Eingaben werden validiert bevor sie verarbeitet werden
- String-Sanitization entfernt gefährliche Zeichen
- UUID-Validierung für alle ID-Parameter
- E-Mail-Validierung
- Dezimal- und Integer-Validierung mit Min/Max-Grenzen
- Datum-Validierung
- Enum-Validierung für feste Werte

### 2. SQL-Injection-Schutz
- DBIx::Class verwendet Prepared Statements
- Keine direkten SQL-Strings in Code
- Parameter werden immer gebunden

### 3. XSS-Schutz
- Content-Security-Policy Header
- X-XSS-Protection Header
- Input-Sanitization entfernt gefährliche Zeichen
- JSON-Responses sind automatisch escaped

### 4. CSRF-Schutz
- SameSite Cookies (wenn Cookies verwendet werden)
- Origin-Validierung für CORS

### 5. Rate Limiting
- 100 Requests pro Minute pro IP-Adresse
- Verhindert Brute-Force-Angriffe
- Loggt Rate-Limit-Verstöße

### 6. Sicherheits-Header
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection: 1; mode=block
- Strict-Transport-Security (HSTS)
- Content-Security-Policy
- Referrer-Policy

### 7. CORS-Konfiguration
- Nur erlaubte Origins (nicht * für alle)
- Konfigurierbar über ALLOWED_ORIGINS Umgebungsvariable
- Credentials-Support wenn benötigt

### 8. Fehlerbehandlung
- Keine internen Fehlerdetails nach außen
- Generische Fehlermeldungen für Benutzer
- Detaillierte Logs für Administratoren
- Server-Header entfernt

### 9. Sicherheits-Logging
- Alle verdächtigen Zugriffe werden geloggt
- POST/PUT/DELETE Requests werden geloggt
- Fehler werden geloggt
- Rate-Limit-Verstöße werden geloggt

### 10. Datenbank-Sicherheit
- SSL-Verbindung zur Datenbank erzwingen
- Prepared Statements über DBIx::Class
- Keine direkten Passwörter im Code (Umgebungsvariablen)

## Konfiguration

### Umgebungsvariablen

```bash
# Datenbank
export DB_DSN="dbi:MariaDB:database=xbillr;host=localhost;port=3307"
export DB_USER="xbillr_user"
export DB_PASSWORD="secure_password"

# CORS
export ALLOWED_ORIGINS="http://localhost:3000,https://yourdomain.com"
```

### Rate Limiting anpassen

In `app.pl` können die Rate-Limit-Parameter angepasst werden:
- Standard: 100 Requests pro 60 Sekunden
- Anpassbar in der `check_rate_limit` Funktion

## Best Practices

1. **Passwörter**: Verwenden Sie starke Passwörter für Datenbankzugriff
2. **HTTPS**: Verwenden Sie HTTPS in Produktion
3. **Updates**: Halten Sie alle Dependencies aktuell
4. **Logs**: Überwachen Sie die Logs regelmäßig
5. **Backups**: Regelmäßige Datenbank-Backups
6. **Firewall**: Beschränken Sie Datenbankzugriff auf vertrauenswürdige IPs

## Bekannte Sicherheitslücken

Keine bekannten kritischen Sicherheitslücken. Bei Entdeckung von Sicherheitsproblemen bitte sofort melden.

## Penetration Testing

Regelmäßige Sicherheitsprüfungen werden empfohlen:
- OWASP Top 10 Checks
- SQL-Injection Tests
- XSS Tests
- CSRF Tests
- Rate Limiting Tests

