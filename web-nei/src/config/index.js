let HOST, PRODUCTION;

if(process.env.NODE_ENV === 'production') {
    PRODUCTION = true;
    // HOST = 'https://nei-aauav.pt';
    HOST = 'https://nei.web.ua.pt';
} else {
    PRODUCTION = false;
    HOST = 'http://localhost';
}

const config = {
    PRODUCTION,
    HOST, 
    NEI_URL: `${HOST}/api/nei/v1`,
    TACAUA_URL: `${HOST}/api/tacaua/v1`,
    FAMILY_URL: `${HOST}/api/family/v1`,
    RALLYTASCAS_URL:`${HOST}/api/rallytascas/v1`,
    GOOGLE_CALENDAR_URL: `https://www.googleapis.com/calendar/v3`,
    GOOGLE_RECAPTCHA_CDN: `https://www.google.com/recaptcha/api.js`,
    GOOGLE_RECAPTCHA_KEY: `6LejnQ4lAAAAAFsMWR1S2Rw3LJv02KcbdOL-aNUh`,
}

export default config;
