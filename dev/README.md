# Development Environment Configuration

This directory contains configurations **only for local development**.

## Purpose

The `dev/` directory isolates development-specific configurations from production code, making it clear what's used where.

## Contents

### proxy/

Internal nginx proxy for local development routing.

**Used in:** `docker-compose up` (development)  
**Not used in:** Production (uses Infrastructure/nginx instead)

See [`proxy/README.md`](./proxy/README.md) for detailed documentation.

## Development vs Production

| Environment | Routing | Config Location |
|-------------|---------|-----------------|
| **Development** | Internal proxy (this directory) | `dev/proxy/` |
| **Production** | External standalone-nginx | `../../Infrastructure/nginx/` |

## Why This Separation?

1. **Clarity**: Obvious what's dev-only vs production
2. **Safety**: Can't accidentally use dev configs in production
3. **Organization**: Easy to find dev-specific tools
4. **Onboarding**: New developers immediately understand structure

## Adding Dev Tools

Future dev-specific configurations can go here:
- `dev/docker/` - Docker development helpers
- `dev/scripts/` - Development-only scripts
- `dev/fixtures/` - Test data
- etc.

## See Also

- Platform extensions: [`../EXTENSIONS.md`](../EXTENSIONS.md)
- Main compose file: [`../compose.yml`](../compose.yml)



