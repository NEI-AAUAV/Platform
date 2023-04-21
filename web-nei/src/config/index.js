let HOST, PRODUCTION, BASE_URL, WS_SCHEME;


const scheme = {
    WS: "ws://",
    WSS: "wss://",
    HTTP: "http://", // dev only
    HTTPS: "https://",
}


if (process.env.NODE_ENV === 'production') {
    PRODUCTION = true;
    // HOST = 'https://nei-aauav.pt';
    HOST = 'nei.web.ua.pt';
    BASE_URL = `${scheme.HTTPS}${HOST}`;
    WS_SCHEME = scheme.WSS;
} else {
    PRODUCTION = false;
    HOST = 'localhost';
    BASE_URL = `${scheme.HTTP}${HOST}`;
    WS_SCHEME = scheme.WS;
}

const config = {
    PRODUCTION: true,
    HOST,
    BASE_URL,
    NEI_URL: `${BASE_URL}/api/nei/v1`,
    NEI_STATIC_URL: `${BASE_URL}/static/nei`,
    TACAUA_URL: `${BASE_URL}/api/tacaua/v1`,
    FAMILY_URL: `${BASE_URL}/api/family/v1`,
    RALLYTASCAS_URL: `${BASE_URL}/api/rallytascas/v1`,
    WS_URL: `${WS_SCHEME}${HOST}/api/nei/v1`,
    GOOGLE_CALENDAR_URL: `https://www.googleapis.com/calendar/v3`,
    GOOGLE_RECAPTCHA_CDN: `https://www.google.com/recaptcha/api.js`,
    GOOGLE_RECAPTCHA_KEY: `6LejnQ4lAAAAAFsMWR1S2Rw3LJv02KcbdOL-aNUh`,
}

export default config;
