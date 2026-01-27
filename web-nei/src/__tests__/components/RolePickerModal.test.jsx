import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { RolePickerModal } from '../../components/Family';

// Mock dependencies
vi.mock('../../services/FamilyService', () => ({
    default: {
        getRoleTree: vi.fn(),
    },
}));
vi.mock('../../components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('../../assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('framer-motion', () => ({
    motion: {
        div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div>
    },
    AnimatePresence: ({ children }) => <>{children}</>
}));
vi.mock('../../pages/Family/data', () => ({
    organizations: {
        'CEI': { insignia: 'cei.png' },
        'NEI': { insignia: 'nei.png' }
    }
}));

import FamilyService from '../../services/FamilyService';

describe('RolePickerModal', () => {
    const mockOnClose = vi.fn();
    const mockOnSelect = vi.fn();

    const mockRoleTree = [
        {
            id: '1',
            name: 'Root',
            children: [
                { id: '2', name: 'NEI', short: 'NEI', children: [] },
                { id: '3', name: 'Groups', children: [{ id: '4', name: 'CEI', short: 'CEI', children: [] }] }
            ]
        }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getRoleTree.mockResolvedValue(mockRoleTree);
    });

    it('renders nothing when closed', () => {
        render(
            <RolePickerModal isOpen={false} onClose={mockOnClose} onSelect={mockOnSelect} />
        );
        expect(screen.queryByText('Escolher Filtro')).not.toBeInTheDocument();
    });

    it('loads and displays role tree when opened', async () => {
        render(
            <RolePickerModal isOpen={true} onClose={mockOnClose} onSelect={mockOnSelect} />
        );

        expect(FamilyService.getRoleTree).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });
    });

    it('navigates through hierarchy', async () => {
        render(
            <RolePickerModal isOpen={true} onClose={mockOnClose} onSelect={mockOnSelect} />
        );

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });

        // Click on Root (which has children)
        const rootBtn = screen.getByText('Root').closest('button');
        fireEvent.click(rootBtn);

        // Should show children of Root (NEI appears twice: as name and short)
        await waitFor(() => {
            expect(screen.getAllByText('NEI').length).toBeGreaterThan(0);
        });
    });

    it('hides year selection when hideYear=true', async () => {
        render(
            <RolePickerModal isOpen={true} onClose={mockOnClose} onSelect={mockOnSelect} hideYear={true} />
        );

        await waitFor(() => {
            expect(screen.queryByText('Ano da Insígnia (Opcional)')).not.toBeInTheDocument();
        });
    });
});
