import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { createClient } from '../../services/client'

// Mock axios
vi.mock('axios')
const mockedAxios = vi.mocked(axios)

// Mock the user store
const mockUserStore = {
  getState: vi.fn(() => ({
    token: 'mock-token',
    login: vi.fn(),
    logout: vi.fn()
  }))
}

vi.mock('stores/useUserStore', () => ({
  useUserStore: mockUserStore
}))

describe('createClient', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('creates axios client with correct baseURL', () => {
    const baseURL = 'http://test-api.com'
    const client = createClient(baseURL)
    
    expect(mockedAxios.create).toHaveBeenCalledWith({
      baseURL,
      timeout: 5000
    })
  })

  it('adds authorization header to requests', () => {
    const client = createClient('http://test-api.com')
    
    // Get the request interceptor
    const requestInterceptor = mockedAxios.create.mock.calls[0][0]
    const config = { headers: {} }
    
    const result = requestInterceptor.request.use.mock.calls[0][0](config)
    
    expect(result.headers.Authorization).toBe('Bearer mock-token')
  })

  it('handles request errors', () => {
    const client = createClient('http://test-api.com')
    
    // Get the request interceptor error handler
    const requestInterceptor = mockedAxios.create.mock.calls[0][0]
    const error = new Error('Request failed')
    
    const result = requestInterceptor.request.use.mock.calls[0][1](error)
    
    expect(result).rejects.toThrow('Request failed')
  })

  it('processes successful responses', () => {
    const client = createClient('http://test-api.com')
    
    // Get the response interceptor
    const responseInterceptor = mockedAxios.create.mock.calls[0][0]
    const response = { data: { message: 'success' } }
    
    const result = responseInterceptor.response.use.mock.calls[0][0](response)
    
    expect(result).toEqual({ message: 'success' })
  })
})
