import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { createClient } from '../../services/client'

// Mock axios
vi.mock('axios')
const mockedAxios = vi.mocked(axios)

// Mock the user store
vi.mock('stores/useUserStore', () => ({
  useUserStore: {
    getState: vi.fn(() => ({
      token: 'mock-token',
      login: vi.fn(),
      logout: vi.fn()
    }))
  }
}))

describe('createClient', () => {
  let mockAxiosInstance

  beforeEach(() => {
    vi.clearAllMocks()
    
    // Create a mock axios instance with interceptors
    mockAxiosInstance = {
      interceptors: {
        request: {
          use: vi.fn()
        },
        response: {
          use: vi.fn()
        }
      }
    }
    
    mockedAxios.create.mockReturnValue(mockAxiosInstance)
  })

  it('creates axios client with correct baseURL', () => {
    const baseURL = 'http://test-api.com'
    const client = createClient(baseURL)
    
    expect(mockedAxios.create).toHaveBeenCalledWith({
      baseURL,
      timeout: 5000
    })
    expect(client).toBe(mockAxiosInstance)
  })

  it('adds authorization header to requests', () => {
    createClient('http://test-api.com')
    
    // Get the request interceptor function
    const requestInterceptor = mockAxiosInstance.interceptors.request.use.mock.calls[0][0]
    const config = { headers: {} }
    
    const result = requestInterceptor(config)
    
    // Check that Authorization header was added
    expect(result.headers.Authorization).toBeDefined()
    expect(result.headers.Authorization).toMatch(/^Bearer /)
  })

  it('handles request errors', () => {
    createClient('http://test-api.com')
    
    // Get the request interceptor error handler
    const errorHandler = mockAxiosInstance.interceptors.request.use.mock.calls[0][1]
    const error = new Error('Request failed')
    
    const result = errorHandler(error)
    
    expect(result).rejects.toThrow('Request failed')
  })

  it('processes successful responses', () => {
    createClient('http://test-api.com')
    
    // Get the response interceptor
    const responseInterceptor = mockAxiosInstance.interceptors.response.use.mock.calls[0][0]
    const response = { data: { message: 'success' } }
    
    const result = responseInterceptor(response)
    
    expect(result).toEqual({ message: 'success' })
  })
})
