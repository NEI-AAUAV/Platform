import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render } from '@testing-library/react'
import { MemoryRouter, Routes, Route } from 'react-router-dom'

// Must use relative paths — vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../../stores/useUserStore', () => ({ useUserStore: vi.fn() }))
vi.mock('../../../config', () => ({
  default: { API_NEI_URL: 'http://localhost/api/nei/v1' },
}))

import { useUserStore } from '../../../stores/useUserStore'
const { Component } = await import('../../../pages/auth/Login/index')

const replaceMock = vi.fn()
const DEFAULT_STATE = { sessionLoading: false, token: null }

function renderWith(search = '', storeState = DEFAULT_STATE) {
  useUserStore.mockImplementation((selector) => selector(storeState))
  return render(
    <MemoryRouter initialEntries={[`/auth/login${search}`]}>
      <Routes>
        <Route path="/auth/login" element={<Component />} />
      </Routes>
    </MemoryRouter>
  )
}

describe('Login', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.stubGlobal('location', { replace: replaceMock })
  })

  it('does nothing while session is loading', () => {
    renderWith('', { sessionLoading: true, token: null })
    expect(replaceMock).not.toHaveBeenCalled()
  })

  it('redirects to / when already logged in', () => {
    renderWith('', { sessionLoading: false, token: 'valid-token' })
    expect(replaceMock).toHaveBeenCalledWith('/')
  })

  it('redirects to redirect_to param when logged in', () => {
    renderWith('?redirect_to=%2Fprofile', { sessionLoading: false, token: 'valid-token' })
    expect(replaceMock).toHaveBeenCalledWith('/profile')
  })

  it('redirects to OIDC login URL when not logged in', () => {
    renderWith('', { sessionLoading: false, token: null })
    expect(replaceMock).toHaveBeenCalledWith(
      expect.stringContaining('/auth/oidc/login')
    )
  })

  it('includes redirect_to in OIDC URL when present', () => {
    renderWith('?redirect_to=%2Fdashboard', { sessionLoading: false, token: null })
    expect(replaceMock).toHaveBeenCalledWith(
      expect.stringContaining('redirect_to=')
    )
  })
})
