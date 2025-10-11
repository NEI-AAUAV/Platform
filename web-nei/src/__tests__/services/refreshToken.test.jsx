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
    const { useUserStore } = await import('stores/useUserStore')
    expect(useUserStore.getState().login).toHaveBeenCalledWith({ 
      token: 'new-access-token' 
    })
  })

  it('handles refresh token failure', async () => {
    mockedAxios.create.mockReturnValue({
      post: vi.fn().mockRejectedValue(new Error('Refresh failed'))
    })

    const result = await refreshToken()
    
    expect(result).toBeUndefined()
    const { useUserStore } = await import('stores/useUserStore')
    expect(useUserStore.getState().logout).toHaveBeenCalled()
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
