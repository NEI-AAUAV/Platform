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

// Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: vi.fn().mockImplementation(query => ({
    matches: query === '(prefers-color-scheme: dark)',
    media: query,
    onchange: null,
    addListener: vi.fn(),
    removeListener: vi.fn(),
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
    dispatchEvent: vi.fn(),
  })),
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
vi.mock('../../utils', () => ({
  parseJWT: vi.fn()
}))

describe('useUserStore - Theme Management', () => {
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

  it('sets theme from localStorage', () => {
    localStorageMock.getItem.mockReturnValue('dark')
    
    // Re-import to trigger theme initialization
    vi.resetModules()
    require('../../stores/useUserStore')
    
    expect(document.body.setAttribute).toHaveBeenCalledWith('class', 'dark')
    expect(document.body.setAttribute).toHaveBeenCalledWith('data-theme', 'dark')
  })

  it('sets theme from system preference when no localStorage', () => {
    localStorageMock.getItem.mockReturnValue(null)
    window.matchMedia.mockReturnValue({ matches: true })
    
    vi.resetModules()
    require('../../stores/useUserStore')
    
    expect(document.body.setAttribute).toHaveBeenCalledWith('class', 'dark')
  })

  it('updates theme correctly', () => {
    const { setTheme } = useUserStore.getState()
    
    setTheme('dark')
    
    expect(localStorageMock.setItem).toHaveBeenCalledWith('th', 'dark')
    expect(document.body.setAttribute).toHaveBeenCalledWith('class', 'dark')
    expect(document.body.setAttribute).toHaveBeenCalledWith('data-theme', 'dark')
    expect(document.documentElement.className).toBe('dark')
    
    const state = useUserStore.getState()
    expect(state.theme).toBe('dark')
  })

  it('switches between light and dark themes', () => {
    const { setTheme } = useUserStore.getState()
    
    setTheme('dark')
    expect(useUserStore.getState().theme).toBe('dark')
    
    setTheme('light')
    expect(useUserStore.getState().theme).toBe('light')
    expect(document.documentElement.className).toBe('')
  })
})
