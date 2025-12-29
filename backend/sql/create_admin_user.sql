-- Erstelle Admin-Benutzer für XBillr
-- Passwort: admin123 (sollte nach dem ersten Login geändert werden!)

USE xbillr;

-- Passwort-Hash für "admin123" (wird von AuthService generiert)
-- Für die Initialisierung verwenden wir einen temporären Hash
-- Das Passwort sollte nach dem ersten Login geändert werden

-- Prüfe ob Admin bereits existiert
SET @admin_exists = (SELECT COUNT(*) FROM users WHERE username = 'admin');

-- Erstelle Admin-Benutzer nur wenn noch nicht vorhanden
INSERT INTO users (
    id,
    username,
    email,
    password_hash,
    first_name,
    last_name,
    is_active,
    is_email_verified,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'admin',
    'admin@xbillr.local',
    '$pbkdf2-sha1$10000$dGVzdA==$hash_placeholder',  -- Wird beim ersten Start durch echten Hash ersetzt
    'Admin',
    'User',
    1,
    1,
    NOW(),
    NOW()
) ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Weise Admin-Rolle zu
INSERT INTO user_roles (
    id,
    user_id,
    role_id,
    assigned_at
) VALUES (
    'ur-admin-001',
    '00000000-0000-0000-0000-000000000001',
    '00000000-0000-0000-0000-000000000001',  -- admin Rolle
    NOW()
) ON DUPLICATE KEY UPDATE assigned_at = assigned_at;

