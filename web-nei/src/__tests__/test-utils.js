// Test configuration and shared utilities
import { vi } from 'vitest'

// Global test setup
export const setupTestEnvironment = () => {
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

  return { localStorageMock }
}

// Helper to create mock JWT token
export const createMockJWT = (payload) => {
  const header = { alg: 'HS256', typ: 'JWT' }
  const encodedHeader = btoa(JSON.stringify(header))
  const encodedPayload = btoa(JSON.stringify(payload))
  const signature = 'mock-signature'
  return `${encodedHeader}.${encodedPayload}.${signature}`
}
