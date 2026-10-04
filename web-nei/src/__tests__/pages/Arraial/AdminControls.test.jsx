import { describe, it, expect, vi } from 'vitest'
import { render, screen, fireEvent } from '@testing-library/react'
import AdminControls from '../../../pages/Arraial/components/AdminControls'

function renderControls(props = {}) {
  const onBoost = vi.fn()
  render(
    <AdminControls
      paused={false}
      boostsEnabled={false}
      selectedValue="NEI"
      number=""
      isLoading={false}
      onBoost={onBoost}
      onChangeNucleo={vi.fn()}
      onChangePoints={vi.fn()}
      onQuickAdjust={vi.fn()}
      onSubmit={vi.fn()}
      {...props}
    />
  )
  return { onBoost }
}

describe('AdminControls', () => {
  it('hides the boost buttons when boosts are disabled', () => {
    renderControls({ boostsEnabled: false })

    expect(screen.queryByText(/Boost 1.25x/)).not.toBeInTheDocument()
    expect(screen.getByRole('button', { name: '+1' })).toBeInTheDocument()
  })

  it('shows the boost buttons and activates a boost when boosts are enabled', () => {
    const { onBoost } = renderControls({ boostsEnabled: true })

    expect(screen.getByText(/Boost 1.25x/)).toBeInTheDocument()
    fireEvent.click(screen.getByRole('button', { name: 'NEECT' }))

    expect(onBoost).toHaveBeenCalledWith('NEECT')
  })
})
