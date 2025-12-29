-- XBillr Datenbankschema für MariaDB

CREATE DATABASE IF NOT EXISTS xbillr CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE xbillr;

-- Customers
CREATE TABLE IF NOT EXISTS customers (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'DE',
    tax_id VARCHAR(50),
    vat_id VARCHAR(50),
    email VARCHAR(255),
    payment_terms INTEGER,
    created_at DATETIME NOT NULL,
    INDEX idx_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Suppliers
CREATE TABLE IF NOT EXISTS suppliers (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    city VARCHAR(100) NOT NULL,
    country VARCHAR(2) NOT NULL DEFAULT 'DE',
    tax_id VARCHAR(50),
    vat_id VARCHAR(50),
    hra_hrb_number VARCHAR(50),
    email VARCHAR(255),
    bank_account VARCHAR(50),
    bank_name VARCHAR(255),
    iban VARCHAR(34),
    bic VARCHAR(11),
    default_tax_rate DOUBLE,
    logo TEXT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Hourly Rates
CREATE TABLE IF NOT EXISTS hourly_rates (
    id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    rate DECIMAL(10,2) NOT NULL,
    rate_type VARCHAR(10) NOT NULL,
    description TEXT,
    valid_from DATE NOT NULL,
    valid_to DATE,
    created_at DATETIME NOT NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_valid_from (valid_from),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Time Entries
CREATE TABLE IF NOT EXISTS time_entries (
    id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    hourly_rate_id VARCHAR(36) NOT NULL,
    date DATE NOT NULL,
    hours DECIMAL(10,2) NOT NULL,
    description TEXT NOT NULL,
    week INTEGER NOT NULL,
    year INTEGER NOT NULL,
    created_at DATETIME NOT NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_date (date),
    INDEX idx_week_year (year, week),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (hourly_rate_id) REFERENCES hourly_rates(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Invoices
CREATE TABLE IF NOT EXISTS invoices (
    id VARCHAR(36) PRIMARY KEY,
    invoice_number VARCHAR(50) NOT NULL UNIQUE,
    customer_id VARCHAR(36) NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    tax_rate DECIMAL(5,2) NOT NULL,
    tax_amount DECIMAL(10,2) NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    tax_type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    payment_terms INTEGER,
    due_date DATE,
    xrechnung_xml TEXT,
    archived BOOLEAN NOT NULL DEFAULT 0,
    archived_at DATETIME,
    created_at DATETIME NOT NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_invoice_number (invoice_number),
    INDEX idx_archived (archived),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Invoice Items
CREATE TABLE IF NOT EXISTS invoice_items (
    id VARCHAR(36) PRIMARY KEY,
    invoice_id VARCHAR(36) NOT NULL,
    time_entry_id TEXT NOT NULL,
    description TEXT NOT NULL,
    hours DECIMAL(10,2) NOT NULL,
    rate DECIMAL(10,2) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    rate_type VARCHAR(10),
    INDEX idx_invoice (invoice_id),
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Timesheets
CREATE TABLE IF NOT EXISTS timesheets (
    id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    pdf_data LONGBLOB,
    description TEXT,
    archived BOOLEAN NOT NULL DEFAULT 0,
    archived_at DATETIME,
    created_at DATETIME NOT NULL,
    INDEX idx_customer (customer_id),
    INDEX idx_date_range (date_from, date_to),
    INDEX idx_archived (archived),
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Activity Logs
CREATE TABLE IF NOT EXISTS activity_logs (
    id VARCHAR(36) PRIMARY KEY,
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id VARCHAR(36),
    details TEXT,
    created_at DATETIME NOT NULL,
    INDEX idx_created_at (created_at),
    INDEX idx_entity (entity_type, entity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

