import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { Component as FamilyPage } from 'pages/Family/index'; // Import the named export
import FamilyService from 'services/FamilyService';
import { useFamilyTree } from 'pages/Family/useFamilyTree';
import { useUserStore } from 'stores/useUserStore';

// Mocks
vi.mock('services/FamilyService');
vi.mock('pages/Family/useFamilyTree');
vi.mock('stores/useUserStore');

// Mock child components
vi.mock('pages/Family/FamilyContent', () => ({
    default: ({ onNodeEdit, editMode }) => (
        <div data-testid="family-content">
            Content (EditMode: {editMode ? 'ON' : 'OFF'})
            <button onClick={() => onNodeEdit({ id: 1, name: 'Node 1', parent: 0 })}>
                Edit Node 1
            </button>
        </div>
    )
}));

vi.mock('pages/Family/FamilySidebar', () => ({
    default: () => <div data-testid="family-sidebar">Sidebar</div>
}));

vi.mock('pages/settings/Family/UserForm', () => ({
    default: ({ isOpen, onClose, user, onSave, onDelete }) => isOpen ? (
        <div role="dialog" data-testid="user-form">
            User Form: {user ? user.name : 'New'}
            <button onClick={onSave}>Save</button>
            <button onClick={() => onDelete(user)}>Delete</button>
            <button onClick={onClose}>Close</button>
        </div>
    ) : null
}));

vi.mock('components/MaterialSymbol', () => ({
    default: ({ icon }) => <span>{icon}</span>
}));

vi.mock('assets/icons/google', () => ({
    TuneIcon: () => <span>Tune</span>,
    CloseIcon: () => <span>Close</span>,
    FullScreenIcon: () => <span>Full</span>,
    FullScreenExitIcon: () => <span>ExitFull</span>,
}));

// Mock framer-motion
vi.mock('framer-motion', () => ({
    motion: {
        div: ({ children, className, id }) => <div id={id} className={className}>{children}</div>
    }
}));

describe('FamilyPage', () => {
    // Default mock implementations
    const mockRefetch = vi.fn();

    beforeEach(() => {
        vi.clearAllMocks();

        // Mock hook returns
        useFamilyTree.mockReturnValue({
            loading: false,
            users: [],
            minYear: 2000,
            maxYear: 2024,
            refetch: mockRefetch
        });

        useUserStore.mockImplementation((selector) =>
            selector({
                scopes: ['manager-family'], // Default to having access
                sessionLoading: false
            })
        );

        // Mock confirmation for delete
        vi.spyOn(window, 'confirm').mockReturnValue(true);
        vi.spyOn(window, 'alert').mockImplementation(() => { });

        FamilyService.getUserChildren.mockResolvedValue([]);
        FamilyService.deleteUser.mockResolvedValue({});
    });

    it('renders loading state initially', () => {
        useFamilyTree.mockReturnValue({ loading: true });

        render(<FamilyPage />);

        expect(screen.getByText('A carregar árvore genealógica...')).toBeInTheDocument();
        expect(screen.queryByTestId('family-content')).not.toBeInTheDocument();
    });

    it('renders content when loaded', () => {
        render(<FamilyPage />);

        expect(screen.getByTestId('family-content')).toBeInTheDocument();
        expect(screen.getByTestId('family-sidebar')).toBeInTheDocument();
    });

    it('toggles sidebar and fullscreen', () => {
        render(<FamilyPage />);

        // Find sidebar toggle (tooltip logic makes checking by title hard, check rendered icon)
        const toggleSidebar = screen.getByText('Tune').closest('label'); // Assuming it starts closed or open based on logic
        fireEvent.click(toggleSidebar);
        // We can't easily check internal state 'sidebarOpened' without checking class changes on drawer
        // But we can verify no crash.

        const toggleFullscreen = screen.getByText('Full').closest('label');
        fireEvent.click(toggleFullscreen);
    });

    it('enters edit mode if authorized', () => {
        render(<FamilyPage />);

        // Find edit button
        const editButton = screen.getByRole('button', { name: /editar nós/i }) || screen.getByText('edit_square').closest('button');
        fireEvent.click(editButton);

        // Should show edit mode banner
        expect(screen.getByText('Clique num nó para editar')).toBeInTheDocument();

        // Content should reflect edit mode
        expect(screen.getByText('Content (EditMode: ON)')).toBeInTheDocument();
    });

    it('hides edit controls if not authorized', () => {
        useUserStore.mockImplementation((selector) =>
            selector({
                scopes: ['user'], // No manager scope
                sessionLoading: false
            })
        );

        render(<FamilyPage />);

        expect(screen.queryByText('edit_square')).not.toBeInTheDocument();
    });

    it('opens UserForm when a node is clicked in edit mode', () => {
        render(<FamilyPage />);

        // Enter edit mode
        fireEvent.click(screen.getByText('edit_square').closest('button'));

        // Simulate node click from content (mocked above)
        fireEvent.click(screen.getByText('Edit Node 1'));

        expect(screen.getByTestId('user-form')).toBeInTheDocument();
        expect(screen.getByText('User Form: Node 1')).toBeInTheDocument();
    });

    it('opens UserForm for new user when "Novo" is clicked', () => {
        render(<FamilyPage />);

        // Enter edit mode
        fireEvent.click(screen.getByText('edit_square').closest('button'));

        // Click Novo
        fireEvent.click(screen.getByTitle('Adicionar novo membro'));

        expect(screen.getByTestId('user-form')).toBeInTheDocument();
        expect(screen.getByText('User Form: New')).toBeInTheDocument();
    });

    it('handles save from UserForm', () => {
        render(<FamilyPage />);

        // Open form
        fireEvent.click(screen.getByText('edit_square').closest('button'));
        fireEvent.click(screen.getByTitle('Adicionar novo membro'));

        // Click Save in form
        fireEvent.click(screen.getByText('Save'));

        // Should close form and refetch
        expect(screen.queryByTestId('user-form')).not.toBeInTheDocument();
        expect(mockRefetch).toHaveBeenCalled();
    });

    it('handles delete from UserForm', async () => {
        render(<FamilyPage />);

        // Open form for existing node
        fireEvent.click(screen.getByText('edit_square').closest('button'));
        fireEvent.click(screen.getByText('Edit Node 1'));

        // Click Delete in form
        fireEvent.click(screen.getByText('Delete'));

        await waitFor(() => {
            expect(FamilyService.deleteUser).toHaveBeenCalledWith(1);
        });

        expect(screen.queryByTestId('user-form')).not.toBeInTheDocument();
        expect(mockRefetch).toHaveBeenCalled();
    });

    it('checks for orphans before deleting', async () => {
        // Mock children response
        FamilyService.getUserChildren.mockResolvedValue([{ name: 'Child 1' }]);

        render(<FamilyPage />);

        // Open form
        fireEvent.click(screen.getByText('edit_square').closest('button'));
        fireEvent.click(screen.getByText('Edit Node 1'));

        fireEvent.click(screen.getByText('Delete'));

        await waitFor(() => {
            expect(window.confirm).toHaveBeenCalledWith(expect.stringContaining('tem 1 pedaço(s)'));
        });

        expect(FamilyService.deleteUser).toHaveBeenCalled();
    });
});
