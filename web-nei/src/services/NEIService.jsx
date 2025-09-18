import config from "config";
import { createClient } from "./client";

const client = createClient(config.API_NEI_URL);

const NEIService = {
  async getNotes(params) {
    return await client.get("/note", { params });
  },

  async getNotesById(id) {
    return await client.get(`/note/${id}`);
  },

  async getNotesYears(params) {
    return await client.get("/note/year", { params });
  },

  async getNotesSubjects(params) {
    return await client.get("/note/subject", { params });
  },

  async getNotesStudents(params) {
    return await client.get("/note/student", { params });
  },

  async getNotesTeachers(params) {
    return await client.get("/note/teacher", { params });
  },

  async getRGM(params) {
    return await client.get(`/rgm/`, { params });
  },

  async getNotesCurricularYears(params) {
    return await client.get("/note/curricular-year", { params });
  },

  async getHistory() {
    return await client.get("/history/");
  },

  async getRGMMandates() {
    return await client.get(`/rgm/mandates/`);
  },

  async getMerch() {
    return await client.get(`/merch/`);
  },

  async getPartners() {
    return await client.get(`/partner/`);
  },

  async getTeamMembers(params) {
    return await client.get("/team/member/", { params });
  },

  async getTeamMandates(params) {
    return await client.get("/team/member/mandates");
  },

  async getTeamRoles(params) {
    return await client.get("/team/role", { params });
  },

  async getFainaMandates(params) {
    return await client.get("/faina/", { params });
  },

  async getTeamCollaborators(params) {
    return await client.get("/team/colaborator/", { params });
  },

  async getNewsCategories(params) {
    return await client.get("/news/category/", { params });
  },

  async getNewsById(id) {
    return await client.get(`/news/${id}`);
  },

  async getNews(params) {
    return await client.get("/news/", { params });
  },

  async getVideosCategories(params) {
    return await client.get("/video/category/", { params });
  },

  async getVideosById(id) {
    return await client.get(`/video/${id}`);
  },

  async getVideos(params) {
    return await client.get("/video/", { params });
  },

  async getRedirects(params) {
    return await client.get("/redirect/", { params });
  },

  async getSeniorsCourse() {
    return await client.get("/senior/course");
  },

  async getSeniorsCourseYear(course) {
    return await client.get(`/senior/${course}/year`);
  },

  async getSeniorsBy(course, year) {
    return await client.get(`/senior/${course}/${year}`);
  },

  async getCurrUser() {
    return await client.get("/user/me");
  },

  async updateCurrUser(data) {
    return await client.put("/user/me", data);
  },

  async login(data) {
    return await client.post("/auth/login/", data);
  },

  async loginIdP() {
    return await client.get("/auth/token");
  },

  async redirectIdP({ oauthToken, oauthVerifier }) {
    return await client.get("/auth/token/", {
      params: { oauth_token: oauthToken, oauth_verifier: oauthVerifier },
    });
  },

  async register(data) {
    // Increase timeout because the reCaptcha takes a while
    return await client.post("/auth/register/", data, { timeout: 15000 });
  },

  async logout() {
    return await client.post("/auth/logout/");
  },

  async verifyEmail(params) {
    return await client.get("/auth/verify/", { params });
  },

  async forgotPassword(data) {
    return await client.post("/auth/forgot/", data);
  },

  async resetPassword(data, params) {
    return await client.post("/auth/reset/", data, { params });
  },
  async magicLink({ token, password }) {
    const formData = new FormData();
    formData.append("password", password);
    return await client.post(`/auth/magic?token=${token}`, formData);
  },

  async getArraialPoints() {
    return await client.get("/arraial/points");
  },
  
  async updateArraialPoints(data) {
    return await client.put("/arraial/points", data);
  },

  async getArraialLog(limit = 25, offset = 0, filters = {}) {
    const params = { limit, offset, ...filters };
    return await client.get("/arraial/log", { params });
  },

  async rollbackArraial(logId) {
    return await client.post(`/arraial/rollback/${logId}`);
  },

  async getArraialConfig() {
    return await client.get("/arraial/config");
  },

  async setArraialConfig(enabled, paused = false) {
    return await client.put("/arraial/config", { enabled, paused });
  },

  // Admin: Users
  async getUsers() {
    return await client.get("/user/");
  },

  async updateUserScopes(userId, scopes) {
    return await client.put(`/user/${userId}`, { scopes });
  }
};

// Export a singleton service
export default NEIService;
