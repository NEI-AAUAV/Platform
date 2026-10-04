import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import FilterSelect from '../../components/Filters/FilterSelect'

const filterList = [{ filter: 'Eventos' }, { filter: 'Avisos' }]

const setup = (props = {}) =>
  render(
    <FilterSelect
      filterList={filterList}
      activeFilters={[]}
      setActiveFilters={vi.fn()}
      btnClass=""
      allBtnClass=""
      {...props}
    >
      <span>cabeçalho</span>
    </FilterSelect>
  )

describe('FilterSelect', () => {
  it('renders the toggle and the children next to it', () => {
    setup()

    expect(screen.getByRole('button', { name: 'Filtros' })).toBeInTheDocument()
    expect(screen.getByText('cabeçalho')).toBeInTheDocument()
  })

  it('starts collapsed', () => {
    setup()

    expect(screen.getByText('Eventos').closest('.collapse')).not.toHaveClass('show')
  })

  it('expands the filter list when the toggle is clicked', async () => {
    setup()

    await userEvent.click(screen.getByRole('button', { name: 'Filtros' }))

    expect(screen.getByText('Eventos').closest('.collapse')).toHaveClass('show')
  })

  it('collapses again on a second click', async () => {
    setup()
    const toggle = screen.getByRole('button', { name: 'Filtros' })

    await userEvent.click(toggle)
    await userEvent.click(toggle)

    expect(screen.getByText('Eventos').closest('.collapse')).not.toHaveClass('show')
  })

  it('passes the available filters down to the pills', () => {
    setup()

    filterList.forEach(({ filter }) => expect(screen.getByText(filter)).toBeInTheDocument())
  })
})
