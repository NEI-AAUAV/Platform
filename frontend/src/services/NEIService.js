import axios from "axios";
import { NEI_URL } from "config";


let instance = null;

const client = axios.create({
    baseURL: NEI_URL,
    timeout: 5000,
});

client.interceptors.request.use(function (config) {
    // Do something before request is sent

    // Inject here authorization token in request header

    return config;
}, function (error) {
    // Do something with request error
    console.error(error);

    return Promise.reject(error);
});


client.interceptors.response.use(function (response) {
    // Any status code that lie within the range of 2xx cause this function to trigger
    // Do something with response data
    // console.log(response)

    return response.data;
}, function (error) {
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


class NEIService {

    constructor() {
        if (!instance) {
            instance = this;
        }
        return instance;
    }

    async getNotes() {
        return await client.get(`/notes`, { params: { category: ['ola'] } });
    }

    async getNotesById(id) {
        return await client.get(`/notes/${id}`);
    }

}

export default NEIService();
