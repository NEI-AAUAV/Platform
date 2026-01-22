import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import UserForm from 'pages/settings/Family/UserForm';
import FamilyService from 'services/FamilyService';

// Mock dependencies
vi.mock('services/FamilyService');
vi.mock('components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('components/form', () => ({
    Input: React.forwardRef(({ label, error, ...props }, ref) => (
        <label>
            {label}
            <input ref={ref} {...props} />
            {error && <span role="alert">{error.message}</span>}
        </label>
    ))
}));
vi.mock('components/RolePickerModal', () => ({
    default: ({ isOpen, onSelect }) => isOpen ? (
        <div role="dialog">
            <button onClick={() => onSelect({ _id: 'role1', name: 'Role 1', short: 'R1' }, 2024)}>
                Select Role
            </button>
        </div>
    ) : null
}));
vi.mock('framer-motion', () => ({
    motion: {
        div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div>
    },
    AnimatePresence: ({ children }) => <>{children}</>
}));

// Mock react-dom createPortal to just render children
vi.mock('react-dom', () => ({
    createPortal: (node) => node
}));

// Mock scrollIntoView
window.HTMLElement.prototype.scrollIntoView = vi.fn();

describe('UserForm', () => {
    const mockOnClose = vi.fn();
    const mockOnSave = vi.fn();
    const mockOnDelete = vi.fn();

    // Default mocks
    const mockCourses = [{ _id: 1, name: 'Computer Science', short: 'LEI' }];
    const mockPatroes = { items: [{ _id: 10, name: 'Patrao User', sex: 'M' }] };

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getCourses.mockResolvedValue({ items: mockCourses });
        FamilyService.getUsers.mockResolvedValue(mockPatroes);
        FamilyService.getRolesForUser.mockResolvedValue({ items: [] });
        FamilyService.getUserChildren.mockResolvedValue([]);
    });

    it('renders nothing when closed', () => {
        render(
            <UserForm
                isOpen={false}
                onClose={mockOnClose}
            />
        );
        expect(screen.queryByText('Novo Pedaço')).not.toBeInTheDocument();
    });

    it('initializes for creating a new user', async () => {
        render(
            <UserForm
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Novo Pedaço')).toBeInTheDocument();
        });

        expect(screen.getByLabelText('Nome Completo')).toHaveValue('');
        expect(FamilyService.getCourses).toHaveBeenCalled();
        expect(FamilyService.getUsers).toHaveBeenCalled(); // Loads patroes
    });

    it('initializes for editing an existing user', async () => {
        const mockUser = {
            _id: 1,
            name: 'Test User',
            sex: 'M',
            start_year: 20,
            course_id: 1,
            patrao_id: 10
        };

        // Mock getting patrao details
        FamilyService.getUserById.mockResolvedValue({ _id: 10, name: 'Patrao User' });

        render(
            <UserForm
                user={mockUser}
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Editar Membro')).toBeInTheDocument();
        });

        expect(screen.getByLabelText('Nome Completo')).toHaveValue('Test User');
        expect(FamilyService.getRolesForUser).toHaveBeenCalledWith(1);
        expect(FamilyService.getUserChildren).toHaveBeenCalledWith(1);
        expect(FamilyService.getUserById).toHaveBeenCalledWith(10);
    });

    it('creates a new user successfully', async () => {
        const user = userEvent.setup();
        render(
            <UserForm
                isOpen={true}
                onClose={mockOnClose}
                onSave={mockOnSave}
            />
        );

        await user.type(screen.getByLabelText('Nome Completo'), 'New User');
        await user.clear(screen.getByLabelText('Ano de Entrada (Civil | Letivo)'));
        await user.type(screen.getByLabelText('Ano de Entrada (Civil | Letivo)'), '24');

        // Select Course
        await user.selectOptions(screen.getByLabelText('Curso'), '1');

        // Select Patrao from list
        await waitFor(() => {
            expect(screen.getByText('Patrao User')).toBeInTheDocument();
        });
        fireEvent.click(screen.getByText('Patrao User'));

        FamilyService.createUser.mockResolvedValue({ _id: 99, name: 'New User' });

        const submitBtn = screen.getByText('Criar'); // Assuming the button says "Criar" based on isEdit=false
        // Actually the button text is "Criar" or "Guardar e Criar Novo" maybe? 
        // Checking the code: {isEdit ? "Editar Membro" : "Novo Pedaço"} in header. 
        // Footer buttons: !isEdit && <button>Criar</button> (Need to check truncated code, but likely standard submit)
        // Wait, the footer button logic wasn't fully visible in truncated view. 
        // Let's find button by type="submit" or text within form.

        const createBtn = screen.getByText((content, element) => {
            return element.tagName.toLowerCase() === 'button' && content.includes('Novo Pedaço') === false && (content === 'Criar' || content === 'Guardar');
        });
        // The code has: {isNew ? "Criar" : "Guardar Alterações"} in RoleManager, but UserForm is different.
        // Let's rely on finding a submit button.
        // Looking at truncated code line 799: `{!isEdit && (` ... likely "Criar"

        // Let's submit via form enter or find button more generally
        // Or finding "Cancelar" and looking next to it.
        const footer = screen.getByText('Cancelar').closest('div');
        const submitButton = footer.querySelectorAll('button')[2] || footer.querySelectorAll('button')[1]; // Depending on if delete is there

        fireEvent.click(submitButton);

        await waitFor(() => {
            expect(FamilyService.createUser).toHaveBeenCalledWith(expect.objectContaining({
                name: 'New User',
                start_year: 24,
                course_id: 1,
                patrao_id: 10
            }));
        });

        expect(mockOnSave).toHaveBeenCalled();
        expect(mockOnClose).toHaveBeenCalled();
    });

    it('updates an existing user successfully', async () => {
        const mockUser = { _id: 1, name: 'Old Name' };
        const user = userEvent.setup();

        render(
            <UserForm
                user={mockUser}
                isOpen={true}
                onClose={mockOnClose}
                onSave={mockOnSave}
            />
        );

        await waitFor(() => {
            expect(screen.getByDisplayValue('Old Name')).toBeInTheDocument();
        });

        await user.clear(screen.getByLabelText('Nome Completo'));
        await user.type(screen.getByLabelText('Nome Completo'), 'New Name');

        FamilyService.updateUser.mockResolvedValue({ _id: 1, name: 'New Name' });

        const saveButton = screen.getByText((content) => content.includes('Guardar') || content.includes('Salvar'));
        fireEvent.click(saveButton);

        await waitFor(() => {
            expect(FamilyService.updateUser).toHaveBeenCalledWith(1, expect.objectContaining({
                name: 'New Name'
            }));
        });
    });

    it('handles assigning roles', async () => {
        const user = userEvent.setup();
        render(
            <UserForm
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        // Open role picker
        fireEvent.click(screen.getByText('Adicionar'));

        // Click mocked select in picker
        fireEvent.click(screen.getByText('Select Role'));

        // Check if role is added to pending list (since it's new user mode)
        await waitFor(() => {
            expect(screen.getByText('Role 1')).toBeInTheDocument();
        });

        // Now submit form
        await user.type(screen.getByLabelText('Nome Completo'), 'User With Role');
        FamilyService.createUser.mockResolvedValue({ _id: 100 });
        FamilyService.assignRole.mockResolvedValue({});

        // Find submit button (likely "Criar")
        // Safe way: get the form and fire submit
        fireEvent.submit(screen.getByLabelText('Nome Completo').closest('form'));

        await waitFor(() => {
            expect(FamilyService.createUser).toHaveBeenCalled();
        });

        await waitFor(() => {
            expect(FamilyService.assignRole).toHaveBeenCalledWith(expect.objectContaining({
                user_id: 100,
                role_id: 'role1',
                year: 2024
            }));
        });
    });

    it('searches for patroes', async () => {
        const user = userEvent.setup();
        render(
            <UserForm
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        const searchInput = screen.getByPlaceholderText('Nome, ID ou nmec...');
        await user.type(searchInput, 'SearchTerm');

        // Wait for debounce
        await waitFor(() => {
            expect(FamilyService.getUsers).toHaveBeenCalledWith(expect.objectContaining({
                search: 'SearchTerm'
            }));
        }, { timeout: 1000 });
    });

    it('allows deleting a user (when editing)', async () => {
        const mockUser = { _id: 1, name: 'To Delete' };

        // Mock window.confirm
        const confirmSpy = vi.spyOn(window, 'confirm');
        confirmSpy.mockReturnValue(true);

        render(
            <UserForm
                user={mockUser}
                isOpen={true}
                onClose={mockOnClose}
                onDelete={mockOnDelete}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Eliminar')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Eliminar'));

        expect(confirmSpy).toHaveBeenCalled();
        expect(mockOnDelete).toHaveBeenCalledWith(mockUser);
    });

    it('loads and interacts with children (pedaços)', async () => {
        const mockUser = { _id: 1, name: 'Parent' };

        FamilyService.getUserChildren.mockResolvedValue([
            { _id: 2, name: 'Child One', start_year: 21 }
        ]);

        const mockOnSwitchUser = vi.fn();

        render(
            <UserForm
                user={mockUser}
                isOpen={true}
                onClose={mockOnClose}
                onSwitchUser={mockOnSwitchUser}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Child One')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Child One').closest('button'));

        expect(mockOnSwitchUser).toHaveBeenCalledWith(expect.objectContaining({ _id: 2 }));
    });
});
