import { describe, it, expect, vi, beforeEach } from 'vitest'
import axios from 'axios'
import { refreshToken } from '../../services/client'

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

// Mock config
vi.mock('config', () => ({
  default: {
    API_NEI_URL: 'http://localhost:8000'
  }
}))

describe('refreshToken', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('successfully refreshes token', async () => {
    const mockResponse = {
      data: {
        access_token: 'new-access-token'
      }
    }
    
    mockedAxios.create.mockReturnValue({
      post: vi.fn().mockResolvedValue(mockResponse)
    })

    const result = await refreshToken()
    
    expect(result).toBe('new-access-token')
    expect(mockUserStore.getState().login).toHaveBeenCalledWith({ 
      token: 'new-access-token' 
    })
  })

  it('handles refresh token failure', async () => {
    mockedAxios.create.mockReturnValue({
      post: vi.fn().mockRejectedValue(new Error('Refresh failed'))
    })

    const result = await refreshToken()
    
    expect(result).toBeUndefined()
    expect(mockUserStore.getState().logout).toHaveBeenCalled()
  })

  it('uses correct API endpoint', async () => {
    const mockAxiosInstance = {
      post: vi.fn().mockResolvedValue({ data: { access_token: 'token' } })
    }
    mockedAxios.create.mockReturnValue(mockAxiosInstance)

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
