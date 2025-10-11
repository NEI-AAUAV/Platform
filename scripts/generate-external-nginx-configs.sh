#!/bin/bash

# Generate nginx configurations for external nginx server
# This script generates nginx configs based on ENABLED_EXTENSIONS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"
OUTPUT_DIR="${OUTPUT_DIR:-$SCRIPT_DIR/nginx-configs}"

echo "Generating nginx configurations for external nginx server"
echo "ENABLED_EXTENSIONS: ${ENABLED_EXTENSIONS:-'(none)'}"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Function to check if extension is enabled
is_extension_enabled() {
    local extension="$1"
    if [[ -z "$ENABLED_EXTENSIONS" ]]; then
        return 1  # Not set - disable all
    fi
    if [[ "$ENABLED_EXTENSIONS" == *"$extension"* ]]; then
        return 0  # Enabled
    else
        return 1  # Disabled
    fi
}

# Function to generate nginx config for extension
generate_extension_nginx_config() {
    local extension="$1"
    local manifest_file="$SCRIPT_DIR/extensions/$extension/manifest.json"
    
    if [[ ! -f "$manifest_file" ]]; then
        echo "Manifest file not found: $manifest_file"
        return
    fi
    
    # Extract extension info from manifest
    local extension_name=$(jq -r '.name // empty' "$manifest_file" 2>/dev/null || echo "$extension")
    local api_port=$(jq -r '.api.port // empty' "$manifest_file" 2>/dev/null || echo "")
    local web_port=$(jq -r '.web.port // empty' "$manifest_file" 2>/dev/null || echo "")
    
    # Generate nginx config
    local nginx_file="$OUTPUT_DIR/locations.$extension.conf"
    
    if is_extension_enabled "$extension"; then
        # Enabled config - for external nginx with proper container names
        cat > "$nginx_file" << EOF
# $extension_name Extension Routes (enabled)

location ~ ^/(api|static)/$extension(/.*)?$ {
    limit_req zone=api burst=20 nodelay;
    
    proxy_pass http://platform-api_$extension-1:${api_port};
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
}

location ~ ^/$extension(/.*)?$ {
    proxy_pass http://platform-web_$extension-1:${web_port};
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
}
EOF
        echo "Generated enabled config for $extension"
    else
        # Disabled config - proxy to main platform for consistent 404 handling
        cat > "$nginx_file" << EOF
# $extension_name Extension Routes (disabled)
# Proxy to main platform for consistent 404 handling

location ~ ^/(api|static)/$extension(/.*)?$ {
    return 404;
}

location ~ ^/$extension(/.*)?$ {
    proxy_pass http://platform-web_nei-1:3000;
    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";
}
EOF
        echo "Generated disabled config for $extension"
    fi
}

# Generate configs for known extensions
generate_extension_nginx_config "rally"
generate_extension_nginx_config "gala"

# Copy main nginx configs
echo ""
echo "Copying main nginx configurations..."
cp "$SCRIPT_DIR/proxy/locations.conf" "$OUTPUT_DIR/"
cp "$SCRIPT_DIR/proxy/nginx.conf" "$OUTPUT_DIR/"

echo ""
echo "Nginx configurations generated successfully!"
echo "Output directory: $OUTPUT_DIR"
echo ""
echo "Generated files:"
ls -la "$OUTPUT_DIR/"
echo ""
echo "Next steps:"
echo "1. Copy nginx configs to your external nginx server"
echo "2. Reload nginx configuration"
echo ""
echo "Example commands:"
echo "  scp $OUTPUT_DIR/* user@nginx-server:/etc/nginx/conf.d/"
echo "  ssh user@nginx-server 'nginx -s reload'"
