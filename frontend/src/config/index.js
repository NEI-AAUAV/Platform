let HOST, PRODUCTION;

if(process.env.NODE_ENV === 'production') {
    PRODUCTION = true;
    HOST = 'http://aauav-nei.ua.pt';
} else {
    PRODUCTION = false;
    HOST = 'http://localhost';
}

const config = {
    PRODUCTION,
    HOST, 
    NEI_URL: `${HOST + (PRODUCTION ? '' : ':8000')}/nei/api/v1`,
    TACAUA_URL: `${HOST + (PRODUCTION ? '' : ':8001')}/tacaua/api/v1`,
    RALLYTASCAS_URL:`${HOST + (PRODUCTION ? '' : ':8002')}/rallytascas/api/v1`,
}

export default config;
