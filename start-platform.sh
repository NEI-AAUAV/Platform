#!/bin/bash

# NEI Platform Startup Script
# Automatically manages extensions based on ENABLED_EXTENSIONS.
#
# Set WITH_DIRECTUS=1 to also route /cms/ to a Directus started from the
# Infrastructure repository (services/directus) on the shared `nei-shared`
# network.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENABLED_EXTENSIONS="${ENABLED_EXTENSIONS:-}"
WITH_DIRECTUS="${WITH_DIRECTUS:-0}"

# Prefer Compose v2 (`docker compose`); fall back to the legacy binary.
if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
  HAS_WAIT=1
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
  HAS_WAIT=0
else
  echo "Neither 'docker compose' nor 'docker-compose' is available." >&2
  exit 1
fi

COMPOSE_FILES=(-f "$SCRIPT_DIR/compose.yml")
if [ "$WITH_DIRECTUS" = "1" ]; then
  COMPOSE_FILES+=(-f "$SCRIPT_DIR/compose.directus.yml")
fi
compose() { "${COMPOSE[@]}" "${COMPOSE_FILES[@]}" "$@"; }

echo "Starting NEI Platform..."
echo "ENABLED_EXTENSIONS: ${ENABLED_EXTENSIONS:-'(none)'}"
echo ""

# compose.yml declares nei-shared as external; it must exist before `up`.
if ! docker network inspect nei-shared >/dev/null 2>&1; then
  echo "Creating docker network nei-shared..."
  docker network create nei-shared >/dev/null
fi

# Start main platform services. `--wait` blocks on the healthchecks defined in
# compose.yml instead of guessing with a fixed sleep.
echo "Starting main platform services..."
if [ "$HAS_WAIT" = "1" ]; then
  compose up -d --wait
else
  compose up -d
  echo "Waiting for services to start..."
  sleep 10
fi

# Manage extensions automatically
echo "Managing extensions..."
"$SCRIPT_DIR/scripts/manage-extensions.sh"

# Restart API to pick up extension changes
echo "Restarting API to apply extension changes..."
ENABLED_EXTENSIONS="$ENABLED_EXTENSIONS" compose restart api_nei

# Ensure nginx configuration is applied correctly
echo "Ensuring nginx configuration is applied..."
compose restart proxy
sleep 3

echo ""
echo "NEI Platform started successfully!"
echo ""
echo "Service Status:"
compose ps
echo ""
echo "Access the platform at: http://localhost"
echo "Extensions enabled: ${ENABLED_EXTENSIONS:-'(none)'}"
