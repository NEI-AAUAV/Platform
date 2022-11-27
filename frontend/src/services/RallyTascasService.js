import axios from "axios";
import config from "config";

import { useRallyAuth } from "stores/useRallyAuth";


const client = axios.create({
    baseURL: config.RALLYTASCAS_URL,
    timeout: 5000,
});


client.interceptors.request.use(function(config) {
    // Do something before request is sent

    // Inject here authorization token in request header
    const token = useRallyAuth.getState().token;
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
}, function(error) {
    // Do something with request error
    console.error(error);

    return Promise.reject(error);
});


client.interceptors.response.use(function(response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    // console.log(response)

    return response.data;
}, function(error) {
    // Any status codes that falls outside the range of 2xx cause this function to trigger
    // Do something with response error

    console.error(error);

    const { response: { status } } = error;

    if (status === 401) {
        // Token expired. Retry authentication here
        return Promise.reject("Session Expired");
    }

    return Promise.reject(error);
});


class RallyTascasService {

    async login(data) {
        return await client.post(`/user/token`, data);
    }

    async getOwnTeam() {
        return await client.get(`/team/me`);
    }

    async getTeams() {
        return await client.get('/team');
    }

    async getCheckpoints() {
        return await client.get('/checkpoint');
    }

    async getCurrentCheckpoint() {
        return await client.get('/checkpoint/me');
    }
}

// Export a singleton service
export default new RallyTascasService();
