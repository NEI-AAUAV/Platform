# NEI Platform Extensions Guide

This guide explains how to manage extensions in the NEI Platform, including starting the platform with extensions and controlling their lifecycle.

## Overview

The NEI Platform supports extensions that can be enabled or disabled without modifying the main codebase. Extensions are controlled via the `ENABLED_EXTENSIONS` environment variable and managed through automated scripts.

## Quick Start

### Start Platform with Extensions

```bash
# Start with no extensions
./start-platform.sh

# Start with Rally extension
ENABLED_EXTENSIONS="rally" ./start-platform.sh

# Start with multiple extensions
ENABLED_EXTENSIONS="rally,gala" ./start-platform.sh
```

### Manual Extension Control

```bash
# Disable all extensions
ENABLED_EXTENSIONS="" ./scripts/manage-extensions.sh

# Enable Rally only
ENABLED_EXTENSIONS="rally" ./scripts/manage-extensions.sh

# Enable multiple extensions
ENABLED_EXTENSIONS="rally,gala" ./scripts/manage-extensions.sh

# Force cleanup of all extension schemas (use with caution!)
FORCE_CLEANUP=true ./scripts/manage-extension-databases.sh

# Clean up only specific extension
./scripts/manage-extension-databases.sh --only rally --force-cleanup
```

## Available Extensions

- **rally**: Rally Tascas extension (team management, checkpoints, scoring)
- **gala**: Gala extension (event management)

## Generic Extension Management System

The platform uses a generic extension management system that:

- **Auto-discovers** extensions in `extensions/*/` directories
- **Generates nginx configurations** dynamically based on extension manifests
- **Manages container lifecycle** automatically (start/stop)
- **Works with any extension** following the standard structure
- **No hardcoded logic** - completely generic

### How It Works

1. **Discovery**: Scans `extensions/*/compose.override.yml` files
2. **Configuration**: Reads `manifest.json` for API/web ports and metadata
3. **Nginx Generation**: Creates enabled/disabled nginx configs automatically
4. **Container Management**: Starts/stops extension services based on `ENABLED_EXTENSIONS`
5. **Proxy Restart**: Applies nginx configuration changes

### Extension Structure

Each extension must follow this structure:

```
extensions/extension-name/
├── manifest.json          # Extension metadata (ports, scopes, etc.)
├── compose.override.yml   # Docker Compose override
├── api-extension/         # API service
└── web-extension/         # Web service
```

### Manifest Format

```json
{
  "name": "extension-name",
  "version": "1.0.0",
  "api": {
    "port": "8003"
  },
  "web": {
    "port": "3003"
  },
  "scopes": [
    { "name": "manager-extension", "description": "Manage extension data" }
  ],
  "nav": [
    { "label": "Extension", "href": "/extension", "requiresScopes": ["manager-extension", "admin"] }
  ]
}
```

## External Nginx Support

The generic extension management system can be adapted for external nginx servers:

### How It Works with External Nginx

1. **Config Generation**: Script generates nginx configs in `proxy/locations.*.conf`
2. **Config Deployment**: Copy generated configs to external nginx server
3. **Nginx Reload**: Reload external nginx to apply changes

### Example External Nginx Integration

```bash
# Generate extension nginx configs
ENABLED_EXTENSIONS="rally" ./scripts/manage-extensions.sh

# Copy configs to external nginx server
scp proxy/locations.*.conf user@nginx-server:/etc/nginx/conf.d/

# Reload external nginx
ssh user@nginx-server "nginx -s reload"
```

### Production Deployment

The system works seamlessly with the existing GitHub Actions deploy workflow:

- **Extension Selection**: Choose extensions via GitHub Actions input
- **Automatic Deployment**: Extension containers and nginx configs deployed automatically
- **Environment Variable Control**: `ENABLED_EXTENSIONS` controls everything

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
