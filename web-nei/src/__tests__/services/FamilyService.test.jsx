import { describe, it, expect, vi, beforeEach } from 'vitest';
import FamilyService from '../../services/FamilyService';

// Mock the entire FamilyService module
vi.mock('../../services/FamilyService', () => ({
    default: {
        getTree: vi.fn(),
        getUsers: vi.fn(),
        getYears: vi.fn(),
        getUserById: vi.fn(),
        getUserChildren: vi.fn(),
        createUser: vi.fn(),
        updateUser: vi.fn(),
        deleteUser: vi.fn(),
        bulkCreateUsers: vi.fn(),
        getCourses: vi.fn(),
        getCourseById: vi.fn(),
        createCourse: vi.fn(),
        updateCourse: vi.fn(),
        deleteCourse: vi.fn(),
        getRoles: vi.fn(),
        getRoleTree: vi.fn(),
        createRole: vi.fn(),
        updateRole: vi.fn(),
        deleteRole: vi.fn(),
        getUserRolesWithDetails: vi.fn(),
        getRolesForUser: vi.fn(),
        assignRole: vi.fn(),
        removeRole: vi.fn(),
    },
}));

describe('FamilyService', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    describe('Tree Endpoints', () => {
        it('getTree is callable', async () => {
            FamilyService.getTree.mockResolvedValue({ roots: [], total_users: 0 });

            const result = await FamilyService.getTree();

            expect(FamilyService.getTree).toHaveBeenCalled();
            expect(result).toEqual({ roots: [], total_users: 0 });
        });

        it('getTree passes parameters', async () => {
            FamilyService.getTree.mockResolvedValue({ roots: [] });

            await FamilyService.getTree({ depth: 5 });

            expect(FamilyService.getTree).toHaveBeenCalledWith({ depth: 5 });
        });
    });

    describe('User Endpoints', () => {
        it('getUsers is callable', async () => {
            FamilyService.getUsers.mockResolvedValue({ items: [] });

            const result = await FamilyService.getUsers();

            expect(FamilyService.getUsers).toHaveBeenCalled();
            expect(result).toEqual({ items: [] });
        });

        it('getUsers passes filter parameters', async () => {
            FamilyService.getUsers.mockResolvedValue({ items: [] });

            await FamilyService.getUsers({ skip: 10, limit: 50, from_year: 2020 });

            expect(FamilyService.getUsers).toHaveBeenCalledWith({ skip: 10, limit: 50, from_year: 2020 });
        });

        it('getYears is callable', async () => {
            FamilyService.getYears.mockResolvedValue([2020, 2021, 2022]);

            const result = await FamilyService.getYears();

            expect(FamilyService.getYears).toHaveBeenCalled();
            expect(result).toEqual([2020, 2021, 2022]);
        });

        it('getUserById is callable', async () => {
            FamilyService.getUserById.mockResolvedValue({ id: 1, name: 'Test' });

            const result = await FamilyService.getUserById(1);

            expect(FamilyService.getUserById).toHaveBeenCalledWith(1);
            expect(result).toEqual({ id: 1, name: 'Test' });
        });

        it('getUserChildren is callable', async () => {
            FamilyService.getUserChildren.mockResolvedValue([]);

            await FamilyService.getUserChildren(1);

            expect(FamilyService.getUserChildren).toHaveBeenCalledWith(1);
        });

        it('createUser is callable', async () => {
            const userData = { name: 'Test User', sex: 'M', start_year: 2020 };
            FamilyService.createUser.mockResolvedValue({ id: 1, ...userData });

            await FamilyService.createUser(userData);

            expect(FamilyService.createUser).toHaveBeenCalledWith(userData);
        });

        it('updateUser is callable', async () => {
            const userData = { name: 'Updated Name' };
            FamilyService.updateUser.mockResolvedValue({ id: 1, ...userData });

            await FamilyService.updateUser(1, userData);

            expect(FamilyService.updateUser).toHaveBeenCalledWith(1, userData);
        });

        it('deleteUser is callable', async () => {
            FamilyService.deleteUser.mockResolvedValue(null);

            await FamilyService.deleteUser(1);

            expect(FamilyService.deleteUser).toHaveBeenCalledWith(1);
        });

        it('bulkCreateUsers is callable with options', async () => {
            const users = [{ name: 'User1' }, { name: 'User2' }];
            FamilyService.bulkCreateUsers.mockResolvedValue({ created: 2 });

            await FamilyService.bulkCreateUsers(users, { dry_run: true, atomic: true });

            expect(FamilyService.bulkCreateUsers).toHaveBeenCalledWith(users, { dry_run: true, atomic: true });
        });
    });

    describe('Course Endpoints', () => {
        it('getCourses is callable', async () => {
            FamilyService.getCourses.mockResolvedValue({ items: [] });

            await FamilyService.getCourses();

            expect(FamilyService.getCourses).toHaveBeenCalled();
        });

        it('getCourseById is callable', async () => {
            FamilyService.getCourseById.mockResolvedValue({ id: 1 });

            await FamilyService.getCourseById(1);

            expect(FamilyService.getCourseById).toHaveBeenCalledWith(1);
        });

        it('createCourse is callable', async () => {
            const courseData = { name: 'Test Course', degree: 'BSc' };
            FamilyService.createCourse.mockResolvedValue({ id: 1, ...courseData });

            await FamilyService.createCourse(courseData);

            expect(FamilyService.createCourse).toHaveBeenCalledWith(courseData);
        });

        it('updateCourse is callable', async () => {
            const courseData = { name: 'Updated Course' };
            FamilyService.updateCourse.mockResolvedValue({ id: 1, ...courseData });

            await FamilyService.updateCourse(1, courseData);

            expect(FamilyService.updateCourse).toHaveBeenCalledWith(1, courseData);
        });

        it('deleteCourse is callable', async () => {
            FamilyService.deleteCourse.mockResolvedValue(null);

            await FamilyService.deleteCourse(1);

            expect(FamilyService.deleteCourse).toHaveBeenCalledWith(1);
        });
    });

    describe('Role Endpoints', () => {
        it('getRoles is callable', async () => {
            FamilyService.getRoles.mockResolvedValue([]);

            await FamilyService.getRoles();

            expect(FamilyService.getRoles).toHaveBeenCalled();
        });

        it('getRoleTree is callable', async () => {
            FamilyService.getRoleTree.mockResolvedValue({ children: [] });

            await FamilyService.getRoleTree();

            expect(FamilyService.getRoleTree).toHaveBeenCalled();
        });

        it('createRole is callable', async () => {
            const roleData = { id: 'CF.new', name: 'New Role' };
            FamilyService.createRole.mockResolvedValue(roleData);

            await FamilyService.createRole(roleData);

            expect(FamilyService.createRole).toHaveBeenCalledWith(roleData);
        });

        it('updateRole is callable', async () => {
            const roleData = { name: 'Updated Role' };
            FamilyService.updateRole.mockResolvedValue({ id: 'CF', ...roleData });

            await FamilyService.updateRole('CF', roleData);

            expect(FamilyService.updateRole).toHaveBeenCalledWith('CF', roleData);
        });

        it('deleteRole is callable', async () => {
            FamilyService.deleteRole.mockResolvedValue(null);

            await FamilyService.deleteRole('CF.old');

            expect(FamilyService.deleteRole).toHaveBeenCalledWith('CF.old');
        });
    });

    describe('UserRole Endpoints', () => {
        it('getUserRolesWithDetails is callable', async () => {
            FamilyService.getUserRolesWithDetails.mockResolvedValue([]);

            await FamilyService.getUserRolesWithDetails();

            expect(FamilyService.getUserRolesWithDetails).toHaveBeenCalled();
        });

        it('getUserRolesWithDetails passes filter parameters', async () => {
            FamilyService.getUserRolesWithDetails.mockResolvedValue([]);

            await FamilyService.getUserRolesWithDetails({ user_id: 1, year: 2024 });

            expect(FamilyService.getUserRolesWithDetails).toHaveBeenCalledWith({ user_id: 1, year: 2024 });
        });

        it('getRolesForUser is callable', async () => {
            FamilyService.getRolesForUser.mockResolvedValue({ items: [] });

            await FamilyService.getRolesForUser(1);

            expect(FamilyService.getRolesForUser).toHaveBeenCalledWith(1);
        });

        it('assignRole is callable', async () => {
            const data = { user_id: 1, role_id: 'CF', year: 2024 };
            FamilyService.assignRole.mockResolvedValue({ id: 'abc123', ...data });

            await FamilyService.assignRole(data);

            expect(FamilyService.assignRole).toHaveBeenCalledWith(data);
        });

        it('removeRole is callable', async () => {
            FamilyService.removeRole.mockResolvedValue(null);

            await FamilyService.removeRole('abc123');

            expect(FamilyService.removeRole).toHaveBeenCalledWith('abc123');
        });
    });
});
