import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'

// Must use relative paths — vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../../services/NEIService', () => ({
  default: {
    getCurrUser: vi.fn(),
    getUsers: vi.fn(),
    getAuthentikGroups: vi.fn(),
    getArraialConfig: vi.fn(),
    addUserToAuthentikGroup: vi.fn(),
    removeUserFromAuthentikGroup: vi.fn(),
    setArraialConfig: vi.fn(),
    resetArraial: vi.fn(),
  },
}))

vi.mock('../../../stores/useUserStore', () => ({ useUserStore: vi.fn() }))

vi.mock('../../../services/SocketService', () => ({
  getArraialSocket: vi.fn(() => ({
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  })),
}))

import service from '../../../services/NEIService'
import { useUserStore } from '../../../stores/useUserStore'
const { Component } = await import('../../../pages/admin/Roles')

const ADMIN_USER = {
  id: 1, name: 'Admin', surname: 'User', email: 'admin@test.com',
  scopes: ['admin'], authentik_sub: 'sub-admin',
}
const PLAIN_USER = {
  id: 2, name: 'Bob', surname: 'Smith', email: 'bob@test.com',
  scopes: ['default'], authentik_sub: null,
}
const GROUP = { pk: 'grp-uuid-1', name: 'nei-admin', member_subs: ['sub-admin'] }

function setup(token = 'tok') {
  useUserStore.mockImplementation((selector) => selector({ token }))
}

describe('Roles', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    service.getCurrUser.mockResolvedValue(ADMIN_USER)
    service.getUsers.mockResolvedValue([ADMIN_USER, PLAIN_USER])
    service.getAuthentikGroups.mockResolvedValue([GROUP])
    service.getArraialConfig.mockResolvedValue({ enabled: false, paused: false })
  })

  it('shows Unauthorized when no token', () => {
    setup(null)
    render(<Component />)
    expect(screen.getByText('Unauthorized')).toBeInTheDocument()
  })

  it('renders heading when token present', async () => {
    setup()
    render(<Component />)
    await waitFor(() => expect(service.getCurrUser).toHaveBeenCalled())
    expect(screen.getByText(/Admin · Roles/)).toBeInTheDocument()
  })

  it('shows non-admin message when user lacks admin scope', async () => {
    service.getCurrUser.mockResolvedValue({ ...PLAIN_USER, scopes: ['default'] })
    setup()
    render(<Component />)
    await waitFor(() =>
      expect(screen.getByText(/You need admin scope/)).toBeInTheDocument()
    )
  })

  it('loads users and groups for admin', async () => {
    setup()
    render(<Component />)
    await waitFor(() => expect(service.getUsers).toHaveBeenCalled())
    await waitFor(() => expect(service.getAuthentikGroups).toHaveBeenCalled())
  })

  it('renders email filter input for admin', async () => {
    setup()
    render(<Component />)
    await waitFor(() => expect(service.getUsers).toHaveBeenCalled())
    expect(screen.getByPlaceholderText(/Filter by email/)).toBeInTheDocument()
  })

  it('filters users by email', async () => {
    setup()
    render(<Component />)
    await waitFor(() => expect(screen.getByPlaceholderText(/Filter by email/)).toBeInTheDocument())
    fireEvent.change(screen.getByPlaceholderText(/Filter by email/), {
      target: { value: 'admin' },
    })
    await waitFor(() =>
      expect(screen.getByText(/Showing 1 of 2 users/)).toBeInTheDocument()
    )
  })

  it('shows arraial config section for admin', async () => {
    service.getArraialConfig.mockResolvedValue({ enabled: true, paused: false })
    setup()
    render(<Component />)
    await waitFor(() =>
      expect(screen.getByText('Enable Arraial')).toBeInTheDocument()
    )
  })

  it('calls setArraialConfig when arraial toggle changes', async () => {
    service.getArraialConfig.mockResolvedValue({ enabled: false, paused: false })
    service.setArraialConfig.mockResolvedValue({})
    setup()
    render(<Component />)
    await waitFor(() =>
      expect(screen.getByText('Enable Arraial')).toBeInTheDocument()
    )

    // The arraial toggles are .toggle checkboxes (not .checkbox-sm)
    const enableToggle = screen
      .getAllByRole('checkbox')
      .find((c) => c.className.includes('toggle') && !c.className.includes('checkbox-sm'))
    fireEvent.click(enableToggle)
    await waitFor(() =>
      expect(service.setArraialConfig).toHaveBeenCalledWith(true, false)
    )
  })

  it('shows no-SSO badge for user without authentik_sub', async () => {
    setup()
    render(<Component />)
    await waitFor(() => expect(screen.getByText('no SSO')).toBeInTheDocument())
  })

  it('calls addUserToAuthentikGroup for non-member with sub', async () => {
    // Admin user is NOT a member
    service.getAuthentikGroups.mockResolvedValue([{ ...GROUP, member_subs: [] }])
    service.addUserToAuthentikGroup.mockResolvedValue({})
    setup()
    render(<Component />)

    // Wait for the table to appear (loading resolves)
    await waitFor(() => expect(screen.getByText('no SSO')).toBeInTheDocument())

    const memberCheckboxes = screen
      .getAllByRole('checkbox')
      .filter((c) => c.className.includes('checkbox-sm') && !c.disabled)
    expect(memberCheckboxes.length).toBeGreaterThan(0)
    fireEvent.click(memberCheckboxes[0])
    await waitFor(() =>
      expect(service.addUserToAuthentikGroup).toHaveBeenCalledWith('grp-uuid-1', ADMIN_USER.id)
    )
  })
})
