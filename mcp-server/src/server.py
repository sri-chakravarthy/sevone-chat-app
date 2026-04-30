"""MCP Server for SevOne MySQL Database Access"""
import asyncio
import logging
import os
from pathlib import Path
from typing import Any
from dotenv import load_dotenv

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent

# Load environment variables from .env file
env_path = Path(__file__).parent.parent.parent / '.env'
if env_path.exists():
    load_dotenv(env_path)
    logger = logging.getLogger(__name__)
    logger.info(f"Loaded environment variables from {env_path}")
else:
    logger = logging.getLogger(__name__)
    logger.warning(f".env file not found at {env_path}")

from .config.settings import DatabaseConfig, SecurityConfig
from .database.connection import DatabaseConnection
from .database.validator import QueryValidator
from .database.schema import SchemaExtractor
from .tools.select_query import select_query_tool
from .tools.insert_query import insert_query_tool

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize server
app = Server("sevone-mysql-mcp")

# Global instances
db_connection: DatabaseConnection = None
validator: QueryValidator = None
schema_extractor: SchemaExtractor = None


@app.list_tools()
async def list_tools() -> list[Tool]:
    """List available MCP tools"""
    return [
        Tool(
            name="select_query",
            description=(
                "Execute SELECT queries on the SevOne MySQL database. "
                "This tool provides read-only access to query data. "
                "Supports parameterized queries for safe data retrieval."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "SQL SELECT query to execute"
                    },
                    "parameters": {
                        "type": "array",
                        "items": {"type": "string"},
                        "description": "Optional parameterized query values"
                    }
                },
                "required": ["query"]
            }
        ),
        Tool(
            name="insert_query",
            description=(
                "Execute INSERT queries on the SevOne MySQL database. "
                "This tool allows adding new records to the database. "
                "Parameterized queries are REQUIRED for security."
            ),
            inputSchema={
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "SQL INSERT query with placeholders (%s)"
                    },
                    "parameters": {
                        "type": "array",
                        "items": {"type": "string"},
                        "description": "Parameterized query values (REQUIRED)"
                    }
                },
                "required": ["query", "parameters"]
            }
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
                        "default": False
                    }
                }
            }
        )
    ]


@app.call_tool()
async def call_tool(name: str, arguments: Any) -> list[TextContent]:
    """Handle tool calls"""
    try:
        if name == "select_query":
            query = arguments.get("query")
            parameters = arguments.get("parameters")
            
            if not query:
                return [TextContent(
                    type="text",
                    text="Error: 'query' parameter is required"
                )]
            
            result = await select_query_tool(
                db_connection,
                validator,
                query,
                parameters
            )
            
            return [TextContent(
                type="text",
                text=format_select_result(result)
            )]
        
        elif name == "insert_query":
            query = arguments.get("query")
            parameters = arguments.get("parameters")
            
            if not query:
                return [TextContent(
                    type="text",
                    text="Error: 'query' parameter is required"
                )]
            
            if not parameters:
                return [TextContent(
                    type="text",
                    text="Error: 'parameters' parameter is required for INSERT queries"
                )]
            
            result = await insert_query_tool(
                db_connection,
                validator,
                query,
                parameters
            )
            
            return [TextContent(
                type="text",
                text=format_insert_result(result)
            )]
        
        elif name == "get_schema":
            refresh = arguments.get("refresh", False)
            schema = await schema_extractor.get_schema(refresh=refresh)
            
            if "error" in schema:
                return [TextContent(
                    type="text",
                    text=f"Error retrieving schema: {schema['error']}"
                )]
            
            formatted_schema = schema_extractor.format_schema_for_prompt(schema)
            
            return [TextContent(
                type="text",
                text=formatted_schema
            )]
        
        else:
            return [TextContent(
                type="text",
                text=f"Error: Unknown tool '{name}'"
            )]
    
    except Exception as e:
        logger.error(f"Error executing tool {name}: {e}")
        return [TextContent(
            type="text",
            text=f"Error: {str(e)}"
        )]


def format_select_result(result: dict[str, Any]) -> str:
    """Format SELECT query result for display"""
    if not result.get("success"):
        return f"Error: {result.get('error', 'Unknown error')}"
    
    rows = result.get("rows", [])
    row_count = result.get("row_count", 0)
    execution_time = result.get("execution_time", 0)
    columns = result.get("columns", [])
    
    output = [
        f"Query executed successfully in {execution_time}s",
        f"Rows returned: {row_count}",
        ""
    ]
    
    if row_count > 0 and columns:
        # Format as table
        output.append("Results:")
        output.append("-" * 80)
        
        # Column headers
        output.append(" | ".join(columns))
        output.append("-" * 80)
        
        # Rows (limit to first 100 for display)
        for row in rows[:100]:
            values = [str(row.get(col, "NULL")) for col in columns]
            output.append(" | ".join(values))
        
        if row_count > 100:
            output.append(f"... and {row_count - 100} more rows")
    
    return "\n".join(output)


def format_insert_result(result: dict[str, Any]) -> str:
    """Format INSERT query result for display"""
    if not result.get("success"):
        return f"Error: {result.get('error', 'Unknown error')}"
    
    insert_id = result.get("insert_id")
    affected_rows = result.get("affected_rows", 0)
    
    output = [
        "Insert successful!",
        f"Inserted row ID: {insert_id}",
        f"Affected rows: {affected_rows}"
    ]
    
    return "\n".join(output)


async def main():
    """Main entry point for MCP server"""
    global db_connection, validator, schema_extractor
    
    logger.info("Starting SevOne MySQL MCP Server...")
    
    # Load configuration from environment
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    
    logger.info(f"Connecting to database: {db_config.host}:{db_config.port}/{db_config.database}")
    
    # Initialize database connection
    db_connection = DatabaseConnection(db_config)
    await db_connection.initialize()
    
    # Test connection
    if not await db_connection.test_connection():
        logger.error("Database connection test failed!")
        return
    
    logger.info("Database connection successful")
    
    # Initialize validator and schema extractor
    validator = QueryValidator(security_config)
    schema_extractor = SchemaExtractor(db_connection)
    
    # Pre-load schema
    logger.info("Loading database schema...")
    schema = await schema_extractor.get_schema()
    logger.info(f"Schema loaded: {len(schema.get('tables', []))} tables found")
    
    # Run MCP server
    logger.info("MCP Server ready")
    async with stdio_server() as (read_stream, write_stream):
        await app.run(read_stream, write_stream, app.create_initialization_options())


if __name__ == "__main__":
    asyncio.run(main())

# Made with Bob
