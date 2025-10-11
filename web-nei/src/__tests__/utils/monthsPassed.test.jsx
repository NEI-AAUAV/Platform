import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { monthsPassed } from '../../utils/index'

describe('monthsPassed', () => {
  beforeEach(() => {
    // Mock current date to 2024-01-15
    vi.useFakeTimers()
    vi.setSystemTime(new Date('2024-01-15'))
  })

  afterEach(() => {
    vi.useRealTimers()
  })

  it('calculates months passed correctly for same year', () => {
    const pastDate = new Date('2024-01-01')
    expect(monthsPassed(pastDate)).toBe(0)
  })

  it('calculates months passed correctly across years', () => {
    const pastDate = new Date('2023-01-01')
    expect(monthsPassed(pastDate)).toBe(12)
  })

  it('calculates months passed correctly for partial months', () => {
    const pastDate = new Date('2023-12-01')
    expect(monthsPassed(pastDate)).toBe(1)
  })

  it('handles edge case of same month different year', () => {
    const pastDate = new Date('2023-01-15')
    expect(monthsPassed(pastDate)).toBe(12)
  })

  it('handles future dates correctly', () => {
    const futureDate = new Date('2024-02-01')
    expect(monthsPassed(futureDate)).toBe(-1)
  })
})
