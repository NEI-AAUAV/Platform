import config from "config";
import { createClient } from "./client";

const client = createClient(config.API_TACAUA_URL);

const TacaUAService = {
  //----Modalidade----
  async getModalitys() {
    return await client.get("/modality/");
  },

  async createModality(params, image) {
    let data = new FormData();
    data.append("image", image, image.name);
    data.append("modality", params);
    return await client.post("/modality", data);
  },

  async getModalitybyId(id) {
    return await client.get(`/modality/${id}`);
  },

  async updateModality(id, params, image) {
    let data = new FormData();
    data.append("image", image, image.name);
    data.append("modality", params);
    return await client.put(`/modality/${id}`, data);
  },

  async removeModality(id) {
    return await client.delete(`/modality/${id}`);
  },

  //----Competiçao----
  async createCompetition(params) {
    return await client.post("/competition/", { params });
  },

  async updateCompetition(id, params) {
    return await client.put(`/competition/${id}`, { params });
  },

  async removeCompetition(id) {
    return await client.delete(`/competition/${id}`);
  },

  //----Equipa----
  async createTeam(params, image) {
    let data = new FormData();
    data.append("image", image, image.name);
    data.append("team", params);
    return await client.post("/team/", data);
  },

  async updateTeam(id, params, image) {
    let data = new FormData();
    data.append("image", image, image.name);
    data.append("team", params);
    return await client.put(`/team/${id}`, data);
  },

  async removeTeam(id) {
    return await client.delete(`/team/${id}`);
  },

  //----Participante----
  async createParticipant(params) {
    return await client.post("/participant/", { params });
  },

  async updateParticipant(id, params) {
    return await client.put(`/participant/${id}`, { params });
  },

  async removeParticipant(id) {
    return await client.delete(`/participant/${id}`);
  },

  //----Curso----
  async getCourses() {
    return await client.get("/course/");
  },

  async createCourse(params) {
    return await client.post("/course", { params });
  },

  async getCoursebyId(id) {
    return await client.get(`/course/${id}`);
  },

  async updateCourse(id, params) {
    return await client.put(`/course/${id}`, { params });
  },

  async removeCourse(id) {
    return await client.delete(`/course/${id}`);
  },

  //----Grupo----
  async createGroup(params) {
    return await client.post("/group/", { params });
  },

  async updateGroup(id, params) {
    return await client.put(`/group/${id}`, { params });
  },

  async removeGroup(id) {
    return await client.delete(`/group/${id}`);
  },

  //----Match----
  async updateMatch(id, params) {
    return await client.put(`/match/${id}`, { params });
  },
};

export default TacaUAService;
