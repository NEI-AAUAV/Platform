#!/bin/bash

# Generic Extension Management Script
# Automatically starts/stops extension containers based on ENABLED_EXTENSIONS
# Works with any extension that follows the standard structure

set -e

COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"

echo "Managing extensions based on ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS'"

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

# Function to get extension services from compose override file
get_extension_services() {
    local override_file="$1"
    if [[ ! -f "$override_file" ]]; then
        return
    fi
    
    # Extract service names from compose file (services that are not in main compose.yml)
    # Only return services that actually exist in the compose file
    grep -E "^  [a-zA-Z_][a-zA-Z0-9_]*:" "$override_file" | sed 's/^  //; s/:$//' | grep -v -E "^(web_nei|api_nei|proxy|db_pg|db_mongo|ofelia)$" | while read -r service; do
        # Check if service is actually defined (not just referenced)
        if grep -q "^  $service:" "$override_file"; then
            echo "$service"
        fi
    done
}

# Function to generate nginx config for extension
generate_nginx_config() {
    local extension="$1"
    local manifest_file="$COMPOSE_DIR/extensions/$extension/manifest.json"
    
    if [[ ! -f "$manifest_file" ]]; then
        echo "Manifest file not found: $manifest_file"
        return
    fi
    
    # Extract extension info from manifest
    local extension_name=$(jq -r '.name // empty' "$manifest_file" 2>/dev/null || echo "$extension")
    local api_port=$(jq -r '.api.port // empty' "$manifest_file" 2>/dev/null || echo "")
    local web_port=$(jq -r '.web.port // empty' "$manifest_file" 2>/dev/null || echo "")
    
    # Generate nginx config
    local nginx_file="$COMPOSE_DIR/proxy/locations.$extension.conf"
    
    if is_extension_enabled "$extension"; then
        # Enabled config
        cat > "$nginx_file" << EOF
# $extension_name Extension Routes (enabled)

location ~ ^/(api|static)/$extension(/.*)?$ {
    limit_except GET POST PUT DELETE {
        deny all;
    }
    
    proxy_pass http://api_$extension:${api_port};
}

location ~ ^/$extension(/.*)?$ {
    proxy_pass http://web_$extension:${web_port};
}
EOF
    else
        # Disabled config - proxy to main platform for consistent 404 handling
        cat > "$nginx_file" << EOF
# $extension_name Extension Routes (disabled)
# Proxy to main platform for consistent 404 handling

location ~ ^/(api|static)/$extension(/.*)?$ {
    return 404;
}

location ~ ^/$extension(/.*)?$ {
    proxy_pass http://web_nei:3000;
}
EOF
    fi
}

# Function to manage extension containers
manage_extension() {
    local extension="$1"
    local override_file="$COMPOSE_DIR/extensions/$extension/compose.override.yml"
    
    if [[ ! -f "$override_file" ]]; then
        echo "Override file not found: $override_file"
        return
    fi
    
    # Generate nginx config
    generate_nginx_config "$extension"
    
    if is_extension_enabled "$extension"; then
        echo "Starting $extension extension..."
        docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" up -d
    else
        echo "Stopping $extension extension..."
        # Get extension services and stop them
        local services=$(get_extension_services "$override_file")
        if [[ -n "$services" ]]; then
            docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" stop $services || true
        fi
        
        # Clean up extension database schemas
        echo "Cleaning up database schemas for disabled extensions..."
        FORCE_CLEANUP=true "$COMPOSE_DIR/scripts/manage-extension-databases.sh" --only "$extension"
    fi
}

# Function to restart proxy to apply nginx config changes
restart_proxy() {
    echo "Restarting proxy to apply nginx configuration changes..."
    docker-compose -f "$COMPOSE_DIR/compose.yml" restart proxy || true
    sleep 3
    
    # Verify nginx configuration is applied correctly
    echo "Verifying nginx configuration..."
    for extension in rally gala; do
        if [[ -f "$COMPOSE_DIR/proxy/locations.$extension.conf" ]]; then
            local expected_config=$(cat "$COMPOSE_DIR/proxy/locations.$extension.conf")
            local container_config=$(docker exec platform-proxy-1 cat "/etc/nginx/conf.d/locations.$extension.conf" 2>/dev/null || echo "")
            
            if [[ "$expected_config" != "$container_config" ]]; then
                echo "Nginx config mismatch for $extension, forcing container recreation..."
                docker-compose -f "$COMPOSE_DIR/compose.yml" stop proxy
                docker-compose -f "$COMPOSE_DIR/compose.yml" rm -f proxy
                docker-compose -f "$COMPOSE_DIR/compose.yml" up -d proxy
                sleep 5
                break
            fi
        fi
    done
}

# Function to discover extensions
discover_extensions() {
    local extensions_dir="$COMPOSE_DIR/extensions"
    if [[ ! -d "$extensions_dir" ]]; then
        return
    fi
    
    # Find all directories with compose.override.yml
    find "$extensions_dir" -maxdepth 1 -type d -name "*" | while read -r dir; do
        local extension=$(basename "$dir")
        if [[ "$extension" != "extensions" ]] && [[ -f "$dir/compose.override.yml" ]]; then
            echo "$extension"
        fi
    done
}

# Discover and manage all extensions
echo "Discovering extensions..."
extensions=$(discover_extensions)

if [[ -z "$extensions" ]]; then
    echo "No extensions found"
else
    echo "$extensions" | while read -r extension; do
        if [[ -n "$extension" ]]; then
            manage_extension "$extension"
        fi
    done
fi

# Restart proxy to apply nginx configuration changes
restart_proxy

# Sync external nginx (standalone-nginx) configuration
sync_external_nginx() {
    echo "Syncing external nginx configuration..."
    
    # Check if standalone-nginx container exists
    if ! docker ps -a --format "{{.Names}}" | grep -q "^standalone-nginx$"; then
        echo "⚠ standalone-nginx container not found, skipping external nginx sync"
        return 0
    fi
    
    # Check if container is running
    if ! docker ps --format "{{.Names}}" | grep -q "^standalone-nginx$"; then
        echo "⚠ standalone-nginx container is not running, skipping external nginx sync"
        return 0
    fi
    
    echo "Syncing nginx configs for ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS'"
    
    # Run sync script in nginx container
    if docker exec standalone-nginx sh -c "export ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS' && /scripts/sync-extensions.sh"; then
        # Reload nginx to apply changes
        docker exec standalone-nginx nginx -s reload
        echo "✓ External nginx configuration synced and reloaded"
    else
        echo "✗ Failed to sync external nginx configuration"
        echo "  You may need to manually sync: docker exec standalone-nginx /scripts/sync-extensions.sh"
        return 1
    fi
}

sync_external_nginx

echo "Extension management complete!"
