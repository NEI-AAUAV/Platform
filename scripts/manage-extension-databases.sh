#!/bin/bash

# Extension Database Management Script
# Handles database schema creation/cleanup when extensions are enabled/disabled
#
# Usage:
#   ./manage-extension-databases.sh [--force-cleanup] [--only EXTENSION]
#
# Options:
#   --force-cleanup    Force cleanup even when ENABLED_EXTENSIONS is empty
#   --only EXTENSION   Only manage the specified extension

set -e

COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"

# Database connection details
POSTGRES_SERVER="${POSTGRES_SERVER:-localhost}"
POSTGRES_USER="${POSTGRES_USER:-postgres}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-postgres}"
POSTGRES_DB="${POSTGRES_DB:-postgres}"

# Safety flag to prevent accidental schema drops
FORCE_CLEANUP="${FORCE_CLEANUP:-false}"
ONLY_EXTENSION=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --force-cleanup)
            FORCE_CLEANUP="true"
            shift
            ;;
        --only)
            ONLY_EXTENSION="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--force-cleanup] [--only EXTENSION]"
            exit 1
            ;;
    esac
done

echo "Managing extension databases based on ENABLED_EXTENSIONS='$ENABLED_EXTENSIONS'"
if [[ "$FORCE_CLEANUP" == "true" ]]; then
    echo "FORCE_CLEANUP is enabled - will drop schemas even when ENABLED_EXTENSIONS is empty"
fi
if [[ -n "$ONLY_EXTENSION" ]]; then
    echo "Only managing extension: $ONLY_EXTENSION"
fi

# Function to check if extension is enabled
is_extension_enabled() {
    local extension="$1"
    if [[ -z "$ENABLED_EXTENSIONS" ]]; then
        return 1  # Not set - disable all
    fi
    
    # Split ENABLED_EXTENSIONS into array and check for exact match
    IFS=',' read -ra EXTENSIONS <<< "$ENABLED_EXTENSIONS"
    for ext in "${EXTENSIONS[@]}"; do
        # Trim whitespace
        ext=$(echo "$ext" | xargs)
        if [[ "$ext" == "$extension" ]]; then
            return 0  # Enabled
        fi
    done
    return 1  # Disabled
}

# Function to run SQL command
run_sql() {
    local sql="$1"
    PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_SERVER" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "$sql"
}

# Function to check if schema exists
schema_exists() {
    local schema="$1"
    local result=$(PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_SERVER" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tA -c "SELECT 1 FROM information_schema.schemata WHERE schema_name = '$schema' LIMIT 1;" 2>/dev/null)
    [[ "$result" == "1" ]]
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
        # Safety check: Don't drop schemas unless explicitly forced or ENABLED_EXTENSIONS is explicitly set
        if [[ -z "$ENABLED_EXTENSIONS" && "$FORCE_CLEANUP" != "true" ]]; then
            echo "Skipping schema cleanup for $extension (ENABLED_EXTENSIONS is empty and FORCE_CLEANUP=false)"
            echo "To force cleanup, set FORCE_CLEANUP=true"
            return
        fi
        
        echo "Cleaning up database schema for $extension..."
        if schema_exists "$schema"; then
            echo "Dropping schema $schema for $extension..."
            run_sql "DROP SCHEMA IF EXISTS $schema CASCADE;"
        fi
    fi
}

# Function to discover extensions
discover_extensions() {
    local extensions_dir="$COMPOSE_DIR/extensions"
    if [[ ! -d "$extensions_dir" ]]; then
        echo "Extensions directory not found: $extensions_dir"
        return
    fi
    
    find "$extensions_dir" -maxdepth 1 -type d -name "*" | while read -r dir; do
        local extension=$(basename "$dir")
        if [[ "$extension" != "extensions" && -f "$dir/compose.override.yml" ]]; then
            echo "$extension"
        fi
    done
}

# Main execution
echo "Discovering extensions..."
extensions=$(discover_extensions)

if [[ -z "$extensions" ]]; then
    echo "No extensions found"
    exit 0
fi

# Filter to only specified extension if --only is used
if [[ -n "$ONLY_EXTENSION" ]]; then
    if echo "$extensions" | grep -q "^$ONLY_EXTENSION$"; then
        extensions="$ONLY_EXTENSION"
    else
        echo "Extension '$ONLY_EXTENSION' not found"
        echo "Available extensions: $(echo "$extensions" | tr '\n' ' ')"
        exit 1
    fi
fi

for extension in $extensions; do
    if [[ -n "$extension" ]]; then
        manage_extension_db "$extension"
    fi
done

echo "Extension database management completed."
