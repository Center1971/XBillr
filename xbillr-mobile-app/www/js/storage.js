import { Preferences } from './native.js';

const KEYS = {
  tokens: 'xb.tokens',
  cache: 'xb.cache',
  queue: 'xb.queue',
  pkce: 'xb.pkce'
};

async function getJson(key, fallback) {
  const { value } = await Preferences.get({ key });
  if (!value) return fallback;
  try { return JSON.parse(value); } catch { return fallback; }
}

async function setJson(key, value) {
  await Preferences.set({ key, value: JSON.stringify(value) });
}

export const storage = {
  async getTokens() { return getJson(KEYS.tokens, null); },
  async setTokens(tokens) { return setJson(KEYS.tokens, tokens); },
  async clearTokens() { return Preferences.remove({ key: KEYS.tokens }); },

  async getPkce() { return getJson(KEYS.pkce, null); },
  async setPkce(pkce) { return setJson(KEYS.pkce, pkce); },
  async clearPkce() { return Preferences.remove({ key: KEYS.pkce }); },

  async getCache() {
    return getJson(KEYS.cache, {
      me: null,
      tenant: null,
      profile: null,
      customers: [],
      invoices: [],
      countries: [],
      updatedAt: null
    });
  },
  async setCache(cache) { return setJson(KEYS.cache, cache); },

  async getQueue() { return getJson(KEYS.queue, []); },
  async setQueue(queue) { return setJson(KEYS.queue, queue); },

  async enqueue(item) {
    const queue = await this.getQueue();
    queue.push({ ...item, queuedAt: Date.now(), localId: crypto.randomUUID() });
    await this.setQueue(queue);
  }
};
