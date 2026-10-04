import { describe, it, expect, vi, afterEach } from 'vitest'
import { render } from '@testing-library/react'
import MultipleRangeInput from '../../components/MultipleRangeInput'

// React logs the thrown error before rethrowing it
afterEach(() => vi.restoreAllMocks())
const renders = (props) => {
  vi.spyOn(console, 'error').mockImplementation(() => {})
  return () => render(<MultipleRangeInput {...props} />)
}

describe('MultipleRangeInput validation', () => {
  it('rejects an odd number of boundaries', () => {
    expect(renders({ defaultValues: [[0, 50], [50]] })).toThrow(/pair number/)
  })

  it('rejects an empty list', () => {
    expect(renders({ defaultValues: [] })).toThrow(/pair number/)
  })

  it('rejects boundaries that go backwards', () => {
    expect(renders({ defaultValues: [[50, 25]] })).toThrow(/in order/)
  })

  it('rejects boundaries not separated by a multiple of step', () => {
    expect(renders({ defaultValues: [[0, 30]], step: 25 })).toThrow(/multiple of `step`/)
  })

  it('rejects unknown size and color', () => {
    expect(renders({ size: 'huge' })).toThrow(/size/)
    expect(renders({ color: 'pink' })).toThrow(/color/)
  })
})

describe('MultipleRangeInput rendering', () => {
  it('positions each range and handle as a percentage of the scale', () => {
    const { container } = render(
      <MultipleRangeInput min={0} max={100} step={25} defaultValues={[[0, 25], [50, 100]]} />
    )

    const ranges = container.querySelectorAll('.mulrange-ranges > div')
    const handles = container.querySelectorAll('.mulrange-handles > div')

    expect([...ranges].map((r) => [r.style.left, r.style.width])).toEqual([
      ['0%', '25%'],
      ['50%', '50%'],
    ])
    expect([...handles].map((h) => h.style.left)).toEqual(['0%', '25%', '50%', '100%'])
  })

  it('draws one tick per step including both ends', () => {
    const { container } = render(
      <MultipleRangeInput min={0} max={100} step={25} defaultValues={[[0, 25]]} />
    )

    expect(container.querySelectorAll('.select-none span')).toHaveLength(5)
  })

  it('applies size and color modifiers', () => {
    const { container } = render(
      <MultipleRangeInput min={0} max={100} step={25} defaultValues={[[0, 25]]} size="sm" color="primary" />
    )

    expect(container.querySelector('.mulrange')).toHaveClass('mulrange-sm', 'mulrange-primary')
  })
})
