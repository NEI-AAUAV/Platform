/**
 * FamilyService - API client for Family Tree endpoints
 * 
 * Provides methods to interact with the api-family backend.
 * All methods return promises that resolve to the API response data.
 */

import config from "config";
import { createClient } from "./client";

const client = createClient(config.API_FAMILY_URL);

const FamilyService = {
    // ============================================================
    // Tree Endpoints
    // ============================================================

    /**
     * Get the family tree structure
     * @param {Object} params - Query parameters
     * @param {number} [params.depth] - Maximum depth to traverse
     * @returns {Promise} Tree data with nested users
     */
    async getTree(params = {}) {
        return await client.get("/tree/", { params });
    },

    // ============================================================
    // User Endpoints
    // ============================================================

    /**
     * Get list of users with pagination and filters
     * @param {Object} params - Query parameters
     * @param {number} [params.skip=0] - Records to skip
     * @param {number} [params.limit=100] - Max records to return
     * @param {number} [params.from_year] - Filter by start_year >= value
     * @param {number} [params.patrao_id] - Filter by patron ID
     * @returns {Promise} Paginated user list
     */
    async getUsers(params = {}) {
        return await client.get("/user/", { params });
    },

    /**
     * Get a single user by ID
     * @param {number} id - User ID
     * @returns {Promise} User data
     */
    async getUserById(id) {
        return await client.get(`/user/${id}`);
    },

    /**
     * Get children (pedaços) of a user
     * @param {number} id - User ID
     * @returns {Promise} List of children users
     */
    async getUserChildren(id) {
        return await client.get(`/user/${id}/children`);
    },

    /**
     * Create a new user (requires MANAGER_FAMILY scope)
     * @param {Object} data - User data
     * @returns {Promise} Created user
     */
    async createUser(data) {
        return await client.post("/user/", data);
    },

    /**
     * Update a user (requires MANAGER_FAMILY scope)
     * @param {number} id - User ID
     * @param {Object} data - Update data
     * @returns {Promise} Updated user
     */
    async updateUser(id, data) {
        return await client.put(`/user/${id}`, data);
    },

    /**
     * Delete a user (requires MANAGER_FAMILY scope)
     * @param {number} id - User ID
     * @returns {Promise} No content
     */
    async deleteUser(id) {
        return await client.delete(`/user/${id}`);
    },

    // ============================================================
    // Course Endpoints
    // ============================================================

    /**
     * Get list of courses
     * @param {Object} params - Query parameters
     * @param {string} [params.degree] - Filter by degree type
     * @param {boolean} [params.show_only] - Only visible courses
     * @returns {Promise} Paginated course list
     */
    async getCourses(params = {}) {
        return await client.get("/course/", { params });
    },

    /**
     * Get a course by ID
     * @param {number} id - Course ID
     * @returns {Promise} Course data
     */
    async getCourseById(id) {
        return await client.get(`/course/${id}`);
    },

    // ============================================================
    // Role Endpoints
    // ============================================================

    /**
     * Get list of roles
     * @returns {Promise} Role list
     */
    async getRoles() {
        return await client.get("/role/");
    },

    /**
     * Get role tree structure
     * @returns {Promise} Hierarchical role data
     */
    async getRoleTree() {
        return await client.get("/role/tree");
    },

    // ============================================================
    // UserRole Endpoints
    // ============================================================

    /**
     * Get user-role associations with details
     * @param {Object} params - Query parameters
     * @param {number} [params.user_id] - Filter by user
     * @param {string} [params.role_id] - Filter by role
     * @param {number} [params.year] - Filter by year
     * @returns {Promise} User-role associations with details
     */
    async getUserRolesWithDetails(params = {}) {
        return await client.get("/userrole/details", { params });
    },

    /**
     * Get roles for a specific user
     * @param {number} userId - User ID
     * @returns {Promise} User's roles with details
     */
    async getRolesForUser(userId) {
        return await client.get(`/userrole/user/${userId}`);
    },

    /**
     * Assign a role to a user (requires MANAGER_FAMILY scope)
     * @param {Object} data - { user_id, role_id, year }
     * @returns {Promise} Created association
     */
    async assignRole(data) {
        return await client.post("/userrole/", data);
    },

    /**
     * Remove a role from a user (requires MANAGER_FAMILY scope)
     * @param {string} id - UserRole ID
     * @returns {Promise} No content
     */
    async removeRole(id) {
        return await client.delete(`/userrole/${id}`);
    },
};

export default FamilyService;
