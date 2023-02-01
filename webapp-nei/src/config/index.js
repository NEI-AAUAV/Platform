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
    NEI_URL: `${HOST + (PRODUCTION ? '' : ':8000')}/api/nei/v1`,
    TACAUA_URL: `${HOST + (PRODUCTION ? '' : ':8001')}/api/tacaua/v1`,
    RALLYTASCAS_URL:`${HOST + (PRODUCTION ? '' : ':8002')}/api/rallytascas/v1`,
}

export default config;
