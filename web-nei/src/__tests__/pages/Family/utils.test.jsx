import { describe, it, expect } from 'vitest';
import {
    flattenTree,
    wouldCreateCycle,
    getSuggestedPatroes,
    formatYear,
    separateName,
    getFainaHierarchy,
    showLabelFaina,
    labelFamilies
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
            { id: 1, name: 'Root' },
            { id: 2, name: 'Child', patrao_id: 1 },
            { id: 3, name: 'Grandchild', patrao_id: 2 },
            { id: 4, name: 'Unrelated' },
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

    describe('separateName', () => {
        it('splits name into two balanced lines', () => {
            // Use a short name that won't be truncated (each half < 15 chars)
            const result = separateName("João Silva");
            expect(result.name1).toBeDefined();
            expect(result.name2).toBeDefined();
            expect(result.isTruncated).toBe(false);
        });

        it('truncates very long names', () => {
            const longName = "Um Nome Extremamente Longo Que Certamente Será Cortado Pelo Algoritmo";
            const result = separateName(longName);
            expect(result.isTruncated).toBe(true);
            expect(result.tname1).toMatch(/\.\.\.$/);
        });
    });

    describe('getFainaHierarchy', () => {
        it('returns special roles (CF/ST) if present at end year', () => {
            const user = {
                organizations: [
                    { name: "CF", year: 2024, role: "Anzol" }
                ]
            };
            expect(getFainaHierarchy(user, 2024)).toBe("Anzol");
        });

        it('calculates male hierarchy correctly', () => {
            const user = { sex: 'M', start_year: 2020 }; // 4 years in 2024
            // 2024 - 2020 - 1 = 3 -> Index 3 -> Mestre
            expect(getFainaHierarchy(user, 2024)).toBe("Mestre");

            // 2021 - 2020 - 1 = 0 -> Index 0 -> Junco
            expect(getFainaHierarchy(user, 2021)).toBe("Junco");
        });

        it('calculates female hierarchy correctly', () => {
            const user = { sex: 'F', start_year: 2022 };
            // 2024 - 2022 - 1 = 1 -> Index 1 -> Moça
            expect(getFainaHierarchy(user, 2024)).toBe("Moça");
        });
    });

    describe('labelFamilies', () => {
        it('labels family heads and calculates depth', () => {
            const root = { id: 0, depth: 0, children: [] };
            const familyHead1 = { id: 1, depth: 1, parent: root, children: [] };
            const familyHead2 = { id: 2, depth: 1, parent: root, children: [] };
            const child1 = { id: 3, depth: 2, parent: familyHead1, children: [] };

            root.children = [familyHead1, familyHead2];
            familyHead1.children = [child1];

            labelFamilies(root);

            // Head of family gets its own ID as family
            expect(familyHead1.family).toBe(1);
            expect(familyHead2.family).toBe(2);

            // Descendant gets ancestor's family ID
            expect(child1.family).toBe(1);

            // Check recursive depth (max depth of subtree)
            // labelFamilies sets family_depth to depth of leaf nodes, then propagates max up
            // child1 has no children, so its family_depth = child1.depth = 2
            // familyHead1's family_depth = max(child1.family_depth) = 2
            expect(familyHead1.family_depth).toBe(2); // Max depth in subtree
            expect(child1.family_depth).toBe(2); // Leaf node depth
        });
    });

    describe('flattenTree', () => {
        it('flattens a simple tree', () => {
            const tree = {
                id: 1,
                name: 'Root',
                children: [
                    { id: 2, name: 'Child 1' },
                    { id: 3, name: 'Child 2' }
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
                { id: 1, name: 'Root 1' },
                { id: 2, name: 'Root 2' }
            ];

            const flat = flattenTree(roots);
            // 2 roots + 1 virtual Root (id: 0)
            expect(flat).toHaveLength(3);
            expect(flat.find(u => u.id === 0).name).toBe('Root');
            expect(flat.find(u => u.id === 1).parent).toBe(0);
        });
    });
});
