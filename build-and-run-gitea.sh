#!/usr/bin/env bash

set -euo pipefail

# Gitea Build and Run Script

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

log() {
echo "[INFO] $1"
}

success() {
echo "[SUCCESS] $1"
}

error() {
echo "[ERROR] $1" >&2
}

# Verify project directory

log "Checking project directory..."

if [[ ! -f "$PROJECT_DIR/go.mod" || ! -f "$PROJECT_DIR/Makefile" ]]; then
error "This script must be run from the Gitea project directory."
error "Expected go.mod and Makefile were not found."
exit 1
fi

success "Gitea project directory verified: $PROJECT_DIR"

# Configure Go environment

log "Configuring Go environment..."

if [[ -z "${GOPATH:-}" ]]; then
    export GOPATH="$(go env GOPATH)"
fi

if [[ -z "${GOMODCACHE:-}" ]]; then
    export GOMODCACHE="$GOPATH/pkg/mod"
fi

# Use project-relative writable directories for
# Go temporary files and build cache.
export GOTMPDIR="$PROJECT_DIR/.go-tmp"
export GOCACHE="$PROJECT_DIR/.go-cache"

mkdir -p "$GOTMPDIR"
mkdir -p "$GOCACHE"

success "Go environment configured."

# Ensure HOME is available for Gitea
if [[ -z "${HOME:-}" ]]; then
    export HOME="$(cd ~ && pwd)"
fi

if [[ -z "${USERPROFILE:-}" ]]; then
    USERPROFILE="$(cygpath -w "$HOME" 2>/dev/null || true)"
    export USERPROFILE
fi

success "Environment configured."

# Check required tools

log "Checking required tools..."

REQUIRED_TOOLS=("git" "go" "node" "npm" "pnpm" "make")

for tool in "${REQUIRED_TOOLS[@]}"; do
if ! command -v "$tool" >/dev/null 2>&1; then
error "$tool is not installed or is not available in PATH."
exit 1
fi
done

success "All required tools are available."

# Display dependency versions

log "Checking dependency versions..."

echo "Git:   $(git --version)"
echo "Go:    $(go version)"
echo "Node:  $(node --version)"
echo "npm:   $(npm --version)"
echo "pnpm:  $(pnpm --version)"
echo "Make:  $(make --version | head -n 1)"

# Build Gitea

log "Building Gitea from source..."

export TAGS="bindata sqlite sqlite_unlock_notify"

if ! make build; then
    error "Gitea build failed."
    exit 1
fi

success "Gitea build completed successfully."

# Verify Gitea binary

log "Checking Gitea binary..."

GITEA_BINARY="$PROJECT_DIR/gitea.exe"

if [[ ! -f "$GITEA_BINARY" ]]; then
error "Gitea binary was not created."
exit 1
fi

success "Gitea binary found: $GITEA_BINARY"

# Check port 3000

PORT=3000

log "Checking whether port $PORT is already in use..."

if command -v netstat >/dev/null 2>&1; then
if netstat -ano | grep -E "[:.]$PORT[[:space:]].*LISTENING" >/dev/null 2>&1; then
error "Port $PORT is already in use."
error "Please stop the process using port $PORT and run the script again."
exit 1
fi
else
error "netstat command is not available."
exit 1
fi

success "Port $PORT is available."

# Start Gitea

log "Starting Gitea web server..."

echo
echo "=================================================="
echo "Gitea is starting..."
echo "Local URL: http://localhost:3000"
echo "Press Ctrl+C to stop Gitea."
echo "=================================================="
echo

exec "$GITEA_BINARY" web
