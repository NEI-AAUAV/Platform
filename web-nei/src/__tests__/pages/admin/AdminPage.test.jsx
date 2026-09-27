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
    signOutEverywhere: vi.fn(),
    getAdminActivity: vi.fn(),
    getSystemStatus: vi.fn(),
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
const { describeActivity } = await import('../../../pages/admin/sections/Activity')
const { formatDateTime } = await import('../../../pages/admin/formatDate')

const ADMIN_USER = {
  id: 1, name: 'Admin', surname: 'User', email: 'admin@test.com',
  scopes: ['admin'], authentik_sub: 'sub-admin', last_login_at: '2026-09-20T14:05:00Z',
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

const SYSTEM = {
  commit: '0123456789abcdef',
  production: false,
  database: { current: 'd6f8b0c2e4a7', expected: 'd6f8b0c2e4a7' },
  extensions: ['gala'],
  integrations: { oidc: true, authentik_api: true, email: false, recaptcha: false },
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
    service.getAdminActivity.mockResolvedValue({ items: [], total: 0 })
    service.getSystemStatus.mockResolvedValue(SYSTEM)
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

    it('explains why roles are unavailable and still lists users without role columns', async () => {
      service.getAuthentikStatus.mockResolvedValue({ ...STATUS, groups_managed: false })
      renderAt()

      expect(await screen.findByText('Role management is unavailable')).toBeInTheDocument()
      expect(screen.getByRole('link', { name: 'Open Authentik' })).toHaveAttribute('href', STATUS.admin_url)
      expect(await screen.findByText('admin@test.com')).toBeInTheDocument()
      expect(screen.queryByRole('columnheader', { name: 'admin' })).not.toBeInTheDocument()
      expect(service.getAuthentikGroups).not.toHaveBeenCalled()
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
      expect(await screen.findByText('Gave Admin User the admin role')).toBeInTheDocument()
    })

    it('removes a user from a group', async () => {
      service.removeUserFromAuthentikGroup.mockResolvedValue({})
      renderAt()

      fireEvent.click(await screen.findByLabelText('admin role for Admin'))

      await waitFor(() =>
        expect(service.removeUserFromAuthentikGroup).toHaveBeenCalledWith('grp-uuid-1', ADMIN_USER.id)
      )
      expect(await screen.findByText('Removed the admin role from Admin User')).toBeInTheDocument()
    })

    it('shows when each user last signed in', async () => {
      renderAt()

      expect(await screen.findByText(formatDateTime(ADMIN_USER.last_login_at))).toBeInTheDocument()
      expect(screen.getByText('never')).toBeInTheDocument()
    })

    it('filters to accounts that never signed in with Authentik', async () => {
      renderAt()
      await screen.findByText('admin@test.com')
      fireEvent.click(screen.getByLabelText('Only accounts that never signed in with Authentik'))

      expect(await screen.findByText(/Showing 1 of 2 users/)).toBeInTheDocument()
      expect(screen.queryByText('admin@test.com')).not.toBeInTheDocument()
      expect(screen.getByText('bob@test.com')).toBeInTheDocument()
    })

    it('signs a user out everywhere after confirmation', async () => {
      service.signOutEverywhere.mockResolvedValue({ sessions_ended: 2 })
      const confirm = vi.spyOn(globalThis, 'confirm').mockReturnValue(true)
      renderAt()

      fireEvent.click(await screen.findByRole('button', { name: 'Sign Bob out everywhere' }))

      await waitFor(() => expect(service.signOutEverywhere).toHaveBeenCalledWith(PLAIN_USER.id))
      expect(
        await screen.findByText('Signed Bob Smith out everywhere (2 sessions ended)')
      ).toBeInTheDocument()
      confirm.mockRestore()
    })

    it('does not sign anyone out when the confirmation is cancelled', async () => {
      const confirm = vi.spyOn(globalThis, 'confirm').mockReturnValue(false)
      renderAt()

      fireEvent.click(await screen.findByRole('button', { name: 'Sign Bob out everywhere' }))

      expect(service.signOutEverywhere).not.toHaveBeenCalled()
      confirm.mockRestore()
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

  describe('Activity', () => {
    it.each([
      [{ action: 'role.add', target_name: 'Bob Smith', detail: { role: 'admin' } }, 'gave Bob Smith the admin role'],
      [{ action: 'role.remove', target_name: 'Bob Smith', detail: { role: 'admin' } }, 'removed the admin role from Bob Smith'],
      [{ action: 'sessions.revoke', target_name: 'Bob Smith', detail: { sessions: 1 } }, 'signed Bob Smith out everywhere (1 session ended)'],
      [{ action: 'arraial.config', detail: { boosts_enabled: true, paused: false } }, 'changed Arraial settings: boosts on, pause off'],
      [{ action: 'arraial.reset', detail: null }, 'reset Arraial'],
      [{ action: 'role.add', target_name: null, detail: { role: 'admin' } }, 'gave a deleted account the admin role'],
    ])('describes %o', (entry, text) => {
      expect(describeActivity(entry)).toBe(text)
    })

    it('lists entries and loads older ones', async () => {
      const entry = (id, action) => ({
        id, action, created_at: '2026-09-27T10:00:00Z', actor_name: 'Ana Admin',
        target_name: null, detail: null,
      })
      service.getAdminActivity
        .mockResolvedValueOnce({ items: [entry(2, 'arraial.reset')], total: 2 })
        .mockResolvedValueOnce({ items: [entry(1, 'arraial.reset')], total: 2 })
      renderAt('/admin?tab=activity')

      expect(await screen.findAllByText('Ana Admin')).toHaveLength(1)
      fireEvent.click(screen.getByRole('button', { name: 'Load older entries' }))

      await waitFor(() => expect(screen.getAllByText('Ana Admin')).toHaveLength(2))
      expect(service.getAdminActivity).toHaveBeenLastCalledWith(1, 50)
      expect(screen.queryByRole('button', { name: 'Load older entries' })).not.toBeInTheDocument()
    })

    it('says when nothing has been recorded', async () => {
      renderAt('/admin?tab=activity')

      expect(await screen.findByText('Nothing recorded yet.')).toBeInTheDocument()
    })
  })

  describe('System', () => {
    it('shows the deployment and integrations', async () => {
      renderAt('/admin?tab=system')

      expect(await screen.findByText('0123456')).toBeInTheDocument()
      expect(screen.getByText('up to date')).toBeInTheDocument()
      expect(screen.getByText('gala')).toBeInTheDocument()
      expect(screen.queryByRole('alert')).not.toBeInTheDocument()
    })

    it('warns when the database is behind the code', async () => {
      service.getSystemStatus.mockResolvedValue({
        ...SYSTEM, database: { current: 'c5e7a9b1d3f6', expected: 'd6f8b0c2e4a7' },
      })
      renderAt('/admin?tab=system')

      expect(await screen.findByText('out of date')).toBeInTheDocument()
      expect(screen.getByRole('alert')).toHaveTextContent('Run the migrations')
    })

    it('warns about integrations that are off in production only', async () => {
      service.getSystemStatus.mockResolvedValue({ ...SYSTEM, production: true, commit: null })
      renderAt('/admin?tab=system')

      expect(
        await screen.findByText('Switched off in production: Email sending, reCAPTCHA on sign-up.')
      ).toBeInTheDocument()
      expect(screen.getByText('Not recorded (local build)')).toBeInTheDocument()
    })
  })

  describe('Your account', () => {
    it('shows the signed-in user and their scopes', async () => {
      renderAt('/admin?tab=account')

      expect(await screen.findByText('Admin User')).toBeInTheDocument()
      expect(screen.getByText('admin')).toBeInTheDocument()
      expect(screen.getByRole('link', { name: 'Family manager' })).toHaveAttribute('href', '/settings/family')
    })

    it('explains how to recover when the profile fails to load', async () => {
      service.getCurrUser.mockRejectedValue(new Error('boom'))
      renderAt('/admin?tab=account')

      expect(await screen.findByText(/Reload the page to try again/)).toBeInTheDocument()
    })
  })
})
