let HOST, PRODUCTION, BASE_URL, WS_SCHEME;

const scheme = {
  WS: "ws://",
  WSS: "wss://",
  HTTP: "http://",
  HTTPS: "https://",
};

if (import.meta.env.PROD) {
  // HOST = 'https://nei-aauav.pt';
  HOST = "nei.web.ua.pt";
  BASE_URL = `${scheme.HTTPS}${HOST}`;
  WS_SCHEME = scheme.WSS;
} else {
  HOST = "localhost";
  BASE_URL = `${scheme.HTTP}${HOST}`;
  WS_SCHEME = scheme.WS;
}

const config = {
  PRODUCTION: import.meta.env.PROD,
  HOST,
  BASE_URL,
  STATIC_NEI_URL: `${BASE_URL}/static/nei`,
  API_NEI_URL: `${BASE_URL}/api/nei/v1`,
  API_TACAUA_URL: `${BASE_URL}/api/tacaua/v1`,
  API_FAMILY_URL: `${BASE_URL}/api/family/v1`,
  WS_URL: `${WS_SCHEME}${HOST}/api/nei/v1`,
  WEB_GALA_URL: `${BASE_URL}/gala`,
  WEB_RALLY_URL: `${BASE_URL}/rally`,
  ENABLE_GALA: import.meta.env.VITE_ENABLE_GALA === "True",
  ENABLE_RALLY: import.meta.env.VITE_ENABLE_RALLY === "True",
  GOOGLE_CALENDAR_URL: `https://www.googleapis.com/calendar/v3`,
  GOOGLE_RECAPTCHA_CDN: `https://www.google.com/recaptcha/api.js`,
  GOOGLE_RECAPTCHA_KEY: `6LejnQ4lAAAAAFsMWR1S2Rw3LJv02KcbdOL-aNUh`,
};

export default config;
