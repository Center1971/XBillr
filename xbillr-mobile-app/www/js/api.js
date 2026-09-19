import { Network, plugin } from './native.js';
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

function parseBody(data) {
  if (data == null || data === '') return {};
  if (typeof data === 'object') return data;
  if (typeof data === 'string') {
    try { return JSON.parse(data); } catch { return { detail: data }; }
  }
  return {};
}

function httpError(status, data) {
  const msg = data?.detail || data?.title || data?.error || data?.error_description || `HTTP ${status}`;
  const err = new Error(msg);
  err.status = status;
  err.data = data;
  return err;
}

/** API-Request über CapacitorHttp (kein CORS, Headers zuverlässig) oder fetch. */
async function nativeRequest(method, url, headers, body) {
  const Http = plugin('CapacitorHttp');
  if (Http?.request) {
    let res;
    try {
      res = await Http.request({
        method,
        url,
        headers,
        data: body !== undefined ? body : undefined,
        dataType: body !== undefined ? 'json' : undefined
      });
    } catch (e) {
      const status = e?.status ?? e?.statusCode ?? 0;
      throw httpError(status, parseBody(e?.data));
    }
    const status = res?.status ?? res?.statusCode ?? 0;
    if (status === 204) return null;
    const data = parseBody(res?.data);
    if (status < 200 || status >= 300) throw httpError(status, data);
    return data;
  }

  const res = await fetch(url, {
    method,
    headers,
    body: body !== undefined ? JSON.stringify(body) : undefined
  });
  if (res.status === 204) return null;
  const text = await res.text();
  const data = parseBody(text);
  if (!res.ok) throw httpError(res.status, data);
  return data;
}

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

  const url = `${CONFIG.apiBase}/${path.replace(/^\//, '')}`;
  const headers = {
    Authorization: `Bearer ${token}`,
    Accept: 'application/json',
    ...(body !== undefined && body !== null ? { 'Content-Type': 'application/json' } : {})
  };

  try {
    return await nativeRequest(method, url, headers, body ?? undefined);
  } catch (e) {
    if (e.status === 401 && !_retried) {
      try {
        await auth.refresh();
        return request(method, path, body, { queueIfOffline: false, _retried: true });
      } catch (refreshErr) {
        throw new Error(refreshErr.message || 'Sitzung abgelaufen – bitte erneut anmelden.');
      }
    }
    throw e;
  }
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
  const results = await Promise.allSettled([
    api.me(),
    api.getTenant(),
    api.getProfile(),
    api.listCustomers(),
    api.listInvoices(),
    api.countries()
  ]);

  const [me, tenant, profile, customers, invoices, countries] = results.map((r) =>
    r.status === 'fulfilled' ? r.value : null
  );

  const firstAuthError = results.find((r) =>
    r.status === 'rejected' && (r.reason?.status === 401 || r.reason?.status === 403)
  );
  if (firstAuthError && !me && !tenant) {
    throw firstAuthError.reason;
  }

  const cache = {
    me: me || null,
    tenant: tenant || null,
    profile: profile || null,
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
