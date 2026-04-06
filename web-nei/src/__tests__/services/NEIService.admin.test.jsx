import { describe, it, expect, vi, beforeEach } from 'vitest'

const mockClient = { get: vi.fn(), post: vi.fn(), delete: vi.fn() }

vi.mock('config', () => ({ default: { API_NEI_URL: 'http://localhost/api/nei/v1' } }))
vi.mock('services/client', () => ({ createClient: () => mockClient }))

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
})
