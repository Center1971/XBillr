import { api, isOnline } from './api.js';

const STATUS_LABEL = {
  draft: 'Entwurf',
  sent: 'Gesendet',
  overdue: 'Überfällig',
  paid: 'Bezahlt',
  cancelled: 'Storniert'
};

function money(n, currency = 'EUR') {
  const v = Number(n);
  if (Number.isNaN(v)) return '–';
  return new Intl.NumberFormat('de-DE', { style: 'currency', currency }).format(v);
}

function esc(s) {
  return String(s ?? '').replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;'
  }[c]));
}

function field(label, name, value = '', { type = 'text', readonly = false, options = null } = {}) {
  if (options) {
    const opts = options.map((o) => {
      const val = typeof o === 'string' ? o : o.value;
      const text = typeof o === 'string' ? o : o.label;
      return `<option value="${esc(val)}" ${String(val) === String(value) ? 'selected' : ''}>${esc(text)}</option>`;
    }).join('');
    return `<div class="field"><label>${esc(label)}</label><select name="${esc(name)}" ${readonly ? 'disabled' : ''}>${opts}</select></div>`;
  }
  return `<div class="field"><label>${esc(label)}</label><input type="${type}" name="${esc(name)}" value="${esc(value)}" ${readonly ? 'readonly' : ''}></div>`;
}

function formData(form) {
  const data = {};
  new FormData(form).forEach((v, k) => { data[k] = typeof v === 'string' ? v.trim() : v; });
  return data;
}

function toast(msg, isError = false) {
  const el = document.getElementById('toast');
  el.textContent = msg;
  el.className = `toast show${isError ? ' error' : ''}`;
  clearTimeout(toast._t);
  toast._t = setTimeout(() => { el.className = 'toast'; }, 3200);
}

export const ui = {
  toast,

  setOffline(online) {
    document.getElementById('offline-banner').classList.toggle('show', !online);
  },

  showLogin(error = '') {
    document.getElementById('login-screen').hidden = false;
    document.getElementById('app-shell').hidden = true;
    let msg = error == null ? '' : String(error);
    if (msg.includes('"url"') && msg.includes('openid-connect')) {
      msg = 'Token-Austausch fehlgeschlagen. Bitte erneut anmelden.';
    }
    document.getElementById('login-error').textContent = msg;
  },

  showApp() {
    document.getElementById('login-screen').hidden = true;
    document.getElementById('app-shell').hidden = false;
  },

  navigate(page, title) {
    document.querySelectorAll('.page').forEach((p) => p.classList.remove('active'));
    document.getElementById(`page-${page}`).classList.add('active');
    document.querySelectorAll('#main-nav button').forEach((b) => {
      b.classList.toggle('active', b.dataset.page === page);
    });
    document.getElementById('page-title').textContent = title || ({
      invoices: 'Rechnungen',
      customers: 'Kunden',
      stammdaten: 'Stammdaten',
      profile: 'Profil',
      detail: 'Details'
    }[page] || 'XBillr');
  },

  renderInvoices(cache, handlers) {
    const el = document.getElementById('page-invoices');
    const year = new Date().getFullYear();
    const items = (cache.invoices || []).filter((inv) => {
      const d = inv.createdAt || inv.sentDate || inv.draftDate || '';
      return !d || d.startsWith(String(year));
    });

    el.innerHTML = `
      <div class="row" style="margin-bottom:12px">
        <p class="muted" style="margin:0">Nur ${year} (Cache). Ältere Rechnungen brauchen Internet.</p>
        <button class="btn" id="btn-new-invoice">Neu</button>
      </div>
      ${!isOnline() ? '<div class="card muted">Offline: ältere/archivierte Rechnungen sind nicht abrufbar.</div>' : ''}
      ${items.length ? items.map((inv) => {
        const st = inv.status || 'draft';
        return `<div class="list-item invoice-${st}" data-id="${esc(inv.id)}">
          <div class="row">
            <strong>${esc(inv.invoiceNumber || '–')}</strong>
            <span class="badge ${st}">${STATUS_LABEL[st] || st}</span>
          </div>
          <div class="muted">${esc(inv.customerName || '')}</div>
          <div class="row" style="margin-top:6px">
            <span>${money(inv.grossTotal ?? inv.total, inv.currency || 'EUR')}</span>
            <span class="muted">${esc(inv.dueDate || '')}</span>
          </div>
        </div>`;
      }).join('') : '<div class="empty">Keine Rechnungen in diesem Jahr.</div>'}
    `;

    el.querySelector('#btn-new-invoice')?.addEventListener('click', () => handlers.onCreate());
    el.querySelectorAll('.list-item').forEach((node) => {
      node.addEventListener('click', () => handlers.onOpen(node.dataset.id));
    });
  },

  renderInvoiceDetail(inv, handlers) {
    const el = document.getElementById('page-detail');
    const st = inv.status || 'draft';
    const lines = (inv.lineItems || []).map((li) => `
      <div class="row" style="padding:6px 0;border-bottom:1px solid var(--border)">
        <div>
          <div>${esc(li.description)}</div>
          <div class="muted">MwSt ${esc(li.vatRate)}%</div>
        </div>
        <strong>${money(li.price, inv.currency || 'EUR')}</strong>
      </div>`).join('') || '<p class="muted">Keine Positionen</p>';

    const actions = [];
    if (st === 'draft') {
      actions.push(['cancel', 'Stornieren', 'danger']);
      actions.push(['archive', 'Archivieren', 'secondary']);
    } else if (st === 'cancelled') {
      actions.push(['download', 'Herunterladen', 'secondary']);
      actions.push(['cancel', 'Stornieren', 'secondary']);
      actions.push(['archive', 'Archivieren', 'secondary']);
      actions.push(['delete', 'Löschen', 'danger']);
    } else if (st === 'overdue' || st === 'sent') {
      actions.push(['download', 'Herunterladen', 'secondary']);
      if (st === 'overdue') actions.push(['pay', 'Als bezahlt', '']);
      actions.push(['cancel', 'Stornieren', 'danger']);
      actions.push(['archive', 'Archivieren', 'secondary']);
    } else if (st === 'paid') {
      actions.push(['download', 'Herunterladen', 'secondary']);
      actions.push(['archive', 'Archivieren', 'secondary']);
    }

    el.innerHTML = `
      <button class="btn secondary" id="btn-back">← Zurück</button>
      <div class="card" style="margin-top:12px">
        <div class="row"><h3 style="margin:0">${esc(inv.invoiceNumber)}</h3>
          <span class="badge ${st}">${STATUS_LABEL[st] || st}</span></div>
        <p class="muted">${esc(inv.customerName)}</p>
        ${field('Kunde', 'customerName', inv.customerName, { readonly: true })}
        ${field('Format', 'format', inv.format, { readonly: true })}
        ${field('Vertragsnummer', 'contractNumber', inv.contractNumber || '', { readonly: true })}
        ${field('Währung', 'currency', inv.currency || 'EUR', { readonly: true })}
        ${field('Zeitraum Beginn', 'periodStart', inv.periodStart || '', { readonly: true })}
        ${field('Zeitraum Ende', 'periodEnd', inv.periodEnd || '', { readonly: true })}
        ${field('Fälligkeitsdatum', 'dueDate', inv.dueDate || '', { readonly: true })}
        <h3>Positionen</h3>
        ${lines}
        <div class="row" style="margin-top:12px"><span>Netto</span><strong>${money(inv.netTotal ?? inv.subtotal, inv.currency)}</strong></div>
        <div class="row"><span>MwSt</span><strong>${money(inv.vatTotal ?? inv.taxAmount, inv.currency)}</strong></div>
        <div class="row"><span>Brutto</span><strong>${money(inv.grossTotal ?? inv.total, inv.currency)}</strong></div>
        <div class="actions">
          ${actions.map(([k, label, cls]) => `<button class="btn ${cls}" data-act="${k}">${label}</button>`).join('')}
        </div>
      </div>`;

    this.navigate('detail', inv.invoiceNumber || 'Rechnung');
    el.querySelector('#btn-back').onclick = () => handlers.onBack();
    el.querySelectorAll('[data-act]').forEach((btn) => {
      btn.onclick = () => handlers.onAction(btn.dataset.act, inv);
    });
  },

  renderInvoiceCreate(cache, handlers) {
    const el = document.getElementById('page-detail');
    const customers = cache.customers || [];
    const profile = cache.profile || {};
    const today = new Date().toISOString().slice(0, 10);
    el.innerHTML = `
      <button class="btn secondary" id="btn-back">← Zurück</button>
      <form id="invoice-form" class="card" style="margin-top:12px">
        <h3>Neue Rechnung</h3>
        <div class="field"><label>Kunde</label>
          <select name="customerId" required>
            <option value="">– wählen –</option>
            ${customers.map((c) => `<option value="${esc(c.id)}">${esc(c.name)}</option>`).join('')}
          </select>
        </div>
        ${field('Rechnungsnummer', 'invoiceNumber', '', { type: 'text' })}
        ${field('Format', 'format', 'zugferd', { options: ['zugferd', 'xrechnung', 'fatturapa', 'facturx'] })}
        ${field('Vertragsnummer', 'contractNumber')}
        ${field('Währung', 'currency', 'EUR')}
        ${field('Zeitraum Beginn', 'periodStart', today, { type: 'date' })}
        ${field('Zeitraum Ende', 'periodEnd', today, { type: 'date' })}
        ${field('Fälligkeitsdatum', 'dueDate', '', { type: 'date' })}
        <h3>Position</h3>
        ${field('Beschreibung', 'liDescription', 'Leistung')}
        ${field('Preis (netto)', 'liPrice', '0', { type: 'number' })}
        ${field('MwSt %', 'liVat', String(profile.defaultVatRate ?? 19), { type: 'number' })}
        <button class="btn btn-block" type="submit">Als Entwurf speichern</button>
      </form>`;
    this.navigate('detail', 'Neue Rechnung');
    el.querySelector('#btn-back').onclick = () => handlers.onBack();
    el.querySelector('#invoice-form').onsubmit = (e) => {
      e.preventDefault();
      const d = formData(e.target);
      handlers.onSave({
        customerId: d.customerId,
        invoiceNumber: d.invoiceNumber,
        format: d.format,
        contractNumber: d.contractNumber || undefined,
        currency: d.currency || 'EUR',
        periodStart: d.periodStart || undefined,
        periodEnd: d.periodEnd || undefined,
        dueDate: d.dueDate || undefined,
        lineItems: [{
          description: d.liDescription || 'Leistung',
          price: Number(d.liPrice) || 0,
          vatRate: Number(d.liVat) || 0
        }]
      });
    };
    api.nextNumber().then((n) => {
      const input = el.querySelector('[name=invoiceNumber]');
      if (input && !input.value && n?.invoiceNumber) input.value = n.invoiceNumber;
    }).catch(() => {});
  },

  renderCustomers(cache, handlers) {
    const el = document.getElementById('page-customers');
    const items = cache.customers || [];
    el.innerHTML = `
      <div class="row" style="margin-bottom:12px">
        <p class="muted" style="margin:0">${items.length} Kunden</p>
        <button class="btn" id="btn-new-customer">Neu</button>
      </div>
      ${items.length ? items.map((c) => `
        <div class="list-item" data-id="${esc(c.id)}">
          <div class="row"><strong>${esc(c.name)}</strong><span class="muted">${money(c.totalBilledCurrentYear || 0)}/a</span></div>
          <div class="muted">${esc(c.email || '')} · ${esc(c.city || '')}</div>
        </div>`).join('') : '<div class="empty">Keine Kunden.</div>'}`;

    el.querySelector('#btn-new-customer').onclick = () => handlers.onEdit(null);
    el.querySelectorAll('.list-item').forEach((n) => {
      n.onclick = () => handlers.onEdit(items.find((c) => c.id === n.dataset.id));
    });
  },

  renderCustomerEdit(customer, countries, handlers) {
    const el = document.getElementById('page-detail');
    const c = customer || {};
    const countryOpts = (countries || []).map((x) => ({ value: x.alpha2, label: x.nameDe || x.alpha2 }));
    el.innerHTML = `
      <button class="btn secondary" id="btn-back">← Zurück</button>
      <form id="customer-form" class="card" style="margin-top:12px">
        <h3>${c.id ? 'Kunde bearbeiten' : 'Neuer Kunde'}</h3>
        ${field('Kundenname', 'name', c.name || '')}
        ${field('E-Mail', 'email', c.email || '', { type: 'email' })}
        ${field('Telefon', 'phone', c.phone || '')}
        ${field('Rechnungs-E-Mail', 'billingEmail', c.billingEmail || '', { type: 'email' })}
        ${field('Straße', 'street', c.street || '')}
        ${field('Hausnummer', 'houseNumber', c.houseNumber || '')}
        ${field('Adresszeile 1', 'addressLine1', c.addressLine1 || '')}
        ${field('Adresszeile 2', 'addressLine2', c.addressLine2 || '')}
        ${field('PLZ', 'postalCode', c.postalCode || '')}
        ${field('Stadt', 'city', c.city || '')}
        ${field('Land', 'country', c.country || 'DE', { options: countryOpts.length ? countryOpts : ['DE', 'AT', 'CH'] })}
        ${field('Steuernummer', 'taxNumber', c.taxNumber || '')}
        <button class="btn btn-block" type="submit">Speichern</button>
        ${c.id ? '<button class="btn danger btn-block" type="button" id="btn-del-customer">Löschen</button>' : ''}
      </form>`;
    this.navigate('detail', c.name || 'Kunde');
    el.querySelector('#btn-back').onclick = () => handlers.onBack();
    el.querySelector('#customer-form').onsubmit = (e) => {
      e.preventDefault();
      handlers.onSave(c.id, formData(e.target));
    };
    el.querySelector('#btn-del-customer')?.addEventListener('click', () => handlers.onDelete(c.id));
  },

  renderStammdaten(cache, handlers) {
    const el = document.getElementById('page-stammdaten');
    const t = cache.tenant || {};
    const a = t.billingAddress || {};
    const countries = cache.countries || [];
    const countryOpts = countries.map((x) => ({ value: x.alpha2, label: x.nameDe || x.alpha2 }));
    el.innerHTML = `
      <form id="tenant-form" class="card">
        ${t.logoUrl ? `<img class="logo-preview" src="${esc(t.logoUrl)}" alt="Logo">` : '<p class="muted">Kein Logo</p>'}
        ${field('Firmenname', 'name', t.companyName || t.name || '')}
        ${field('Rechnungs-E-Mail', 'billingEmail', t.billingEmail || '', { type: 'email' })}
        ${field('Straße', 'street', a.street || '')}
        ${field('Hausnummer', 'houseNumber', a.houseNumber || '')}
        ${field('Adresszeile 1', 'addressLine1', a.addressLine1 || '')}
        ${field('Adresszeile 2', 'addressLine2', a.addressLine2 || '')}
        ${field('PLZ', 'postalCode', a.postalCode || '')}
        ${field('Stadt', 'city', a.city || '')}
        ${field('Land', 'country', a.country || 'DE', { options: countryOpts.length ? countryOpts : ['DE'] })}
        ${field('IBAN', 'iban', t.iban || '')}
        ${field('Steuernummer', 'taxNumber', t.taxNumber || '')}
        <button class="btn btn-block" type="submit">Speichern</button>
      </form>`;
    el.querySelector('#tenant-form').onsubmit = (e) => {
      e.preventDefault();
      handlers.onSave(formData(e.target));
    };
  },

  renderProfile(cache, handlers) {
    const el = document.getElementById('page-profile');
    const p = cache.profile || {};
    const me = cache.me || {};
    const roles = (me.roles || []).join(', ') || '–';
    el.innerHTML = `
      <form id="profile-form" class="card">
        ${field('Vorname', 'firstName', p.firstName || me.firstName || '')}
        ${field('Nachname', 'lastName', p.lastName || me.lastName || '')}
        ${field('E-Mail', 'email', p.email || me.email || '', { readonly: true })}
        ${field('Rollen', 'roles', roles, { readonly: true })}
        ${field('Sprache', 'language', p.language || 'de', { options: [{ value: 'de', label: 'Deutsch' }, { value: 'en', label: 'English' }] })}
        ${field('Theme', 'theme', p.theme || 'light', { options: [{ value: 'light', label: 'Hell' }, { value: 'dark', label: 'Dunkel' }] })}
        ${field('Standard-MwSt-Satz', 'defaultVatRate', p.defaultVatRate ?? 19, { type: 'number' })}
        ${field('Standard-Zahlungsziel (Tage)', 'defaultPaymentTerm', p.defaultPaymentTerm ?? 30, { type: 'number' })}
        <button class="btn btn-block" type="submit">Speichern</button>
      </form>`;
    el.querySelector('#profile-form').onsubmit = (e) => {
      e.preventDefault();
      const d = formData(e.target);
      handlers.onSave({
        firstName: d.firstName,
        lastName: d.lastName,
        theme: d.theme,
        defaultVatRate: Number(d.defaultVatRate),
        defaultPaymentTerm: Number(d.defaultPaymentTerm)
      });
    };
  },

  async openDownload(url) {
    const { auth } = await import('./auth.js');
    const token = await auth.getAccessToken();
    const res = await fetch(url, {
      headers: { Authorization: `Bearer ${token}`, Accept: 'application/pdf,*/*' }
    });
    if (!res.ok) throw new Error('Download fehlgeschlagen');
    const blob = await res.blob();
    const objUrl = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = objUrl;
    a.download = 'rechnung.pdf';
    a.click();
    setTimeout(() => URL.revokeObjectURL(objUrl), 5000);
  }
};

export { toast, money, STATUS_LABEL };
