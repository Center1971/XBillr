import { Network } from './native.js';
import { CONFIG } from './config.js';
import { auth } from './auth.js';
import { storage } from './storage.js';

let online = true;

export async function initNetwork(onChange) {
  const status = await Network.getStatus();
  online = status.connected;
  Network.addListener('networkStatusChange', (s) => {
    online = s.connected;
    onChange?.(online);
  });
  return online;
}

export function isOnline() { return online; }

async function request(method, path, body, { queueIfOffline = false, _retried = false } = {}) {
  if (!online) {
    if (queueIfOffline && method !== 'GET') {
      await storage.enqueue({ method, path, body });
      return { queued: true };
    }
    const err = new Error('OFFLINE');
    err.code = 'OFFLINE';
    throw err;
  }

  const token = await auth.getAccessToken();
  if (!token) throw new Error('Nicht angemeldet.');

  const res = await fetch(`${CONFIG.apiBase}/${path.replace(/^\//, '')}`, {
    method,
    headers: {
      Authorization: `Bearer ${token}`,
      Accept: 'application/json',
      ...(body ? { 'Content-Type': 'application/json' } : {})
    },
    body: body ? JSON.stringify(body) : undefined
  });

  if (res.status === 401 && !_retried) {
    await auth.refresh();
    return request(method, path, body, { queueIfOffline: false, _retried: true });
  }

  if (res.status === 204) return null;
  const text = await res.text();
  let data = null;
  try { data = text ? JSON.parse(text) : null; } catch { data = { detail: text }; }
  if (!res.ok) {
    const err = new Error(data?.detail || data?.title || `HTTP ${res.status}`);
    err.status = res.status;
    err.data = data;
    throw err;
  }
  return data;
}

export const api = {
  me: () => request('GET', 'auth/me'),
  getTenant: () => request('GET', 'v1/web/tenants/current'),
  updateTenant: (body) => request('PUT', 'v1/web/tenants/current', body, { queueIfOffline: true }),
  getProfile: () => request('GET', 'v1/web/profile'),
  updateProfile: (body) => request('PUT', 'v1/web/profile', body, { queueIfOffline: true }),
  listCustomers: () => request('GET', 'v1/web/customers?limit=100'),
  getCustomer: (id) => request('GET', `v1/web/customers/${id}`),
  createCustomer: (body) => request('POST', 'v1/web/customers', body, { queueIfOffline: true }),
  updateCustomer: (id, body) => request('PUT', `v1/web/customers/${id}`, body, { queueIfOffline: true }),
  deleteCustomer: (id) => request('DELETE', `v1/web/customers/${id}`, null, { queueIfOffline: true }),
  listInvoices: (params = '') => request('GET', `v1/web/invoices?archived=0&limit=100${params}`),
  getInvoice: (id) => request('GET', `v1/web/invoices/${id}`),
  createInvoice: (body) => request('POST', 'v1/web/invoices', body, { queueIfOffline: true }),
  deleteInvoice: (id) => request('DELETE', `v1/web/invoices/${id}`, null, { queueIfOffline: true }),
  payInvoice: (id) => request('POST', `v1/web/invoices/${id}/pay`, null, { queueIfOffline: true }),
  cancelInvoice: (id) => request('POST', `v1/web/invoices/${id}/cancel`, null, { queueIfOffline: true }),
  archiveInvoice: (id) => request('POST', `v1/web/invoices/${id}/archive`, null, { queueIfOffline: true }),
  downloadInvoice: (id, type = 'pdf') =>
    `${CONFIG.apiBase}/v1/web/invoices/${id}/download?type=${type}`,
  countries: () => request('GET', 'v1/web/countries'),
  nextNumber: () => request('GET', 'v1/web/invoices/next-number')
};

export async function refreshCache() {
  const [me, tenant, profile, customers, invoices, countries] = await Promise.all([
    api.me(),
    api.getTenant(),
    api.getProfile(),
    api.listCustomers(),
    api.listInvoices(),
    api.countries().catch(() => ({ items: [] }))
  ]);
  const cache = {
    me,
    tenant,
    profile,
    customers: customers?.items || [],
    invoices: invoices?.items || [],
    countries: countries?.items || [],
    updatedAt: Date.now()
  };
  await storage.setCache(cache);
  return cache;
}

export async function flushQueue() {
  if (!online) return { flushed: 0 };
  const queue = await storage.getQueue();
  if (!queue.length) return { flushed: 0 };
  const remaining = [];
  let flushed = 0;
  for (const item of queue) {
    try {
      await request(item.method, item.path, item.body, { queueIfOffline: false });
      flushed += 1;
    } catch (_) {
      remaining.push(item);
    }
  }
  await storage.setQueue(remaining);
  if (flushed) await refreshCache();
  return { flushed, remaining: remaining.length };
}
