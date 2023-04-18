import axios from "axios";
import config from "config";
import { useUserStore } from "stores/useUserStore";

const client = axios.create({
  baseURL: config.NEI_URL,
  timeout: 5000,
});

const UNAUTHORIZED = 401;
const MAX_RETRIES = 3;

let isRefreshing = false;
let refreshSubscribers = [];

/** Attempt to login with refresh token cookie. */
async function refreshToken() {
  return client.post("/auth/refresh/").then(({ access_token }) => {
    client.defaults.headers.common.Authorization = `Bearer ${access_token}`;
    useUserStore.getState().login({ token: access_token });
    return access_token;
  });
};

/** Add new pending request to wait for a new access token. */
function subscribeTokenRefresh(callback) {
  refreshSubscribers.push(callback);
}

/* Resolve all pending requests with the new access token. */
function processQueue(error, token = null) {
  refreshSubscribers.map((callback) => callback(token));
  refreshSubscribers = [];
}

client.interceptors.request.use(
  (config) => {
    // Do something before request is sent

    return config;
  },
  (error) => {
    // Do something with request error
    console.error(error);

    return Promise.reject(error);
  }
);

client.interceptors.response.use(
  (response) => {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    // console.log(response)

    return response.data;
  },
  async (error) => {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error

    console.error(error);

    const {
      response: { status },
    } = error;

    if (status === UNAUTHORIZED) {
      // Token expired. Retry authentication here
      if (!isRefreshing) {
        isRefreshing = true;

        try {
          const token = await refreshToken();
          // Inject the access token in request header
          config.headers.Authorization = `Bearer ${token}`;
          processQueue(null, token);
          return client.request(config);
        } catch (e) {
          processQueue(e, null);
          return Promise.reject("Session Expired");
        } finally {
          isRefreshing = false;
        }
      } else {
        return new Promise((resolve) => {
          subscribeTokenRefresh((token) => {
            config.headers.Authorization = `Bearer ${token}`;
            resolve(client.request(config));
          });
        });
      }
    }

    return Promise.reject(error);
  }
);

class NEIService {
  constructor() {
    refreshToken();
  }

  async getNotes(params) {
    return await client.get("/note", { params });
  }

  async getNotesById(id) {
    return await client.get(`/note/${id}`);
  }

  async getNotesYears(params) {
    return await client.get("/note/year", { params });
  }

  async getNotesSubjects(params) {
    return await client.get("/note/subject", { params });
  }

  async getNotesStudents(params) {
    return await client.get("/note/student", { params });
  }

  async getNotesTeachers(params) {
    return await client.get("/note/teacher", { params });
  }

  async getRGM(params) {
    return await client.get(`/rgm/`, { params });
  }

  async getNotesCurricularYears(params) {
    return await client.get("/note/curricular-year", { params });
  }

  async getHistory() {
    return await client.get("/history/");
  }

  async getRGMMandates() {
    return await client.get(`/rgm/mandates/`);
  }

  async getMerch() {
    return await client.get(`/merch/`);
  }

  async getPartners() {
    return await client.get(`/partner/`);
  }

  async getTeamMembers(params) {
    return await client.get("/team/member/", { params });
  }

  async getTeamMandates(params) {
    return await client.get("/team/member/mandates");
  }

  async getTeamRoles(params) {
    return await client.get("/team/role", { params });
  }

  async getTeamCollaborators(params) {
    return await client.get("/team/colaborator/", { params });
  }

  async getFainaMandates(params) {
    return await client.get("/faina/", { params });
  }

  async getTeamCollaborators(params) {
    return await client.get("/team/colaborator/", { params });
  }

  async getNewsCategories(params) {
    return await client.get("/news/category/", { params });
  }

  async getNewsById(id) {
    return await client.get(`/news/${id}`);
  }

  async getNews(params) {
    return await client.get("/news/", { params });
  }

  async getVideosCategories(params) {
    return await client.get("/video/category/", { params });
  }

  async getVideosById(id) {
    return await client.get(`/video/${id}`);
  }

  async getVideos(params) {
    return await client.get("/video/", { params });
  }

  async getRedirects(params) {
    return await client.get("/redirect/", { params });
  }

  async getSeniorsCourse() {
    return await client.get("/senior/course");
  }

  async getSeniorsCourseYear(course) {
    return await client.get(`/senior/${course}/year`);
  }

  async getSeniorsBy(course, year) {
    return await client.get(`/senior/${course}/${year}`);
  }

  async getCurrUser() {
    return await client.get("/user/me");
  }

  async updateCurrUser(data) {
    return await client.put("/user/me", data);
  }

  async login(data) {
    return await client.post("/auth/login/", data);
  }

  async loginIdP() {
    return await client.get("/auth/token");
  }

  async redirectIdP({ oauthToken, oauthVerifier }) {
    return await client.get("/auth/token/", {
      params: { oauth_token: oauthToken, oauth_verifier: oauthVerifier },
    });
  }

  async register(data) {
    // Increase timeout because the reCaptcha takes a while
    return await client.post("/auth/register/", data, { timeout: 15000 });
  }

  async verifyEmail(params) {
    return await client.get("/auth/verify/", { params });
  }

  async forgotPassword(data) {
    return await client.post("/auth/forgot/", data);
  }

  async resetPassword(data, params) {
    return await client.post("/auth/reset/", data, { params });
  }
}

// Export a singleton service
export default new NEIService();
