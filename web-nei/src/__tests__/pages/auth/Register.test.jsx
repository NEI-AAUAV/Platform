import { describe, it, expect, vi, afterEach } from 'vitest'
import React from 'react'
import { render } from '@testing-library/react'

vi.mock('config', () => ({
  default: { AUTHENTIK_ENROLL_URL: 'https://test.example.com/enroll' },
}))

const { Component } = await import('../../../pages/auth/Register/index')

describe('Register', () => {
  afterEach(() => vi.unstubAllGlobals())

  it('redirects to Authentik enrollment URL on mount', () => {
    const replaceMock = vi.fn()
    vi.stubGlobal('location', { replace: replaceMock })
    render(<Component />)
    expect(replaceMock).toHaveBeenCalledWith('https://test.example.com/enroll')
  })
})
