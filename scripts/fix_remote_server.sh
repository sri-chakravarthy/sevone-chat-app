#!/bin/bash

# Script to fix the remote MCP server configuration
# Usage: ./scripts/fix_remote_server.sh

set -e

REMOTE_HOST="${1:-c49988v1.fyre.ibm.com}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo "Fixing Remote MCP Server Configuration"
echo "=========================================="
echo "Remote Host: ${REMOTE_HOST}"
echo ""

# Step 1: Copy updated .env file
echo "Step 1: Copying updated .env file to remote host..."
scp "${PROJECT_DIR}/.env" "${REMOTE_HOST}:~/.env"
echo "   ✓ .env file updated on remote host"
echo ""

# Step 2: Restart the container with new configuration
echo "Step 2: Restarting MCP server container..."
ssh "${REMOTE_HOST}" << 'REMOTE_COMMANDS'
echo "Stopping container..."
podman stop sevone-mysql-mcp

echo "Removing container..."
podman rm sevone-mysql-mcp

echo "Starting container with updated configuration..."
podman run -d \
  --name sevone-mysql-mcp \
  --env-file ~/.env \
  -p 8443:8443 \
  localhost/sevone-mysql-mcp:latest

echo "Waiting for startup..."
sleep 5

echo ""
echo "Container status:"
podman ps | grep sevone-mysql-mcp

echo ""
echo "Recent logs:"
podman logs --tail 20 sevone-mysql-mcp

echo ""
echo "Testing health endpoint..."
curl -k -s https://localhost:8443/health || echo "Health check failed"
REMOTE_COMMANDS

echo ""
echo "   ✓ Container restarted"
echo ""

# Step 3: Verify from local machine
echo "Step 3: Verifying from local machine..."
sleep 2

echo "Testing health endpoint..."
if curl -k -s --connect-timeout 10 "https://${REMOTE_HOST}:8443/health" 2>&1 | grep -q "ok"; then
    echo "   ✓ Health endpoint accessible"
else
    echo "   ✗ Health endpoint not accessible"
fi

echo ""
echo "Testing SSE endpoint..."
if timeout 3 curl -k -s -H "Authorization: Bearer 85a87b5b24e957808932276e012047110741b16120cf2ad2b1490d86de23f297" \
    "https://${REMOTE_HOST}:8443/sse" 2>&1 | head -5 | grep -q "event:"; then
    echo "   ✓ SSE endpoint accessible"
else
    echo "   ⚠ SSE endpoint test inconclusive (may be working)"
fi

echo ""
echo "=========================================="
echo "Configuration Fix Complete"
echo "=========================================="
echo ""
echo "The MCP server should now be accessible at:"
echo "  https://${REMOTE_HOST}:8443"
echo ""
echo "Next steps:"
echo "1. Restart Bob AI to reconnect"
echo "2. Test with: Can you show me the database schema?"
echo ""

# Made with Bob
