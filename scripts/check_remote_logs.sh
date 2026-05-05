#!/bin/bash

# Script to check MCP server logs on remote host
# Usage: ./scripts/check_remote_logs.sh

REMOTE_HOST="${1:-c49988v1.fyre.ibm.com}"

echo "=========================================="
echo "Checking MCP Server Logs"
echo "=========================================="
echo ""

echo "Container Status:"
ssh "${REMOTE_HOST}" 'podman ps | grep sevone-mysql-mcp'
echo ""

echo "Recent Logs (last 50 lines):"
echo "=========================================="
ssh "${REMOTE_HOST}" 'podman logs --tail 50 sevone-mysql-mcp'
echo "=========================================="
echo ""

echo "Testing health endpoint from remote host:"
ssh "${REMOTE_HOST}" 'curl -k -s https://localhost:8443/health || echo "Health check failed"'
echo ""

echo "Testing SSE endpoint from remote host:"
ssh "${REMOTE_HOST}" 'timeout 3 curl -k -s https://localhost:8443/sse || echo "SSE endpoint test completed"'
echo ""

echo "Checking environment variables in container:"
ssh "${REMOTE_HOST}" 'podman exec sevone-mysql-mcp env | grep -E "(MCP_SERVER|MYSQL_|LOG_LEVEL)" | sort'
echo ""

# Made with Bob
