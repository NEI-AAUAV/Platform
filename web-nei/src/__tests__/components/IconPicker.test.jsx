import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import IconPicker, { AVAILABLE_ICONS } from '../../components/IconPicker';

// Mock dependencies
vi.mock('../../components/MaterialSymbol', () => ({
    default: ({ icon, size, className }) => (
        <span data-testid={`icon-${icon}`} className={className} data-size={size}>
            {icon}
        </span>
    ),
}));

describe('IconPicker', () => {
    const mockOnChange = vi.fn();
    const defaultProps = {
        value: '',
        onChange: mockOnChange,
        inheritedIcon: '/icons/inherited.svg',
        inputId: 'icon-picker-input',
    };

    beforeEach(() => {
        vi.clearAllMocks();
    });

    describe('Rendering', () => {
        it('renders with inherited icon when value is empty', () => {
            render(<IconPicker {...defaultProps} />);

            // Check for "Herdado do parent" text
            expect(screen.getByText(/Herdado do parent/i)).toBeInTheDocument();
            // Check for inherited icon path display
            expect(screen.getByText('/icons/inherited.svg')).toBeInTheDocument();
            // Check if image tries to load inherited icon
            const img = screen.getByRole('img', { name: '' });
            expect(img).toHaveAttribute('src', '/icons/inherited.svg');
            expect(img).toHaveClass('opacity-50'); // Inherited style
        });

        it('renders with explicit value', () => {
            render(<IconPicker {...defaultProps} value="/icons/faina.svg" />);

            // Check for "Ícone definido" text
            expect(screen.getByText(/Ícone definido/i)).toBeInTheDocument();
            expect(screen.getByText('/icons/faina.svg')).toBeInTheDocument();

            const img = screen.getByRole('img', { name: '' });
            expect(img).toHaveAttribute('src', '/icons/faina.svg');
            expect(img).not.toHaveClass('opacity-50');
        });

        it('renders empty state when no value and no inherited icon', () => {
            render(<IconPicker {...defaultProps} inheritedIcon="" />);

            expect(screen.getByText(/Sem ícone/i)).toBeInTheDocument();
            // Should show placeholder icon (MaterialSymbol 'image')
            expect(screen.getByTestId('icon-image')).toBeInTheDocument();
        });

        it('renders available icons grid', () => {
            render(<IconPicker {...defaultProps} />);

            // Check if all available icons are rendered
            AVAILABLE_ICONS.forEach(icon => {
                expect(screen.getByTitle(icon.name)).toBeInTheDocument();
            });
        });
    });

    describe('Interactions', () => {
        it('calls onChange when selecting a preset icon', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            const firstIcon = AVAILABLE_ICONS[0];
            const button = screen.getByTitle(firstIcon.name);

            await user.click(button);

            expect(mockOnChange).toHaveBeenCalledWith(firstIcon.path);
        });

        it('clears icon when clear button is clicked', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} value="/icons/faina.svg" />);

            // Clear button only appears when value is set
            const clearBtn = screen.getByTitle('Remover ícone (usará herança)');
            await user.click(clearBtn);

            expect(mockOnChange).toHaveBeenCalledWith('');
        });

        it('allows custom path entry', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            // Open custom input
            const customBtn = screen.getByTitle('Caminho personalizado');
            await user.click(customBtn);

            // Type new path
            const input = screen.getByPlaceholderText('/icons/meu-icone.svg');
            await user.type(input, '/icons/custom.svg');

            // Submit
            const okBtn = screen.getByText('OK');
            await user.click(okBtn);

            expect(mockOnChange).toHaveBeenCalledWith('/icons/custom.svg');
        });
    });

    describe('Security (XSS Prevention)', () => {
        it('sanitizes javascript: protocol', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            // Open custom input
            await user.click(screen.getByTitle('Caminho personalizado'));

            const input = screen.getByPlaceholderText('/icons/meu-icone.svg');
            // Try to inject javascript
            await user.type(input, 'javascript:alert(1)');
            await user.click(screen.getByText('OK'));

            // Should NOT call onChange with the malicious string
            expect(mockOnChange).not.toHaveBeenCalled();
        });

        it('sanitizes non-HTTPS absolute URLs', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            await user.click(screen.getByTitle('Caminho personalizado'));
            const input = screen.getByPlaceholderText('/icons/meu-icone.svg');

            // HTTP (insecure)
            await user.type(input, 'http://malicious.com/image.png');
            await user.click(screen.getByText('OK'));
            expect(mockOnChange).not.toHaveBeenCalled();

            // Re-open custom input (it closes after clicking OK)
            await user.click(screen.getByTitle('Caminho personalizado'));
            const newInput = screen.getByPlaceholderText('/icons/meu-icone.svg');

            // No protocol
            await user.type(newInput, 'www.google.com/logo.png');
            await user.click(screen.getByText('OK'));
            expect(mockOnChange).not.toHaveBeenCalled();
        });

        it('accepts HTTPS absolute URLs', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            await user.click(screen.getByTitle('Caminho personalizado'));
            const input = screen.getByPlaceholderText('/icons/meu-icone.svg');

            const validUrl = 'https://example.com/logo.png';
            await user.type(input, validUrl);
            await user.click(screen.getByText('OK'));

            expect(mockOnChange).toHaveBeenCalledWith(validUrl);
        });

        it('accepts local /icons/ paths', async () => {
            const user = userEvent.setup();
            render(<IconPicker {...defaultProps} />);

            await user.click(screen.getByTitle('Caminho personalizado'));
            const input = screen.getByPlaceholderText('/icons/meu-icone.svg');

            const validPath = '/icons/test-icon.svg';
            await user.type(input, validPath);
            await user.click(screen.getByText('OK'));

            expect(mockOnChange).toHaveBeenCalledWith(validPath);
        });
    });

    describe('Error Handling', () => {
        it('switches to fallback when image errors', () => {
            render(<IconPicker {...defaultProps} value="/icons/broken.svg" />);

            // Get only the preview image (first one with alt="")
            const previewImg = screen.getByRole('img', { name: '' });

            // Simulate error
            fireEvent.error(previewImg);

            // Should now show placeholder icon instead of preview img
            expect(screen.getByTestId('icon-image')).toBeInTheDocument();
            // Preview img should be gone, but grid icons remain
            expect(screen.queryByRole('img', { name: '' })).not.toBeInTheDocument();
        });

        it('resets error state when value changes', () => {
            const { rerender } = render(<IconPicker {...defaultProps} value="/icons/broken.svg" />);

            // Get preview image and trigger error
            const previewImg = screen.getByRole('img', { name: '' });
            fireEvent.error(previewImg);
            expect(screen.getByTestId('icon-image')).toBeInTheDocument();

            // Change value to working one
            rerender(<IconPicker {...defaultProps} value="/icons/working.svg" />);

            // Should show preview img again (with alt="")
            expect(screen.getByRole('img', { name: '' })).toBeInTheDocument();
        });
    });
});
