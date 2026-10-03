import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, waitFor, within } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import Details from '../../../pages/Notes/Details'
import service from '../../../services/NEIService'

// Must use relative paths - vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../../services/NEIService', () => ({ default: { getNotesById: vi.fn() } }))

const baseNote = {
  name: 'Resumo de Cálculo',
  location: 'https://files.example/resumo.pdf',
  size: 2_500_000,
  year: 2023,
  subject: { name: 'Cálculo I' },
  subject_id: 7,
  author: { name: 'Ana', surname: 'Silva' },
  author_id: 11,
  teacher: { name: 'Prof. Rui', personal_page: 'https://ua.pt/rui' },
  teacher_id: 5,
  summary: '0',
  tests: '0',
  bibliography: '0',
  slides: '0',
  exercises: '0',
  projects: '0',
  notebook: '0',
}

let props
beforeEach(() => {
  vi.clearAllMocks()
  vi.spyOn(console, 'error').mockImplementation(() => {})
  vi.spyOn(console, 'log').mockImplementation(() => {})
  Element.prototype.scrollIntoView = vi.fn()
  props = {
    note_id: 1,
    close: vi.fn(),
    setSelSubject: vi.fn(),
    setSelYear: vi.fn(),
    setSelStudent: vi.fn(),
    setSelTeacher: vi.fn(),
    setSelPage: vi.fn(),
    setAlert: vi.fn(),
    className: 'c',
  }
})

const load = async (note) => {
  service.getNotesById.mockResolvedValue({ ...baseNote, ...note })
  const view = render(<Details {...props} />)
  await screen.findByText(note?.name ?? baseNote.name)
  return view
}

describe('Details loading', () => {
  it('shows a spinner and requests the note by id', async () => {
    service.getNotesById.mockReturnValue(new Promise(() => {}))

    render(<Details {...props} note_id={42} />)

    expect(screen.getByTitle('A carregar...')).toBeInTheDocument()
    expect(service.getNotesById).toHaveBeenCalledWith(42)
  })

  it('reloads when the selected note changes', async () => {
    service.getNotesById.mockResolvedValue(baseNote)
    const { rerender } = render(<Details {...props} note_id={1} />)
    await screen.findByText(baseNote.name)

    rerender(<Details {...props} note_id={2} />)

    await waitFor(() => expect(service.getNotesById).toHaveBeenCalledWith(2))
  })

  it('alerts the user and renders nothing when loading fails', async () => {
    service.getNotesById.mockRejectedValue(new Error('boom'))

    const { container } = render(<Details {...props} />)

    await waitFor(() => expect(props.setAlert).toHaveBeenCalledTimes(1))
    expect(props.setAlert.mock.calls[0][0]).toMatchObject({ type: 'alert' })
    expect(container).toBeEmptyDOMElement()
  })
})

describe('Details tags', () => {
  it('shows no tag when every flag is off', async () => {
    const { container } = await load()

    expect(container.querySelectorAll('.badge')).toHaveLength(0)
  })

  it.each([
    ['summary', 'Resumos'],
    ['tests', 'Testes e exames'],
    ['bibliography', 'Bibliografia'],
    ['slides', 'Slides'],
    ['exercises', 'Exercícios'],
    ['projects', 'Projetos'],
    ['notebook', 'Caderno'],
  ])('shows "%s" as "%s" only when flagged with "1"', async (flag, label) => {
    await load({ [flag]: '1' })

    expect(await screen.findByText(label)).toBeInTheDocument()
  })
})

describe('Details link', () => {
  const link = () => document.querySelector('a[href][target="_blank"]')

  it('offers a download for pdf and zip files', async () => {
    await load({ location: 'https://x/y.pdf' })
    expect(within(link()).getByText('Descarregar')).toBeInTheDocument()
  })

  it('offers a download for zip files', async () => {
    await load({ location: 'https://x/y.zip' })
    expect(within(link()).getByText('Descarregar')).toBeInTheDocument()
  })

  it.each([
    ['https://github.com/nei/repo', 'Repositório'],
    ['https://drive.google.com/file/d/1', 'Google Drive'],
  ])('labels %s as "%s" instead of a download', async (location, caption) => {
    await load({ location })
    expect(await within(link()).findByText(caption)).toBeInTheDocument()
  })

  it('opens in a new tab safely', async () => {
    await load()
    expect(link()).toHaveAttribute('rel', 'noreferrer')
    expect(link()).toHaveAttribute('href', baseNote.location)
  })
})

describe('Details size', () => {
  it.each([
    [500, '500.0 bytes'],
    [1500, '1.5 KB'],
    [2_500_000, '2.5 MB'],
    [3_000_000_000, '3.0 GB'],
  ])('formats %d bytes as %s', async (size, text) => {
    await load({ size })
    expect(screen.getByText(`(${text})`)).toBeInTheDocument()
  })

  it('hides the size when unknown', async () => {
    await load({ size: 0 })
    expect(screen.queryByText(/bytes|KB|MB|GB/)).not.toBeInTheDocument()
  })
})

describe('Details metadata and filters', () => {
  const filterOf = (label) =>
    screen.getByText(label).closest('dt').querySelector('button')

  it('shows the academic year as a range', async () => {
    await load()
    expect(screen.getByText('2023-2024')).toBeInTheDocument()
  })

  it('shows subject, author and teacher', async () => {
    await load()
    expect(screen.getByText('Cálculo I')).toBeInTheDocument()
    expect(screen.getByText('Ana Silva')).toBeInTheDocument()
    expect(screen.getByText('Prof. Rui')).toBeInTheDocument()
  })

  it('omits sections the note has no data for', async () => {
    await load({ year: 0, subject: null, author: null, teacher: null })
    ;['Ano letivo', 'Cadeira', 'Autor', 'Docente'].forEach((l) =>
      expect(screen.queryByText(l)).not.toBeInTheDocument()
    )
  })

  it.each([
    ['Ano letivo', 'setSelYear', 2023],
    ['Cadeira', 'setSelSubject', 7],
    ['Autor', 'setSelStudent', 11],
    ['Docente', 'setSelTeacher', 5],
  ])('filtering by "%s" selects it and goes back to page 1', async (label, setter, value) => {
    await load()

    await userEvent.click(filterOf(label))

    expect(props[setter]).toHaveBeenCalledWith(value)
    expect(props.setSelPage).toHaveBeenCalledWith(1)
  })

  it('links to the teacher profile when there is one', async () => {
    await load()
    expect(screen.getByTitle('Perfil do docente ua.pt')).toHaveAttribute('href', 'https://ua.pt/rui')
  })

  it('has no profile link without a personal page', async () => {
    await load({ teacher: { name: 'Prof. Rui' } })
    expect(screen.queryByTitle('Perfil do docente ua.pt')).not.toBeInTheDocument()
  })

  it('closes through the close button', async () => {
    await load()
    const header = screen.getByText(baseNote.name).parentElement

    await userEvent.click(within(header).getByRole('button'))

    expect(props.close).toHaveBeenCalled()
  })

  it('scrolls the notes list into view when the note loads', async () => {
    const anchor = document.createElement('div')
    anchor.id = 'notes'
    anchor.scrollIntoView = vi.fn()
    document.body.appendChild(anchor)

    await load()

    expect(anchor.scrollIntoView).toHaveBeenCalledWith({ behavior: 'smooth' })
    anchor.remove()
  })
})

describe('Details contents tree', () => {
  const contents = ['docs/', 'docs/a.pdf', 'docs/sub/b.pdf', 'readme.txt']

  // The tree is built in an effect after the note renders
  const loadTree = async (note) => {
    await load(note)
    await screen.findByText('readme.txt')
  }

  it('is not shown for notes without contents', async () => {
    await load()
    expect(screen.queryByText('Conteúdo')).not.toBeInTheDocument()
  })

  it('shows top level entries first, with children collapsed', async () => {
    await loadTree({ contents })

    expect(screen.getByText('Conteúdo')).toBeInTheDocument()
    expect(screen.getByText('docs')).toBeInTheDocument()
    expect(screen.getByText('readme.txt')).toBeInTheDocument()
    expect(screen.queryByText('a.pdf')).not.toBeInTheDocument()
  })

  it('expands and collapses a folder on click', async () => {
    await loadTree({ contents })
    const folder = screen.getByText('docs').closest('[role="button"]')

    await userEvent.click(folder)
    expect(folder).toHaveAttribute('aria-expanded', 'true')
    expect(screen.getByText('a.pdf')).toBeInTheDocument()
    expect(screen.getByText('sub')).toBeInTheDocument()

    await userEvent.click(folder)
    expect(screen.queryByText('a.pdf')).not.toBeInTheDocument()
  })

  it('expands with the keyboard', async () => {
    await loadTree({ contents })
    screen.getByText('docs').closest('[role="button"]').focus()

    await userEvent.keyboard('{Enter}')

    expect(screen.getByText('a.pdf')).toBeInTheDocument()
  })

  it('files are not expandable', async () => {
    await loadTree({ contents })
    const file = screen.getByText('readme.txt').closest('[role="button"]')

    await userEvent.click(file)

    expect(file).not.toHaveAttribute('aria-expanded')
    expect(file).toHaveAttribute('tabindex', '-1')
  })

  it('nests deeper folders', async () => {
    await loadTree({ contents })
    await userEvent.click(screen.getByText('docs').closest('[role="button"]'))
    await userEvent.click(screen.getByText('sub').closest('[role="button"]'))

    expect(screen.getByText('b.pdf')).toBeInTheDocument()
  })
})
