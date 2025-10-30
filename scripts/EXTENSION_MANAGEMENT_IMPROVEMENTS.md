# Extension Management Improvements

This document outlines improvements to `manage-extensions.sh` and `manage-extension-databases.sh`.

## Critical Fixes

### 1. Fix String Matching Bug in `is_extension_enabled()`

**Current Code (BUGGY):**
```bash
if [[ "$ENABLED_EXTENSIONS" == *"$extension"* ]]; then
    return 0  # Would match "rally" in "rally-test"!
fi
```

**Fixed Code:**
```bash
is_extension_enabled() {
    local extension="$1"
    if [[ -z "$ENABLED_EXTENSIONS" ]]; then
        return 1  # Not set - disable all
    fi
    
    # Split by comma and check for exact match
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
```

This matches the implementation in `manage-extension-databases.sh` lines 78-94, which is correct.

**Action**: Apply this fix to `manage-extensions.sh` line 15-25.

---

### 2. Remove Hardcoded Extension List

**Current Code (lines 134-148):**
```bash
for extension in rally gala; do  # ← HARDCODED! Defeats generic design
    if [[ -f "$COMPOSE_DIR/proxy/locations.$extension.conf" ]]; then
        # ... verification ...
    fi
done
```

**Fixed Code:**
```bash
# Use discovered extensions instead
echo "Verifying nginx configuration..."
extensions_to_verify=$(discover_extensions)
for extension in $extensions_to_verify; do
    if is_extension_enabled "$extension"; then
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
    fi
done
```

**Action**: Replace lines 134-148 with generic version.

---

## Important Improvements

### 3. Add Manifest Validation

Add before using manifest data:

```bash
# Add after line 46
validate_manifest() {
    local manifest_file="$1"
    local extension="$2"
    
    if [[ ! -f "$manifest_file" ]]; then
        echo "Error: Manifest not found for $extension: $manifest_file"
        return 1
    fi
    
    # Validate JSON structure
    if ! jq empty "$manifest_file" 2>/dev/null; then
        echo "Error: Invalid JSON in manifest for $extension: $manifest_file"
        return 1
    fi
    
    # Check required fields
    local name=$(jq -r '.name // empty' "$manifest_file")
    if [[ -z "$name" ]]; then
        echo "Error: Manifest missing 'name' field for $extension"
        return 1
    fi
    
    echo "✓ Manifest validated for $extension"
    return 0
}

# Update generate_nginx_config() to use it:
generate_nginx_config() {
    local extension="$1"
    local manifest_file="$COMPOSE_DIR/extensions/$extension/manifest.json"
    
    # Add validation
    if ! validate_manifest "$manifest_file" "$extension"; then
        echo "Skipping nginx config generation for $extension due to invalid manifest"
        return 1
    fi
    
    # ... rest of function ...
}
```

---

### 4. Add Health Checks

Add after starting containers:

```bash
# Add new function
wait_for_extension_health() {
    local extension="$1"
    local max_wait=30
    local waited=0
    
    echo "Waiting for $extension to be healthy..."
    
    while [[ $waited -lt $max_wait ]]; do
        # Check if extension containers are running
        local api_running=$(docker ps --filter "name=platform_api_${extension}_1" --filter "status=running" --format "{{.Names}}" | wc -l)
        local web_running=$(docker ps --filter "name=platform_web_${extension}_1" --filter "status=running" --format "{{.Names}}" | wc -l)
        
        if [[ $api_running -gt 0 && $web_running -gt 0 ]]; then
            echo "✓ $extension containers are running"
            
            # Optional: Add HTTP health check
            # local manifest_file="$COMPOSE_DIR/extensions/$extension/manifest.json"
            # local api_port=$(jq -r '.api.port // empty' "$manifest_file" 2>/dev/null)
            # if [[ -n "$api_port" ]]; then
            #     if curl -sf "http://localhost:${api_port}/health" > /dev/null 2>&1; then
            #         echo "✓ $extension API is healthy"
            #         return 0
            #     fi
            # fi
            
            return 0
        fi
        
        sleep 2
        waited=$((waited + 2))
    done
    
    echo "✗ $extension failed to start within ${max_wait}s"
    docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" logs --tail=50
    return 1
}

# Update manage_extension() to use it:
if is_extension_enabled "$extension"; then
    echo "Starting $extension extension..."
    if docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" up -d; then
        # Add health check
        if ! wait_for_extension_health "$extension"; then
            echo "✗ $extension health check failed, stopping containers..."
            docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" stop || true
            return 1
        fi
    else
        echo "✗ Failed to start $extension"
        return 1
    fi
fi
```

---

### 5. Run Database Commands in Container

Update `manage-extension-databases.sh`:

```bash
# Replace lines 96-101
run_sql() {
    local sql="$1"
    local schema="$2"
    
    # Run psql inside postgres container instead of on host
    docker exec platform_db_pg_1 psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
        -v schema="$schema" \
        -c "$sql"
}

# Also update schema_exists() function similarly:
schema_exists() {
    local schema="$1"
    local result
    
    result=$(docker exec platform_db_pg_1 psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
        -tA -v schema="$schema" \
        -c "SELECT 1 FROM information_schema.schemata WHERE schema_name = :'schema' LIMIT 1;" \
        2>/dev/null)
    
    local status=$?
    if [[ $status -ne 0 ]]; then
        echo "Error: Failed to check if schema '$schema' exists (exit status $status)" >&2
        return $status
    fi
    [[ "$result" == "1" ]]
}

# Remove lines 69-75 (psql availability check) since we're using container
```

---

### 6. Add Rollback Mechanism

```bash
# Add new function
rollback_extension() {
    local extension="$1"
    local override_file="$2"
    
    echo "Rolling back $extension..."
    
    # Stop containers
    local services=$(get_extension_services "$override_file")
    if [[ -n "$services" ]]; then
        docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" stop $services || true
    fi
    
    # Optionally remove containers
    # docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" rm -f $services || true
    
    echo "✓ Rolled back $extension"
}

# Update manage_extension() to use rollback:
manage_extension() {
    local extension="$1"
    local override_file="$COMPOSE_DIR/extensions/$extension/compose.override.yml"
    
    if [[ ! -f "$override_file" ]]; then
        echo "Override file not found: $override_file"
        return 1
    fi
    
    # Generate nginx config
    if ! generate_nginx_config "$extension"; then
        echo "Failed to generate nginx config for $extension"
        return 1
    fi
    
    if is_extension_enabled "$extension"; then
        echo "Starting $extension extension..."
        
        # Try to start
        if ! docker-compose -f "$COMPOSE_DIR/compose.yml" -f "$override_file" up -d; then
            echo "✗ Failed to start $extension containers"
            rollback_extension "$extension" "$override_file"
            return 1
        fi
        
        # Wait for health
        if ! wait_for_extension_health "$extension"; then
            echo "✗ $extension health check failed"
            rollback_extension "$extension" "$override_file"
            return 1
        fi
        
        echo "✓ $extension started successfully"
    else
        echo "Stopping $extension extension..."
        # Existing stop logic...
    fi
}
```

---

## Additional Enhancements

### 7. Add Logging

```bash
# Add at the top of the script
LOG_FILE="${LOG_FILE:-/var/log/extension-management.log}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"  # DEBUG, INFO, WARN, ERROR

log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file if LOG_FILE is set
    if [[ -n "$LOG_FILE" ]]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    fi
    
    # Also log to stdout
    echo "[$level] $message"
}

# Use throughout:
log INFO "Managing extensions based on ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS'"
log ERROR "Failed to start $extension"
log DEBUG "Container status: $(docker ps --filter name=$extension)"
```

---

### 8. Add Dry-Run Mode

```bash
# Add at the top
DRY_RUN="${DRY_RUN:-false}"

# Wrapper for docker commands
docker_compose() {
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY-RUN] Would run: docker-compose $*"
        return 0
    else
        docker-compose "$@"
    fi
}

# Usage:
# DRY_RUN=true ./scripts/manage-extensions.sh
```

---

### 9. Add Metrics/Monitoring Hooks

```bash
# Send metrics to monitoring system
send_metric() {
    local metric_name="$1"
    local value="$2"
    local tags="$3"
    
    # Example: Send to StatsD/Prometheus/etc
    # echo "$metric_name:$value|c|#$tags" | nc -u -w1 localhost 8125
    
    # Or write to file for collection
    echo "$(date +%s),$metric_name,$value,$tags" >> /var/metrics/extension-management.csv
}

# Use after operations:
send_metric "extension.start" 1 "extension=$extension,status=success"
send_metric "extension.start" 1 "extension=$extension,status=failed"
send_metric "extension.start.duration" $duration "extension=$extension"
```

---

### 10. Improve Error Messages

```bash
# Be more specific about what failed
echo "✗ Failed to start $extension"
# Becomes:
echo "✗ Failed to start $extension: docker-compose exited with code $?"
echo "  Check logs with: docker-compose -f compose.yml -f extensions/$extension/compose.override.yml logs"

# Add suggestion for fixes
echo "  Possible causes:"
echo "    - Containers failed health checks"
echo "    - Port conflicts"
echo "    - Missing environment variables"
echo "    - Database connection issues"
```

---

## Migration Strategy

1. **Phase 1**: Apply critical fixes (string matching, hardcoded list) immediately
2. **Phase 2**: Add validation and health checks
3. **Phase 3**: Add rollback mechanism
4. **Phase 4**: Add logging and monitoring
5. **Phase 5**: Refactor database script to use containers

## Testing Checklist

After implementing improvements:

- [ ] Test with single extension: `ENABLED_EXTENSIONS="rally"`
- [ ] Test with multiple extensions: `ENABLED_EXTENSIONS="rally,gala"`
- [ ] Test with no extensions: `ENABLED_EXTENSIONS=""`
- [ ] Test with non-existent extension: `ENABLED_EXTENSIONS="fake"`
- [ ] Test disable after enable
- [ ] Test enable after disable
- [ ] Test with invalid manifest.json
- [ ] Test with missing compose.override.yml
- [ ] Test database schema creation/cleanup
- [ ] Test nginx config sync
- [ ] Test health check timeouts
- [ ] Test rollback on failure

## Summary

**Priority:**
1. 🔴 **Critical**: Fix string matching bug (lines 15-25)
2. 🔴 **Critical**: Remove hardcoded extension list (lines 134-148)
3. 🟡 **Important**: Add manifest validation
4. 🟡 **Important**: Add health checks
5. 🟡 **Important**: Fix database script (use container)
6. 🟢 **Nice to have**: Add rollback, logging, dry-run mode

**Estimated effort:**
- Critical fixes: 15 minutes
- Important improvements: 1-2 hours
- Nice-to-have features: 2-4 hours

**Impact:**
- Prevents false positive extension matches
- More maintainable (no hardcoded lists)
- More robust (validation, health checks, rollback)
- Better observability (logging, metrics)

