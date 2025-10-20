#!/bin/bash

# Extension Database Management Script
# Handles database schema creation/cleanup when extensions are enabled/disabled
#
# External dependencies and assumptions:
#   - Requires 'psql' to be available on the host running this script.
#   - PostgreSQL connection is controlled via the following environment variables:
#       POSTGRES_SERVER (default: localhost)
#       POSTGRES_USER (default: postgres)
#       POSTGRES_PASSWORD (default: postgres)
#       POSTGRES_DB (default: postgres)
#   - If the database is only reachable inside Docker, ensure this script is run in the correct environment.
#
# Usage:
#   ./manage-extension-databases.sh [--force-cleanup] [--only EXTENSION]
#
# Options:
#   --force-cleanup    Force cleanup even when ENABLED_EXTENSIONS is empty
#   --only EXTENSION   Only manage the specified extension

set -Eeuo pipefail

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
            if [[ $# -lt 2 ]] || [[ -z "$2" ]]; then
                echo "Error: --only requires an extension name argument."
                echo "Usage: $0 [--force-cleanup] [--only EXTENSION]"
                exit 1
            fi
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

# Check if psql is available
if ! command -v psql >/dev/null 2>&1; then
    echo "Error: 'psql' command not found. Please install PostgreSQL client tools."
    echo "On Ubuntu/Debian: sudo apt-get install postgresql-client"
    echo "On CentOS/RHEL: sudo yum install postgresql"
    exit 1
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

# Function to run SQL command with proper parameter binding
run_sql() {
    local sql="$1"
    local schema="$2"
    PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_SERVER" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -v schema="$schema" -c "$sql"
}

# Function to check if schema exists
schema_exists() {
    local schema="$1"
    local result=$(PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_SERVER" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -tA -v schema="$schema" -c "SELECT 1 FROM information_schema.schemata WHERE schema_name = :'schema' LIMIT 1;" 2>/dev/null)
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
            return 1
            ;;
    esac
    
    if is_extension_enabled "$extension"; then
        echo "Ensuring database schema exists for $extension..."
        if ! schema_exists "$schema"; then
            echo "Creating schema $schema for $extension..."
            run_sql "CREATE SCHEMA IF NOT EXISTS :\"schema\";" "$schema"
        fi
    else
        # Safety check: Don't drop schemas unless explicitly forced or ENABLED_EXTENSIONS is explicitly set
        if [[ -z "$ENABLED_EXTENSIONS" && "$FORCE_CLEANUP" != "true" ]]; then
            echo "Skipping schema cleanup for $extension (ENABLED_EXTENSIONS is empty and FORCE_CLEANUP=false)"
            echo "To force cleanup, set FORCE_CLEANUP=true or pass --force-cleanup"
            return
        fi
        
        echo "Cleaning up database schema for $extension..."
        if schema_exists "$schema"; then
            echo "Dropping schema $schema for $extension..."
            run_sql "DROP SCHEMA IF EXISTS :\"schema\" CASCADE;" "$schema"
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
    if printf '%s\n' "$extensions" | grep -Fxq "$ONLY_EXTENSION"; then
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
