/** Capacitor-Plugins ohne Bundler – registerPlugin spricht die native Bridge an. */

function cap() {
  return window.Capacitor;
}

function platform() {
  return cap()?.getPlatform?.() || 'web';
}

function plugin(name) {
  const C = cap();
  if (!C) return null;
  if (C.Plugins?.[name]) return C.Plugins[name];
  if (typeof C.registerPlugin === 'function') {
    try { return C.registerPlugin(name); } catch (_) { return null; }
  }
  return null;
}

export const Preferences = {
  async get({ key }) {
    const P = plugin('Preferences');
    if (P?.get) return P.get({ key });
    return { value: localStorage.getItem(key) };
  },
  async set({ key, value }) {
    const P = plugin('Preferences');
    if (P?.set) return P.set({ key, value });
    localStorage.setItem(key, value);
  },
  async remove({ key }) {
    const P = plugin('Preferences');
    if (P?.remove) return P.remove({ key });
    localStorage.removeItem(key);
  }
};

export const Browser = {
  async open({ url }) {
    const B = plugin('Browser');
    if (B?.open) {
      return B.open({ url, presentationStyle: 'fullscreen' });
    }
    // WebView blockiert window.open oft – explizit fehlschlagen
    throw new Error('Browser-Plugin nicht verfügbar. App neu bauen (cap sync).');
  },
  async close() {
    const B = plugin('Browser');
    if (B?.close) return B.close();
  }
};

export const App = {
  addListener(event, cb) {
    const A = plugin('App');
    if (A?.addListener) return A.addListener(event, cb);
    return { remove: () => {} };
  }
};

export const Network = {
  async getStatus() {
    const N = plugin('Network');
    if (N?.getStatus) return N.getStatus();
    return { connected: navigator.onLine, connectionType: 'unknown' };
  },
  addListener(event, cb) {
    const N = plugin('Network');
    if (N?.addListener) return N.addListener(event, cb);
    const handler = () => cb({ connected: navigator.onLine });
    window.addEventListener('online', handler);
    window.addEventListener('offline', handler);
    return { remove: () => {
      window.removeEventListener('online', handler);
      window.removeEventListener('offline', handler);
    } };
  }
};

export const StatusBar = {
  async setStyle({ style }) {
    const S = plugin('StatusBar');
    if (S?.setStyle) return S.setStyle({ style });
  },
  async setBackgroundColor({ color }) {
    if (platform() !== 'android') return;
    const S = plugin('StatusBar');
    if (S?.setBackgroundColor) return S.setBackgroundColor({ color });
  }
};

export const Style = { Dark: 'DARK', Light: 'LIGHT' };
