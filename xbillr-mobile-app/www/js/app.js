import { StatusBar, Style, App, Browser } from './native.js';
import { auth, authErrorMessage } from './auth.js';
import { api, initNetwork, isOnline, refreshCache, flushQueue } from './api.js';
import { storage } from './storage.js';
import { ui } from './ui.js';

let cache = null;
let appReady = false;
let loginWatchTimer = null;

function stopLoginWatch() {
  if (loginWatchTimer) {
    clearInterval(loginWatchTimer);
    loginWatchTimer = null;
  }
}

function startLoginWatch() {
  stopLoginWatch();
  let ticks = 0;
  loginWatchTimer = setInterval(async () => {
    ticks += 1;
    if (ticks > 90) { // ~90s
      stopLoginWatch();
      return;
    }
    try {
      if (await auth.isLoggedIn()) {
        stopLoginWatch();
        await handleOAuthSuccess();
      }
    } catch (_) { /* ignore */ }
  }, 1000);
}

async function ensureCache() {
  cache = await storage.getCache();
  return cache;
}

async function loadOnline() {
  try {
    const result = await flushQueue();
    if (result.flushed) ui.toast(`${result.flushed} Änderung(en) synchronisiert`);
    cache = await refreshCache();
  } catch (e) {
    cache = await ensureCache();
    if (e.message !== 'OFFLINE') ui.toast(e.message || 'Laden fehlgeschlagen', true);
  }
}

async function afterMutation() {
  if (isOnline()) {
    try { cache = await refreshCache(); }
    catch { cache = await ensureCache(); }
  } else {
    cache = await ensureCache();
  }
}

function renderInvoices() {
  ui.renderInvoices(cache || { invoices: [] }, { onOpen: openInvoice, onCreate: createInvoice });
}

function renderCustomers() {
  ui.renderCustomers(cache || { customers: [] }, { onEdit: editCustomer });
}

function createInvoice() {
  ui.renderInvoiceCreate(cache, {
    onBack: () => { ui.navigate('invoices'); renderInvoices(); },
    onSave: saveInvoice
  });
}

async function openInvoice(id) {
  let inv = (cache.invoices || []).find((i) => i.id === id);
  if (isOnline()) {
    try { inv = await api.getInvoice(id); } catch (e) { ui.toast(e.message, true); }
  } else if (!inv) {
    ui.toast('Ältere Rechnungen können nur online geladen werden.', true);
    return;
  }
  if (!inv) return;
  ui.renderInvoiceDetail(inv, {
    onBack: () => { ui.navigate('invoices'); renderInvoices(); },
    onAction: invoiceAction
  });
}

async function invoiceAction(act, inv) {
  try {
    if (act === 'download') {
      await ui.openDownload(api.downloadInvoice(inv.id, 'pdf'));
      return;
    }
    if (act === 'pay') await api.payInvoice(inv.id);
    if (act === 'cancel') await api.cancelInvoice(inv.id);
    if (act === 'archive') await api.archiveInvoice(inv.id);
    if (act === 'delete') {
      if (!confirm('Rechnung wirklich löschen?')) return;
      await api.deleteInvoice(inv.id);
    }
    ui.toast(act === 'delete' ? 'Gelöscht' : 'Aktualisiert');
    await afterMutation();
    ui.navigate('invoices');
    renderInvoices();
  } catch (e) {
    if (e.message === 'OFFLINE' || e.code === 'OFFLINE') {
      ui.toast('Offline gespeichert – Sync bei Verbindung');
      await applyLocalInvoiceMutation(act, inv);
      ui.navigate('invoices');
      renderInvoices();
    } else ui.toast(e.message, true);
  }
}

async function applyLocalInvoiceMutation(act, inv) {
  const c = await storage.getCache();
  let list = c.invoices || [];
  if (act === 'delete') list = list.filter((i) => i.id !== inv.id);
  else {
    list = list.map((i) => {
      if (i.id !== inv.id) return i;
      if (act === 'pay') return { ...i, status: 'paid' };
      if (act === 'cancel') return { ...i, status: 'cancelled' };
      if (act === 'archive') return null;
      return i;
    }).filter(Boolean);
  }
  c.invoices = list;
  await storage.setCache(c);
  cache = c;
}

async function saveInvoice(body) {
  try {
    if (!body.invoiceNumber) {
      ui.toast('Rechnungsnummer fehlt', true);
      return;
    }
    const res = await api.createInvoice(body);
    if (res?.queued) {
      const c = await storage.getCache();
      const temp = {
        id: crypto.randomUUID(),
        ...body,
        status: 'draft',
        customerName: (c.customers || []).find((x) => x.id === body.customerId)?.name,
        grossTotal: body.lineItems?.reduce((s, li) => s + Number(li.price) * (1 + Number(li.vatRate) / 100), 0),
        createdAt: new Date().toISOString()
      };
      c.invoices = [temp, ...(c.invoices || [])];
      await storage.setCache(c);
      cache = c;
      ui.toast('Offline gespeichert');
    } else {
      ui.toast('Rechnung angelegt');
      await afterMutation();
    }
    ui.navigate('invoices');
    renderInvoices();
  } catch (e) {
    ui.toast(e.message, true);
  }
}

function editCustomer(customer) {
  ui.renderCustomerEdit(customer, cache.countries, {
    onBack: () => { ui.navigate('customers'); renderCustomers(); },
    onSave: saveCustomer,
    onDelete: deleteCustomer
  });
}

async function saveCustomer(id, body) {
  try {
    const res = id ? await api.updateCustomer(id, body) : await api.createCustomer(body);
    if (res?.queued) {
      await patchLocalCustomer(id, body);
      ui.toast('Offline gespeichert');
    } else {
      ui.toast('Kunde gespeichert');
      await afterMutation();
    }
    ui.navigate('customers');
    renderCustomers();
  } catch (e) {
    ui.toast(e.message, true);
  }
}

async function patchLocalCustomer(id, body) {
  const c = await storage.getCache();
  if (id) {
    c.customers = (c.customers || []).map((x) => (x.id === id ? { ...x, ...body } : x));
  } else {
    c.customers = [{ id: crypto.randomUUID(), ...body, totalBilledCurrentYear: 0 }, ...(c.customers || [])];
  }
  await storage.setCache(c);
  cache = c;
}

async function deleteCustomer(id) {
  if (!confirm('Kunde löschen?')) return;
  try {
    const res = await api.deleteCustomer(id);
    if (res?.queued) {
      const c = await storage.getCache();
      c.customers = (c.customers || []).filter((x) => x.id !== id);
      await storage.setCache(c);
      cache = c;
      ui.toast('Offline gelöscht – Sync folgt');
    } else {
      ui.toast('Gelöscht');
      await afterMutation();
    }
    ui.navigate('customers');
    renderCustomers();
  } catch (e) {
    ui.toast(e.message, true);
  }
}

async function saveTenant(body) {
  try {
    const res = await api.updateTenant(body);
    if (res?.queued) {
      const c = await storage.getCache();
      c.tenant = {
        ...c.tenant,
        name: body.name,
        companyName: body.name,
        billingEmail: body.billingEmail,
        iban: body.iban,
        taxNumber: body.taxNumber,
        billingAddress: {
          street: body.street,
          houseNumber: body.houseNumber,
          addressLine1: body.addressLine1,
          addressLine2: body.addressLine2,
          postalCode: body.postalCode,
          city: body.city,
          country: body.country
        }
      };
      await storage.setCache(c);
      cache = c;
      ui.toast('Offline gespeichert');
    } else {
      ui.toast('Stammdaten gespeichert');
      await afterMutation();
    }
    ui.renderStammdaten(cache, { onSave: saveTenant });
  } catch (e) {
    ui.toast(e.message, true);
  }
}

async function saveProfile(body) {
  try {
    const res = await api.updateProfile(body);
    if (res?.queued) {
      const c = await storage.getCache();
      c.profile = { ...c.profile, ...body };
      await storage.setCache(c);
      cache = c;
      ui.toast('Offline gespeichert');
    } else {
      ui.toast('Profil gespeichert');
      await afterMutation();
    }
    ui.renderProfile(cache, { onSave: saveProfile });
  } catch (e) {
    ui.toast(e.message, true);
  }
}

async function enterApp() {
  console.log('[app] enterApp');
  appReady = true;
  ui.showApp();
  await ensureCache();
  renderInvoices();
  renderCustomers();
  ui.renderStammdaten(cache || {}, { onSave: saveTenant });
  ui.renderProfile(cache || {}, { onSave: saveProfile });
  ui.navigate('invoices');
  // Daten danach laden – Fehler dürfen nicht zurück zum Login schicken
  if (isOnline()) await loadOnline();
  renderInvoices();
  renderCustomers();
  ui.renderStammdaten(cache || {}, { onSave: saveTenant });
  ui.renderProfile(cache || {}, { onSave: saveProfile });
}

async function tryEnterFromSession(reason = '') {
  if (!(await auth.isLoggedIn())) return false;
  console.log('[app] session found', reason);
  await enterApp();
  return true;
}

async function handleOAuthSuccess() {
  stopLoginWatch();
  if (appReady) {
    ui.showApp();
    return;
  }
  ui.toast('Angemeldet');
  await enterApp();
}

async function handleOAuthError(e) {
  ui.showLogin(authErrorMessage(e));
}

async function boot() {
  try {
    await StatusBar.setStyle({ style: Style.Dark });
    await StatusBar.setBackgroundColor({ color: '#091638' });
  } catch (_) { /* web */ }

  await initNetwork(async (online) => {
    ui.setOffline(online);
    if (online && appReady && await auth.isLoggedIn()) {
      await loadOnline();
      renderInvoices();
      renderCustomers();
    }
  });
  ui.setOffline(isOnline());

  auth.bindDeepLink(handleOAuthSuccess, handleOAuthError);

  // Safari/In-App-Browser geschlossen → Session prüfen
  Browser.addListener('browserFinished', async () => {
    console.log('[app] browserFinished');
    if (await auth.isLoggedIn()) await handleOAuthSuccess();
    else if (!appReady) startLoginWatch();
  });

  // Zurück aus Safari: Deep Link / Session nachziehen
  App.addListener('appStateChange', async ({ isActive }) => {
    if (!isActive) return;
    console.log('[app] resumed');
    try {
      const launchUrl = await auth.consumeLaunchUrl();
      if (launchUrl && await auth.handleRedirectUrl(launchUrl)) {
        await handleOAuthSuccess();
        return;
      }
    } catch (e) {
      // Token evtl. trotzdem schon da
      if (await auth.isLoggedIn()) {
        await handleOAuthSuccess();
        return;
      }
      handleOAuthError(e);
      return;
    }
    if (!appReady && await auth.isLoggedIn()) await handleOAuthSuccess();
  });

  try {
    const launchUrl = await auth.consumeLaunchUrl();
    if (launchUrl && await auth.handleRedirectUrl(launchUrl)) {
      await handleOAuthSuccess();
      return;
    }
  } catch (e) {
    if (!(await auth.isLoggedIn())) handleOAuthError(e);
    else {
      await handleOAuthSuccess();
      return;
    }
  }

  document.getElementById('btn-login').onclick = async () => {
    const btn = document.getElementById('btn-login');
    const errEl = document.getElementById('login-error');
    try {
      errEl.textContent = '';
      btn.disabled = true;
      btn.textContent = 'Öffne Login …';
      await auth.login();
      errEl.textContent = 'Bitte im Browser anmelden. Danach kehrst du automatisch zurück.';
      startLoginWatch();
    } catch (e) {
      console.error('[login]', authErrorMessage(e));
      ui.showLogin(authErrorMessage(e) || 'Login konnte nicht geöffnet werden');
    } finally {
      btn.disabled = false;
      btn.textContent = 'Anmelden';
    }
  };

  document.getElementById('btn-logout').onclick = async () => {
    appReady = false;
    stopLoginWatch();
    await auth.logout();
    ui.showLogin();
  };

  document.querySelectorAll('#main-nav button').forEach((btn) => {
    btn.onclick = () => {
      const page = btn.dataset.page;
      ui.navigate(page);
      if (page === 'invoices') renderInvoices();
      if (page === 'customers') renderCustomers();
      if (page === 'stammdaten') ui.renderStammdaten(cache || {}, { onSave: saveTenant });
      if (page === 'profile') ui.renderProfile(cache || {}, { onSave: saveProfile });
    };
  });

  if (await tryEnterFromSession('boot')) return;
  ui.showLogin();
}

boot().catch((e) => {
  console.error(e);
  ui.showLogin(e.message || 'Start fehlgeschlagen');
});
