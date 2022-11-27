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

    async getHistory() {
        return await client.get('/history/');
    }

    async getRGM(category) {
        return await client.get(`/rgm/${category}`)
    }

    async getMerch() {
        return await client.get(`/merch/`)
    }

    async getPartners() {
        return await client.get(`/partners/`)
    }

    async getPartnersBanner() {
        return await client.get(`/partners/banner/`)
    }

    async getTeamMandates(params) {
        return await client.get('/team/', { params });
    }

    async getTeamRoles(params) {
        return await client.get('/team/roles', { params });
    }

    async getTeamColaborators(params) {
        return await client.get('/team/colaborators/', { params });
    }

    async getFainaMandates(params) {
        return await client.get('/faina/', { params });
    }

    async getNewsCategories(params) {
        return await client.get('/news/categories/', { params });
    }

    async getNewsById(id) {
        return await client.get(`/news/${id}`);
    }

    async getNews(params) {
        return await client.get('/news/', { params });
    }

    async getVideosCategories(params) {
        return await client.get('/videos/categories/', { params });
    }

    async getVideosById(id) {
        return await client.get(`/videos/${id}`);
    }

    async getVideos(params) {
        return await client.get('/videos/', { params });
    }

    async getRedirects(params) {
        return await client.get('/redirects/', { params });
    }

    async getSeniorsCourse() {
        return await client.get('/seniors/course');
    }

    async getSeniorsCourseYear(course) {
        return await client.get(`/seniors/${course}/year`);
    }

    async getSeniorsBy(course, year) {
        return await client.get(`/seniors/${course}/${year}`);
    }
}

// Export a singleton service
export default new NEIService();
