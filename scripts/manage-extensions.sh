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
    
    # Split by comma and check for exact match (prevent false positives)
    IFS=',' read -ra EXTENSIONS <<< "$ENABLED_EXTENSIONS"
    for ext in "${EXTENSIONS[@]}"; do
        # Trim whitespace and check exact match
        ext=$(echo "$ext" | xargs)
        if [[ "$ext" == "$extension" ]]; then
            return 0  # Enabled
        fi
    done
    return 1  # Disabled
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

# Function to validate extension manifest
validate_manifest() {
    local manifest_file="$1"
    local extension="$2"
    
    if [[ ! -f "$manifest_file" ]]; then
        echo "✗ Error: Manifest not found for $extension: $manifest_file"
        return 1
    fi
    
    # Validate JSON structure
    if ! jq empty "$manifest_file" 2>/dev/null; then
        echo "✗ Error: Invalid JSON in manifest for $extension: $manifest_file"
        return 1
    fi
    
    # Check required fields
    local name=$(jq -r '.name // empty' "$manifest_file")
    if [[ -z "$name" ]]; then
        echo "✗ Error: Manifest missing required 'name' field for $extension"
        return 1
    fi
    
    return 0
}

# Function to wait for extension containers to be healthy
wait_for_extension() {
    local extension="$1"
    local max_wait=30
    local waited=0
    
    echo "Waiting for $extension containers to be healthy..."
    
    while [[ $waited -lt $max_wait ]]; do
        local api_container="platform_api_${extension}_1"
        local web_container="platform_web_${extension}_1"
        
        # Check if containers exist and are running
        local api_running=$(docker ps --filter "name=^${api_container}$" --filter "status=running" --format "{{.Names}}" 2>/dev/null | wc -l)
        local web_running=$(docker ps --filter "name=^${web_container}$" --filter "status=running" --format "{{.Names}}" 2>/dev/null | wc -l)
        
        if [[ $api_running -gt 0 && $web_running -gt 0 ]]; then
            echo "✓ $extension containers are running"
            # Give containers a moment to fully initialize
            sleep 2
            
            # Final check they're still running (not crashed immediately)
            api_running=$(docker ps --filter "name=^${api_container}$" --filter "status=running" --format "{{.Names}}" 2>/dev/null | wc -l)
            web_running=$(docker ps --filter "name=^${web_container}$" --filter "status=running" --format "{{.Names}}" 2>/dev/null | wc -l)
            
            if [[ $api_running -gt 0 && $web_running -gt 0 ]]; then
                return 0
            fi
        fi
        
        sleep 2
        waited=$((waited + 2))
    done
    
    echo "✗ $extension containers failed to start within ${max_wait}s"
    echo "  Check logs: docker-compose logs ${extension}"
    return 1
}

# Function to generate nginx config for extension
generate_nginx_config() {
    local extension="$1"
    local manifest_file="$COMPOSE_DIR/extensions/$extension/manifest.json"
    
    # Validate manifest first
    if ! validate_manifest "$manifest_file" "$extension"; then
        return 1
    fi
    
    # Extract extension info from manifest
    local extension_name=$(jq -r '.name // empty' "$manifest_file" 2>/dev/null || echo "$extension")
    local api_port=$(jq -r '.api.port // empty' "$manifest_file" 2>/dev/null || echo "")
    local web_port=$(jq -r '.web.port // empty' "$manifest_file" 2>/dev/null || echo "")
    
    # Generate nginx config
    local nginx_file="$COMPOSE_DIR/dev/proxy/locations.$extension.conf"
    
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
        echo "✗ Error: Override file not found: $override_file"
        return 1
    fi
    
    # Generate nginx config
    if ! generate_nginx_config "$extension"; then
        echo "✗ Failed to generate nginx config for $extension"
        return 1
    fi
    
    if is_extension_enabled "$extension"; then
        echo "Starting $extension extension..."
        
        if ! docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" up -d; then
            echo "✗ Failed to start $extension containers"
            echo "  Check docker-compose logs for details"
            return 1
        fi
        
        # Wait for containers to be healthy
        if ! wait_for_extension "$extension"; then
            echo "✗ $extension containers unhealthy, stopping..."
            local services=$(get_extension_services "$override_file")
            if [[ -n "$services" ]]; then
                docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" stop $services 2>/dev/null || true
            fi
            echo "  Review logs and try again"
            return 1
        fi
        
        echo "✓ $extension started successfully"
    else
        echo "Stopping $extension extension..."
        # Get extension services and stop them
        local services=$(get_extension_services "$override_file")
        if [[ -n "$services" ]]; then
            docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" stop $services || true
        fi
        
        # Clean up extension database schemas
        echo "Cleaning up database schemas for disabled extensions..."
        FORCE_CLEANUP=true "$COMPOSE_DIR/scripts/manage-extension-databases.sh" --only "$extension" || true
    fi
}

# Function to restart proxy to apply nginx config changes
restart_proxy() {
    echo "Restarting proxy to apply nginx configuration changes..."
    docker-compose -f "$COMPOSE_DIR/compose.yml" restart proxy || true
    sleep 3
    
    # Verify nginx configuration is applied correctly
    echo "Verifying nginx configuration..."
    # Get all discovered extensions (not hardcoded)
    local extensions_to_verify=$(discover_extensions)
    for extension in $extensions_to_verify; do
        if is_extension_enabled "$extension"; then
            if [[ -f "$COMPOSE_DIR/dev/proxy/locations.$extension.conf" ]]; then
                local expected_config=$(cat "$COMPOSE_DIR/dev/proxy/locations.$extension.conf")
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
    if ! docker exec standalone-nginx sh -c "export ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS' && /scripts/sync-extensions.sh"; then
        echo "✗ Failed to sync external nginx configuration"
        echo "  Manual sync command: docker exec standalone-nginx /scripts/sync-extensions.sh"
        echo "  Check standalone-nginx logs: docker logs standalone-nginx"
        return 1
    fi
    
    # Verify nginx config is valid before reloading
    if ! docker exec standalone-nginx nginx -t 2>&1 | grep -q "syntax is ok"; then
        echo "✗ Nginx configuration test failed after sync!"
        echo "  Check config: docker exec standalone-nginx nginx -t"
        echo "  Nginx may still be running with old config"
        return 1
    fi
    
    # Reload nginx to apply changes
    if ! docker exec standalone-nginx nginx -s reload; then
        echo "✗ Failed to reload nginx"
        echo "  Nginx config was synced but reload failed"
        return 1
    fi
    
    echo "✓ External nginx configuration synced and reloaded"
    
    # Verify what's actually enabled
    echo "Active nginx configs:"
    docker exec standalone-nginx ls -1 /etc/nginx/sites-enabled/ 2>/dev/null | sed 's/^/  - /' || true
    
    return 0
}

sync_external_nginx

echo "Extension management complete!"
