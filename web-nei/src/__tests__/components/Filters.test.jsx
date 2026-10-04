import { describe, it, expect, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import Filters from '../../components/Filters'

const filterList = [
  { filter: 'Futsal' },
  { filter: 'Voleibol', color: '#ff0000' },
  { filter: 'Andebol' },
]
const names = filterList.map((f) => f.filter)

const setup = (activeFilters) => {
  const setActiveFilters = vi.fn()
  render(
    <Filters
      filterList={filterList}
      activeFilters={activeFilters}
      setActiveFilters={setActiveFilters}
      btnClass=""
      allBtnClass=""
    />
  )
  return setActiveFilters
}

describe('Filters', () => {
  it('renders one pill per filter', () => {
    setup([])

    names.forEach((n) => expect(screen.getByText(n)).toBeInTheDocument())
  })

  it('offers "Todas" while some filter is inactive and selects every filter', async () => {
    const setActive = setup(['Futsal'])

    await userEvent.click(screen.getByRole('button', { name: 'Todas' }))

    expect(setActive).toHaveBeenCalledWith(names)
  })

  it('offers "Nenhumas" when everything is active and clears the selection', async () => {
    const setActive = setup(names)

    await userEvent.click(screen.getByRole('button', { name: 'Nenhumas' }))

    expect(setActive).toHaveBeenCalledWith([])
  })

  it('hides the toggle-all button when there is a single filter', () => {
    render(
      <Filters filterList={[{ filter: 'Só' }]} activeFilters={[]} setActiveFilters={vi.fn()} btnClass="" allBtnClass="" />
    )

    expect(screen.queryByRole('button', { name: /Todas|Nenhumas/ })).not.toBeInTheDocument()
  })

  it('reports the new selection when a pill is toggled', async () => {
    const setActive = setup(['Futsal'])

    await userEvent.click(screen.getByRole('checkbox', { name: 'Andebol' }))

    // react-bootstrap also passes the DOM event as 2nd argument
    expect(setActive.mock.calls[0][0]).toEqual(['Futsal', 'Andebol'])
  })
})
