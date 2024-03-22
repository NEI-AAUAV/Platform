let HOST;
let PRODUCTION;
let BASE_URL;

const scheme = {
  HTTP: "http://",
  HTTPS: "https://",
};

if (process.env.NODE_ENV === "production") {
  PRODUCTION = true;
  // HOST = 'https://nei-aauav.pt';
  HOST = "nei.web.ua.pt";
  BASE_URL = `${scheme.HTTPS}${HOST}`;
} else {
  PRODUCTION = false;
  HOST = "localhost";
  BASE_URL = `${scheme.HTTP}${HOST}`;
}

const config = {
  PRODUCTION,
  HOST,
  BASE_URL,
  STATIC_NEI_URL: `${BASE_URL}/static/nei`,
  API_NEI_URL: `${BASE_URL}/api/nei/v1`,
  API_TACAUA_URL: `${BASE_URL}/api/tacaua/v1`,
  API_FAMILY_URL: `${BASE_URL}/api/family/v1`,
  WEB_NEI_URL: `${BASE_URL}/`,
};

export default config;
