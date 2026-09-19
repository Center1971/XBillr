export const CONFIG = {
  apiBase: 'https://www.xbillr.eu/api',
  keycloak: {
    authUrl: 'https://iam.smetools.eu/realms/SME%20Tools/protocol/openid-connect/auth',
    tokenUrl: 'https://iam.smetools.eu/realms/SME%20Tools/protocol/openid-connect/token',
    clientId: 'xbillr-mobile',
    redirectUri: 'xbillr-mobile://oauth/callback',
    scopes: 'openid profile email'
  },
  brand: { yellow: '#FABC3D', orange: '#F4781E', blue: '#091638' }
};
