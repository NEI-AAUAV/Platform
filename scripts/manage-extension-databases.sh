#!/bin/bash

# Extension Database Management Script
# Handles database schema creation/cleanup when extensions are enabled/disabled

set -e

COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"

# Database connection details
POSTGRES_SERVER="${POSTGRES_SERVER:-localhost}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-postgres}"

echo "Managing extension databases based on ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS'"

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

# Function to run SQL command
run_sql() {
    local sql="$1"
    PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_SERVER" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "$sql"
}

# Function to check if schema exists
schema_exists() {
    local schema="$1"
    local result=$(run_sql "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '$schema';" 2>/dev/null | grep -c "$schema" || echo "0")
    [[ "$result" -gt 0 ]]
}

# Function to manage extension database
manage_extension_db() {
    local extension="$1"
    local schema=""
    
    # Map extension names to schema names
    case "$extension" in
        "rally")
            schema="rally_tascas"
            ;;
        "gala")
            schema="gala"
            ;;
        *)
            echo "Unknown extension: $extension"
            return
            ;;
    esac
    
    if is_extension_enabled "$extension"; then
        echo "Ensuring database schema exists for $extension..."
        if ! schema_exists "$schema"; then
            echo "Creating schema $schema for $extension..."
            run_sql "CREATE SCHEMA IF NOT EXISTS $schema;"
        fi
    else
        echo "Cleaning up database schema for $extension..."
        if schema_exists "$schema"; then
            echo "Dropping schema $schema for $extension..."
            run_sql "DROP SCHEMA IF EXISTS $schema CASCADE;"
        fi
    fi
}

# Function to discover extensions
discover_extensions() {
    find "$COMPOSE_DIR/extensions" -maxdepth 1 -type d -name "*" | while read -r dir; do
        local extension=$(basename "$dir")
        if [[ "$extension" != "extensions" && -f "$dir/compose.override.yml" ]]; then
            echo "$extension"
        fi
    done
}

# Main execution
echo "Discovering extensions..."
for extension in $(discover_extensions); do
    manage_extension_db "$extension"
done

echo "Extension database management completed."
