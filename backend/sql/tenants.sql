-- XBillr Tenants and Plans Schema (migration for existing DBs)
-- New installs: tenants + tenant columns are in schema.sql.
-- Run this file only to add tenants/tenant columns to an existing database.

USE xbillr;

-- Tenants table
CREATE TABLE IF NOT EXISTS tenants (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    plan VARCHAR(50) NOT NULL DEFAULT 'free',
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL,
    INDEX idx_name (name),
    INDEX idx_plan (plan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add tenant column to suppliers table
ALTER TABLE suppliers ADD COLUMN tenant VARCHAR(255) NULL;
CREATE INDEX idx_suppliers_tenant ON suppliers(tenant);

-- Add tenant column to customers table (if not exists)
ALTER TABLE customers ADD COLUMN tenant VARCHAR(255) NULL;
CREATE INDEX idx_customers_tenant ON customers(tenant);

-- Add tenant column to invoices table (if not exists)
ALTER TABLE invoices ADD COLUMN tenant VARCHAR(255) NULL;
CREATE INDEX idx_invoices_tenant ON invoices(tenant);

-- Add tenant column to time_entries table (if not exists)
ALTER TABLE time_entries ADD COLUMN tenant VARCHAR(255) NULL;
CREATE INDEX idx_time_entries_tenant ON time_entries(tenant);

-- Add tenant column to hourly_rates table (if not exists)
ALTER TABLE hourly_rates ADD COLUMN tenant VARCHAR(255) NULL;
CREATE INDEX idx_hourly_rates_tenant ON hourly_rates(tenant);
