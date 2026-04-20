import { describe, it, expect, vi, beforeEach } from 'vitest'

// vi.hoisted ensures mockClient is defined before the mock factory below runs
const mockClient = vi.hoisted(() => ({
  get: vi.fn(),
  post: vi.fn(),
  delete: vi.fn(),
}))

// Must use relative paths — vi.mock factories don't resolve tsconfig path aliases
vi.mock('../../config', () => ({ default: { API_NEI_URL: 'http://localhost/api/nei/v1' } }))
vi.mock('../../services/client', () => ({ createClient: () => mockClient }))

const service = (await import('../../services/NEIService')).default

describe('NEIService - Authentik admin methods', () => {
  beforeEach(() => vi.clearAllMocks())

  it('getAuthentikGroups calls GET /admin/authentik/groups', async () => {
    mockClient.get.mockResolvedValue([])
    await service.getAuthentikGroups()
    expect(mockClient.get).toHaveBeenCalledWith('/admin/authentik/groups')
  })

  it('addUserToAuthentikGroup calls POST with correct path', async () => {
    mockClient.post.mockResolvedValue({})
    await service.addUserToAuthentikGroup('grp-uuid', 42)
    expect(mockClient.post).toHaveBeenCalledWith(
      '/admin/authentik/groups/grp-uuid/members/42'
    )
  })

  it('removeUserFromAuthentikGroup calls DELETE with correct path', async () => {
    mockClient.delete.mockResolvedValue({})
    await service.removeUserFromAuthentikGroup('grp-uuid', 42)
    expect(mockClient.delete).toHaveBeenCalledWith(
      '/admin/authentik/groups/grp-uuid/members/42'
    )
  })

  it('logout calls POST /auth/logout/', async () => {
    mockClient.post.mockResolvedValue({ status: 'ok', end_session_url: null })
    await service.logout()
    expect(mockClient.post).toHaveBeenCalledWith('/auth/logout/')
  })
})
