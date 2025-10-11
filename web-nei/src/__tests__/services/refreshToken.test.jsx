import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { refreshToken } from '../../services/client'

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

// Mock config
vi.mock('config', () => ({
  default: {
    API_NEI_URL: 'http://localhost:8000'
  }
}))

describe('refreshToken', () => {
  let mockAxiosInstance
  let mockLogin
  let mockLogout
  let mockGetState

  beforeEach(() => {
    vi.clearAllMocks()
    
    mockLogin = vi.fn()
    mockLogout = vi.fn()
    mockGetState = vi.fn(() => ({
      token: 'mock-token',
      login: mockLogin,
      logout: mockLogout
    }))
    
    mockAxiosInstance = {
      post: vi.fn()
    }
    
    mockedAxios.create.mockReturnValue(mockAxiosInstance)
    
    // Mock the useUserStore module
    vi.doMock('stores/useUserStore', () => ({
      useUserStore: {
        getState: mockGetState
      }
    }))
  })

  it('successfully refreshes token', async () => {
    const mockResponse = {
      data: {
        access_token: 'new-access-token'
      }
    }
    
    mockAxiosInstance.post.mockResolvedValue(mockResponse)

    const result = await refreshToken()
    
    expect(result).toBe('new-access-token')
    expect(mockLogin).toHaveBeenCalledWith({ 
      token: 'new-access-token' 
    })
  })

  it('handles refresh token failure', async () => {
    mockAxiosInstance.post.mockRejectedValue(new Error('Refresh failed'))

    const result = await refreshToken()
    
    expect(result).toBeUndefined()
    expect(mockLogout).toHaveBeenCalled()
  })

  it('uses correct API endpoint', async () => {
    mockAxiosInstance.post.mockResolvedValue({ data: { access_token: 'token' } })

    await refreshToken()
    
    expect(mockedAxios.create).toHaveBeenCalledWith({
      baseURL: 'http://localhost:8000',
      timeout: 5000,
      headers: {
        Authorization: 'Bearer mock-token'
      }
    })
    expect(mockAxiosInstance.post).toHaveBeenCalledWith('/auth/refresh/')
  })
})
