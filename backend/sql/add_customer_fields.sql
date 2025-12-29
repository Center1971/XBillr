-- Migration: Erweitere customers-Tabelle um Tages-/Stundensätze, Zahlungsziel, MwSt und Reverse Charge

USE xbillr;

ALTER TABLE customers 
ADD COLUMN IF NOT EXISTS default_hourly_rate DECIMAL(10,2) NULL,
ADD COLUMN IF NOT EXISTS default_daily_rate DECIMAL(10,2) NULL,
ADD COLUMN IF NOT EXISTS tax_rate DECIMAL(5,2) NULL DEFAULT 19.00,
ADD COLUMN IF NOT EXISTS reverse_charge BOOLEAN NOT NULL DEFAULT 0;

-- Falls IF NOT EXISTS nicht unterstützt wird, verwenden wir einen anderen Ansatz
-- ALTER TABLE customers 
-- ADD COLUMN default_hourly_rate DECIMAL(10,2) NULL,
-- ADD COLUMN default_daily_rate DECIMAL(10,2) NULL,
-- ADD COLUMN tax_rate DECIMAL(5,2) NULL DEFAULT 19.00,
-- ADD COLUMN reverse_charge BOOLEAN NOT NULL DEFAULT 0;

