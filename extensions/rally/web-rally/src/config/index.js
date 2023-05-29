let HOST, PRODUCTION, BASE_URL, WS_SCHEME;

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
  API_RALLY_URL: `${BASE_URL}/api/rally/v1`,
};

export default config;
