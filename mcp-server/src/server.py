"""MCP Server for SevOne MySQL Database Access"""
import asyncio
import logging
from contextlib import asynccontextmanager
from pathlib import Path
from typing import Any

from dotenv import load_dotenv
from mcp.server import Server
from mcp.server.sse import SseServerTransport
from mcp.types import Tool, TextContent
from starlette.applications import Starlette
from starlette.requests import Request
from starlette.responses import JSONResponse
from starlette.routing import Route
import uvicorn

from .config.settings import DatabaseConfig, SecurityConfig, ServerConfig
from .database.connection import DatabaseConnection
from .database.schema import SchemaExtractor
from .database.validator import QueryValidator
from .tools.insert_query import insert_query_tool
from .tools.select_query import select_query_tool

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)
logger = logging.getLogger(__name__)

# Load environment variables from .env file
env_path = Path(__file__).parent.parent.parent / ".env"
if env_path.exists():
    load_dotenv(env_path)
    logger.info("Loaded environment variables from %s", env_path)
else:
    logger.warning(".env file not found at %s", env_path)

# Initialize MCP server
app = Server("sevone-mysql-mcp")

# Global instances
db_connection: DatabaseConnection | None = None
validator: QueryValidator | None = None
schema_extractor: SchemaExtractor | None = None


@app.list_tools()
async def list_tools() -> list[Tool]:
    """List available MCP tools."""
    return [
        Tool(
            name="select_query",
            description=(
                "Execute SELECT queries on the SevOne MySQL database using the "
                "configured database access mode."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "SQL SELECT query to execute",
                    },
                    "parameters": {
                        "type": "array",
                        "items": {
                            "anyOf": [
                                {"type": "string"},
                                {"type": "number"},
                                {"type": "boolean"},
                                {"type": "null"},
                            ]
                        },
                        "description": "Optional parameterized query values",
                    },
                },
                "required": ["query"],
            },
        ),
        Tool(
            name="insert_query",
            description=(
                "Execute INSERT queries on the SevOne MySQL database using the "
                "configured database access mode. Parameterized queries are "
                "REQUIRED for security."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "SQL INSERT query with placeholders (%s)",
                    },
                    "parameters": {
                        "type": "array",
                        "items": {
                            "anyOf": [
                                {"type": "string"},
                                {"type": "number"},
                                {"type": "boolean"},
                                {"type": "null"},
                            ]
                        },
                        "description": "Parameterized query values (REQUIRED)",
                    },
                },
                "required": ["query", "parameters"],
            },
        ),
        Tool(
            name="get_schema",
            description=(
                "Get the complete database schema including tables, columns, "
                "data types, indexes, and relationships. Useful for understanding "
                "the database structure before writing queries."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "refresh": {
                        "type": "boolean",
                        "description": "Force refresh of cached schema",
                        "default": False,
                    }
                },
            },
        ),
    ]


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls."""
    if db_connection is None or validator is None or schema_extractor is None:
        return [TextContent(type="text", text="Error: MCP server not initialized")]

    arguments = arguments or {}

    try:
        if name == "select_query":
            query = arguments.get("query")
            parameters = arguments.get("parameters")

            if not query:
                return [
                    TextContent(
                        type="text",
                        text="Error: 'query' parameter is required",
                    )
                ]

            result = await select_query_tool(
                db_connection,
                validator,
                query,
                parameters,
            )

            return [
                TextContent(
                    type="text",
                    text=format_select_result(result),
                )
            ]

        if name == "insert_query":
            query = arguments.get("query")
            parameters = arguments.get("parameters")

            if not query:
                return [
                    TextContent(
                        type="text",
                        text="Error: 'query' parameter is required",
                    )
                ]

            if not parameters:
                return [
                    TextContent(
                        type="text",
                        text="Error: 'parameters' parameter is required for INSERT queries",
                    )
                ]

            result = await insert_query_tool(
                db_connection,
                validator,
                query,
                parameters,
            )

            return [
                TextContent(
                    type="text",
                    text=format_insert_result(result),
                )
            ]

        if name == "get_schema":
            refresh = arguments.get("refresh", False)
            schema = await schema_extractor.get_schema(refresh=refresh)

            if "error" in schema:
                return [
                    TextContent(
                        type="text",
                        text=f"Error retrieving schema: {schema['error']}",
                    )
                ]

            formatted_schema = schema_extractor.format_schema_for_prompt(schema)

            return [
                TextContent(
                    type="text",
                    text=formatted_schema,
                )
            ]

        return [
            TextContent(
                type="text",
                text=f"Error: Unknown tool '{name}'",
            )
        ]

    except Exception as e:
        logger.error("Error executing tool %s: %s", name, e)
        return [
            TextContent(
                type="text",
                text=f"Error: {str(e)}",
            )
        ]


def format_select_result(result: dict[str, Any]) -> str:
    """Format SELECT query result for display."""
    if not result.get("success"):
        return f"Error: {result.get('error', 'Unknown error')}"

    rows = result.get("rows", [])
    row_count = result.get("row_count", 0)
    execution_time = result.get("execution_time", 0)
    columns = result.get("columns", [])

    output = [
        f"Query executed successfully in {execution_time}s",
        f"Rows returned: {row_count}",
        "",
    ]

    if row_count > 0 and columns:
        output.append("Results:")
        output.append(" | ".join(columns))
        output.append("-" * len(" | ".join(columns)))

        for row in rows[:100]:
            output.append(" | ".join(str(row.get(col, "")) for col in columns))

        if row_count > 100:
            output.append(f"\n... and {row_count - 100} more rows")

    return "\n".join(output)


def format_insert_result(result: dict[str, Any]) -> str:
    """Format INSERT query result for display."""
    if not result.get("success"):
        return f"Error: {result.get('error', 'Unknown error')}"

    return (
        "Insert query executed successfully\n"
        f"Insert ID: {result.get('insert_id', 'N/A')}\n"
        f"Affected rows: {result.get('affected_rows', 0)}"
    )


async def initialize_runtime() -> None:
    """Initialize shared runtime resources."""
    global db_connection, validator, schema_extractor

    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()

    db_connection = DatabaseConnection(db_config)
    validator = QueryValidator(security_config)
    schema_extractor = SchemaExtractor(db_connection)

    await db_connection.initialize()

    target = (
        f"{db_config.host}:{db_config.port}"
        if db_config.access_mode == "tcp"
        else db_config.podman_container_name
    )

    logger.info(
        "Database executor initialized via %s for %s/%s",
        db_config.access_mode.upper(),
        target,
        db_config.database,
    )


async def shutdown_runtime() -> None:
    """Shutdown shared runtime resources."""
    global db_connection, validator, schema_extractor

    if db_connection is not None:
        await db_connection.close()

    db_connection = None
    validator = None
    schema_extractor = None


@asynccontextmanager
async def lifespan(_: Starlette):
    """Manage Starlette application lifecycle."""
    await initialize_runtime()
    try:
        yield
    finally:
        await shutdown_runtime()


def create_http_app() -> Starlette:
    """Create the HTTP/SSE MCP application."""
    server_config = ServerConfig.from_env()
    sse_transport = SseServerTransport(server_config.message_endpoint)

    async def sse_endpoint(request: Request) -> None:
        async with sse_transport.connect_sse(
            request.scope,
            request.receive,
            request._send,
        ) as (read_stream, write_stream):
            await app.run(
                read_stream,
                write_stream,
                app.create_initialization_options(),
            )

    async def message_endpoint(request: Request) -> None:
        await sse_transport.handle_post_message(
            request.scope,
            request.receive,
            request._send,
        )

    async def health_endpoint(_: Request) -> JSONResponse:
        return JSONResponse(
            {
                "status": "ok",
                "server": "sevone-mysql-mcp",
                "transport": "sse",
            }
        )

    return Starlette(
        debug=False,
        lifespan=lifespan,
        routes=[
            Route("/health", health_endpoint, methods=["GET"]),
            Route(server_config.sse_endpoint, sse_endpoint, methods=["GET"]),
            Route(server_config.message_endpoint, message_endpoint, methods=["POST"]),
        ],
    )


def main() -> None:
    """Run the MCP server over HTTP/SSE inside the container."""
    server_config = ServerConfig.from_env()
    application = create_http_app()

    logger.info(
        "Starting MCP SSE server on %s:%s (sse=%s, messages=%s)",
        server_config.host,
        server_config.port,
        server_config.sse_endpoint,
        server_config.message_endpoint,
    )

    uvicorn.run(
        application,
        host=server_config.host,
        port=server_config.port,
        log_level=server_config.log_level.lower(),
    )


if __name__ == "__main__":
    main()

# Made with Bob
