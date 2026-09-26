import { describe, it, expect, vi, beforeEach } from 'vitest'
import { renderHook, waitFor, act } from '@testing-library/react'

vi.mock('../../../services/NEIService', () => ({
  default: {
    getArraialConfig: vi.fn(),
    getArraialPoints: vi.fn(),
  },
}))

const listeners = {}
const fakeSocket = {
  readyState: 1,
  addEventListener: vi.fn((type, fn) => { listeners[type] = fn }),
  removeEventListener: vi.fn(),
}
vi.mock('../../../services/SocketService', () => ({
  getArraialSocket: vi.fn(() => fakeSocket),
}))

import service from '../../../services/NEIService'
import useArraialRealtime from '../../../pages/Arraial/hooks/useArraialRealtime'

const POINTS = [
  { nucleo: 'NEEETA', value: 0 },
  { nucleo: 'NEECT', value: 0 },
  { nucleo: 'NEI', value: 0 },
]

describe('useArraialRealtime', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    service.getArraialPoints.mockResolvedValue(POINTS)
  })

  it('treats boosts and milestones as off when the config omits them', async () => {
    service.getArraialConfig.mockResolvedValue({ enabled: true, paused: false })

    const { result } = renderHook(() => useArraialRealtime())

    await waitFor(() => expect(result.current.enabled).toBe(true))
    expect(result.current.boostsEnabled).toBe(false)
    expect(result.current.milestonesEnabled).toBe(false)
  })

  it('reads the flags from the config endpoint', async () => {
    service.getArraialConfig.mockResolvedValue({
      enabled: true, paused: false, boosts_enabled: true, milestones_enabled: true,
    })

    const { result } = renderHook(() => useArraialRealtime())

    await waitFor(() => expect(result.current.boostsEnabled).toBe(true))
    expect(result.current.milestonesEnabled).toBe(true)
  })

  it('updates the flags from ARRAIAL_CONFIG socket messages', async () => {
    service.getArraialConfig.mockResolvedValue({ enabled: true, paused: false })
    const { result } = renderHook(() => useArraialRealtime())
    await waitFor(() => expect(result.current.enabled).toBe(true))

    act(() => {
      listeners.message({
        data: JSON.stringify({
          topic: 'ARRAIAL_CONFIG',
          enabled: true,
          paused: false,
          boosts_enabled: true,
          milestones_enabled: true,
        }),
      })
    })

    expect(result.current.boostsEnabled).toBe(true)
    expect(result.current.milestonesEnabled).toBe(true)
  })
})
