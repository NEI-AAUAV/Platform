import { describe, it, expect, vi, beforeEach } from 'vitest'
import React from 'react'
import { render } from '@testing-library/react'
import { MemoryRouter, Routes, Route } from 'react-router-dom'

// vi.hoisted ensures these are defined before mock factories run (which are hoisted)
const { mockNavigate, mockLogin } = vi.hoisted(() => ({
  mockNavigate: vi.fn(),
  mockLogin: vi.fn(),
}))

vi.mock('react-router-dom', async (importOriginal) => {
  const actual = await importOriginal()
  return { ...actual, useNavigate: () => mockNavigate }
})

// Must use relative path — vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../../stores/useUserStore', () => ({
  useUserStore: { getState: () => ({ login: mockLogin }) },
}))

const { Component } = await import('../../../pages/auth/OidcCallback/index')

function renderWith(hash = '') {
  return render(
    <MemoryRouter initialEntries={[`/auth/oidc/return${hash}`]}>
      <Routes>
        <Route path="/auth/oidc/return" element={<Component />} />
      </Routes>
    </MemoryRouter>
  )
}

describe('OidcCallback', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    vi.unstubAllGlobals()
  })

  it('navigates to /auth/login when no token in URL', () => {
    renderWith()
    expect(mockNavigate).toHaveBeenCalledWith('/auth/login')
  })

  it('calls login and navigates home when token is present in fragment', () => {
    renderWith('#token=mytoken123')
    expect(mockLogin).toHaveBeenCalledWith({ token: 'mytoken123' })
    expect(mockNavigate).toHaveBeenCalledWith('/')
  })

  it('calls location.replace when redirect_to is a safe relative path', () => {
    const replaceMock = vi.fn()
    vi.stubGlobal('location', {
      replace: replaceMock,
      hash: '#token=mytoken123&redirect_to=%2Fdashboard',
      pathname: '/auth/oidc/return',
      search: '',
    })
    renderWith('#token=mytoken123&redirect_to=%2Fdashboard')
    expect(mockLogin).toHaveBeenCalledWith({ token: 'mytoken123' })
    expect(replaceMock).toHaveBeenCalledWith('/dashboard')
  })

  it('ignores unsafe absolute redirect_to and navigates home', () => {
    renderWith('#token=mytoken123&redirect_to=https%3A%2F%2Fevil.com')
    expect(mockLogin).toHaveBeenCalledWith({ token: 'mytoken123' })
    expect(mockNavigate).toHaveBeenCalledWith('/')
  })

  it('ignores protocol-relative redirect_to and navigates home', () => {
    renderWith('#token=mytoken123&redirect_to=%2F%2Fevil.com')
    expect(mockLogin).toHaveBeenCalledWith({ token: 'mytoken123' })
    expect(mockNavigate).toHaveBeenCalledWith('/')
  })

  it('ignores tab-confusion redirect_to (/\\t/evil.com) and navigates home', () => {
    renderWith('#token=mytoken123&redirect_to=%2F%09%2Fevil.com')
    expect(mockLogin).toHaveBeenCalledWith({ token: 'mytoken123' })
    expect(mockNavigate).toHaveBeenCalledWith('/')
  })

  it('navigates to /auth/login?error=session_failed when login throws', () => {
    mockLogin.mockImplementation(() => { throw new Error('login failed') })
    renderWith('#token=badtoken')
    expect(mockNavigate).toHaveBeenCalledWith('/auth/login?error=session_failed')
  })
})
