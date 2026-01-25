import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import UserForm from '../../../../pages/settings/Family/UserForm';

// Mock dependencies
vi.mock('../../../../services/FamilyService', () => ({
    default: {
        getCourses: vi.fn(),
        getUsers: vi.fn(),
        getRolesForUser: vi.fn(),
        getUserChildren: vi.fn(),
        getUserById: vi.fn(),
        createUser: vi.fn(),
        updateUser: vi.fn(),
        assignRole: vi.fn(),
        removeRole: vi.fn(),
    },
}));
vi.mock('../../../../components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('../../../../assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('../../../../components/form', () => ({
    Input: React.forwardRef(({ label, error, ...props }, ref) => (
        <label>
            {label}
            <input ref={ref} {...props} aria-label={label} />
            {error && <span role="alert">{error.message}</span>}
        </label>
    ))
}));
vi.mock('../../../../components/RolePickerModal', () => ({
    default: ({ isOpen, onSelect }) => isOpen ? (
        <div role="dialog" data-testid="role-picker">
            <button onClick={() => onSelect({ id: 'role1', name: 'Role 1', short: 'R1' }, 2024)}>Select Role</button>
        </div>
    ) : null
}));
vi.mock('framer-motion', () => ({
    motion: { div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div> },
    AnimatePresence: ({ children }) => <>{children}</>
}));
vi.mock('react-dom', async () => {
    const actual = await vi.importActual('react-dom');
    return { ...actual, createPortal: (node) => node };
});

window.HTMLElement.prototype.scrollIntoView = vi.fn();

import FamilyService from '../../../../services/FamilyService';

describe('UserForm', () => {
    const mockOnClose = vi.fn();
    const mockOnSave = vi.fn();
    const mockOnDelete = vi.fn();

    const mockCourses = [{ id: 1, name: 'Computer Science', short: 'LEI' }];
    const mockPatroes = { items: [{ id: 10, name: 'Patrao User', sex: 'M' }] };

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getCourses.mockResolvedValue({ items: mockCourses });
        FamilyService.getUsers.mockResolvedValue(mockPatroes);
        FamilyService.getRolesForUser.mockResolvedValue({ items: [] });
        FamilyService.getUserChildren.mockResolvedValue([]);
    });

    it('renders nothing when closed', () => {
        render(<UserForm isOpen={false} onClose={mockOnClose} />);
        expect(screen.queryByText('Novo Pedaço')).not.toBeInTheDocument();
    });

    it('initializes for creating a new user', async () => {
        render(<UserForm isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('Novo Pedaço')).toBeInTheDocument();
        });

        expect(screen.getByLabelText('Nome Completo')).toHaveValue('');
        expect(FamilyService.getCourses).toHaveBeenCalled();
    });

    it('initializes for editing an existing user', async () => {
        const mockUser = { id: 1, name: 'Test User', sex: 'M', start_year: 20, course_id: 1, patrao_id: 10 };
        FamilyService.getUserById.mockResolvedValue({ id: 10, name: 'Patrao User' });

        render(<UserForm user={mockUser} isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('Editar Membro')).toBeInTheDocument();
        });

        expect(screen.getByLabelText('Nome Completo')).toHaveValue('Test User');
        expect(FamilyService.getRolesForUser).toHaveBeenCalledWith(1);
    });

    it('handles assigning roles', async () => {
        render(<UserForm isOpen={true} onClose={mockOnClose} />);

        // Click 'Adicionar' to open the role picker modal
        fireEvent.click(screen.getByText('Adicionar'));

        // Wait for the role picker modal to appear
        await waitFor(() => {
            expect(screen.getByTestId('role-picker')).toBeInTheDocument();
        });

        // Simulate selecting a role in the modal
        fireEvent.click(screen.getByRole('button', { name: /role/i }));

        // Wait for the role to appear in the list
        await waitFor(() => {
            expect(screen.getByText('Role 1')).toBeInTheDocument();
        });
    });
});
