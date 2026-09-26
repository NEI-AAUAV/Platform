import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'

vi.mock('../../config', () => ({
  default: {
    ENABLE_RALLY: true,
    WEB_RALLY_URL: 'https://rally.test',
    ENABLE_GAMIFICATION: true,
    WEB_GAMIFICATION_URL: 'https://gamification.test',
    PRODUCTION: false,
  },
}))

vi.mock('../../services/NEIService', () => ({
  default: {
    getArraialConfig: vi.fn().mockResolvedValue({ enabled: false }),
    getExtensionsManifest: vi.fn().mockResolvedValue({ nav: [] }),
    logout: vi.fn().mockResolvedValue({}),
  },
}))

vi.mock('../../services/SocketService', () => ({
  getArraialSocket: vi.fn(() => ({
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  })),
  destroyArraialSocket: vi.fn(),
}))

import service from '../../services/NEIService'
import Navbar from '../../layouts/Navbar'
import { useUserStore } from '../../stores/useUserStore'

describe('Navbar', () => {
  beforeEach(() => {
    global.fetch = vi.fn().mockResolvedValue({})
    useUserStore.setState({
      theme: 'light',
      token: null,
      name: null,
      surname: null,
      image: null,
      scopes: [],
    })
  })

  afterEach(() => {
    vi.clearAllMocks()
  })

  it('renders external service links for Rally and Gamification', async () => {
    render(
      <MemoryRouter>
        <Navbar />
      </MemoryRouter>,
    )

    expect((await screen.findAllByText('Rally Tascas')).length).toBeGreaterThan(0)
    expect(screen.getAllByText('Quests').length).toBeGreaterThan(0)
  })

  it('disables external service link when health check reports down', async () => {
    global.fetch = vi.fn().mockRejectedValue(new Error('network error'))

    render(
      <MemoryRouter>
        <Navbar />
      </MemoryRouter>,
    )

    await waitFor(async () => {
      const rallyLinks = await screen.findAllByText('Rally Tascas')
      expect(rallyLinks.length).toBeGreaterThan(0)
      rallyLinks.forEach((link) =>
        expect(link.closest('li')).toHaveClass('pointer-events-none'),
      )
    })
  })

  it('shows login/register links when logged out', async () => {
    render(
      <MemoryRouter>
        <Navbar />
      </MemoryRouter>,
    )

    expect(await screen.findByText('Entrar')).toBeInTheDocument()
    expect(screen.getByText('Registar')).toBeInTheDocument()
  })

  it('shows user menu when logged in', async () => {
    useUserStore.setState({
      theme: 'light',
      token: 'abc',
      name: 'John',
      surname: 'Doe',
      image: null,
      scopes: [],
    })

    render(
      <MemoryRouter>
        <Navbar />
      </MemoryRouter>,
    )

    expect(await screen.findByText('John Doe')).toBeInTheDocument()
  })

  it('calls logout service on logout click', async () => {
    useUserStore.setState({
      theme: 'light',
      token: 'abc',
      name: 'John',
      surname: 'Doe',
      image: null,
      scopes: [],
    })

    const { container } = render(
      <MemoryRouter>
        <Navbar />
      </MemoryRouter>,
    )

    await screen.findByText('John Doe')
    const logoutItem = screen.getByText('Log out')
    logoutItem.closest('li').click()

    await waitFor(() => expect(service.logout).toHaveBeenCalled())
  })
})
