import axios from "axios";
import { useUserStore } from "stores/useUserStore";
import config from "config";

const UNAUTHORIZED = 401;

let isRefreshing = false;
let refreshSubscribers = [];

/** Add new pending request to wait for a new access token. */
function subscribeTokenRefresh(callback) {
  refreshSubscribers.push(callback);
}

/** Resolve all pending requests with the new access token. */
function processQueue(token = null) {
  for (const callback of refreshSubscribers) {
    callback(token);
  }
  refreshSubscribers = [];
}

/** Attempt to login with refresh token cookie. */
export async function refreshToken() {
  return await axios
    .create({
      baseURL: config.API_NEI_URL,
      timeout: 5000,
      withCredentials: true,
    })
    .post("/auth/refresh")
    .then(({ data: { access_token } }) => {
      useUserStore.getState().login({ token: access_token });
      return access_token;
    })
    .catch(() => {
      useUserStore.getState().logout();
    });
}

/**
 * Replay a request that failed with 401 using the refreshed token.
 *
 * It goes through the same client (not the global axios) so that the response
 * interceptor still unwraps `response.data` for the caller.
 */
function retryRequest(client, config, token) {
  config.retry = true;
  config.headers.Authorization = `Bearer ${token}`;
  return client.request(config);
}

export const createClient = (baseURL) => {
  const client = axios.create({
    baseURL,
    timeout: 5000,
    withCredentials: true,
  });

  client.interceptors.request.use(
    (config) => {
      // Inject the access token in request header
      config.headers.Authorization = `Bearer ${useUserStore.getState().token}`;
      return config;
    },
    (error) => {
      // Do something with request error
      return Promise.reject(error instanceof Error ? error : new Error(error));
    }
  );

  client.interceptors.response.use(
    (response) => {
      // Any status code that lie within the range of 2xx cause this function to trigger
      // Do something with response data
      return response.data;
    },
    async (error) => {
      // Any status codes that falls outside the range of 2xx cause this function to trigger
      // Do something with response error

      const { response, config } = error;

      if (response?.status === UNAUTHORIZED && !config.retry) {
        // Token expired. Retry authentication here
        if (!isRefreshing) {
          isRefreshing = true;
          const token = await refreshToken();
          processQueue(token);
          isRefreshing = false;

          if (token) {
            return retryRequest(client, config, token);
          } else {
            throw new Error("Session Expired");
          }
        } else {
          return new Promise((resolve, reject) => {
            subscribeTokenRefresh((token) => {
              if (token) {
                resolve(retryRequest(client, config, token));
              } else {
                reject(new Error("Session Expired"));
              }
            });
          });
        }
      }
      throw error instanceof Error ? error : new Error(error);
    }
  );
  return client;
};
