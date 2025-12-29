# Benutzerverwaltung für XBillr

## Übersicht

Die Benutzerverwaltung ermöglicht es Administratoren, Benutzer zu erstellen, zu verwalten und ihnen Rollen und Rechte zuzuweisen.

## Features

- **Benutzerverwaltung**: Erstellen, Bearbeiten und Löschen von Benutzern
- **Rollenverwaltung**: Erstellen und Verwalten von Rollen mit spezifischen Rechten
- **Rechteverwaltung**: Granulare Kontrolle über Benutzeraktionen
- **E-Mail-Versand**: Automatischer Versand von Login-Daten per E-Mail
- **Session-Management**: Sichere Authentifizierung mit Session-Tokens

## Installation

### 1. Datenbankschema erstellen

```bash
mysql -u xbillr_user -p xbillr < sql/user_management.sql
```

### 2. Admin-Benutzer erstellen

```bash
cd backend
perl scripts/create_admin.pl [passwort]
```

Standard-Passwort: `admin123`

**WICHTIG**: Ändern Sie das Passwort nach dem ersten Login!

### 3. E-Mail-Konfiguration (optional)

Setzen Sie die folgenden Umgebungsvariablen für den E-Mail-Versand:

```bash
export SMTP_HOST=smtp.example.com
export SMTP_PORT=587
export SMTP_USER=your-email@example.com
export SMTP_PASSWORD=your-password
export SMTP_FROM=noreply@xbillr.local
export SMTP_FROM_NAME="XBillr"
export APP_URL=http://localhost:3000
```

## Standard-Rollen

### Admin
- Hat alle Rechte
- Kann Benutzer und Rollen verwalten
- Kann alle Ressourcen erstellen, bearbeiten und löschen

### User
- Kann Kunden erstellen und anzeigen
- Kann Rechnungen erstellen und anzeigen
- Kann Zeiteinträge erstellen und anzeigen
- Kann Stundensätze anzeigen

### Viewer
- Nur Lese-Zugriff auf alle Ressourcen
- Kann keine Daten ändern

## API-Endpunkte

### Authentifizierung

- `POST /api/auth/login` - Anmeldung
- `POST /api/auth/logout` - Abmeldung
- `GET /api/auth/me` - Aktueller Benutzer

### Benutzerverwaltung

- `GET /api/users` - Liste aller Benutzer (erfordert `users.view`)
- `POST /api/users` - Neuen Benutzer erstellen (erfordert `users.create`)
- `PUT /api/users/:id` - Benutzer aktualisieren (erfordert `users.update`)
- `DELETE /api/users/:id` - Benutzer löschen (erfordert `users.delete`)
- `POST /api/users/:id/send-credentials` - Login-Daten per E-Mail senden (erfordert `users.create`)

### Rollenverwaltung

- `GET /api/roles` - Liste aller Rollen (erfordert `roles.view`)
- `POST /api/roles` - Neue Rolle erstellen (erfordert `roles.create`)
- `PUT /api/roles/:id` - Rolle aktualisieren (erfordert `roles.update`)
- `DELETE /api/roles/:id` - Rolle löschen (erfordert `roles.delete`)

### Rechte

- `GET /api/permissions` - Liste aller Rechte (erfordert `roles.view`)

## Verwendung

### 1. Anmeldung

Öffnen Sie `http://localhost:3000/login.html` und melden Sie sich mit den Admin-Credentials an.

### 2. Benutzer erstellen

1. Navigieren Sie zu "Benutzerverwaltung"
2. Klicken Sie auf "Neuer Benutzer"
3. Geben Sie Benutzername, E-Mail und Passwort ein
4. Wählen Sie Rollen aus
5. Aktivieren Sie "E-Mail senden", um Login-Daten automatisch zu versenden

### 3. Rollen verwalten

1. Navigieren Sie zu "Rollenverwaltung"
2. Erstellen Sie eine neue Rolle oder bearbeiten Sie eine bestehende
3. Weisen Sie Rechte zu
4. Speichern Sie die Rolle

### 4. Rechte zuweisen

Rechte werden über Rollen verwaltet:
- Erstellen Sie eine Rolle
- Wählen Sie die gewünschten Rechte aus
- Weisen Sie die Rolle Benutzern zu

## Sicherheit

- Passwörter werden mit PBKDF2 gehasht
- Session-Tokens sind zeitlich begrenzt (24 Stunden)
- Rate Limiting verhindert Brute-Force-Angriffe
- Fehlgeschlagene Login-Versuche werden gezählt (Sperre nach 5 Versuchen)
- System-Rollen können nicht gelöscht werden

## Troubleshooting

### E-Mail-Versand funktioniert nicht

1. Überprüfen Sie die SMTP-Konfiguration
2. Prüfen Sie die Logs: `tail -f backend/log/development.log`
3. Verwenden Sie die Passwort-Anzeige im Admin-Interface als Fallback

### Benutzer kann sich nicht anmelden

1. Prüfen Sie, ob der Benutzer aktiv ist
2. Prüfen Sie, ob der Benutzer gesperrt ist (zu viele fehlgeschlagene Versuche)
3. Setzen Sie das Passwort zurück über "Login-Daten senden"

### Berechtigungen funktionieren nicht

1. Prüfen Sie, ob der Benutzer die richtige Rolle hat
2. Prüfen Sie, ob die Rolle die benötigten Rechte hat
3. Prüfen Sie die Logs für detaillierte Fehlermeldungen

