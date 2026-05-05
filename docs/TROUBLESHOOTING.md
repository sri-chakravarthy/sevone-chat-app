# Troubleshooting

## MCP Server Startup Problems

### Problem: MCP server fails during initialization

Verify the Podman-backed mysql execution path manually:

```bash
podman exec -i "nms-nms-nms" "/usr/bin/mysql" << 'SQL'
SELECT 1;
SQL
```

Check the configured values in [`.env.example`](.env.example):
- `PODMAN_BINARY`
- `PODMAN_CONTAINER_NAME`
- `MYSQL_CLIENT_PATH`
- `MYSQL_DATABASE`

### Problem: Podman command not found

Ensure Podman is installed on the Unix host and available to the MCP server runtime.

### Problem: mysql client not found in the target container

Ensure [`MYSQL_CLIENT_PATH`](.env.example) points to a valid mysql binary inside the target container.

## Query Execution Problems

### Problem: parameter count mismatch

The new backend renders placeholders before passing SQL to the mysql CLI. Ensure the number of `%s` or `?` placeholders matches the parameter list supplied to [`select_query_tool()`](mcp-server/src/tools/select_query.py:11) or [`insert_query_tool()`](mcp-server/src/tools/insert_query.py:11).

### Problem: INSERT rejected due to placeholders

[`insert_query_tool()`](mcp-server/src/tools/insert_query.py:11) still requires placeholders for security. Inline literal INSERT statements will be rejected.

### Problem: schema retrieval fails

Verify metadata queries can be executed through the podman/mysql path and that the configured database name matches the schema to inspect.

## Remote Bob Connectivity Problems

### Problem: Bob cannot reach the MCP server

Verify Bob is configured with the correct remote MCP endpoint in [`bob_config.json`](bob_config.json).

Expected configuration shape:
- transport: `sse`
- url: `SEVONE_MCP_URL`
- auth header using `SEVONE_MCP_AUTH_TOKEN`

### Problem: wrong Unix host target

Update the Bob-side `SEVONE_MCP_URL` value to point at the correct Unix host where the MCP server container is running.

Example:
```text
SEVONE_MCP_URL=https://unix-host.example.com:8443/sse
```

### Problem: authentication failures

Verify:
- `SEVONE_MCP_AUTH_TOKEN` matches the token expected by the remote endpoint
- any reverse proxy or gateway forwards the `Authorization` header correctly

### Problem: TLS or reverse proxy issues

Check:
- certificate validity
- hostname match
- firewall and load balancer rules
- that the exposed path matches the configured SSE endpoint

## Container Deployment Problems

### Problem: MCP server container starts but cannot execute Podman

If the MCP server runs as a Podman container, it still needs a controlled way to execute host-side `podman exec`.

Validate your chosen deployment pattern:
- mounted Podman socket
- host-side helper service
- other approved control mechanism

### Problem: target MySQL container name mismatch

Ensure `PODMAN_CONTAINER_NAME` matches the actual MySQL container name:
```bash
podman ps --format "{{.Names}}"
```

## Validation and Test Checks

Run tests:
```bash
cd mcp-server
pytest tests/ -v
```

Run lint checks:
```bash
cd mcp-server
ruff check src/ tests/
```

Run type checks:
```bash
cd mcp-server
mypy src/