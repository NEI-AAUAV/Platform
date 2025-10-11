import { describe, it, expect } from 'vitest'
import { parseJWT } from '../../utils/index'

describe('parseJWT', () => {
  it('parses valid JWT token correctly', () => {
    // Create a mock JWT token
    const header = { alg: 'HS256', typ: 'JWT' }
    const payload = { sub: '1234567890', name: 'John Doe', iat: 1516239022 }
    
    const encodedHeader = btoa(JSON.stringify(header))
    const encodedPayload = btoa(JSON.stringify(payload))
    const signature = 'mock-signature'
    
    const token = `${encodedHeader}.${encodedPayload}.${signature}`
    
    const result = parseJWT(token)
    expect(result).toEqual(payload)
  })

  it('handles JWT with special characters in payload', () => {
    const payload = { 
      sub: 'user@example.com', 
      name: 'José María', 
      roles: ['admin', 'user'] 
    }
    
    const encodedPayload = btoa(JSON.stringify(payload))
    const token = `header.${encodedPayload}.signature`
    
    const result = parseJWT(token)
    expect(result).toEqual(payload)
  })

  it('throws error for invalid JWT format', () => {
    const invalidToken = 'invalid-token'
    
    expect(() => parseJWT(invalidToken)).toThrow()
  })

  it('throws error for malformed base64', () => {
    const malformedToken = 'header.invalid-base64.signature'
    
    expect(() => parseJWT(malformedToken)).toThrow()
  })

  it('handles empty payload', () => {
    const payload = {}
    const encodedPayload = btoa(JSON.stringify(payload))
    const token = `header.${encodedPayload}.signature`
    
    const result = parseJWT(token)
    expect(result).toEqual(payload)
  })
})
