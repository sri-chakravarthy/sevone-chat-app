# Quick Start: Remote SevOne MCP Server

This guide explains how to run the SevOne MCP server on a Unix host as a Podman container and configure Bob AI on another host to connect to it.

## 1. Target Deployment Model

The preferred setup is:

```text
Bob Host
  -> remote MCP connection
  -> SevOne MCP Server container on Unix host
  -> TCP MySQL connection to c49988v1.fyre.ibm.com:3306
  -> MySQL service on Unix host / host-networked container
```

Alternative setup:
- host-run MCP server
- `podman exec -i "nms-nms-nms" "/usr/bin/mysql"`
- MySQL inside `nms-nms-nms`

Key points:
- Bob runs on a different host
- The MCP server runs on the Unix host
- For containerized deployment, TCP mode is preferred in this environment
- Bob must be told which MCP server URL to use

## 2. Files Involved

Important files in this implementation:
- [`mcp-server/src/config/settings.py`](mcp-server/src/config/settings.py)
- [`mcp-server/src/database/connection.py`](mcp-server/src/database/connection.py)
- [`mcp-server/src/database/schema.py`](mcp-server/src/database/schema.py)
- [`mcp-server/src/server.py`](mcp-server/src/server.py)
- [`bob_config.json`](bob_config.json)
- [`.env.example`](.env.example)
- [`mcp-server/Containerfile`](mcp-server/Containerfile)
- [`mcp-server/README.md`](mcp-server/README.md)
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)

## 3. Prerequisites on the Unix Host

Make sure the Unix host has:
- Podman installed
- MySQL reachable on the Unix host network
- network reachability from Bob host to the MCP endpoint
- TLS/reverse proxy plan if exposing the endpoint securely

Verify MySQL reachability from a container on the Unix host:

```bash
podman run --rm -it python:3.11-slim sh -lc 'python - <<EOF
import socket
s = socket.socket()
s.settimeout(5)
s.connect(("c49988v1.fyre.ibm.com", 3306))
print("TCP 3306 reachable")
s.close()
EOF'
```

If this fails, fix that first before starting the MCP server container.

## 4. Prepare Environment Configuration

Create a runtime environment file based on [`.env.example`](.env.example).

Example:

```bash
SEVONE_MCP_URL=https://unix-host.example.com:8000/sse
SEVONE_MCP_AUTH_TOKEN=replace_with_secure_token

DB_ACCESS_MODE=tcp
MYSQL_HOST=c49988v1.fyre.ibm.com
MYSQL_PORT=3306
MYSQL_DATABASE=sevone_db
MYSQL_USER=sevone_user
MYSQL_PASSWORD=your_secure_password_here

PODMAN_BINARY=/usr/bin/podman
PODMAN_CONTAINER_NAME=nms-nms-nms
MYSQL_CLIENT_PATH=/usr/bin/mysql
MYSQL_DEFAULTS_FILE=

DB_COMMAND_TIMEOUT=30
DB_MAX_CONCURRENT_COMMANDS=5

ALLOWED_OPERATIONS=SELECT,INSERT
MAX_QUERY_LENGTH=5000
QUERY_TIMEOUT=30
ENABLE_QUERY_LOGGING=true

MCP_SERVER_HOST=0.0.0.0
MCP_SERVER_PORT=8000
MCP_SSE_ENDPOINT=/sse
MCP_MESSAGE_ENDPOINT=/messages
LOG_LEVEL=INFO
```

Important values:
- `DB_ACCESS_MODE=tcp` is preferred for the containerized deployment
- `MYSQL_HOST` should be the Unix host name or host-network endpoint reachable from the MCP container
- `SEVONE_MCP_URL` is the URL Bob will use

## 5. Build the MCP Server Container

From [`mcp-server/`](mcp-server):

```bash
cd mcp-server
podman build -t sevone-mysql-mcp -f Containerfile .
```

This builds the MCP server image using [`mcp-server/Containerfile`](mcp-server/Containerfile). The image includes the Podman CLI for optional podman-exec mode, but TCP mode is the recommended deployment path for this environment.

## 6. Run the MCP Server Container on the Unix Host

Example run command:

```bash
podman rm -f sevone-mysql-mcp 2>/dev/null || true

podman run -d \
  --name sevone-mysql-mcp \
  --env-file ../.env \
  -v /run/podman/podman.sock:/run/podman/podman.sock \
  -p 8000:8000 \
  sevone-mysql-mcp
```

Verify the deployed connectivity model from a temporary container:

```bash
podman run --rm -it python:3.11-slim sh -lc 'python - <<EOF
import socket
s = socket.socket()
s.settimeout(5)
s.connect(("c49988v1.fyre.ibm.com", 3306))
print("TCP 3306 reachable")
s.close()
EOF'
```

Note:
- this project currently packages the MCP server in a container
- the preferred implementation now uses TCP mode through [`MYSQL_HOST`](.env.example) and [`MYSQL_PORT`](.env.example)
- [`podman exec`](mcp-server/src/database/connection.py:266) remains available only as an optional alternative backend

## 7. Expose the MCP Server Remotely

Bob is on another host, so it cannot use local stdio.

You must expose the MCP server using a remote-access model.

Recommended production pattern:

```text
Bob Host
  -> HTTPS / SSE
  -> reverse proxy on Unix host
  -> MCP service/container
  -> TCP connection to Unix host MySQL listener
  -> MySQL service
```

Recommended controls:
- TLS
- auth token
- firewall allowlist for Bob host
- reverse proxy or gateway in front of the MCP service

Runtime endpoints exposed by the server:
- health check: `/health`
- SSE connect endpoint: `/sse`
- MCP message POST endpoint: `/messages`

## 8. Configure Bob to Use the Remote MCP Host

Bob must be told which host to connect to.

Use [`bob_config.json`](bob_config.json):

```json
{
  "mcpServers": {
    "sevone-mysql": {
      "transport": "sse",
      "url": "${SEVONE_MCP_URL}",
      "headers": {
        "Authorization": "Bearer ${SEVONE_MCP_AUTH_TOKEN}"
      },
      "timeout": 30000
    }
  }
}
```

This is the main answer to:
- how Bob knows which Unix host to use
- how Bob connects to a remote MCP server

To change the remote Unix host, update:
- `SEVONE_MCP_URL`

Examples:
- `SEVONE_MCP_URL=https://unix-host-dev.example.com:8000/sse`
- `SEVONE_MCP_URL=https://unix-host-prod.example.com:8000/sse`

## 9. Validate the Implementation

### Run unit tests

From [`mcp-server/`](mcp-server):

```bash
python -m pytest ./tests -q
```

Expected result:
- all tests pass

### Validate MySQL access path

From the Unix host:

```bash
podman run --rm -it python:3.11-slim sh -lc 'python - <<EOF
import socket
s = socket.socket()
s.settimeout(5)
s.connect(("c49988v1.fyre.ibm.com", 3306))
print("TCP 3306 reachable")
s.close()
EOF'
```

### Validate HTTP/SSE endpoints

From any host that can reach the Unix host:

```bash
curl http://unix-host.example.com:8000/health
```

Expected result:
- JSON payload showing `status: ok`

### Validate Bob-side host selection

On the Bob host:
- set `SEVONE_MCP_URL` to the target Unix host SSE URL
- set `SEVONE_MCP_AUTH_TOKEN`
- start Bob with [`bob_config.json`](bob_config.json)

## 10. Operational Notes

### Database access model
The MCP server now supports two modes:
- TCP mode using:
  - `MYSQL_HOST`
  - `MYSQL_PORT`
  - `MYSQL_USER`
  - `MYSQL_PASSWORD`
- Podman mode using:
  - `PODMAN_CONTAINER_NAME`
  - `MYSQL_CLIENT_PATH`

For this environment, prefer:
- [`DB_ACCESS_MODE=tcp`](.env.example)

Implemented in:
- [`DatabaseConfig`](mcp-server/src/config/settings.py:7)
- [`DatabaseConnection`](mcp-server/src/database/connection.py:14)

### Query execution model
Queries are executed through:
- [`execute_select()`](mcp-server/src/database/connection.py:35)
- [`execute_insert()`](mcp-server/src/database/connection.py:62)

Both route through:
- [`_execute_mysql_command()`](mcp-server/src/database/connection.py:103)

### Schema access
Schema extraction uses:
- [`SchemaExtractor`](mcp-server/src/database/schema.py:10)

## 11. Security Checklist

Before production use, confirm:
- the MCP endpoint is behind TLS
- auth token handling is secure
- only approved Bob hosts can reach the MCP server
- the Podman control path from MCP container to host is approved
- logs do not expose sensitive SQL or credentials
- the mysql client authentication mechanism inside the MySQL container is secured

## 12. If Something Fails

Check:
- [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md)
- [`mcp-server/README.md`](mcp-server/README.md)

Most common issues:
- wrong `PODMAN_CONTAINER_NAME`
- wrong `MYSQL_CLIENT_PATH`
- Bob pointing to wrong `SEVONE_MCP_URL`
- auth header not forwarded correctly
- MCP container unable to access host Podman