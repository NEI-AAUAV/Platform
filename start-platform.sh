#!/bin/bash

# NEI Platform Startup Script
# Automatically manages extensions based on ENABLED_EXTENSIONS

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"

echo "Starting NEI Platform..."
echo "ENABLED_EXTENSIONS: ${ENABLED_EXTENSIONS:-'(none)'}"
echo ""

# Start main platform services
echo "Starting main platform services..."
docker-compose -f "$SCRIPT_DIR/compose.yml" up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 10

# Manage extensions automatically
echo "Managing extensions..."
"$SCRIPT_DIR/scripts/manage-extensions.sh"

# Restart API to pick up extension changes
echo "Restarting API to apply extension changes..."
ENABLED_EXTENSIONS="$ENABLED_EXTENSIONS" docker-compose -f "$SCRIPT_DIR/compose.yml" restart api_nei

# Ensure nginx configuration is applied correctly
echo "Ensuring nginx configuration is applied..."
docker-compose -f "$SCRIPT_DIR/compose.yml" restart proxy
sleep 3

echo ""
echo "NEI Platform started successfully!"
echo ""
echo "Service Status:"
docker-compose -f "$SCRIPT_DIR/compose.yml" ps
echo ""
echo "Access the platform at: http://localhost"
echo "Extensions enabled: ${ENABLED_EXTENSIONS:-'(none)'}"
