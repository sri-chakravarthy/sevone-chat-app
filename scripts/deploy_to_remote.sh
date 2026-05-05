#!/bin/bash

# Script to deploy MCP server to remote host
# Usage: ./scripts/deploy_to_remote.sh [remote_host]

set -e

REMOTE_HOST="${1:-c49988v1.fyre.ibm.com}"
REMOTE_USER="${2:-$(whoami)}"
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=========================================="
echo "MCP Server Remote Deployment"
echo "=========================================="
echo "Remote Host: ${REMOTE_HOST}"
echo "Remote User: ${REMOTE_USER}"
echo "Project Dir: ${PROJECT_DIR}"
echo ""

# Step 1: Create deployment package
echo "Step 1: Creating deployment package..."
cd "${PROJECT_DIR}"
tar -czf /tmp/mcp-server-deploy.tar.gz \
    mcp-server/ \
    .env \
    --exclude='mcp-server/__pycache__' \
    --exclude='mcp-server/.pytest_cache' \
    --exclude='mcp-server/src/__pycache__' \
    --exclude='mcp-server/.venv'
echo "   ✓ Package created: /tmp/mcp-server-deploy.tar.gz"
echo ""

# Step 2: Copy to remote host
echo "Step 2: Copying package to remote host..."
scp /tmp/mcp-server-deploy.tar.gz "${REMOTE_USER}@${REMOTE_HOST}:~/"
echo "   ✓ Package copied to remote host"
echo ""

# Step 3: Create deployment script on remote host
echo "Step 3: Creating deployment script on remote host..."
ssh "${REMOTE_USER}@${REMOTE_HOST}" 'cat > ~/deploy_mcp.sh' << 'DEPLOY_SCRIPT'
#!/bin/bash
set -e

echo "Extracting deployment package..."
cd ~
tar -xzf mcp-server-deploy.tar.gz
echo "   ✓ Extracted"

echo ""
echo "Building container image..."
cd ~/mcp-server
podman build -t sevone-mysql-mcp -f Containerfile .
echo "   ✓ Image built"

echo ""
echo "Stopping existing container (if any)..."
podman rm -f sevone-mysql-mcp 2>/dev/null || true
echo "   ✓ Cleaned up"

echo ""
echo "Starting new container..."
podman run -d \
  --name sevone-mysql-mcp \
  --env-file ../.env \
  -p 8443:8000 \
  sevone-mysql-mcp
echo "   ✓ Container started"

echo ""
echo "Waiting for startup..."
sleep 5

echo ""
echo "Container status:"
podman ps | grep sevone-mysql-mcp || echo "Container not found!"

echo ""
echo "Recent logs:"
podman logs --tail 30 sevone-mysql-mcp

echo ""
echo "Testing health endpoint..."
if curl -k -s https://localhost:8443/health | grep -q "ok"; then
    echo "   ✓ Health check passed"
else
    echo "   ✗ Health check failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "Deployment Complete!"
echo "=========================================="
echo "The MCP server is now running on port 8443"
echo ""
echo "Test from external host:"
echo "  curl -k https://$(hostname):8443/health"
echo ""
echo "View logs:"
echo "  podman logs -f sevone-mysql-mcp"
echo ""
DEPLOY_SCRIPT

ssh "${REMOTE_USER}@${REMOTE_HOST}" 'chmod +x ~/deploy_mcp.sh'
echo "   ✓ Deployment script created"
echo ""

# Step 4: Execute deployment
echo "Step 4: Executing deployment on remote host..."
echo "=========================================="
ssh "${REMOTE_USER}@${REMOTE_HOST}" '~/deploy_mcp.sh'
echo "=========================================="
echo ""

# Step 5: Verify from local machine
echo "Step 5: Verifying deployment from local machine..."
sleep 2

if curl -k -s --connect-timeout 10 "https://${REMOTE_HOST}:8443/health" | grep -q "ok"; then
    echo "   ✓ MCP server is accessible from local machine"
    echo ""
    echo "=========================================="
    echo "SUCCESS!"
    echo "=========================================="
    echo "The MCP server is now running and accessible at:"
    echo "  https://${REMOTE_HOST}:8443"
    echo ""
    echo "You can now use Bob AI to connect to the server."
    echo "Restart Bob AI if it's already running."
else
    echo "   ✗ MCP server is not accessible from local machine"
    echo ""
    echo "Possible issues:"
    echo "  - Firewall blocking port 8443"
    echo "  - Server not listening on 0.0.0.0"
    echo "  - Network routing issue"
    echo ""
    echo "Check firewall on remote host:"
    echo "  ssh ${REMOTE_USER}@${REMOTE_HOST} 'sudo firewall-cmd --list-ports'"
    echo ""
    echo "Add port if needed:"
    echo "  ssh ${REMOTE_USER}@${REMOTE_HOST} 'sudo firewall-cmd --permanent --add-port=8443/tcp && sudo firewall-cmd --reload'"
fi

# Cleanup
rm -f /tmp/mcp-server-deploy.tar.gz

echo ""
echo "Deployment script completed."

# Made with Bob
