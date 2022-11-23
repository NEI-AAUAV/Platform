import axios from "axios";
import config from "config";


const client = axios.create({
    baseURL: config.NEI_URL,
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

    async getNotes(params) {
        return await client.get('/notes', { params });
    }

    async getNotesById(id) {
        return await client.get(`/notes/${id}`);
    }

    async getNotesThanks() {
        return await client.get('/notes/thanks');
    }

    async getNotesYears(params) {
        return await client.get('/notes/years', { params });
    }

    async getNotesSubjects(params) {
        return await client.get('/notes/subjects', { params });
    }

    async getNotesStudents(params) {
        return await client.get('/notes/students', { params });
    }

    async getNotesTeachers(params) {
        return await client.get('/notes/teachers', { params });
    }

    async getTeamMandates(params) {
        return await client.get('/team/mandates/', { params });
    }

    async getSeniorsStudents(params) {
        return await client.get('/seniors/students/', { params });
    }

    async getSeniorsYears(params) {
        return await client.get('/seniors/', { params });
    }

    async getVideosCategories(params) {
        return await client.get('/videos/categories/', { params });
    }

    async getVideos(params, url) {
        return await client.get('/videos/', { params });
    }
}

// Export a singleton service
export default new NEIService();
