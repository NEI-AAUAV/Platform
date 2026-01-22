import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import RoleManagerModal from 'components/RoleManagerModal';
import FamilyService from 'services/FamilyService';

// Mock dependencies
vi.mock('services/FamilyService');
vi.mock('components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('components/IconPicker', () => ({
    default: ({ value, onChange, inputId }) => (
        <input
            data-testid="icon-picker"
            id={inputId}
            value={value}
            onChange={(e) => onChange(e.target.value)}
        />
    )
}));
vi.mock('framer-motion', () => ({
    motion: {
        div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div>
    },
    AnimatePresence: ({ children }) => <>{children}</>
}));
vi.mock('pages/Family/data', () => ({
    organizations: {},
    colors: ['#000000']
}));

// Mock window.confirm
const mockConfirm = vi.spyOn(window, 'confirm');
// Mock window.alert
const mockAlert = vi.spyOn(window, 'alert').mockImplementation(() => { });

describe('RoleManagerModal', () => {
    const mockOnClose = vi.fn();

    const mockRoleTree = [
        {
            _id: 'root1',
            name: 'Root Role',
            children: [
                {
                    _id: 'child1',
                    name: 'Child Role',
                    super_roles: 'root1',
                    children: []
                }
            ]
        }
    ];

    const mockMembers = [
        {
            _id: 'assoc1',
            user: { _id: 101, name: 'User One', sex: 'M', start_year: 2020 },
            year: 2023
        }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        mockConfirm.mockReturnValue(true);
        FamilyService.getRoleTree.mockResolvedValue(mockRoleTree);
        FamilyService.getYears.mockResolvedValue([2023, 2024]);
        FamilyService.getUserRolesWithDetails.mockResolvedValue(mockMembers);
    });

    it('renders nothing when closed', () => {
        render(
            <RoleManagerModal
                isOpen={false}
                onClose={mockOnClose}
            />
        );

        expect(screen.queryByRole('dialog')).not.toBeInTheDocument();
    });

    it('loads tree and years when opened', async () => {
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        expect(FamilyService.getRoleTree).toHaveBeenCalled();
        expect(FamilyService.getYears).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });
    });

    it('allows selecting a role to edit', async () => {
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Root Role'));

        // Form should populate
        await waitFor(() => {
            expect(screen.getByLabelText('Nome')).toHaveValue('Root Role');
        });

        // Should fetch members for this role
        expect(FamilyService.getUserRolesWithDetails).toHaveBeenCalledWith(
            expect.objectContaining({ role_id: 'root1' })
        );
    });

    it('allows creating a new root role', async () => {
        const user = userEvent.setup();
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Insígnias')).toBeInTheDocument();
        });

        // Click "Raiz" button
        const rootButton = screen.getByText(/Raiz/i);
        fireEvent.click(rootButton);

        // Check if form is cleared
        expect(screen.getByLabelText('Nome')).toHaveValue('');
        expect(screen.getByText('Nova Insígnia Raiz')).toBeInTheDocument();

        // Fill form
        await user.type(screen.getByLabelText('Nome'), 'New Role');
        await user.type(screen.getByLabelText('Abreviatura (Curto)'), 'NR');

        FamilyService.createRole.mockResolvedValue({ _id: 'new1', name: 'New Role' });

        // Submit
        fireEvent.click(screen.getByRole('button', { name: /Criar/i }));

        await waitFor(() => {
            expect(FamilyService.createRole).toHaveBeenCalledWith(expect.objectContaining({
                name: 'New Role',
                short: 'NR'
            }));
        });

        // Should reload tree
        expect(FamilyService.getRoleTree).toHaveBeenCalledTimes(2);
    });

    it('allows creating a sub-role (child)', async () => {
        const user = userEvent.setup();
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        // Select parent
        fireEvent.click(screen.getByText('Root Role'));

        // Click "Adicionar Sub-Insígnia"
        const addChildButton = screen.getByRole('button', { name: /Adicionar Sub-Insígnia/i });
        fireEvent.click(addChildButton);

        expect(screen.getByText('Nova Sub-Insígnia')).toBeInTheDocument();
        expect(screen.getByText('Root Role')).toBeInTheDocument(); // Parent context
        expect(screen.getByText('(root1)')).toBeInTheDocument(); // Parent ID check

        // Fill form
        await user.type(screen.getByLabelText('Nome'), 'New Child');

        FamilyService.createRole.mockResolvedValue({ _id: 'child_new', name: 'New Child' });

        // Submit
        fireEvent.click(screen.getByRole('button', { name: /Criar/i }));

        await waitFor(() => {
            expect(FamilyService.createRole).toHaveBeenCalledWith(expect.objectContaining({
                name: 'New Child',
                super_roles: 'root1'
            }));
        });
    });

    it('allows updating an existing role', async () => {
        const user = userEvent.setup();
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Root Role'));

        await user.clear(screen.getByLabelText('Nome'));
        await user.type(screen.getByLabelText('Nome'), 'Updated Root');

        FamilyService.updateRole.mockResolvedValue({ _id: 'root1', name: 'Updated Root' });

        fireEvent.click(screen.getByRole('button', { name: /Guardar Alterações/i }));

        await waitFor(() => {
            expect(FamilyService.updateRole).toHaveBeenCalledWith('root1', expect.objectContaining({
                name: 'Updated Root'
            }));
        });
    });

    it('allows deleting a role', async () => {
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Root Role'));

        const deleteButton = screen.getByTitle(''); // MaterialSymbol doesn't always have title, checking icon name or button class
        // Better selector
        const buttons = screen.getAllByRole('button');
        const deleteBtn = buttons.find(b => b.className.includes('btn-error btn-outline'));

        mockConfirm.mockReturnValueOnce(true);
        FamilyService.deleteRole.mockResolvedValue({});

        fireEvent.click(deleteBtn);

        expect(mockConfirm).toHaveBeenCalled();

        await waitFor(() => {
            expect(FamilyService.deleteRole).toHaveBeenCalledWith('root1');
        });

        expect(FamilyService.getRoleTree).toHaveBeenCalledTimes(2);
    });

    it('allows viewing members tab', async () => {
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root Role')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Root Role'));

        // Switch to members tab
        const membersTab = screen.getByText('Membros');
        fireEvent.click(membersTab);

        await waitFor(() => {
            expect(screen.getByText('User One')).toBeInTheDocument();
        });

        // Test removing member
        mockConfirm.mockReturnValueOnce(true);
        FamilyService.removeRole.mockResolvedValue({});

        const removeButton = screen.getByTitle('Remover insígnia');
        fireEvent.click(removeButton);

        expect(mockConfirm).toHaveBeenCalled();
        await waitFor(() => {
            expect(FamilyService.removeRole).toHaveBeenCalledWith('assoc1');
        });

        // Should refresh members
        expect(FamilyService.getUserRolesWithDetails).toHaveBeenCalledTimes(3); // Initial select + remove success refresh
    });

    it('supports year filtering in members tab', async () => {
        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            fireEvent.click(screen.getByText('Root Role'));
        });

        fireEvent.click(screen.getByText('Membros'));

        await waitFor(() => {
            expect(screen.getByText('User One')).toBeInTheDocument();
        });

        const yearSelect = screen.getByRole('combobox');
        fireEvent.change(yearSelect, { target: { value: '2023' } });

        await waitFor(() => {
            expect(FamilyService.getUserRolesWithDetails).toHaveBeenCalledWith(
                expect.objectContaining({
                    role_id: 'root1',
                    year: 2023
                })
            );
        });
    });

    it('handles mobile view behavior', async () => {
        // Mock mobile window width behavior if needed, or check classes
        // The component uses responsive classes (lg:hidden), we can test visibility

        render(
            <RoleManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        // Initially sidebar is visible, detail is hidden (on mobile) or shown if selected
        // We can check if "Insígnias" title is visible
        expect(screen.getByText('Insígnias')).toBeInTheDocument();

        // Select a node
        await waitFor(() => {
            fireEvent.click(screen.getByText('Root Role'));
        });

        // On mobile logic: Selecting node hides sidebar and shows detail.
        // We can't strictly test CSS visibility effectively in jsdom without layout engine,
        // but we can check if the state (selectedNode) is set which triggers the classes.

        // Check if "back to list" button is present (it's conditionally rendered in detail view)
        const backButtons = screen.getAllByRole('button');
        const mobileBackBtn = backButtons.find(b => b.className.includes('lg:hidden') && b.querySelector('[data-testid="icon-arrow_back"]'));

        expect(mobileBackBtn).toBeInTheDocument();

        // Click back
        fireEvent.click(mobileBackBtn);

        // Selected node should be null
        // We can't check internal state provided by useState directly with RTL,
        // but the form "Nome" label should disappear as we go back to empty state or sidebar only.
        // Actually EmptyState is shown when selectedNode is null.

        expect(screen.queryByLabelText('Nome')).not.toBeInTheDocument();
    });
});
