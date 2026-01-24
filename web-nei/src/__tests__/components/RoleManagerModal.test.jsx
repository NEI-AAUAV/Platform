import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { RoleManagerModal } from '../../components/Family';

// Mock dependencies
vi.mock('../../services/FamilyService', () => ({
    default: {
        getRoleTree: vi.fn(),
        getYears: vi.fn(),
        getUserRolesWithDetails: vi.fn(),
        createRole: vi.fn(),
        updateRole: vi.fn(),
        deleteRole: vi.fn(),
        removeRole: vi.fn(),
    },
}));
vi.mock('../../components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('../../assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('../../components/IconPicker', () => ({
    default: ({ value, onChange, inputId }) => (
        <input data-testid="icon-picker" id={inputId} value={value} onChange={(e) => onChange(e.target.value)} />
    )
}));
vi.mock('framer-motion', () => ({
    motion: { div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div> },
    AnimatePresence: ({ children }) => <>{children}</>
}));
vi.mock('../../pages/Family/data', () => ({
    organizations: {},
    colors: ['#000000']
}));

vi.spyOn(window, 'confirm').mockReturnValue(true);
vi.spyOn(window, 'alert').mockImplementation(() => { });

import FamilyService from '../../services/FamilyService';

describe('RoleManagerModal', () => {
    const mockOnClose = vi.fn();

    const mockRoleTree = [
        { id: 'root1', name: 'Root Role', children: [{ id: 'child1', name: 'Child Role', super_roles: 'root1', children: [] }] }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getRoleTree.mockResolvedValue(mockRoleTree);
        FamilyService.getYears.mockResolvedValue([2023, 2024]);
        FamilyService.getUserRolesWithDetails.mockResolvedValue([]);
    });

    it('renders nothing when closed', () => {
        render(<RoleManagerModal isOpen={false} onClose={mockOnClose} />);
        expect(screen.queryByText('Insígnias')).not.toBeInTheDocument();
    });

    it('loads tree and years when opened', async () => {
        render(<RoleManagerModal isOpen={true} onClose={mockOnClose} />);

        expect(FamilyService.getRoleTree).toHaveBeenCalled();
        expect(FamilyService.getYears).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });
    });

    it('allows selecting a role to edit', async () => {
        render(<RoleManagerModal isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Root Role'));

        await waitFor(() => {
            expect(screen.getByLabelText('Nome')).toHaveValue('Root Role');
        });
    });

    it('allows creating a new root role', async () => {
        const user = userEvent.setup();
        render(<RoleManagerModal isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('Insígnias')).toBeInTheDocument();
        });
        // Find and click the "Raiz" button
        const raizButtons = screen.getAllByText(/Raiz/i);
        const raizButton = raizButtons.find(el => el.closest('button'));
        fireEvent.click(raizButton.closest('button'));
        expect(screen.getByLabelText('Nome')).toHaveValue('');

        await user.type(screen.getByLabelText('Nome'), 'New Role');

        FamilyService.createRole.mockResolvedValue({ id: 'new1', name: 'New Role' });

        fireEvent.click(screen.getByRole('button', { name: /Criar/i }));

        await waitFor(() => {
            expect(FamilyService.createRole).toHaveBeenCalledWith(expect.objectContaining({ name: 'New Role' }));
        });
    });
});
