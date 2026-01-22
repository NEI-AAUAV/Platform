import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import CourseManagerModal from 'components/CourseManagerModal';
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

// Mock confirm and alert
const mockConfirm = vi.spyOn(window, 'confirm');
vi.spyOn(window, 'alert').mockImplementation(() => { });

describe('CourseManagerModal', () => {
    const mockOnClose = vi.fn();

    const mockCourses = [
        { _id: '1', name: 'Computer Science', short: 'LEI', degree: 'Licenciatura', show: true },
        { _id: '2', name: 'Informatics Engineering', short: 'MEI', degree: 'Mestrado', show: false }
    ];

    beforeEach(() => {
        vi.clearAllMocks();
        mockConfirm.mockReturnValue(true);
        FamilyService.getCourses.mockResolvedValue({ items: mockCourses });
        FamilyService.createCourse.mockResolvedValue({});
        FamilyService.updateCourse.mockResolvedValue({});
        FamilyService.deleteCourse.mockResolvedValue({});
    });

    it('renders nothing when closed', () => {
        render(
            <CourseManagerModal
                isOpen={false}
                onClose={mockOnClose}
            />
        );
        expect(screen.queryByText('Cursos')).not.toBeInTheDocument();
    });

    it('loads and lists courses upon opening', async () => {
        render(
            <CourseManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        expect(FamilyService.getCourses).toHaveBeenCalled();

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
            expect(screen.getByText('MEI')).toBeInTheDocument();
        });

        expect(screen.getByText('Computer Science')).toBeInTheDocument();
        expect(screen.getByText('Informatics Engineering')).toBeInTheDocument();
    });

    it('filters courses by search', async () => {
        const user = userEvent.setup();
        render(
            <CourseManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        const searchInput = screen.getByPlaceholderText('Pesquisar...');
        await user.type(searchInput, 'LEI');

        expect(screen.getByText('LEI')).toBeInTheDocument();
        expect(screen.queryByText('MEI')).not.toBeInTheDocument();
    });

    it('allows creating a new course', async () => {
        const user = userEvent.setup();
        render(
            <CourseManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        // Click "Novo" button
        const newButton = screen.getByText('Novo');
        fireEvent.click(newButton);

        await waitFor(() => {
            expect(screen.getByText('Novo Curso')).toBeInTheDocument();
        });

        // Fill form
        await user.type(screen.getByLabelText('Nome'), 'New Course');
        await user.type(screen.getByLabelText('Abreviatura'), 'NC');
        await user.selectOptions(screen.getByLabelText('Grau'), 'Programa Doutoral');

        // Submit
        const submitButton = screen.getByText('Guardar');
        fireEvent.click(submitButton);

        await waitFor(() => {
            expect(FamilyService.createCourse).toHaveBeenCalledWith(expect.objectContaining({
                name: 'New Course',
                short: 'NC',
                degree: 'Programa Doutoral',
                show: true
            }));
        });

        // Should reload courses
        expect(FamilyService.getCourses).toHaveBeenCalledTimes(2);
    });

    it('allows updating a course', async () => {
        const user = userEvent.setup();
        render(
            <CourseManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        // Select course
        fireEvent.click(screen.getByText('LEI').closest('button'));

        await waitFor(() => {
            expect(screen.getByLabelText('Nome')).toHaveValue('Computer Science');
        });

        // Edit
        await user.clear(screen.getByLabelText('Nome'));
        await user.type(screen.getByLabelText('Nome'), 'CS Updated');

        // Submit
        fireEvent.click(screen.getByText('Guardar'));

        await waitFor(() => {
            expect(FamilyService.updateCourse).toHaveBeenCalledWith('1', expect.objectContaining({
                name: 'CS Updated'
            }));
        });
    });

    it('allows deleting a course', async () => {
        render(
            <CourseManagerModal
                isOpen={true}
                onClose={mockOnClose}
            />
        );

        await waitFor(() => {
            expect(screen.getByText('LEI')).toBeInTheDocument();
        });

        // Select course
        fireEvent.click(screen.getByText('LEI').closest('button'));

        await waitFor(() => {
            expect(screen.getByText('Eliminar')).toBeInTheDocument();
        });

        fireEvent.click(screen.getByText('Eliminar'));

        expect(mockConfirm).toHaveBeenCalled();

        await waitFor(() => {
            expect(FamilyService.deleteCourse).toHaveBeenCalledWith('1');
        });

        // Should return to "New" mode or cleared state
        await waitFor(() => {
            expect(screen.getByText('Novo Curso')).toBeInTheDocument(); // Assuming it resets to new
        });
    });
});
