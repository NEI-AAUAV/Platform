import { describe, it, expect, vi, beforeEach } from 'vitest';
import { renderHook, waitFor } from '@testing-library/react';
import { useFamilyTree } from '../../pages/Family/useFamilyTree';

// Mock FamilyService
vi.mock('../../services/FamilyService', () => ({
    default: {
        getTree: vi.fn(),
    },
}));

import FamilyService from '../../services/FamilyService';

describe('useFamilyTree', () => {
    beforeEach(() => {
        vi.clearAllMocks();
    });

    it('starts in loading state', () => {
        FamilyService.getTree.mockImplementation(() => new Promise(() => { })); // Never resolves

        const { result } = renderHook(() => useFamilyTree());

        expect(result.current.loading).toBe(true);
        expect(result.current.users).toEqual([]);
        expect(result.current.error).toBeNull();
    });

    it('fetches tree data successfully', async () => {
        const mockData = {
            roots: [
                { _id: 1, name: 'Root User', children: [] }
            ],
            min_year: 2015,
            max_year: 2024,
            total_users: 1
        };
        FamilyService.getTree.mockResolvedValue(mockData);

        const { result } = renderHook(() => useFamilyTree());

        await waitFor(() => {
            expect(result.current.loading).toBe(false);
        });

        expect(result.current.error).toBeNull();
        expect(result.current.minYear).toBe(2015);
        expect(result.current.maxYear).toBe(2024);
        // flattenTree should have processed the data
        expect(result.current.users.length).toBeGreaterThan(0);
    });

    it('handles fetch error', async () => {
        const mockError = new Error('Network error');
        FamilyService.getTree.mockRejectedValue(mockError);

        const { result } = renderHook(() => useFamilyTree());

        await waitFor(() => {
            expect(result.current.loading).toBe(false);
        });

        expect(result.current.error).toBe(mockError);
        expect(result.current.users).toEqual([]);
    });

    it('passes options to FamilyService', async () => {
        FamilyService.getTree.mockResolvedValue({ roots: [] });

        renderHook(() => useFamilyTree({ depth: 10 }));

        await waitFor(() => {
            expect(FamilyService.getTree).toHaveBeenCalledWith({ depth: 10 });
        });
    });

    it('provides refetch function', async () => {
        FamilyService.getTree
            .mockResolvedValueOnce({ roots: [], min_year: 2015, max_year: 2020 })
            .mockResolvedValueOnce({ roots: [{ _id: 1, name: 'New' }], min_year: 2015, max_year: 2024 });

        const { result } = renderHook(() => useFamilyTree());

        await waitFor(() => {
            expect(result.current.loading).toBe(false);
        });

        expect(result.current.maxYear).toBe(2020);

        // Call refetch
        result.current.refetch();

        await waitFor(() => {
            expect(result.current.maxYear).toBe(2024);
        });

        expect(FamilyService.getTree).toHaveBeenCalledTimes(2);
    });

    it('handles data without roots property', async () => {
        // API might return array directly in some cases
        const mockData = [
            { _id: 1, name: 'User 1' },
            { _id: 2, name: 'User 2' }
        ];
        FamilyService.getTree.mockResolvedValue(mockData);

        const { result } = renderHook(() => useFamilyTree());

        await waitFor(() => {
            expect(result.current.loading).toBe(false);
        });

        // Should still process the data (flattenTree handles arrays)
        expect(result.current.users.length).toBeGreaterThan(0);
    });
});
