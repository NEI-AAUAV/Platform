import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import Dialog, { EventDialog } from '../../components/Dialog'

// Skip animations: render the dialog synchronously and drop it on exit
vi.mock('framer-motion', async () => {
  const React = await import('react')
  return {
    AnimatePresence: ({ children }) => <>{children}</>,
    motion: {
      dialog: React.forwardRef(({ children, layoutId, initial, animate, exit, transition, ...rest }, ref) => (
        <dialog ref={ref} {...rest}>{children}</dialog>
      )),
    },
  }
})

const rect = (r) => ({ top: 0, bottom: 0, left: 0, right: 0, ...r })

beforeEach(() => {
  window.innerWidth = 1000
  window.innerHeight = 800
})

const trigger = () => screen.getByRole('button', { name: 'abrir' })

describe('Dialog (uncontrolled)', () => {
  const setup = () =>
    render(
      <Dialog dialog={<p>conteúdo</p>} className="x">
        abrir
      </Dialog>
    )

  it('is closed until the trigger is activated', () => {
    setup()

    expect(screen.queryByText('conteúdo')).not.toBeInTheDocument()
  })

  it('opens on click', async () => {
    setup()

    await userEvent.click(trigger())

    expect(screen.getByText('conteúdo')).toBeInTheDocument()
  })

  it.each(['{Enter}', ' '])('opens with the keyboard (%j)', async (key) => {
    setup()
    trigger().focus()

    await userEvent.keyboard(key)

    expect(screen.getByText('conteúdo')).toBeInTheDocument()
  })

  it('ignores other keys', async () => {
    setup()
    trigger().focus()

    await userEvent.keyboard('a')

    expect(screen.queryByText('conteúdo')).not.toBeInTheDocument()
  })

  it('closes when clicking outside the dialog', async () => {
    setup()
    await userEvent.click(trigger())
    const dialog = screen.getByText('conteúdo').closest('dialog')
    dialog.getBoundingClientRect = () => rect({ left: 0, right: 10, top: 0, bottom: 10 })

    fireEvent.click(document.body, { clientX: 500, clientY: 500 })

    expect(screen.queryByText('conteúdo')).not.toBeInTheDocument()
  })

  it('stays open when clicking inside the dialog', async () => {
    setup()
    await userEvent.click(trigger())
    const dialog = screen.getByText('conteúdo').closest('dialog')
    dialog.getBoundingClientRect = () => rect({ left: 0, right: 100, top: 0, bottom: 100 })

    fireEvent.click(dialog, { clientX: 50, clientY: 50 })

    expect(screen.getByText('conteúdo')).toBeInTheDocument()
  })
})

describe('Dialog positioning', () => {
  const open = async (box) => {
    render(<Dialog dialog={<p>conteúdo</p>}>abrir</Dialog>)
    trigger().parentElement // wrapper
    trigger().getBoundingClientRect = () => rect(box)
    await userEvent.click(trigger())
    return screen.getByText('conteúdo').closest('dialog')
  }

  it('opens below-right of a trigger near the top-left corner', async () => {
    const dialog = await open({ top: 10, bottom: 30, left: 10, right: 30 })

    expect(dialog).toHaveClass('Dialog--top-left')
  })

  it('opens above-right of a trigger near the bottom-right corner', async () => {
    const dialog = await open({ top: 760, bottom: 780, left: 960, right: 990 })

    expect(dialog).toHaveClass('Dialog--bottom-right')
  })

  it('uses a fixed full-width layout on small screens', async () => {
    window.innerWidth = 400
    const dialog = await open({ top: 10, bottom: 30, left: 10, right: 30 })

    expect(dialog).toHaveClass('!fixed')
    expect(dialog.className).not.toMatch(/Dialog--/)
  })
})

describe('Dialog (controlled)', () => {
  it('follows the show prop and reports every change', () => {
    const onShowChange = vi.fn()
    const { rerender } = render(
      <Dialog dialog={<p>conteúdo</p>} show={false} onShowChange={onShowChange}>
        abrir
      </Dialog>
    )
    expect(screen.queryByText('conteúdo')).not.toBeInTheDocument()

    rerender(
      <Dialog dialog={<p>conteúdo</p>} show={true} onShowChange={onShowChange}>
        abrir
      </Dialog>
    )

    expect(screen.getByText('conteúdo')).toBeInTheDocument()
  })

  it('asks the parent to open instead of opening itself', async () => {
    const onShowChange = vi.fn()
    render(
      <Dialog dialog={<p>conteúdo</p>} show={false} onShowChange={onShowChange}>
        abrir
      </Dialog>
    )

    await userEvent.click(trigger())

    expect(onShowChange).toHaveBeenCalledWith(true)
    expect(screen.queryByText('conteúdo')).not.toBeInTheDocument()
  })
})

describe('EventDialog', () => {
  const category = { name: 'Workshop', color: '10 20% 30%' }
  const render_ = (start, end, extra = {}) =>
    render(
      <EventDialog event={{ title: 'Aula aberta', category, start, end }} show={true} onShowChange={vi.fn()} {...extra}>
        abrir
      </EventDialog>
    )
  const month = (d) => d.toLocaleString('pt-PT', { month: 'long', year: 'numeric' })

  it('shows category and title', () => {
    render_(new Date(2026, 8, 1), new Date(2026, 8, 1))

    expect(screen.getByText('Workshop')).toBeInTheDocument()
    expect(screen.getByText('Aula aberta')).toBeInTheDocument()
  })

  it('formats a single day', () => {
    const d = new Date(2026, 8, 1)
    render_(d, d)

    expect(screen.getByText(`1 de ${month(d)}`)).toBeInTheDocument()
  })

  it('formats a range inside one month', () => {
    const s = new Date(2026, 8, 1), e = new Date(2026, 8, 3)
    render_(s, e)

    expect(screen.getByText(`1 – 3 de ${month(s)}`)).toBeInTheDocument()
  })

  it('formats a range across months', () => {
    const s = new Date(2026, 8, 30), e = new Date(2026, 9, 2)
    render_(s, e)

    expect(screen.getByText(`30 de ${month(s)} – 2 de ${month(e)}`)).toBeInTheDocument()
  })

  it('renders no date when it is incomplete', () => {
    const { container } = render_(undefined, undefined)

    expect(container.querySelector('p.mt-2').textContent).toBe('')
  })

  it('closes through the close button', async () => {
    const onShowChange = vi.fn()
    render_(new Date(2026, 8, 1), new Date(2026, 8, 1), { onShowChange })

    await userEvent.click(screen.getByRole('button', { name: '' }))

    expect(onShowChange).toHaveBeenLastCalledWith(false)
  })

  it('renders no content without an event', () => {
    render(<EventDialog event={null} show={true} onShowChange={vi.fn()}>abrir</EventDialog>)

    expect(screen.queryByText('Workshop')).not.toBeInTheDocument()
  })
})
