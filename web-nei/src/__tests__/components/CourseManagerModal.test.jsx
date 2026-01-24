import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { CourseManagerModal } from '../../components/Family';

// Mock dependencies
vi.mock('../../services/FamilyService', () => ({
    default: {
        getCourses: vi.fn(),
        createCourse: vi.fn(),
        updateCourse: vi.fn(),
        deleteCourse: vi.fn(),
    },
}));
vi.mock('../../components/MaterialSymbol', () => ({
    default: ({ icon, className }) => <span className={`material-symbol ${className}`} data-testid={`icon-${icon}`}>{icon}</span>
}));
vi.mock('../../assets/icons/google', () => ({
    CloseIcon: () => <span data-testid="close-icon">Close</span>
}));
vi.mock('framer-motion', () => ({
    motion: { div: ({ children, className, onClick }) => <div className={className} onClick={onClick}>{children}</div> },
    AnimatePresence: ({ children }) => <>{children}</>
}));

vi.spyOn(window, 'confirm').mockReturnValue(true);
vi.spyOn(window, 'alert').mockImplementation(() => { });

import FamilyService from '../../services/FamilyService';

describe('CourseManagerModal', () => {
    const mockOnClose = vi.fn();

    const mockCourses = [
        { id: '1', name: 'Computer Science', short: 'LEI', degree: 'Licenciatura', show: true },
        { id: '2', name: 'Informatics Engineering', short: 'MEI', degree: 'Mestrado', show: false }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        FamilyService.getCourses.mockResolvedValue({ items: mockCourses });
        FamilyService.createCourse.mockResolvedValue({});
        FamilyService.updateCourse.mockResolvedValue({});
        FamilyService.deleteCourse.mockResolvedValue({});
    });

    it('renders nothing when closed', () => {
        render(<CourseManagerModal isOpen={false} onClose={mockOnClose} />);
        expect(screen.queryByText('Cursos')).not.toBeInTheDocument();
    });

    it('loads and lists courses upon opening', async () => {
        render(<CourseManagerModal isOpen={true} onClose={mockOnClose} />);

        expect(FamilyService.getCourses).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
            expect(screen.getByText('MEI')).toBeInTheDocument();
        });
    });

    it('filters courses by search', async () => {
        const user = userEvent.setup();
        render(<CourseManagerModal isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        await user.type(screen.getByPlaceholderText('Pesquisar...'), 'LEI');

        expect(screen.getByText('LEI')).toBeInTheDocument();
        expect(screen.queryByText('MEI')).not.toBeInTheDocument();
    });

    it('allows creating a new course', async () => {
        const user = userEvent.setup();
        render(<CourseManagerModal isOpen={true} onClose={mockOnClose} />);

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Novo'));

        await user.type(screen.getByLabelText('Nome'), 'New Course');
        await user.type(screen.getByLabelText('Abreviatura'), 'NC');

        fireEvent.click(screen.getByText('Guardar'));

        await waitFor(() => {
            expect(FamilyService.createCourse).toHaveBeenCalledWith(expect.objectContaining({
                name: 'New Course', short: 'NC'
            }));
        });
    });
});
