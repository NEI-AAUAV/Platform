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
}

export default config;
