import { describe, it, expect, vi, beforeEach } from 'vitest';
import FamilyService from '../../services/FamilyService';

// Mock the client module
vi.mock('../../services/client', () => ({
    createClient: () => ({
        get: vi.fn(),
        post: vi.fn(),
        put: vi.fn(),
        delete: vi.fn(),
    }),
}));

// Get the mocked client
import { createClient } from '../../services/client';

describe('FamilyService', () => {
    let mockClient;

    beforeEach(() => {
        vi.clearAllMocks();
        mockClient = createClient();
    });

    describe('Tree Endpoints', () => {
        it('getTree calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue({ roots: [], total_users: 0 });

            await FamilyService.getTree();

            expect(mockClient.get).toHaveBeenCalledWith('/tree/', { params: {} });
        });

        it('getTree passes depth parameter', async () => {
            mockClient.get.mockResolvedValue({ roots: [] });

            await FamilyService.getTree({ depth: 5 });

            expect(mockClient.get).toHaveBeenCalledWith('/tree/', { params: { depth: 5 } });
        });
    });

    describe('User Endpoints', () => {
        it('getUsers calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getUsers();

            expect(mockClient.get).toHaveBeenCalledWith('/user/', { params: {} });
        });

        it('getUsers passes filter parameters', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getUsers({ skip: 10, limit: 50, from_year: 2020 });

            expect(mockClient.get).toHaveBeenCalledWith('/user/', {
                params: { skip: 10, limit: 50, from_year: 2020 }
            });
        });

        it('getYears calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([2020, 2021, 2022]);

            await FamilyService.getYears();

            expect(mockClient.get).toHaveBeenCalledWith('/user/years');
        });

        it('getUserById calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue({ id: 1, name: 'Test' });

            await FamilyService.getUserById(1);

            expect(mockClient.get).toHaveBeenCalledWith('/user/1');
        });

        it('getUserChildren calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getUserChildren(1);

            expect(mockClient.get).toHaveBeenCalledWith('/user/1/children');
        });

        it('createUser calls correct endpoint', async () => {
            const userData = { name: 'Test User', sex: 'M', start_year: 2020 };
            mockClient.post.mockResolvedValue({ id: 1, ...userData });

            await FamilyService.createUser(userData);

            expect(mockClient.post).toHaveBeenCalledWith('/user/', userData);
        });

        it('updateUser calls correct endpoint', async () => {
            const userData = { name: 'Updated Name' };
            mockClient.put.mockResolvedValue({ id: 1, ...userData });

            await FamilyService.updateUser(1, userData);

            expect(mockClient.put).toHaveBeenCalledWith('/user/1', userData);
        });

        it('deleteUser calls correct endpoint', async () => {
            mockClient.delete.mockResolvedValue(null);

            await FamilyService.deleteUser(1);

            expect(mockClient.delete).toHaveBeenCalledWith('/user/1');
        });

        it('bulkCreateUsers calls correct endpoint with options', async () => {
            const users = [{ name: 'User1' }, { name: 'User2' }];
            mockClient.post.mockResolvedValue({ created: 2 });

            await FamilyService.bulkCreateUsers(users, { dry_run: true, atomic: true });

            expect(mockClient.post).toHaveBeenCalledWith('/user/bulk', users, {
                params: { dry_run: true, atomic: true }
            });
        });
    });

    describe('Course Endpoints', () => {
        it('getCourses calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getCourses();

            expect(mockClient.get).toHaveBeenCalledWith('/course/', { params: {} });
        });

        it('getCourseById calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue({ id: 1 });

            await FamilyService.getCourseById(1);

            expect(mockClient.get).toHaveBeenCalledWith('/course/1');
        });

        it('createCourse calls correct endpoint', async () => {
            const courseData = { name: 'Test Course', degree: 'BSc' };
            mockClient.post.mockResolvedValue({ id: 1, ...courseData });

            await FamilyService.createCourse(courseData);

            expect(mockClient.post).toHaveBeenCalledWith('/course/', courseData);
        });

        it('updateCourse calls correct endpoint', async () => {
            const courseData = { name: 'Updated Course' };
            mockClient.put.mockResolvedValue({ id: 1, ...courseData });

            await FamilyService.updateCourse(1, courseData);

            expect(mockClient.put).toHaveBeenCalledWith('/course/1', courseData);
        });

        it('deleteCourse calls correct endpoint', async () => {
            mockClient.delete.mockResolvedValue(null);

            await FamilyService.deleteCourse(1);

            expect(mockClient.delete).toHaveBeenCalledWith('/course/1');
        });
    });

    describe('Role Endpoints', () => {
        it('getRoles calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getRoles();

            expect(mockClient.get).toHaveBeenCalledWith('/role/');
        });

        it('getRoleTree calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue({ children: [] });

            await FamilyService.getRoleTree();

            expect(mockClient.get).toHaveBeenCalledWith('/role/tree');
        });

        it('createRole calls correct endpoint', async () => {
            const roleData = { id: 'CF.new', name: 'New Role' };
            mockClient.post.mockResolvedValue(roleData);

            await FamilyService.createRole(roleData);

            expect(mockClient.post).toHaveBeenCalledWith('/role/', roleData);
        });

        it('updateRole calls correct endpoint', async () => {
            const roleData = { name: 'Updated Role' };
            mockClient.put.mockResolvedValue({ id: 'CF', ...roleData });

            await FamilyService.updateRole('CF', roleData);

            expect(mockClient.put).toHaveBeenCalledWith('/role/CF', roleData);
        });

        it('deleteRole calls correct endpoint', async () => {
            mockClient.delete.mockResolvedValue(null);

            await FamilyService.deleteRole('CF.old');

            expect(mockClient.delete).toHaveBeenCalledWith('/role/CF.old');
        });
    });

    describe('UserRole Endpoints', () => {
        it('getUserRolesWithDetails calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getUserRolesWithDetails();

            expect(mockClient.get).toHaveBeenCalledWith('/userrole/details', { params: {} });
        });

        it('getUserRolesWithDetails passes filter parameters', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getUserRolesWithDetails({ user_id: 1, year: 2024 });

            expect(mockClient.get).toHaveBeenCalledWith('/userrole/details', {
                params: { user_id: 1, year: 2024 }
            });
        });

        it('getRolesForUser calls correct endpoint', async () => {
            mockClient.get.mockResolvedValue([]);

            await FamilyService.getRolesForUser(1);

            expect(mockClient.get).toHaveBeenCalledWith('/userrole/user/1');
        });

        it('assignRole calls correct endpoint', async () => {
            const data = { user_id: 1, role_id: 'CF', year: 2024 };
            mockClient.post.mockResolvedValue({ id: 'abc123', ...data });

            await FamilyService.assignRole(data);

            expect(mockClient.post).toHaveBeenCalledWith('/userrole/', data);
        });

        it('removeRole calls correct endpoint', async () => {
            mockClient.delete.mockResolvedValue(null);

            await FamilyService.removeRole('abc123');

            expect(mockClient.delete).toHaveBeenCalledWith('/userrole/abc123');
        });
    });
});
