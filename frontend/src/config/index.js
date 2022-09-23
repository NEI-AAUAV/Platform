const config = {
    
}

if(process.env.NODE_ENV === 'production') {
    config.PRODUCTION = true;
} else {
    config.PRODUCTION = false;
}

export default config;