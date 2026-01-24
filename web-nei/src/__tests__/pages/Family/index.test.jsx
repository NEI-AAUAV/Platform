import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { Component as FamilyPage } from '../../../pages/Family/index';

// Mock dependencies
vi.mock('../../../services/FamilyService', () => ({
    default: {
        getUserChildren: vi.fn(),
        deleteUser: vi.fn(),
    },
}));

vi.mock('../../../pages/Family/useFamilyTree', () => ({
    useFamilyTree: vi.fn(),
}));

vi.mock('../../../stores/useUserStore', () => ({
    useUserStore: vi.fn(),
}));

// Mock child components
vi.mock('../../../pages/Family/FamilyContent', () => ({
    default: ({ onNodeEdit, editMode }) => (
        <div data-testid="family-content">
            Content (EditMode: {editMode ? 'ON' : 'OFF'})
            <button onClick={() => onNodeEdit && onNodeEdit({ id: 1, name: 'Node 1', parent: 0 })}>Edit Node 1</button>
        </div>
    )
}));

vi.mock('../../../pages/Family/FamilySidebar', () => ({
    default: () => <div data-testid="family-sidebar">Sidebar</div>
}));

vi.mock('../../../pages/settings/Family/UserForm', () => ({
    default: ({ isOpen, onClose, user, onSave, onDelete }) => isOpen ? (
        <div role="dialog" data-testid="user-form">
            User Form: {user ? user.name : 'New'}
            <button onClick={onSave}>Save</button>
            <button onClick={() => onDelete && onDelete(user)}>Delete</button>
            <button onClick={onClose}>Close</button>
        </div>
    ) : null
}));

vi.mock('../../../components/MaterialSymbol', () => ({
    default: ({ icon }) => <span data-testid={`icon-${icon}`}>{icon}</span>
}));

vi.mock('../../../assets/icons/google', () => ({
    TuneIcon: () => <span>Tune</span>,
    CloseIcon: () => <span>Close</span>,
    FullScreenIcon: () => <span>Full</span>,
    FullScreenExitIcon: () => <span>ExitFull</span>,
}));

vi.mock('framer-motion', () => ({
    motion: { div: ({ children, className, id }) => <div id={id} className={className}>{children}</div> }
}));

import FamilyService from '../../../services/FamilyService';
import { useFamilyTree } from '../../../pages/Family/useFamilyTree';
import { useUserStore } from '../../../stores/useUserStore';

describe('FamilyPage', () => {
    const mockRefetch = vi.fn();

    beforeEach(() => {
        vi.clearAllMocks();

        useFamilyTree.mockReturnValue({
            loading: false,
            users: [],
            minYear: 2000,
            maxYear: 2024,
            refetch: mockRefetch
        });

        useUserStore.mockImplementation((selector) =>
            selector({ scopes: ['manager-family'], sessionLoading: false })
        );

        vi.spyOn(window, 'confirm').mockReturnValue(true);
        vi.spyOn(window, 'alert').mockImplementation(() => { });

        FamilyService.getUserChildren.mockResolvedValue([]);
        FamilyService.deleteUser.mockResolvedValue({});
    });

    it('renders loading state initially', () => {
        useFamilyTree.mockReturnValue({ loading: true });

        render(<FamilyPage />);

        expect(screen.getByText('A carregar árvore genealógica...')).toBeInTheDocument();
    });

    it('renders content when loaded', () => {
        render(<FamilyPage />);

        expect(screen.getByTestId('family-content')).toBeInTheDocument();
        expect(screen.getByTestId('family-sidebar')).toBeInTheDocument();
    });

    it('enters edit mode if authorized', () => {
        render(<FamilyPage />);

        const editButton = screen.getByTestId('icon-edit_square').closest('button');
        fireEvent.click(editButton);

        expect(screen.getByText('Clique num nó para editar')).toBeInTheDocument();
        expect(screen.getByText('Content (EditMode: ON)')).toBeInTheDocument();
    });

    it('hides edit controls if not authorized', () => {
        useUserStore.mockImplementation((selector) =>
            selector({ scopes: ['user'], sessionLoading: false })
        );

        render(<FamilyPage />);

        expect(screen.queryByTestId('icon-edit_square')).not.toBeInTheDocument();
    });

    it('opens UserForm when a node is clicked in edit mode', () => {
        render(<FamilyPage />);

        fireEvent.click(screen.getByTestId('icon-edit_square').closest('button'));
        fireEvent.click(screen.getByText('Edit Node 1'));

        expect(screen.getByTestId('user-form')).toBeInTheDocument();
        expect(screen.getByText('User Form: Node 1')).toBeInTheDocument();
    });

    it('handles save from UserForm', () => {
        render(<FamilyPage />);

        fireEvent.click(screen.getByTestId('icon-edit_square').closest('button'));
        fireEvent.click(screen.getByTitle('Adicionar novo membro'));
        fireEvent.click(screen.getByText('Save'));

        expect(screen.queryByTestId('user-form')).not.toBeInTheDocument();
        expect(mockRefetch).toHaveBeenCalled();
    });

    it('handles delete from UserForm', async () => {
        render(<FamilyPage />);

        fireEvent.click(screen.getByTestId('icon-edit_square').closest('button'));
        fireEvent.click(screen.getByText('Edit Node 1'));
        fireEvent.click(screen.getByText('Delete'));

        await waitFor(() => {
            expect(FamilyService.deleteUser).toHaveBeenCalledWith(1);
        });

        expect(mockRefetch).toHaveBeenCalled();
    });
});
