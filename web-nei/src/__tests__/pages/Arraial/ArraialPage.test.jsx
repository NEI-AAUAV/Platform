import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, act } from '@testing-library/react'

vi.mock('../../../services/NEIService', () => ({ default: {} }))
vi.mock('../../../stores/useUserStore', () => ({
  useUserStore: vi.fn((selector) => selector({ scopes: [] })),
}))
vi.mock('../../../pages/Arraial/hooks/useArraialHistory', () => ({
  default: vi.fn(() => ({ load: vi.fn() })),
}))
vi.mock('../../../pages/Arraial/hooks/useArraialRealtime', () => ({ default: vi.fn() }))
vi.mock('react-particles', () => ({ default: () => null }))

import useArraialRealtime from '../../../pages/Arraial/hooks/useArraialRealtime'
const { Component } = await import('../../../pages/Arraial')

const at = (nei) => [
  { nucleo: 'NEEETA', value: 0 },
  { nucleo: 'NEECT', value: 0 },
  { nucleo: 'NEI', value: nei },
]

let pushPoints
function mockRealtime(overrides) {
  useArraialRealtime.mockImplementation(({ onPointsUpdate }) => {
    pushPoints = onPointsUpdate
    return {
      enabled: true,
      paused: false,
      wsConnected: true,
      boosts: {},
      boostsEnabled: false,
      milestonesEnabled: false,
      setBoosts: vi.fn(),
      ...overrides,
    }
  })
}

function crossFirstMilestone() {
  act(() => pushPoints(at(0)))
  act(() => pushPoints(at(50)))
}

describe('Arraial page', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('does not show the Shot Capacete toast when milestones are disabled', () => {
    mockRealtime({ milestonesEnabled: false })
    render(<Component />)

    crossFirstMilestone()

    expect(screen.queryByText('Shot Capacete')).not.toBeInTheDocument()
  })

  it('shows the Shot Capacete toast when milestones are enabled', () => {
    mockRealtime({ milestonesEnabled: true })
    render(<Component />)

    crossFirstMilestone()

    expect(screen.getByText('Shot Capacete')).toBeInTheDocument()
    expect(screen.getByText('— nº 50')).toBeInTheDocument()
  })

  it.each([
    [false, 0],
    [true, 1],
  ])('with boostsEnabled=%s shows %i boost countdown(s)', (boostsEnabled, count) => {
    const inFiveMinutes = new Date(Date.now() + 5 * 60 * 1000).toISOString()
    mockRealtime({ boostsEnabled, boosts: { NEI: inFiveMinutes } })

    render(<Component />)

    expect(screen.queryAllByText('1.25x')).toHaveLength(count)
  })
})
