import { Browser, App, plugin } from './native.js';
import { CONFIG } from './config.js';
import { storage } from './storage.js';

function base64Url(buffer) {
  const bytes = new Uint8Array(buffer);
  let str = '';
  bytes.forEach((b) => { str += String.fromCharCode(b); });
  return btoa(str).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

async function sha256(plain) {
  const data = new TextEncoder().encode(plain);
  return crypto.subtle.digest('SHA-256', data);
}

function randomString(len = 64) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';
  const arr = new Uint8Array(len);
  crypto.getRandomValues(arr);
  return Array.from(arr, (x) => chars[x % chars.length]).join('');
}

function parseCallbackUrl(urlString) {
  const normalized = urlString
    .replace(/^xbillr-mobile:\/\//i, 'https://xbillr.local/')
    .replace(/^eu\.xbillr\.mobile:\/\//i, 'https://xbillr.local/');
  return new URL(normalized);
}

function isOAuthCallback(urlString) {
  if (!urlString) return false;
  return (
    urlString.startsWith(CONFIG.keycloak.redirectUri) ||
    urlString.startsWith('xbillr-mobile://oauth/callback') ||
    urlString.startsWith('eu.xbillr.mobile://oauth/callback')
  );
}

function parseBody(data) {
  if (data == null || data === '') return {};
  if (typeof data === 'object' && !Array.isArray(data)) return data;
  if (typeof data === 'string') {
    const trimmed = data.trim();
    if (!trimmed) return {};
    try { return JSON.parse(trimmed); } catch { return { error: trimmed.slice(0, 200) }; }
  }
  return {};
}

function isHttpDump(value) {
  if (value == null) return false;
  if (typeof value === 'object') {
    return !!(value.url && (value.headers || value.status != null));
  }
  const s = String(value);
  return s.includes('"url"') && (s.includes('"headers"') || s.includes('openid-connect'));
}

function messageFromHttpDump(dump) {
  let obj = dump;
  if (typeof dump === 'string') {
    try { obj = JSON.parse(dump); } catch {
      return 'Token-Austausch fehlgeschlagen. Bitte erneut anmelden.';
    }
  }
  const body = parseBody(obj?.data);
  if (body.error_description) return String(body.error_description);
  if (body.error) return String(body.error);
  const status = obj?.status ?? obj?.statusCode;
  if (status === 400) return 'Ungültige Login-Daten oder abgelaufener Code. Bitte erneut anmelden.';
  if (status === 401) return 'Anmeldung abgelehnt. Bitte Zugangsdaten prüfen.';
  if (status) return `Token-Austausch fehlgeschlagen (HTTP ${status}). Bitte erneut anmelden.`;
  return 'Token-Austausch fehlgeschlagen. Bitte erneut anmelden.';
}

/** Lesbare Fehlermeldung – niemals rohe HTTP-Dumps anzeigen. */
export function authErrorMessage(e) {
  if (!e) return 'Anmeldung fehlgeschlagen';
  if (isHttpDump(e)) return messageFromHttpDump(e);
  if (typeof e === 'string') {
    if (isHttpDump(e)) return messageFromHttpDump(e);
    return e;
  }
  if (isHttpDump(e.message)) return messageFromHttpDump(e.message);
  if (isHttpDump(e.errorMessage)) return messageFromHttpDump(e.errorMessage);
  if (isHttpDump(e.data)) return messageFromHttpDump(e.data);

  const body = parseBody(e.data ?? e.error);
  if (body.error_description) return String(body.error_description);
  if (body.error && !isHttpDump(body.error)) return String(body.error);
  if (e.message && !isHttpDump(e.message)) return e.message;
  if (e.errorMessage && !isHttpDump(e.errorMessage)) return e.errorMessage;
  return 'Anmeldung fehlgeschlagen. Bitte erneut versuchen.';
}

/**
 * Token-Request: Form-Body als String, CapacitorHttp (kein CORS).
 * CapacitorHttp resolved auch bei HTTP 4xx – Status selbst prüfen.
 */
async function postForm(url, params) {
  const body = new URLSearchParams(
    Object.fromEntries(Object.entries(params).map(([k, v]) => [k, String(v ?? '')]))
  ).toString();

  const Http = plugin('CapacitorHttp');
  if (Http?.request || Http?.post) {
    let res;
    try {
      const opts = {
        url,
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          Accept: 'application/json'
        },
        data: body,
        responseType: 'json'
      };
      res = Http.post
        ? await Http.post(opts)
        : await Http.request(opts);
    } catch (e) {
      console.error('[auth] CapHttp token error', e);
      throw new Error(authErrorMessage(e));
    }

    const status = res?.status ?? res?.statusCode ?? 0;
    const data = parseBody(res?.data);
    console.log('[auth] token status', status, Object.keys(data));

    if (status < 200 || status >= 300) {
      throw new Error(
        data.error_description || data.error || `Token-Austausch fehlgeschlagen (HTTP ${status}).`
      );
    }
    if (!data.access_token) {
      throw new Error('Kein Access-Token in der Antwort – bitte erneut anmelden.');
    }
    return data;
  }

  // Fallback fetch (nur wenn CapHttp fehlt)
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      Accept: 'application/json'
    },
    body
  });
  const text = await res.text();
  const data = parseBody(text);
  if (!res.ok) {
    throw new Error(data.error_description || data.error || `Token HTTP ${res.status}`);
  }
  if (!data.access_token) throw new Error('Kein Access-Token erhalten.');
  return data;
}

let pending = null;
let handling = false;

async function clearLoginSession() {
  pending = null;
  await storage.clearPkce();
  try { sessionStorage.removeItem('xb.pkce'); } catch (_) { /* ignore */ }
  try { await Browser.close(); } catch (_) { /* ignore */ }
}

export const auth = {
  async getAccessToken() {
    const tokens = await storage.getTokens();
    if (!tokens?.access_token) return null;
    if (tokens.expires_at && Date.now() > tokens.expires_at - 30000) {
      try { return (await this.refresh()).access_token; }
      catch (e) {
        console.warn('[auth] refresh failed, using existing token', e);
        return tokens.access_token;
      }
    }
    return tokens.access_token;
  },

  async isLoggedIn() {
    const tokens = await storage.getTokens();
    return !!(tokens?.access_token);
  },

  async login() {
    await clearLoginSession();

    const verifier = randomString(64);
    const challenge = base64Url(await sha256(verifier));
    const state = randomString(32);
    pending = { verifier, state };
    await storage.setPkce(pending);
    try { sessionStorage.setItem('xb.pkce', JSON.stringify(pending)); } catch (_) { /* ignore */ }

    const url = new URL(CONFIG.keycloak.authUrl);
    url.searchParams.set('response_type', 'code');
    url.searchParams.set('client_id', CONFIG.keycloak.clientId);
    url.searchParams.set('redirect_uri', CONFIG.keycloak.redirectUri);
    url.searchParams.set('scope', CONFIG.keycloak.scopes);
    url.searchParams.set('state', state);
    url.searchParams.set('code_challenge', challenge);
    url.searchParams.set('code_challenge_method', 'S256');
    url.searchParams.set('prompt', 'login');

    const authUrl = url.toString();
    console.log('[auth] opening', authUrl);
    await Browser.open({ url: authUrl });
  },

  async handleRedirectUrl(urlString) {
    if (!isOAuthCallback(urlString)) return false;
    if (handling) return false;
    handling = true;
    try {
      console.log('[auth] callback', urlString);
      const url = parseCallbackUrl(urlString);
      const error = url.searchParams.get('error');
      if (error) {
        await clearLoginSession();
        throw new Error(url.searchParams.get('error_description') || error);
      }

      const code = url.searchParams.get('code');
      const state = url.searchParams.get('state');
      let saved = pending;
      if (!saved) {
        try { saved = JSON.parse(sessionStorage.getItem('xb.pkce') || 'null'); } catch (_) { saved = null; }
      }
      if (!saved) saved = await storage.getPkce();

      if (!code) {
        await clearLoginSession();
        throw new Error('Kein Authorization-Code im Callback.');
      }
      if (!saved) {
        await clearLoginSession();
        throw new Error('Login-Sitzung abgelaufen – bitte erneut anmelden.');
      }
      if (state !== saved.state) {
        await clearLoginSession();
        throw new Error('State-Mismatch – bitte erneut anmelden.');
      }

      await this.exchangeCode(code, saved.verifier);
      await clearLoginSession();
      console.log('[auth] login ok');
      return true;
    } catch (e) {
      await clearLoginSession();
      throw new Error(authErrorMessage(e));
    } finally {
      handling = false;
    }
  },

  async exchangeCode(code, verifier) {
    const json = await postForm(CONFIG.keycloak.tokenUrl, {
      grant_type: 'authorization_code',
      code,
      redirect_uri: CONFIG.keycloak.redirectUri,
      client_id: CONFIG.keycloak.clientId,
      code_verifier: verifier
    });
    await storage.setTokens({
      access_token: json.access_token,
      refresh_token: json.refresh_token,
      id_token: json.id_token,
      token_type: json.token_type,
      expires_in: json.expires_in,
      expires_at: Date.now() + (Number(json.expires_in) || 300) * 1000
    });
    try {
      const payload = JSON.parse(atob(json.access_token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')));
      console.log('[auth] token claims', {
        azp: payload.azp,
        aud: payload.aud,
        iss: payload.iss,
        roles: payload.realm_access?.roles || payload.resource_access
      });
    } catch (_) { /* ignore */ }
  },

  async refresh() {
    const tokens = await storage.getTokens();
    if (!tokens?.refresh_token) throw new Error('Kein Refresh-Token.');
    const json = await postForm(CONFIG.keycloak.tokenUrl, {
      grant_type: 'refresh_token',
      refresh_token: tokens.refresh_token,
      client_id: CONFIG.keycloak.clientId
    });
    const next = {
      access_token: json.access_token || tokens.access_token,
      refresh_token: json.refresh_token || tokens.refresh_token,
      id_token: json.id_token || tokens.id_token,
      token_type: json.token_type || tokens.token_type,
      expires_in: json.expires_in,
      expires_at: Date.now() + (Number(json.expires_in) || 300) * 1000
    };
    await storage.setTokens(next);
    return next;
  },

  async logout() {
    await storage.clearTokens();
    await clearLoginSession();
  },

  async consumeLaunchUrl() {
    const A = plugin('App');
    if (!A?.getLaunchUrl) return null;
    try {
      const result = await A.getLaunchUrl();
      return result?.url || null;
    } catch (_) {
      return null;
    }
  },

  bindDeepLink(onSuccess, onError) {
    App.addListener('appUrlOpen', async ({ url }) => {
      try {
        console.log('[auth] appUrlOpen', url);
        if (await this.handleRedirectUrl(url)) {
          await onSuccess();
        }
      } catch (e) {
        const msg = authErrorMessage(e);
        console.error('[auth] callback error', msg);
        onError(new Error(msg));
      }
    });
  }
};
