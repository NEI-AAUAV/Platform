# NEI Platform Extensions Guide

This guide explains how to control which extensions are loaded in the NEI Platform.

## Overview

The NEI Platform supports extensions that can be enabled or disabled without modifying the main codebase. Extensions are controlled via the `ENABLED_EXTENSIONS` environment variable.

## Available Extensions

- **rally**: Rally Tascas extension (team management, checkpoints, scoring)
- **gala**: Gala extension (event management)

## Extension Control Methods

### Method 1: Using .env file (Recommended)

Create a `.env` file in the Platform root directory:

```bash
# Enable only Rally extension
ENABLED_EXTENSIONS=rally

# Enable multiple extensions
ENABLED_EXTENSIONS=rally,gala

# Disable all extensions
ENABLED_EXTENSIONS=

# Or simply don't create the .env file (defaults to no extensions)
```

Then run:
```bash
docker-compose up -d --build api_nei
```

### Method 2: Environment Variable Override

Override the environment variable directly in the command:

```bash
# Enable Rally
ENABLED_EXTENSIONS=rally docker-compose up -d --build api_nei

# Enable Gala
ENABLED_EXTENSIONS=gala docker-compose up -d --build api_nei

# Enable both
ENABLED_EXTENSIONS=rally,gala docker-compose up -d --build api_nei

# Disable all
ENABLED_EXTENSIONS= docker-compose up -d --build api_nei
```

### Method 3: Modify compose.yml (Not Recommended)

You can directly modify the `compose.yml` file, but this is not recommended as it requires file changes:

```yaml
environment:
  ENABLED_EXTENSIONS: "rally"  # or "rally,gala" or ""
```

## Quick Start Examples

### Run with Rally Extension

```bash
# Create .env file
echo "ENABLED_EXTENSIONS=rally" > .env

# Start platform
docker-compose up -d --build api_nei

# Verify Rally is loaded
curl http://localhost:8000/api/nei/v1/extensions/manifest
```

### Run with No Extensions

```bash
# Remove .env file or set empty
echo "ENABLED_EXTENSIONS=" > .env

# Start platform
docker-compose up -d --build api_nei

# Verify no extensions are loaded
curl http://localhost:8000/api/nei/v1/extensions/manifest
```

### Run with Multiple Extensions

```bash
# Enable both Rally and Gala
echo "ENABLED_EXTENSIONS=rally,gala" > .env

# Start platform
docker-compose up -d --build api_nei
```

## Verification

### Check Extensions API

```bash
# Check which extensions are loaded
curl http://localhost:8000/api/nei/v1/extensions/manifest

# Expected output with Rally enabled:
# {"nav":[{"label":"Rally Tascas","href":"/rally","requiresScopes":["manager-rally","admin"],"extension":"rally"}]}

# Expected output with no extensions:
# {"nav":[]}
```

### Check Available Scopes

```bash
# Check available OAuth2 scopes
curl http://localhost:8000/api/nei/v1/auth/scopes

# Rally extension adds: manager-rally, rally-staff
# Gala extension adds: manager-gala
```

### Check Frontend Navigation

Visit http://localhost:3000 and check if extension navigation items appear:
- **Rally**: "Rally Tascas" navtab
- **Gala**: Gala-related navigation items

## Extension Development

### Adding New Extensions

1. Create extension directory in `extensions/your-extension/`
2. Add `manifest.json` with extension metadata
3. The extension will be automatically discovered if enabled

### Extension Manifest Format

```json
{
  "name": "your-extension",
  "version": "1.0.0",
  "scopes": [
    { "name": "manager-your-extension", "description": "Manage your extension" }
  ],
  "nav": [
    { "label": "Your Extension", "href": "/your-extension", "requiresScopes": ["manager-your-extension"] }
  ]
}
```

## Troubleshooting

### Extension Not Loading

1. Check the `.env` file exists and has correct format
2. Verify extension directory exists in `extensions/`
3. Check `manifest.json` is valid JSON
4. Rebuild the API container: `docker-compose up -d --build api_nei`
5. Check API logs: `docker-compose logs api_nei`

### Extension Still Showing After Disabling

1. Clear browser cache
2. Restart the web container: `docker-compose restart web_nei`
3. Verify API returns empty extensions: `curl http://localhost:8000/api/nei/v1/extensions/manifest`

### Environment Variable Not Working

1. Ensure compose.yml uses `${ENABLED_EXTENSIONS:-}` syntax
2. Check environment variable is set: `docker-compose exec api_nei env | grep ENABLED_EXTENSIONS`
3. Rebuild container to pick up environment changes

## Architecture Notes

- Extensions are loaded at API startup, not runtime
- Extension manifests are read from the filesystem
- Only enabled extensions are loaded into memory
- Extension scopes are registered in the OAuth2 system
- Frontend navigation is dynamically generated from extension manifests

## Security Considerations

- Extension scopes are automatically registered in the OAuth2 system
- Only users with appropriate scopes can access extension features
- Extension containers should be run separately from the main platform
- Extension code runs in isolated containers with limited permissions
