import { describe, it, expect, vi, beforeEach } from 'vitest'
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'

// Must use relative paths - vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../../services/NEIService', () => ({
  default: {
    getCurrUser: vi.fn(),
    getUsers: vi.fn(),
    getAuthentikStatus: vi.fn(),
    getCmsInfo: vi.fn(),
    getAuthentikGroups: vi.fn(),
    getArraialConfig: vi.fn(),
    addUserToAuthentikGroup: vi.fn(),
    removeUserFromAuthentikGroup: vi.fn(),
    setArraialConfig: vi.fn(),
    resetArraial: vi.fn(),
  },
}))

vi.mock('../../../services/SocketService', () => ({
  getArraialSocket: vi.fn(() => ({
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  })),
}))

import service from '../../../services/NEIService'
const { Component } = await import('../../../pages/admin')

const ADMIN_USER = {
  id: 1, name: 'Admin', surname: 'User', email: 'admin@test.com',
  scopes: ['admin'], authentik_sub: 'sub-admin',
}
const PLAIN_USER = {
  id: 2, name: 'Bob', surname: 'Smith', email: 'bob@test.com',
  scopes: ['default'], authentik_sub: null,
}
const GROUP = { pk: 'grp-uuid-1', name: 'nei-admin', role: 'admin', member_subs: ['sub-admin'] }
const STATUS = {
  oidc_enabled: true,
  groups_managed: true,
  admin_url: 'https://sso.example.org/authentik/if/admin/',
}
const ARRAIAL_CFG = {
  enabled: true, paused: false, boosts_enabled: false, milestones_enabled: false,
}

function renderAt(path = '/admin') {
  return render(
    <MemoryRouter initialEntries={[path]}>
      <Component />
    </MemoryRouter>
  )
}

describe('Admin page', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    service.getCurrUser.mockResolvedValue(ADMIN_USER)
    service.getUsers.mockResolvedValue([ADMIN_USER, PLAIN_USER])
    service.getAuthentikStatus.mockResolvedValue(STATUS)
    service.getAuthentikGroups.mockResolvedValue([GROUP])
    service.getArraialConfig.mockResolvedValue(ARRAIAL_CFG)
    service.getCmsInfo.mockResolvedValue({ app_url: 'https://nei.example.org/cms/admin/' })
  })

  describe('tabs', () => {
    it('opens on Users & roles by default', async () => {
      renderAt()

      expect(screen.getByRole('tab', { name: 'Users & roles' })).toHaveAttribute('aria-selected', 'true')
      await screen.findByText('Sign-in and roles are managed by Authentik')
    })

    it('opens the tab named in the URL', async () => {
      renderAt('/admin?tab=arraial')

      expect(screen.getByRole('tab', { name: 'Arraial' })).toHaveAttribute('aria-selected', 'true')
      await screen.findByLabelText('Show the Arraial page')
      expect(service.getAuthentikStatus).not.toHaveBeenCalled()
    })

    it('falls back to Users & roles for an unknown tab', () => {
      renderAt('/admin?tab=nope')

      expect(screen.getByRole('tab', { name: 'Users & roles' })).toHaveAttribute('aria-selected', 'true')
    })

    it('switches tab on click and with the arrow keys', async () => {
      renderAt()

      fireEvent.click(screen.getByRole('tab', { name: 'Your account' }))
      expect(await screen.findByText('Admin User')).toBeInTheDocument()

      fireEvent.keyDown(screen.getByRole('tab', { name: 'Your account' }), { key: 'ArrowRight' })
      expect(screen.getByRole('tab', { name: 'Users & roles' })).toHaveAttribute('aria-selected', 'true')
    })
  })

  describe('Users & roles', () => {
    it('says Authentik manages sign-in and links to its admin UI', async () => {
      renderAt()

      await screen.findByText('Sign-in and roles are managed by Authentik')
      const link = screen.getByRole('link', { name: 'Open Authentik' })
      expect(link).toHaveAttribute('href', STATUS.admin_url)
      expect(link).toHaveAttribute('target', '_blank')
      expect(link).toHaveAttribute('rel', 'noopener noreferrer')
    })

    it('does not claim Authentik handles sign-in when OIDC is off', async () => {
      service.getAuthentikStatus.mockResolvedValue({ ...STATUS, oidc_enabled: false })
      renderAt()

      expect(await screen.findByText('Roles are managed by Authentik')).toBeInTheDocument()
      expect(screen.queryByText('Sign-in and roles are managed by Authentik')).not.toBeInTheDocument()
    })

    it('explains why groups are unavailable instead of showing an empty table', async () => {
      service.getAuthentikStatus.mockResolvedValue({ ...STATUS, groups_managed: false })
      renderAt()

      expect(await screen.findByText('Group management is unavailable')).toBeInTheDocument()
      expect(screen.getByRole('link', { name: 'Open Authentik' })).toHaveAttribute('href', STATUS.admin_url)
      expect(screen.queryByRole('table')).not.toBeInTheDocument()
      expect(service.getAuthentikGroups).not.toHaveBeenCalled()
      expect(service.getUsers).not.toHaveBeenCalled()
    })

    it('shows an error when the Authentik status cannot be loaded', async () => {
      service.getAuthentikStatus.mockRejectedValue(new Error('boom'))
      renderAt()

      expect(await screen.findByText(/Failed to load Authentik status: boom/)).toBeInTheDocument()
    })

    it('filters users by email', async () => {
      renderAt()
      fireEvent.change(await screen.findByPlaceholderText(/Filter by email/), {
        target: { value: 'admin' },
      })

      expect(await screen.findByText(/Showing 1 of 2 users/)).toBeInTheDocument()
    })

    it('heads each column with the role, keeping the group name as a hint', async () => {
      renderAt()

      const header = await screen.findByRole('columnheader', { name: 'admin' })
      expect(header).toHaveAttribute('title', 'Authentik group: nei-admin')
    })

    it('marks users who have not signed in with Authentik', async () => {
      renderAt()

      expect(await screen.findByText('no SSO')).toBeInTheDocument()
      expect(screen.getByLabelText('admin role for Bob')).toBeDisabled()
    })

    it('adds a user to a group', async () => {
      service.getAuthentikGroups.mockResolvedValue([{ ...GROUP, member_subs: [] }])
      service.addUserToAuthentikGroup.mockResolvedValue({})
      renderAt()

      fireEvent.click(await screen.findByLabelText('admin role for Admin'))

      await waitFor(() =>
        expect(service.addUserToAuthentikGroup).toHaveBeenCalledWith('grp-uuid-1', ADMIN_USER.id)
      )
      expect(await screen.findByText('Added Admin to nei-admin')).toBeInTheDocument()
    })

    it('removes a user from a group', async () => {
      service.removeUserFromAuthentikGroup.mockResolvedValue({})
      renderAt()

      fireEvent.click(await screen.findByLabelText('admin role for Admin'))

      await waitFor(() =>
        expect(service.removeUserFromAuthentikGroup).toHaveBeenCalledWith('grp-uuid-1', ADMIN_USER.id)
      )
    })
  })

  describe('Content', () => {
    it('links to the CMS and lists what is edited there', async () => {
      renderAt('/admin?tab=content')

      const link = await screen.findByRole('link', { name: 'Open CMS' })
      expect(link).toHaveAttribute('href', 'https://nei.example.org/cms/admin/')
      expect(link).toHaveAttribute('rel', 'noopener noreferrer')
      expect(screen.getByText('News')).toBeInTheDocument()
      expect(screen.getByText('RGM documents')).toBeInTheDocument()
    })

    it('sends admins to Users & roles to grant CMS access', async () => {
      renderAt('/admin?tab=content')

      fireEvent.click(await screen.findByRole('link', { name: 'Users & roles' }))

      expect(screen.getByRole('tab', { name: 'Users & roles' })).toHaveAttribute('aria-selected', 'true')
    })

    it('shows an error when the CMS link cannot be loaded', async () => {
      service.getCmsInfo.mockRejectedValue(new Error('boom'))
      renderAt('/admin?tab=content')

      expect(await screen.findByText(/Failed to load the CMS link: boom/)).toBeInTheDocument()
      expect(screen.queryByRole('link', { name: 'Open CMS' })).not.toBeInTheDocument()
    })
  })

  describe('Arraial', () => {
    it.each([
      ['Show the Arraial page', 'enabled'],
      ['Pause point updates', 'paused'],
      ['Boosts (1.25x)', 'boosts_enabled'],
      ['Shot Capacete milestones', 'milestones_enabled'],
    ])('toggling "%s" saves only %s', async (label, field) => {
      const current = { ...ARRAIAL_CFG, [field]: false }
      service.getArraialConfig.mockResolvedValue(current)
      service.setArraialConfig.mockResolvedValue({ ...current, [field]: true })
      renderAt('/admin?tab=arraial')

      const toggle = await screen.findByLabelText(label)
      expect(toggle).not.toBeChecked()
      fireEvent.click(toggle)

      await waitFor(() => expect(service.setArraialConfig).toHaveBeenCalledWith({ [field]: true }))
      await waitFor(() => expect(screen.getByLabelText(label)).toBeChecked())
    })

    it('resets only after confirmation', async () => {
      service.resetArraial.mockResolvedValue({ ok: true })
      const confirm = vi.spyOn(globalThis, 'confirm')
      renderAt('/admin?tab=arraial')
      const button = await screen.findByRole('button', { name: 'Reset Arraial' })

      confirm.mockReturnValueOnce(false)
      fireEvent.click(button)
      expect(service.resetArraial).not.toHaveBeenCalled()

      confirm.mockReturnValueOnce(true)
      fireEvent.click(button)
      await waitFor(() => expect(service.resetArraial).toHaveBeenCalledTimes(1))
      confirm.mockRestore()
    })
  })

  describe('Your account', () => {
    it('shows the signed-in user and their scopes', async () => {
      renderAt('/admin?tab=account')

      expect(await screen.findByText('Admin User')).toBeInTheDocument()
      expect(screen.getByText('admin')).toBeInTheDocument()
    })

    it('explains how to recover when the profile fails to load', async () => {
      service.getCurrUser.mockRejectedValue(new Error('boom'))
      renderAt('/admin?tab=account')

      expect(await screen.findByText(/Reload the page to try again/)).toBeInTheDocument()
    })
  })
})
