#!/bin/bash

# Script to check if the remote MCP server is running
# Usage: ./scripts/check_remote_mcp_server.sh

set -e

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

REMOTE_HOST="c49988v1.fyre.ibm.com"
MCP_PORT="8443"
HEALTH_URL="https://${REMOTE_HOST}:${MCP_PORT}/health"
SSE_URL="${SEVONE_MCP_URL}"

echo "=========================================="
echo "MCP Server Diagnostics"
echo "=========================================="
echo ""

# Check 1: DNS Resolution
echo "1. Checking DNS resolution for ${REMOTE_HOST}..."
if host ${REMOTE_HOST} > /dev/null 2>&1; then
    IP=$(host ${REMOTE_HOST} | grep "has address" | awk '{print $4}' | head -1)
    echo "   ✓ DNS resolves to: ${IP}"
else
    echo "   ✗ DNS resolution failed"
    exit 1
fi
echo ""

# Check 2: Port connectivity
echo "2. Checking port ${MCP_PORT} connectivity..."
if timeout 5 bash -c "cat < /dev/null > /dev/tcp/${REMOTE_HOST}/${MCP_PORT}" 2>/dev/null; then
    echo "   ✓ Port ${MCP_PORT} is open and accepting connections"
else
    echo "   ✗ Port ${MCP_PORT} is not accessible (connection refused or timeout)"
    echo "   This means the MCP server is likely not running or firewall is blocking"
    exit 1
fi
echo ""

# Check 3: Health endpoint
echo "3. Checking health endpoint: ${HEALTH_URL}..."
if command -v curl > /dev/null 2>&1; then
    HEALTH_RESPONSE=$(curl -k -s -w "\n%{http_code}" --connect-timeout 5 "${HEALTH_URL}" 2>&1 || echo "FAILED")
    HTTP_CODE=$(echo "${HEALTH_RESPONSE}" | tail -1)
    BODY=$(echo "${HEALTH_RESPONSE}" | head -n -1)
    
    if [ "${HTTP_CODE}" = "200" ]; then
        echo "   ✓ Health endpoint responding (HTTP ${HTTP_CODE})"
        echo "   Response: ${BODY}"
    elif [ "${HTTP_CODE}" = "FAILED" ]; then
        echo "   ✗ Health endpoint not accessible"
        echo "   Error: ${HEALTH_RESPONSE}"
    else
        echo "   ⚠ Health endpoint returned HTTP ${HTTP_CODE}"
        echo "   Response: ${BODY}"
    fi
else
    echo "   ⚠ curl not available, skipping health check"
fi
echo ""

# Check 4: SSE endpoint
echo "4. Checking SSE endpoint: ${SSE_URL}..."
if command -v curl > /dev/null 2>&1; then
    SSE_RESPONSE=$(curl -k -s -w "\n%{http_code}" --connect-timeout 5 \
        -H "Authorization: Bearer ${SEVONE_MCP_AUTH_TOKEN}" \
        "${SSE_URL}" 2>&1 | head -20 || echo "FAILED")
    
    if echo "${SSE_RESPONSE}" | grep -q "event:"; then
        echo "   ✓ SSE endpoint is responding with events"
    else
        echo "   ✗ SSE endpoint not responding correctly"
        echo "   Response: ${SSE_RESPONSE}"
    fi
else
    echo "   ⚠ curl not available, skipping SSE check"
fi
echo ""

# Check 5: SSH access (if available)
echo "5. Checking if we can SSH to the remote host..."
if command -v ssh > /dev/null 2>&1; then
    if timeout 5 ssh -o ConnectTimeout=5 -o BatchMode=yes ${REMOTE_HOST} "echo 'SSH OK'" 2>/dev/null; then
        echo "   ✓ SSH access available"
        echo ""
        echo "   You can check the MCP server status with:"
        echo "   ssh ${REMOTE_HOST} 'podman ps | grep sevone-mysql-mcp'"
        echo "   ssh ${REMOTE_HOST} 'podman logs sevone-mysql-mcp'"
    else
        echo "   ⚠ SSH access not available or requires password"
        echo "   You may need to manually check the server status"
    fi
else
    echo "   ⚠ ssh not available"
fi
echo ""

echo "=========================================="
echo "Summary"
echo "=========================================="
echo "Remote Host: ${REMOTE_HOST} (${IP})"
echo "MCP Port: ${MCP_PORT}"
echo "SSE URL: ${SSE_URL}"
echo ""
echo "If the server is not running, you need to:"
echo "1. SSH to ${REMOTE_HOST}"
echo "2. Check if the container is running: podman ps | grep sevone-mysql-mcp"
echo "3. If not running, start it: podman start sevone-mysql-mcp"
echo "4. If container doesn't exist, deploy it using the instructions in mcp-server/README.md"
echo ""

# Made with Bob
