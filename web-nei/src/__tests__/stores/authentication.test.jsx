import { describe, it, expect, vi, beforeEach } from 'vitest'
import { useUserStore } from '../../stores/useUserStore'

// Mock localStorage
const localStorageMock = {
  getItem: vi.fn(),
  setItem: vi.fn(),
  removeItem: vi.fn(),
  clear: vi.fn(),
}
Object.defineProperty(window, 'localStorage', {
  value: localStorageMock
})

// Mock document methods
Object.defineProperty(document, 'body', {
  value: {
    setAttribute: vi.fn(),
    getAttribute: vi.fn(),
  },
  writable: true,
})

Object.defineProperty(document.documentElement, 'className', {
  value: '',
  writable: true,
})

// Mock parseJWT
vi.mock('../../utils/index', () => ({
  parseJWT: vi.fn()
}))

describe('useUserStore - Authentication', () => {
  beforeEach(() => {
    vi.clearAllMocks()
    // Reset store state
    useUserStore.setState({
      sessionLoading: true,
      theme: 'light',
      image: null,
      sub: null,
      name: null,
      surname: null,
      token: null,
    })
  })

  it('logs in with valid token', () => {
    const mockPayload = {
      sub: 'user123',
      name: 'John',
      surname: 'Doe',
      image: 'avatar.jpg'
    }
    
    // Get the mocked parseJWT function
    const utilsModule = vi.mocked(vi.importMock('../../utils/index'))
    const parseJWT = utilsModule.parseJWT
    parseJWT.mockReturnValue(mockPayload)
    
    const { login } = useUserStore.getState()
    login({ token: 'valid-token' })
    
    const state = useUserStore.getState()
    expect(state.token).toBe('valid-token')
    expect(state.sessionLoading).toBe(false)
    expect(state.sub).toBe('user123')
    expect(state.name).toBe('John')
    expect(state.surname).toBe('Doe')
    expect(state.image).toBe('avatar.jpg')
  })

  it('logs in without token', () => {
    const { login } = useUserStore.getState()
    login({ token: null })
    
    const state = useUserStore.getState()
    expect(state.token).toBe(null)
    expect(state.sessionLoading).toBe(false)
  })

  it('logs out correctly', () => {
    // First login
    const { login } = useUserStore.getState()
    login({ token: 'token', name: 'John', surname: 'Doe' })
    
    // Then logout
    const { logout } = useUserStore.getState()
    logout()
    
    const state = useUserStore.getState()
    expect(state.token).toBe(null)
    expect(state.name).toBe(null)
    expect(state.surname).toBe(null)
    expect(state.image).toBe(null)
    expect(state.sessionLoading).toBe(false)
  })

  it('handles empty JWT payload', () => {
    // Get the mocked parseJWT function
    const utilsModule = vi.mocked(vi.importMock('../../utils/index'))
    const parseJWT = utilsModule.parseJWT
    parseJWT.mockReturnValue({})
    
    const { login } = useUserStore.getState()
    login({ token: 'valid-token' })
    
    const state = useUserStore.getState()
    expect(state.token).toBe('valid-token')
    expect(state.sessionLoading).toBe(false)
  })

  it('preserves theme during logout', () => {
    const { setTheme, login, logout } = useUserStore.getState()
    
    setTheme('dark')
    login({ token: 'token' })
    logout()
    
    const state = useUserStore.getState()
    expect(state.theme).toBe('dark')
  })
})
