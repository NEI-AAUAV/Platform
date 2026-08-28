import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { renderHook, act, waitFor } from '@testing-library/react'
import { useServiceHealth } from '../../hooks/useServiceHealth'

describe('useServiceHealth', () => {
  beforeEach(() => {
    vi.useFakeTimers()
  })

  afterEach(() => {
    vi.useRealTimers()
    vi.restoreAllMocks()
  })

  it('returns "checking" when no targets provided', () => {
    const { result } = renderHook(() => useServiceHealth([]))
    expect(result.current).toBe('checking')
  })

  it('returns "checking" when targets is not an array', () => {
    const { result } = renderHook(() => useServiceHealth(undefined))
    expect(result.current).toBe('checking')
  })

  it('returns "up" when all targets are reachable', async () => {
    global.fetch = vi.fn().mockResolvedValue({})

    const { result } = renderHook(() =>
      useServiceHealth(['https://a.test', 'https://b.test'], { intervalMs: 60000 }),
    )

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })

    await waitFor(() => expect(result.current).toBe('up'))
  })

  it('returns "down" when all targets fail', async () => {
    global.fetch = vi.fn().mockRejectedValue(new Error('network error'))

    const { result } = renderHook(() =>
      useServiceHealth(['https://a.test'], { intervalMs: 60000 }),
    )

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })

    await waitFor(() => expect(result.current).toBe('down'))
  })

  it('returns "degraded" when some targets fail', async () => {
    global.fetch = vi
      .fn()
      .mockResolvedValueOnce({})
      .mockRejectedValueOnce(new Error('network error'))

    const { result } = renderHook(() =>
      useServiceHealth(['https://a.test', 'https://b.test'], { intervalMs: 60000 }),
    )

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })

    await waitFor(() => expect(result.current).toBe('degraded'))
  })

  it('re-checks on interval', async () => {
    global.fetch = vi.fn().mockResolvedValue({})

    renderHook(() => useServiceHealth(['https://a.test'], { intervalMs: 1000 }))

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })
    expect(global.fetch).toHaveBeenCalledTimes(1)

    await act(async () => {
      await vi.advanceTimersByTimeAsync(1000)
    })
    expect(global.fetch).toHaveBeenCalledTimes(2)
  })

  it('stops checking and clears interval on unmount', async () => {
    global.fetch = vi.fn().mockResolvedValue({})

    const { unmount } = renderHook(() =>
      useServiceHealth(['https://a.test'], { intervalMs: 1000 }),
    )

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })
    const callsBeforeUnmount = global.fetch.mock.calls.length

    unmount()

    await act(async () => {
      await vi.advanceTimersByTimeAsync(5000)
    })
    expect(global.fetch.mock.calls.length).toBe(callsBeforeUnmount)
  })

  it('ignores falsy target entries', async () => {
    global.fetch = vi.fn().mockResolvedValue({})

    renderHook(() => useServiceHealth([null, undefined, 'https://a.test', false]))

    await act(async () => {
      await vi.advanceTimersByTimeAsync(0)
    })
    expect(global.fetch).toHaveBeenCalledTimes(1)
  })
})
