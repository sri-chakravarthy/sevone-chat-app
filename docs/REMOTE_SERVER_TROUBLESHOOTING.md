# Remote MCP Server Troubleshooting Guide

## Problem
Bob cannot connect to the MCP server at `c49988v1.fyre.ibm.com:8443`

Error: `SSE error: TypeError: fetch failed: connect ECONNREFUSED 9.46.83.26:8443`

## Root Cause
Port 8443 is not accessible, which means:
- The MCP server container is not running
- The server is running on a different port
- A firewall is blocking the connection

## Solution Steps

### Step 1: SSH to the Remote Host

```bash
ssh c49988v1.fyre.ibm.com
```

### Step 2: Check if the MCP Container is Running

```bash
# List all running containers
podman ps

# Look specifically for the MCP server
podman ps | grep sevone-mysql-mcp
```

**Expected output if running:**
```
CONTAINER ID  IMAGE                    COMMAND     CREATED      STATUS      PORTS                   NAMES
abc123def456  sevone-mysql-mcp:latest  python...   2 hours ago  Up 2 hours  0.0.0.0:8443->8000/tcp  sevone-mysql-mcp
```

### Step 3: Check All Containers (Including Stopped)

```bash
# List all containers including stopped ones
podman ps -a | grep sevone-mysql-mcp
```

### Step 4A: If Container Exists But Is Stopped

```bash
# Start the container
podman start sevone-mysql-mcp

# Check logs
podman logs sevone-mysql-mcp

# Verify it's running
podman ps | grep sevone-mysql-mcp
```

### Step 4B: If Container Doesn't Exist

You need to build and deploy the container. Here's the complete deployment process:

#### 1. Transfer the MCP Server Code to Remote Host

From your local machine:
```bash
# Create a tarball of the mcp-server directory
cd /Users/srikanthchakravarthy/Documents/Projects/github-general/BobAgent-1/sevone-chat-app-mysql
tar -czf mcp-server.tar.gz mcp-server/ .env

# Copy to remote host
scp mcp-server.tar.gz c49988v1.fyre.ibm.com:~/

# SSH to remote host
ssh c49988v1.fyre.ibm.com

# Extract on remote host
cd ~
tar -xzf mcp-server.tar.gz
```

#### 2. Build the Container Image

On the remote host:
```bash
cd ~/mcp-server

# Build the image
podman build -t sevone-mysql-mcp -f Containerfile .
```

#### 3. Deploy the Container

**IMPORTANT**: The container runs on port 8000 internally, but you need to map it to port 8443 externally.

```bash
# Stop and remove any existing container
podman rm -f sevone-mysql-mcp 2>/dev/null || true

# Run the container with correct port mapping
podman run -d \
  --name sevone-mysql-mcp \
  --env-file ../.env \
  -p 8443:8000 \
  sevone-mysql-mcp
```

**Note**: The `-p 8443:8000` maps external port 8443 to internal port 8000.

#### 4. Verify the Deployment

```bash
# Check container is running
podman ps | grep sevone-mysql-mcp

# Check logs for any errors
podman logs sevone-mysql-mcp

# Test the health endpoint
curl -k https://localhost:8443/health

# Test from external (from your local machine)
curl -k https://c49988v1.fyre.ibm.com:8443/health
```

### Step 5: Check Firewall Rules

If the container is running but still not accessible:

```bash
# Check if firewall is running
sudo firewall-cmd --state

# Check if port 8443 is open
sudo firewall-cmd --list-ports

# If port is not open, add it
sudo firewall-cmd --permanent --add-port=8443/tcp
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-ports
```

### Step 6: Verify Environment Variables

On the remote host, check the `.env` file:

```bash
cat ~/.env
```

Ensure it has:
```bash
# Server should bind to all interfaces in container
MCP_SERVER_HOST=0.0.0.0
MCP_SERVER_PORT=8000

# Database connection
MYSQL_HOST=c49988v1.fyre.ibm.com
MYSQL_PORT=3306
MYSQL_DATABASE=net
MYSQL_USER=sevone_mcp
MYSQL_PASSWORD=mcppassword

# Other required settings
DB_ACCESS_MODE=tcp
ALLOWED_OPERATIONS=SELECT,INSERT
LOG_LEVEL=INFO
```

## Quick Deployment Script

Save this as `deploy_mcp_server.sh` on the remote host:

```bash
#!/bin/bash
set -e

echo "Deploying SevOne MCP Server..."

# Stop existing container
podman rm -f sevone-mysql-mcp 2>/dev/null || true

# Build image
cd ~/mcp-server
podman build -t sevone-mysql-mcp -f Containerfile .

# Run container
podman run -d \
  --name sevone-mysql-mcp \
  --env-file ../.env \
  -p 8443:8000 \
  sevone-mysql-mcp

# Wait for startup
sleep 5

# Check status
echo ""
echo "Container status:"
podman ps | grep sevone-mysql-mcp

echo ""
echo "Recent logs:"
podman logs --tail 20 sevone-mysql-mcp

echo ""
echo "Testing health endpoint..."
curl -k https://localhost:8443/health

echo ""
echo "Deployment complete!"
```

Run it:
```bash
chmod +x deploy_mcp_server.sh
./deploy_mcp_server.sh
```

## Verification from Local Machine

After deploying, test from your local machine:

```bash
# Test health endpoint
curl -k https://c49988v1.fyre.ibm.com:8443/health

# Should return:
# {"status":"ok","server":"sevone-mysql-mcp","transport":"sse"}

# Test SSE endpoint (will hang waiting for events - that's normal)
curl -k -H "Authorization: Bearer 85a87b5b24e957808932276e012047110741b16120cf2ad2b1490d86de23f297" \
  https://c49988v1.fyre.ibm.com:8443/sse
```

## Common Issues

### Issue: "Permission denied" when running podman

**Solution**: Add your user to the podman group or use sudo:
```bash
sudo podman ps
```

### Issue: "Port already in use"

**Solution**: Find and stop the process using port 8443:
```bash
sudo lsof -i :8443
sudo kill <PID>
```

### Issue: Container starts but immediately stops

**Solution**: Check logs for errors:
```bash
podman logs sevone-mysql-mcp
```

Common causes:
- Missing environment variables
- Database connection failure
- Python dependency issues

### Issue: "Cannot connect to MySQL"

**Solution**: Verify MySQL is accessible from the container:
```bash
# Test from inside the container
podman exec -it sevone-mysql-mcp sh -c \
  'python -c "import socket; s=socket.socket(); s.connect((\"c49988v1.fyre.ibm.com\", 3306)); print(\"MySQL reachable\")"'
```

## Monitoring

### View Real-time Logs
```bash
podman logs -f sevone-mysql-mcp
```

### Check Container Resource Usage
```bash
podman stats sevone-mysql-mcp
```

### Restart Container
```bash
podman restart sevone-mysql-mcp
```

## Next Steps

Once the server is running and accessible:

1. Test from your local machine using the diagnostic script:
   ```bash
   ./scripts/check_remote_mcp_server.sh
   ```

2. Restart Bob AI to reconnect to the MCP server

3. Test a simple query in Bob:
   ```
   Can you show me the database schema?
   ```

## Contact

If you continue to have issues, provide:
- Output of `podman ps -a`
- Output of `podman logs sevone-mysql-mcp`
- Output of `curl -k https://localhost:8443/health` (from remote host)
- Firewall status: `sudo firewall-cmd --list-all`