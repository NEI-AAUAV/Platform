import axios from "axios";
import { useUserStore } from "@/stores/useUserStore.ts";
import config from "@/config";

const UNAUTHORIZED = 401;

let isRefreshing = false;
let refreshSubscribers: ((token?: string) => void) [] = [];

/** Add new pending request to wait for a new access token. */
function subscribeTokenRefresh(callback: (token?: string) => void) {
  refreshSubscribers.push(callback);
}

/** Resolve all pending requests with the new access token. */
function processQueue(token?: string) {
  refreshSubscribers.map((callback) => callback(token));
  refreshSubscribers = [];
}

/** Attempt to login with refresh token cookie. */
export async function refreshToken() {
  return await axios
    .create({
      baseURL: config.API_NEI_URL,
      timeout: 5000,
      headers: {
        Authorization: `Bearer ${useUserStore.getState().token}`,
      },
    })
    .post("/auth/refresh/")
    .then(({ data: { access_token } }) => {
      useUserStore.getState().login({ token: access_token });
      return access_token;
    })
    .catch(() => {
      useUserStore.getState().logout();
    });
}

export const createClient = (baseURL?: string) => {
  const client = axios.create({
    baseURL,
    timeout: 5000,
  });

  client.interceptors.request.use(
    (config) => {
      // Inject the access token in request header
      config.headers.Authorization = `Bearer ${useUserStore.getState().token}`;
      return config;
    },
    (error) => {
      // Do something with request error
      return Promise.reject(error);
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
            config.retry = true;
            return axios.request(config);
          } else {
            return Promise.reject("Session Expired");
          }
        } else {
          return new Promise((resolve) => {
            subscribeTokenRefresh((token?: string) => {
              config.headers.Authorization = `Bearer ${token}`;
              resolve(axios.request(config));
            });
          });
        }
      }
      return Promise.reject(error);
    }
  );
  return client;
};
