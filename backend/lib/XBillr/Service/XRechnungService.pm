package XBillr::Service::XRechnungService;

use strict;
use warnings;
use Mojo::Base -base;
use XML::LibXML;
use DateTime;

has 'schema';

sub generate_xrechnung_xml {
    my ($self, $invoice_id) = @_;
    
    my $schema = $self->schema;
    my $invoice = $schema->resultset('Invoice')->find($invoice_id);
    die "Rechnung nicht gefunden" unless $invoice;
    
    my $customer = $schema->resultset('Customer')->find($invoice->customer_id);
    die "Kunde nicht gefunden" unless $customer;
    
    my $supplier = $schema->resultset('Supplier')->first;
    die "Rechnungsempfänger nicht gefunden" unless $supplier;
    
    my $items_rs = $schema->resultset('InvoiceItem')->search({ invoice_id => $invoice_id });
    
    # Erstelle XML-Dokument
    my $doc = XML::LibXML::Document->new('1.0', 'UTF-8');
    my $root = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:Invoice-2', 'Invoice');
    $root->setNamespace('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc', 0);
    $root->setNamespace('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac', 0);
    $doc->setDocumentElement($root);
    
    # ID
    my $id_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:ID');
    $id_elem->appendTextNode($invoice->invoice_number);
    $root->appendChild($id_elem);
    
    # IssueDate
    my $issue_date = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:IssueDate');
    my ($year, $month, $day) = split /-/, $invoice->date_from;
    $issue_date->appendTextNode(sprintf('%04d-%02d-%02d', $year, $month, $day));
    $root->appendChild($issue_date);
    
    # InvoiceTypeCode
    my $type_code = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:InvoiceTypeCode');
    $type_code->setAttribute('listID', 'UNCL1001');
    $type_code->appendTextNode('380');
    $root->appendChild($type_code);
    
    # AccountingSupplierParty
    my $supplier_party = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:AccountingSupplierParty');
    my $supplier_party_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Party');
    
    # Supplier Name
    my $supplier_name = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PartyName');
    my $supplier_name_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:Name');
    $supplier_name_elem->appendTextNode($supplier->name);
    $supplier_name->appendChild($supplier_name_elem);
    $supplier_party_elem->appendChild($supplier_name);
    
    # Supplier PostalAddress
    my $supplier_address = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PostalAddress');
    my $street = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:StreetName');
    $street->appendTextNode($supplier->address);
    $supplier_address->appendChild($street);
    my $postal_code = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:PostalZone');
    $postal_code->appendTextNode($supplier->zip_code);
    $supplier_address->appendChild($postal_code);
    my $city = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:CityName');
    $city->appendTextNode($supplier->city);
    $supplier_address->appendChild($city);
    my $country = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Country');
    my $country_code = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:IdentificationCode');
    $country_code->setAttribute('listID', 'ISO3166-1:Alpha2');
    $country_code->appendTextNode($supplier->country);
    $country->appendChild($country_code);
    $supplier_address->appendChild($country);
    $supplier_party_elem->appendChild($supplier_address);
    
    # Supplier VAT ID
    if ($supplier->vat_id) {
        my $supplier_tax = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PartyTaxScheme');
        my $company_id = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:CompanyID');
        $company_id->appendTextNode($supplier->vat_id);
        $supplier_tax->appendChild($company_id);
        $supplier_party_elem->appendChild($supplier_tax);
    }
    
    $supplier_party->appendChild($supplier_party_elem);
    $root->appendChild($supplier_party);
    
    # AccountingCustomerParty
    my $customer_party = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:AccountingCustomerParty');
    my $customer_party_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Party');
    
    # Customer Name
    my $customer_name = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PartyName');
    my $customer_name_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:Name');
    $customer_name_elem->appendTextNode($customer->company || $customer->name);
    $customer_name->appendChild($customer_name_elem);
    $customer_party_elem->appendChild($customer_name);
    
    # Customer PostalAddress
    my $customer_address = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PostalAddress');
    my $cust_street = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:StreetName');
    $cust_street->appendTextNode($customer->address);
    $customer_address->appendChild($cust_street);
    my $cust_postal_code = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:PostalZone');
    $cust_postal_code->appendTextNode($customer->zip_code);
    $customer_address->appendChild($cust_postal_code);
    my $cust_city = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:CityName');
    $cust_city->appendTextNode($customer->city);
    $customer_address->appendChild($cust_city);
    my $cust_country = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Country');
    my $cust_country_code = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:IdentificationCode');
    $cust_country_code->setAttribute('listID', 'ISO3166-1:Alpha2');
    $cust_country_code->appendTextNode($customer->country);
    $cust_country->appendChild($cust_country_code);
    $customer_address->appendChild($cust_country);
    $customer_party_elem->appendChild($customer_address);
    
    # Customer VAT ID
    if ($customer->vat_id) {
        my $customer_tax = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:PartyTaxScheme');
        my $cust_company_id = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:CompanyID');
        $cust_company_id->appendTextNode($customer->vat_id);
        $customer_tax->appendChild($cust_company_id);
        $customer_party_elem->appendChild($customer_tax);
    }
    
    $customer_party->appendChild($customer_party_elem);
    $root->appendChild($customer_party);
    
    # InvoiceLines
    my $line_number = 1;
    while (my $item = $items_rs->next) {
        my $line = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:InvoiceLine');
        
        my $line_id = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:ID');
        $line_id->appendTextNode($line_number++);
        $line->appendChild($line_id);
        
        my $line_amount = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:LineExtensionAmount');
        $line_amount->setAttribute('currencyID', 'EUR');
        $line_amount->appendTextNode(sprintf('%.2f', $item->amount));
        $line->appendChild($line_amount);
        
        my $item_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Item');
        my $item_desc = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:Description');
        $item_desc->appendTextNode($item->description);
        $item_elem->appendChild($item_desc);
        $line->appendChild($item_elem);
        
        my $price_elem = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:Price');
        my $price_amount = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:PriceAmount');
        $price_amount->setAttribute('currencyID', 'EUR');
        $price_amount->appendTextNode(sprintf('%.2f', $item->rate));
        $price_elem->appendChild($price_amount);
        $line->appendChild($price_elem);
        
        $root->appendChild($line);
    }
    
    # LegalMonetaryTotal
    my $monetary_total = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:LegalMonetaryTotal');
    
    my $line_total = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:LineExtensionAmount');
    $line_total->setAttribute('currencyID', 'EUR');
    $line_total->appendTextNode(sprintf('%.2f', $invoice->subtotal));
    $monetary_total->appendChild($line_total);
    
    my $tax_total = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:TaxTotal');
    my $tax_amount = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:TaxAmount');
    $tax_amount->setAttribute('currencyID', 'EUR');
    $tax_amount->appendTextNode(sprintf('%.2f', $invoice->tax_amount));
    $tax_total->appendChild($tax_amount);
    
    my $tax_subtotal = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:TaxSubtotal');
    my $taxable_amount = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:TaxableAmount');
    $taxable_amount->setAttribute('currencyID', 'EUR');
    $taxable_amount->appendTextNode(sprintf('%.2f', $invoice->subtotal));
    $tax_subtotal->appendChild($taxable_amount);
    
    my $tax_category = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:TaxCategory');
    my $tax_scheme = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2', 'cac:TaxScheme');
    my $tax_scheme_id = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:ID');
    $tax_scheme_id->appendTextNode('VAT');
    $tax_scheme->appendChild($tax_scheme_id);
    $tax_category->appendChild($tax_scheme);
    $tax_subtotal->appendChild($tax_category);
    $tax_total->appendChild($tax_subtotal);
    $monetary_total->appendChild($tax_total);
    
    my $payable_amount = $doc->createElementNS('urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2', 'cbc:PayableAmount');
    $payable_amount->setAttribute('currencyID', 'EUR');
    $payable_amount->appendTextNode(sprintf('%.2f', $invoice->total));
    $monetary_total->appendChild($payable_amount);
    
    $root->appendChild($monetary_total);
    
    return $doc->toString(1);
}

1;

