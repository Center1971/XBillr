import { Browser, App } from './native.js';
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

let pending = null;

export const auth = {
  async getAccessToken() {
    const tokens = await storage.getTokens();
    if (!tokens?.access_token) return null;
    if (tokens.expires_at && Date.now() > tokens.expires_at - 30000) {
      try { return (await this.refresh()).access_token; }
      catch { await storage.clearTokens(); return null; }
    }
    return tokens.access_token;
  },

  async isLoggedIn() {
    return !!(await this.getAccessToken());
  },

  async login() {
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

    const authUrl = url.toString();
    console.log('[auth] opening', authUrl);
    await Browser.open({ url: authUrl });
  },

  async handleRedirectUrl(urlString) {
    if (!urlString || !urlString.startsWith(CONFIG.keycloak.redirectUri)) return false;
    const url = new URL(urlString.replace('xbillr-mobile://', 'https://xbillr.local/'));
    const error = url.searchParams.get('error');
    if (error) throw new Error(url.searchParams.get('error_description') || error);

    const code = url.searchParams.get('code');
    const state = url.searchParams.get('state');
    let saved = pending;
    if (!saved) {
      try { saved = JSON.parse(sessionStorage.getItem('xb.pkce') || 'null'); } catch (_) { saved = null; }
    }
    if (!saved) saved = await storage.getPkce();
    if (!code || !saved || state !== saved.state) throw new Error('Ungültiger Login-Callback.');

    await this.exchangeCode(code, saved.verifier);
    pending = null;
    await storage.clearPkce();
    try { sessionStorage.removeItem('xb.pkce'); } catch (_) { /* ignore */ }
    try { await Browser.close(); } catch (_) { /* ignore */ }
    return true;
  },

  async exchangeCode(code, verifier) {
    const body = new URLSearchParams({
      grant_type: 'authorization_code',
      code,
      redirect_uri: CONFIG.keycloak.redirectUri,
      client_id: CONFIG.keycloak.clientId,
      code_verifier: verifier
    });
    const res = await fetch(CONFIG.keycloak.tokenUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body
    });
    if (!res.ok) throw new Error('Token-Austausch fehlgeschlagen.');
    const json = await res.json();
    await storage.setTokens({
      ...json,
      expires_at: Date.now() + (json.expires_in || 300) * 1000
    });
  },

  async refresh() {
    const tokens = await storage.getTokens();
    if (!tokens?.refresh_token) throw new Error('Kein Refresh-Token.');
    const body = new URLSearchParams({
      grant_type: 'refresh_token',
      refresh_token: tokens.refresh_token,
      client_id: CONFIG.keycloak.clientId
    });
    const res = await fetch(CONFIG.keycloak.tokenUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body
    });
    if (!res.ok) throw new Error('Refresh fehlgeschlagen.');
    const json = await res.json();
    const next = {
      ...tokens,
      ...json,
      expires_at: Date.now() + (json.expires_in || 300) * 1000
    };
    await storage.setTokens(next);
    return next;
  },

  async logout() {
    await storage.clearTokens();
  },

  bindDeepLink(onSuccess, onError) {
    App.addListener('appUrlOpen', async ({ url }) => {
      try {
        if (await this.handleRedirectUrl(url)) onSuccess();
      } catch (e) {
        onError(e);
      }
    });
  }
};
