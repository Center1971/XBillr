-- XBillr Benutzerverwaltung Schema
-- Erweitert das bestehende Schema um Benutzer, Rollen und Rechte

USE xbillr;

-- Rollen Tabelle
CREATE TABLE IF NOT EXISTS roles (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_system_role BOOLEAN NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rechte Tabelle
CREATE TABLE IF NOT EXISTS permissions (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(50) NOT NULL,
    created_at DATETIME NOT NULL,
    INDEX idx_resource_action (resource, action),
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Benutzer Tabelle
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT 1,
    is_email_verified BOOLEAN NOT NULL DEFAULT 0,
    last_login DATETIME,
    failed_login_attempts INTEGER NOT NULL DEFAULT 0,
    locked_until DATETIME,
    password_reset_token VARCHAR(255),
    password_reset_expires DATETIME,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    created_by VARCHAR(36),
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_is_active (is_active),
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Benutzer-Rollen Zuordnung
CREATE TABLE IF NOT EXISTS user_roles (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    role_id VARCHAR(36) NOT NULL,
    assigned_by VARCHAR(36),
    assigned_at DATETIME NOT NULL,
    UNIQUE KEY unique_user_role (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Rollen-Rechte Zuordnung
CREATE TABLE IF NOT EXISTS role_permissions (
    id VARCHAR(36) PRIMARY KEY,
    role_id VARCHAR(36) NOT NULL,
    permission_id VARCHAR(36) NOT NULL,
    granted_by VARCHAR(36),
    granted_at DATETIME NOT NULL,
    UNIQUE KEY unique_role_permission (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    FOREIGN KEY (granted_by) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_role_id (role_id),
    INDEX idx_permission_id (permission_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sessions Tabelle für Authentifizierung
CREATE TABLE IF NOT EXISTS user_sessions (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    session_token VARCHAR(255) NOT NULL UNIQUE,
    ip_address VARCHAR(45),
    user_agent TEXT,
    expires_at DATETIME NOT NULL,
    created_at DATETIME NOT NULL,
    last_activity DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_session_token (session_token),
    INDEX idx_expires_at (expires_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Standard-Rollen einfügen
INSERT INTO roles (id, name, description, is_system_role, created_at, updated_at) VALUES
('00000000-0000-0000-0000-000000000001', 'admin', 'Administrator mit allen Rechten', 1, NOW(), NOW()),
('00000000-0000-0000-0000-000000000002', 'user', 'Standard-Benutzer mit eingeschränkten Rechten', 1, NOW(), NOW()),
('00000000-0000-0000-0000-000000000003', 'viewer', 'Nur-Lese-Zugriff', 1, NOW(), NOW())
ON DUPLICATE KEY UPDATE updated_at = NOW();

-- Standard-Rechte einfügen
INSERT INTO permissions (id, name, description, resource, action, created_at) VALUES
-- Kunden
('10000000-0000-0000-0000-000000000001', 'customers.view', 'Kunden anzeigen', 'customers', 'view', NOW()),
('10000000-0000-0000-0000-000000000002', 'customers.create', 'Kunden erstellen', 'customers', 'create', NOW()),
('10000000-0000-0000-0000-000000000003', 'customers.update', 'Kunden bearbeiten', 'customers', 'update', NOW()),
('10000000-0000-0000-0000-000000000004', 'customers.delete', 'Kunden löschen', 'customers', 'delete', NOW()),
-- Rechnungen
('20000000-0000-0000-0000-000000000001', 'invoices.view', 'Rechnungen anzeigen', 'invoices', 'view', NOW()),
('20000000-0000-0000-0000-000000000002', 'invoices.create', 'Rechnungen erstellen', 'invoices', 'create', NOW()),
('20000000-0000-0000-0000-000000000003', 'invoices.update', 'Rechnungen bearbeiten', 'invoices', 'update', NOW()),
('20000000-0000-0000-0000-000000000004', 'invoices.delete', 'Rechnungen löschen', 'invoices', 'delete', NOW()),
('20000000-0000-0000-0000-000000000005', 'invoices.archive', 'Rechnungen archivieren', 'invoices', 'archive', NOW()),
('20000000-0000-0000-0000-000000000006', 'invoices.export', 'Rechnungen exportieren (PDF/XML)', 'invoices', 'export', NOW()),
-- Zeiteinträge
('30000000-0000-0000-0000-000000000001', 'time_entries.view', 'Zeiteinträge anzeigen', 'time_entries', 'view', NOW()),
('30000000-0000-0000-0000-000000000002', 'time_entries.create', 'Zeiteinträge erstellen', 'time_entries', 'create', NOW()),
('30000000-0000-0000-0000-000000000003', 'time_entries.update', 'Zeiteinträge bearbeiten', 'time_entries', 'update', NOW()),
('30000000-0000-0000-0000-000000000004', 'time_entries.delete', 'Zeiteinträge löschen', 'time_entries', 'delete', NOW()),
-- Stundensätze
('40000000-0000-0000-0000-000000000001', 'hourly_rates.view', 'Stundensätze anzeigen', 'hourly_rates', 'view', NOW()),
('40000000-0000-0000-0000-000000000002', 'hourly_rates.create', 'Stundensätze erstellen', 'hourly_rates', 'create', NOW()),
('40000000-0000-0000-0000-000000000003', 'hourly_rates.update', 'Stundensätze bearbeiten', 'hourly_rates', 'update', NOW()),
('40000000-0000-0000-0000-000000000004', 'hourly_rates.delete', 'Stundensätze löschen', 'hourly_rates', 'delete', NOW()),
-- Benutzerverwaltung
('50000000-0000-0000-0000-000000000001', 'users.view', 'Benutzer anzeigen', 'users', 'view', NOW()),
('50000000-0000-0000-0000-000000000002', 'users.create', 'Benutzer erstellen', 'users', 'create', NOW()),
('50000000-0000-0000-0000-000000000003', 'users.update', 'Benutzer bearbeiten', 'users', 'update', NOW()),
('50000000-0000-0000-0000-000000000004', 'users.delete', 'Benutzer löschen', 'users', 'delete', NOW()),
('50000000-0000-0000-0000-000000000005', 'users.manage_roles', 'Rollen zuweisen', 'users', 'manage_roles', NOW()),
-- Rollenverwaltung
('60000000-0000-0000-0000-000000000001', 'roles.view', 'Rollen anzeigen', 'roles', 'view', NOW()),
('60000000-0000-0000-0000-000000000002', 'roles.create', 'Rollen erstellen', 'roles', 'create', NOW()),
('60000000-0000-0000-0000-000000000003', 'roles.update', 'Rollen bearbeiten', 'roles', 'update', NOW()),
('60000000-0000-0000-0000-000000000004', 'roles.delete', 'Rollen löschen', 'roles', 'delete', NOW()),
('60000000-0000-0000-0000-000000000005', 'roles.manage_permissions', 'Rechte zuweisen', 'roles', 'manage_permissions', NOW()),
-- Rechnungssteller
('70000000-0000-0000-0000-000000000001', 'supplier.view', 'Rechnungssteller anzeigen', 'supplier', 'view', NOW()),
('70000000-0000-0000-0000-000000000002', 'supplier.update', 'Rechnungssteller bearbeiten', 'supplier', 'update', NOW()),
-- Stundenzettel
('80000000-0000-0000-0000-000000000001', 'timesheets.view', 'Stundenzettel anzeigen', 'timesheets', 'view', NOW()),
('80000000-0000-0000-0000-000000000002', 'timesheets.create', 'Stundenzettel erstellen', 'timesheets', 'create', NOW()),
('80000000-0000-0000-0000-000000000003', 'timesheets.delete', 'Stundenzettel löschen', 'timesheets', 'delete', NOW()),
-- Logs
('90000000-0000-0000-0000-000000000001', 'logs.view', 'Logs anzeigen', 'logs', 'view', NOW())
ON DUPLICATE KEY UPDATE name = name;

-- Admin-Rolle erhält alle Rechte
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    CONCAT('rp-', LPAD(ROW_NUMBER() OVER (ORDER BY p.id), 10, '0')),
    '00000000-0000-0000-0000-000000000001',
    p.id,
    NOW()
FROM permissions p
ON DUPLICATE KEY UPDATE granted_at = granted_at;

-- Standard-Benutzer-Rolle erhält Basis-Rechte
INSERT INTO role_permissions (id, role_id, permission_id, granted_at) VALUES
('rp-user-001', '00000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000001', NOW()), -- customers.view
('rp-user-002', '00000000-0000-0000-0000-000000000002', '10000000-0000-0000-0000-000000000002', NOW()), -- customers.create
('rp-user-003', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000001', NOW()), -- invoices.view
('rp-user-004', '00000000-0000-0000-0000-000000000002', '20000000-0000-0000-0000-000000000002', NOW()), -- invoices.create
('rp-user-005', '00000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', NOW()), -- time_entries.view
('rp-user-006', '00000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000002', NOW()), -- time_entries.create
('rp-user-007', '00000000-0000-0000-0000-000000000002', '40000000-0000-0000-0000-000000000001', NOW()), -- hourly_rates.view
('rp-user-008', '00000000-0000-0000-0000-000000000002', '70000000-0000-0000-0000-000000000001', NOW()), -- supplier.view
('rp-user-009', '00000000-0000-0000-0000-000000000002', '80000000-0000-0000-0000-000000000001', NOW())  -- timesheets.view
ON DUPLICATE KEY UPDATE granted_at = granted_at;

-- Viewer-Rolle erhält nur Lese-Rechte
INSERT INTO role_permissions (id, role_id, permission_id, granted_at)
SELECT 
    CONCAT('rp-viewer-', LPAD(ROW_NUMBER() OVER (ORDER BY p.id), 10, '0')),
    '00000000-0000-0000-0000-000000000003',
    p.id,
    NOW()
FROM permissions p
WHERE p.action = 'view'
ON DUPLICATE KEY UPDATE granted_at = granted_at;

