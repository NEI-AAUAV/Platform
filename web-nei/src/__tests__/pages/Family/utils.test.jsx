import { describe, it, expect } from 'vitest';
import {
    flattenTree,
    wouldCreateCycle,
    getSuggestedPatroes,
    formatYear
} from '../../../pages/Family/utils';

describe('Family/utils.js', () => {

    describe('formatYear', () => {
        it('formats civil years correctly', () => {
            expect(formatYear(24)).toBe('2024');
            expect(formatYear(2024)).toBe('2024');
            expect(formatYear(99)).toBe('2099');
            expect(formatYear(100)).toBe('100'); // Assuming > 100 is direct
        });

        it('formats academic years correctly', () => {
            expect(formatYear(24, 'academic')).toBe('24/25');
            expect(formatYear(2024, 'academic')).toBe('24/25');
            expect(formatYear(99, 'academic')).toBe('99/00');
        });

        it('handles invalid inputs', () => {
            expect(formatYear(null)).toBe('-');
            expect(formatYear(undefined)).toBe('-');
        });
    });

    describe('wouldCreateCycle', () => {
        const users = [
            { id: 1, _id: 1, name: 'Root' },
            { id: 2, _id: 2, name: 'Child', patrao_id: 1 },
            { id: 3, _id: 3, name: 'Grandchild', patrao_id: 2 },
            { id: 4, _id: 4, name: 'Unrelated' },
        ];

        it('detects direct cycle (assigning self as patrao)', () => {
            expect(wouldCreateCycle(1, 1, users)).toBe(true);
        });

        it('detects indirect cycle (assigning descendant as patrao)', () => {
            // Assigning Grandchild (3) as patrao of Root (1) -> Cycle 1->3->2->1
            expect(wouldCreateCycle(1, 3, users)).toBe(true);
        });

        it('allows valid assignments', () => {
            // Assigning Root (1) as patrao of Unrelated (4)
            expect(wouldCreateCycle(4, 1, users)).toBe(false);
            // Assigning Unrelated (4) as patrao of Root (1)
            expect(wouldCreateCycle(1, 4, users)).toBe(false);
        });

        it('handles valid re-assignment', () => {
            // Changing Child (2) patrao to Unrelated (4)
            expect(wouldCreateCycle(2, 4, users)).toBe(false);
        });
    });

    describe('getSuggestedPatroes', () => {
        const users = [
            { id: 1, name: 'Senior', start_year: 2020 },
            { id: 2, name: 'Junior', start_year: 2023 },
            { id: 3, name: 'Fresher', start_year: 2024 },
            { id: 4, name: 'Oldest', start_year: 2019 },
        ];

        it('suggests patroes with >= 3 years difference', () => {
            // Looking for patrao for year 2024 (Fresher)
            // Should match <= 2021 (Senior: 2020, Oldest: 2019)
            const suggestions = getSuggestedPatroes(2024, users);

            expect(suggestions).toHaveLength(2);
            expect(suggestions.map(u => u.name)).toContain('Senior');
            expect(suggestions.map(u => u.name)).toContain('Oldest');
            expect(suggestions.map(u => u.name)).not.toContain('Junior');
        });

        it('returns empty if no matches', () => {
            // Looking for patrao for year 2020 (Senior) -> Need <= 2017
            const suggestions = getSuggestedPatroes(2020, users);
            expect(suggestions).toHaveLength(0);
        });

        it('sorts by most recent first', () => {
            const suggestions = getSuggestedPatroes(2024, users);
            // Expect Senior (2020) before Oldest (2019)
            expect(suggestions[0].name).toBe('Senior');
        });
    });

    describe('flattenTree', () => {
        it('flattens a simple tree', () => {
            const tree = {
                _id: 1,
                name: 'Root',
                children: [
                    { _id: 2, name: 'Child 1' },
                    { _id: 3, name: 'Child 2' }
                ]
            };

            const flat = flattenTree(tree);
            expect(flat).toHaveLength(3);
            expect(flat.find(u => u.id === 1)).toBeDefined();
            expect(flat.find(u => u.id === 2).parent).toBe(1);
            expect(flat.find(u => u.id === 3).parent).toBe(1);
        });

        it('handles array of roots', () => {
            const roots = [
                { _id: 1, name: 'Root 1' },
                { _id: 2, name: 'Root 2' }
            ];

            const flat = flattenTree(roots);
            // 2 roots + 1 virtual Root (id: 0)
            expect(flat).toHaveLength(3);
            expect(flat.find(u => u.id === 0).name).toBe('Root');
            expect(flat.find(u => u.id === 1).parent).toBe(0);
        });
    });
});
