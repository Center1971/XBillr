-- Populate ISO 3166-1 Countries and ISO 4217 Currencies
-- This is a sample - you may want to import full datasets from:
-- https://www.iso.org/iso-3166-country-codes.html
-- https://www.iso.org/iso-4217-currency-codes.html

-- Sample countries (EU + major countries)
INSERT IGNORE INTO countries (alpha2, alpha3, numeric, name_de, name_en) VALUES
('DE', 'DEU', '276', 'Deutschland', 'Germany'),
('AT', 'AUT', '040', 'Österreich', 'Austria'),
('BE', 'BEL', '056', 'Belgien', 'Belgium'),
('BG', 'BGR', '100', 'Bulgarien', 'Bulgaria'),
('CY', 'CYP', '196', 'Zypern', 'Cyprus'),
('CZ', 'CZE', '203', 'Tschechien', 'Czech Republic'),
('DK', 'DNK', '208', 'Dänemark', 'Denmark'),
('EE', 'EST', '233', 'Estland', 'Estonia'),
('FI', 'FIN', '246', 'Finnland', 'Finland'),
('FR', 'FRA', '250', 'Frankreich', 'France'),
('GR', 'GRC', '300', 'Griechenland', 'Greece'),
('HR', 'HRV', '191', 'Kroatien', 'Croatia'),
('HU', 'HUN', '348', 'Ungarn', 'Hungary'),
('IE', 'IRL', '372', 'Irland', 'Ireland'),
('IT', 'ITA', '380', 'Italien', 'Italy'),
('LV', 'LVA', '428', 'Lettland', 'Latvia'),
('LT', 'LTU', '440', 'Litauen', 'Lithuania'),
('LU', 'LUX', '442', 'Luxemburg', 'Luxembourg'),
('MT', 'MLT', '470', 'Malta', 'Malta'),
('NL', 'NLD', '528', 'Niederlande', 'Netherlands'),
('PL', 'POL', '616', 'Polen', 'Poland'),
('PT', 'PRT', '620', 'Portugal', 'Portugal'),
('RO', 'ROU', '642', 'Rumänien', 'Romania'),
('SE', 'SWE', '752', 'Schweden', 'Sweden'),
('SI', 'SVN', '705', 'Slowenien', 'Slovenia'),
('SK', 'SVK', '703', 'Slowakei', 'Slovakia'),
('ES', 'ESP', '724', 'Spanien', 'Spain'),
('GB', 'GBR', '826', 'Vereinigtes Königreich', 'United Kingdom'),
('US', 'USA', '840', 'Vereinigte Staaten', 'United States'),
('CH', 'CHE', '756', 'Schweiz', 'Switzerland');

-- Sample currencies (EUR + major currencies)
INSERT IGNORE INTO currencies (alpha4, numeric, name_de, name_en, country_alpha2) VALUES
('EUR', '978', 'Euro', 'Euro', 'DE'),
('USD', '840', 'US-Dollar', 'US Dollar', 'US'),
('GBP', '826', 'Britisches Pfund', 'British Pound', 'GB'),
('CHF', '756', 'Schweizer Franken', 'Swiss Franc', 'CH'),
('JPY', '392', 'Japanischer Yen', 'Japanese Yen', 'JP'),
('CNY', '156', 'Chinesischer Yuan', 'Chinese Yuan', 'CN');
