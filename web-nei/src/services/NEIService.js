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
        return await client.get('/note', { params });
    }

    async getNotesById(id) {
        return await client.get(`/note/${id}`);
    }

    async getNotesThanks() {
        return await client.get('/note/thank');
    }

    async getNotesYears(params) {
        return await client.get('/note/year', { params });
    }

    async getNotesSubjects(params) {
        return await client.get('/note/subject', { params });
    }

    async getNotesStudents(params) {
        return await client.get('/note/student', { params });
    }

    async getNotesTeachers(params) {
        return await client.get('/note/teacher', { params });
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
        return await client.get(`/partner/`)
    }

    async getPartnersBanner() {
        return await client.get(`/partner/banner/`)
    }

    async getTeamMandates(params) {
        return await client.get('/team/member/', { params });
    }

    async getTeamRoles(params) {
        return await client.get('/team/role', { params });
    }

    async getTeamColaborators(params) {
        return await client.get('/team/colaborator/', { params });
    }

    async getFainaMandates(params) {
        return await client.get('/faina/', { params });
    }

    async getNewsCategories(params) {
        return await client.get('/news/category/', { params });
    }

    async getNewsById(id) {
        return await client.get(`/news/${id}`);
    }

    async getNews(params) {
        return await client.get('/news/', { params });
    }

    async getVideosCategories(params) {
        return await client.get('/video/category/', { params });
    }

    async getVideosById(id) {
        return await client.get(`/video/${id}`);
    }

    async getVideos(params) {
        return await client.get('/video/', { params });
    }

    async getRedirects(params) {
        return await client.get('/redirect/', { params });
    }

    async getSeniorsCourse() {
        return await client.get('/senior/course');
    }

    async getSeniorsCourseYear(course) {
        return await client.get(`/senior/${course}/year`);
    }

    async getSeniorsBy(course, year) {
        return await client.get(`/senior/${course}/${year}`);
    }
}

// Export a singleton service
export default new NEIService();