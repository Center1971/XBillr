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

export function errMessage(e) {
  if (!e) return 'Unbekannter Fehler';
  if (typeof e === 'string') return e;
  return e.message || e.errorMessage || e.code || JSON.stringify(e) || String(e);
}

export { plugin };

/** Öffnet https-URLs im System-/In-App-Browser (OAuth). */
async function openExternal(url) {
  const B = plugin('Browser');
  if (B?.open) {
    try {
      await B.open({ url });
      return;
    } catch (e1) {
      try { await B.close?.(); } catch (_) { /* ignore */ }
      try {
        await B.open({ url, presentationStyle: 'popover' });
        return;
      } catch (e2) {
        console.warn('[Browser.open failed]', errMessage(e1), errMessage(e2));
      }
    }
  }

  // Fallback: System-Safari / Chrome (iam darf NICHT in allowNavigation stehen)
  const opened = window.open(url, '_blank', 'noopener,noreferrer');
  if (opened) return;

  const a = document.createElement('a');
  a.href = url;
  a.target = '_blank';
  a.rel = 'noopener noreferrer';
  document.body.appendChild(a);
  a.click();
  a.remove();
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
    await openExternal(url);
  },
  async close() {
    const B = plugin('Browser');
    if (B?.close) {
      try { await B.close(); } catch (_) { /* ignore */ }
    }
  }
};

export const App = {
  addListener(event, cb) {
    const A = plugin('App');
    if (A?.addListener) return A.addListener(event, cb);
    return { remove: () => {} };
  },
  async getState() {
    const A = plugin('App');
    if (A?.getState) return A.getState();
    return { isActive: true };
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
