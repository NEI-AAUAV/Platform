import config from "config";
import { createClient } from "./client";

const client = createClient(config.API_TACAUA_URL);

const TacaUAService = {
  //----Modalidade----
  async getModalities() {
    return await client.get("/modalities/");
  },

  async createModality(data) {
    return await client.post("/modalities", data);
  },

  async getModalitybyId(id) {
    return await client.get(`/modalities/${id}`);
  },

  async updateModality(id, data) {
    return await client.put(`/modalities/${id}`, data);
  },

  async removeModality(id) {
    return await client.delete(`/modalities/${id}`);
  },

  //----Competiçao----
  async createCompetition(data) {
    return await client.post("/competitions/", data);
  },

  async updateCompetition(id, data) {
    return await client.put(`/competitions/${id}`, data);
  },

  async removeCompetition(id) {
    return await client.delete(`/competitions/${id}`);
  },

  //----Equipa----
  async createTeam(data) {
    return await client.post("/teams/", data);
  },

  async updateTeam(id, data) {
    return await client.put(`/teams/${id}`, data);
  },

  async removeTeam(id) {
    return await client.delete(`/teams/${id}`);
  },

  //----Participante----
  async createParticipant(data) {
    return await client.post("/participants/", data);
  },

  async updateParticipant(id, data) {
    return await client.put(`/participants/${id}`, data);
  },

  async removeParticipant(id) {
    return await client.delete(`/participants/${id}`);
  },

  //----Curso----
  async getCourses() {
    return await client.get("/courses/");
  },

  async createCourse(data) {
    return await client.post("/courses", data);
  },

  async getCoursebyId(id) {
    return await client.get(`/courses/${id}`);
  },

  async updateCourse(id, data) {
    return await client.put(`/courses/${id}`, data);
  },

  async removeCourse(id) {
    return await client.delete(`/courses/${id}`);
  },

  //----Grupo----
  async createGroup(data) {
    return await client.post("/groups/", data);
  },

  async updateGroup(id, data) {
    return await client.put(`/groups/${id}`, data);
  },

  async removeGroup(id) {
    return await client.delete(`/groups/${id}`);
  },

  async addTeamToGroup(id, data) {
    return await client.post(`/groups/${id}/teams`, data);
  },

  //----Match----
  async updateMatch(id, data) {
    return await client.put(`/matchs/${id}`, data);
  },

  //----Standing----
  async getStanding(id) {
    return await client.get(`/standings/${id}`);
  },

  async createStanding(data) {
    return await client.post("/standings/", data);
  },
};

export default TacaUAService;
