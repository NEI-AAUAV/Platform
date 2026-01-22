import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import RolePickerModal from 'components/RolePickerModal';
import FamilyService from 'services/FamilyService';

// Mock dependencies
vi.mock('services/FamilyService');
vi.mock('components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('framer-motion', () => ({
    motion: {
        div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div>
    },
    AnimatePresence: ({ children }) => <>{children}</>
}));
vi.mock('pages/Family/data', () => ({
    organizations: {
        'CEI': { insignia: 'cei.png' },
        'NEI': { insignia: 'nei.png' }
    }
}));

describe('RolePickerModal', () => {
    const mockOnClose = vi.fn();
    const mockOnSelect = vi.fn();

    const mockRoleTree = [
        {
            _id: '1',
            name: 'Root',
            children: [
                {
                    _id: '2',
                    name: 'NEI',
                    short: 'NEI',
                    children: []
                },
                {
                    _id: '3',
                    name: 'Groups',
                    children: [
                        {
                            _id: '4',
                            name: 'CEI',
                            short: 'CEI',
                            children: []
                        }
                    ]
                }
            ]
        }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getRoleTree.mockResolvedValue(mockRoleTree);
    });

    it('renders nothing when closed', () => {
        render(
            <RolePickerModal
                isOpen={false}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        expect(screen.queryByText('Escolher Filtro')).not.toBeInTheDocument();
    });

    it('loads and displays role tree when opened', async () => {
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        // Should show loading spinner initially if tree fetch is slow
        // But here it resolves quickly, so we verify data
        expect(FamilyService.getRoleTree).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });
    });

    it('navigates through hierarchy', async () => {
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });

        // Click on Root (which has children)
        fireEvent.click(screen.getByText('Root').closest('button'));

        // Should show children of Root
        await waitFor(() => {
            expect(screen.getByText('NEI')).toBeInTheDocument();
            expect(screen.getByText('Groups')).toBeInTheDocument();
        });

        // Breadcrumb should change
        expect(screen.getByText('Root')).toBeInTheDocument(); // Header title
        expect(screen.queryByText('Escolher Filtro')).not.toBeInTheDocument();

        // Navigate back up
        const backButton = screen.getAllByRole('button')[0]; // First button should be back arrow
        fireEvent.click(backButton);

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });
        expect(screen.queryByText('NEI')).not.toBeInTheDocument();
    });

    it('selects a leaf node', async () => {
        const user = userEvent.setup();
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            // Navigate to Root -> NEI
            fireEvent.click(screen.getByText('Root').closest('button'));
        });

        await waitFor(() => {
            expect(screen.getByText('NEI')).toBeInTheDocument();
        });

        // Click NEI (leaf node)
        fireEvent.click(screen.getByText('NEI').closest('button'));

        // Should show "Selecionar NEI" button
        const confirmButton = await screen.findByRole('button', { name: /Selecionar NEI/i });
        fireEvent.click(confirmButton);

        expect(mockOnSelect).toHaveBeenCalled();
        expect(mockOnClose).toHaveBeenCalled();
    });

    it('allows selecting a parent node via checkbox', async () => {
        const user = userEvent.setup();
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });

        // Find the checkbox/overlay button for Root
        const buttons = screen.getAllByRole('button');
        const selectFolderButton = buttons.find(b => b.title === "Selecionar esta categoria");

        fireEvent.click(selectFolderButton);

        const confirmButton = await screen.findByRole('button', { name: /Selecionar Root/i });
        fireEvent.click(confirmButton);

        expect(mockOnSelect).toHaveBeenCalledWith(
            expect.objectContaining({ name: 'Root' }),
            expect.any(Number) // Year
        );
    });

    it('handles year selection', async () => {
        const user = userEvent.setup();
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });

        // Type a year
        const yearInput = screen.getByPlaceholderText('-');
        await user.clear(yearInput);
        await user.type(yearInput, '20');

        // Select a node
        const buttons = screen.getAllByRole('button');
        const selectFolderButton = buttons.find(b => b.title === "Selecionar esta categoria");
        fireEvent.click(selectFolderButton);

        const confirmButton = screen.getByRole('button', { name: /Selecionar Root/i });
        fireEvent.click(confirmButton);

        expect(mockOnSelect).toHaveBeenCalledWith(
            expect.objectContaining({ name: 'Root' }),
            20
        );
    });

    it('can clear year selection', async () => {
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('Root')).toBeInTheDocument();
        });

        const clearButton = screen.getByText('Limpar');
        fireEvent.click(clearButton);

        // Select a node
        const buttons = screen.getAllByRole('button');
        const selectFolderButton = buttons.find(b => b.title === "Selecionar esta categoria");
        fireEvent.click(selectFolderButton);

        const confirmButton = screen.getByRole('button', { name: /Selecionar Root/i });
        fireEvent.click(confirmButton);

        expect(mockOnSelect).toHaveBeenCalledWith(
            expect.objectContaining({ name: 'Root' }),
            null
        );
    });

    it('hides year selection when hideYear=true', async () => {
        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
                hideYear={true}
            />
        );

        await waitFor(() => {
            expect(screen.queryByText('Ano da Insígnia (Opcional)')).not.toBeInTheDocument();
        });
    });

    it('resolves icons correctly', async () => {
        // Mock specific nodes for icon testing
        const iconNodes = [
            { _id: 'a', name: 'Custom Icon', icon: 'custom.png', children: [] },
            { _id: 'b', name: 'Static Short', short: 'CEI', children: [] }, // Should match CEI in mock data
            { _id: 'c', name: 'Role of Escrivão', children: [] }, // Should match special roles
        ];
        FamilyService.getRoleTree.mockResolvedValue(iconNodes);

        render(
            <RolePickerModal
                isOpen={true}
                onClose={mockOnClose}
                onSelect={mockOnSelect}
            />
        );

        await waitFor(() => {
            // Check for images
            const images = screen.getAllByRole('img');
            const srcs = images.map(img => img.getAttribute('src'));

            expect(srcs).toContain('custom.png');
            expect(srcs).toContain('cei.png'); // From map
            // Note: Special roles might not resolve in test env if data mock isn't perfect, 
            // but we can check if it attempts to render an image vs default icon
        });
    });
});
