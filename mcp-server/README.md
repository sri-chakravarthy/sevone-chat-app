# SevOne MySQL MCP Server

MCP (Model Context Protocol) Server for secure SevOne MySQL database access through either direct TCP MySQL connectivity or a Podman-hosted mysql client workflow.

## Features

- **Dual Database Access Modes**: Supports direct TCP MySQL connectivity and `podman exec`-based access
- **Secure Query Validation**: SELECT and controlled INSERT operations only
- **Schema Extraction**: Automatic database schema discovery and formatting
- **Parameterized Query Rendering**: Controlled rendering of placeholders for mysql CLI execution
- **Remote Bob Connectivity**: Bob can connect to the MCP server using a remote SSE endpoint
- **Containerized Deployment**: MCP server can run as a Podman container on the Unix host

## Architecture

```text
Preferred containerized deployment:
Bob AI Agent Host
  -> remote MCP SSE connection
  -> SevOne MCP Server container on Unix host
  -> TCP connection to MySQL on host listener
  -> MySQL service on Unix host / host-networked container

Alternative host-context deployment:
Bob AI Agent Host
  -> remote MCP SSE connection
  -> SevOne MCP Server
  -> podman exec -i nms-nms-nms /usr/bin/mysql
  -> MySQL inside Podman container
```

## Installation

### Prerequisites

- Python 3.11 or higher
- Podman installed on the Unix host
- Access to the target MySQL container `nms-nms-nms`
- Bob configured to reach the remote MCP endpoint

### Install Dependencies

```bash
cd mcp-server
pip install -r requirements.txt
```

Or using the project file:

```bash
pip install -e .
```

## Configuration

### Environment Variables

Create a `.env` file in the project root or provide equivalent environment variables:

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

For containerized deployment, prefer `DB_ACCESS_MODE=tcp` when MySQL is reachable on the Unix host network. Use `DB_ACCESS_MODE=podman_exec` only when the MCP runtime can execute `podman` in the same host/container context that can see the target MySQL container.

### Bob AI Configuration

Configure Bob to connect to the remote MCP server by URL using [`bob_config.json`](../bob_config.json):

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

This is how Bob is told which remote Unix host to connect to.

## Usage

### Running the MCP Server Locally for Development

```bash
cd mcp-server
python -m src.server
```

### Running as a Podman Container on the Unix Host

Example container build:

```bash
cd mcp-server
podman build -t sevone-mysql-mcp -f Containerfile .
```

The image now installs the Podman CLI, but for this environment the preferred deployment mode is TCP MySQL connectivity from the MCP container to the Unix host listener.

Example container run:

```bash
podman rm -f sevone-mysql-mcp 2>/dev/null || true

podman run -d \
  --name sevone-mysql-mcp \
  --env-file ../.env \
  -v /run/podman/podman.sock:/run/podman/podman.sock \
  -p 8000:8000 \
  sevone-mysql-mcp
```

For TCP-mode deployments, verify the container can reach MySQL on the Unix host:

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

If you explicitly use `DB_ACCESS_MODE=podman_exec`, also verify Podman is available inside the image:

```bash
podman exec -it sevone-mysql-mcp sh -lc 'which podman && podman --version'
```

The production deployment should additionally place the server behind TLS termination or a secured reverse proxy if remote SSE is exposed.

The server exposes:
- `/health` for health checks
- `/sse` for the MCP SSE connection
- `/messages` for MCP client POST messages

## Available Tools

### 1. `select_query`

Execute SELECT queries on the database.

**Parameters:**
- `query` (string, required): SQL SELECT query
- `parameters` (array, optional): Parameterized query values

### 2. `insert_query`

Execute INSERT queries on the database.

**Parameters:**
- `query` (string, required): SQL INSERT query with placeholders
- `parameters` (array, required): Parameterized query values

### 3. `get_schema`

Retrieve the complete database schema.

**Parameters:**
- `refresh` (boolean, optional): Force refresh of cached schema

## Security Features

### Query Validation

- Only SELECT and INSERT operations allowed
- Blocks dangerous SQL patterns
- Validates query length and structure
- Requires placeholders for INSERT operations

### Database Execution Security

- TCP mode uses explicit MySQL host, port, user, and password settings
- Podman mode uses a fixed container name through configuration
- SQL is passed over stdin to the mysql client in podman mode
- Supports mysql defaults file instead of plain password env vars in podman mode
- The MCP image includes the Podman CLI, but host Podman access remains environment-dependent
- Prefer TCP mode for containerized deployment when MySQL is already listening on the host network

### Remote Access Security

- Bob should connect using HTTPS/TLS
- Use bearer token authentication or stronger front-end auth
- Restrict access with firewall rules or IP allowlists
- Do not expose an unauthenticated public MCP endpoint

## Testing

Run the test suite:

```bash
cd mcp-server
pytest tests/ -v
```

## Development

### Code Formatting

```bash
black src/ tests/
```

### Linting

```bash
ruff check src/ tests/
```

### Type Checking

```bash
mypy src/
```

## Project Structure

```text
mcp-server/
├── src/
│   ├── __init__.py
│   ├── server.py
│   ├── config/
│   │   ├── __init__.py
│   │   └── settings.py
│   ├── database/
│   │   ├── __init__.py
│   │   ├── connection.py
│   │   ├── validator.py
│   │   └── schema.py
│   └── tools/
│       ├── __init__.py
│       ├── select_query.py
│       └── insert_query.py
├── tests/
├── pyproject.toml
├── requirements.txt
└── README.md
```

## Troubleshooting

### Podman Execution Issues

1. Verify Podman is installed on the Unix host
2. Verify the target container is running:
   ```bash
   podman ps
   ```
3. Verify mysql can be reached through the required access pattern:
   ```bash
   podman exec -i "nms-nms-nms" "/usr/bin/mysql" << 'SQL'
   SELECT 1;
   SQL
   ```

### Remote Bob Connectivity Issues

1. Verify Bob is using the correct `SEVONE_MCP_URL`
2. Verify the remote MCP endpoint is reachable from the Bob host
3. Verify auth token configuration
4. Verify TLS/reverse proxy configuration

## License

Copyright © 2024 SevOne. All rights reserved.