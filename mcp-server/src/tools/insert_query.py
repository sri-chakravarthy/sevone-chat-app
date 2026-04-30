"""INSERT query tool implementation"""
import logging
from typing import Any

from ..database.connection import DatabaseConnection
from ..database.validator import QueryValidator

logger = logging.getLogger(__name__)


async def insert_query_tool(
    db_connection: DatabaseConnection,
    validator: QueryValidator,
    query: str,
    parameters: list[Any]
) -> dict[str, Any]:
    """Execute INSERT queries on MySQL database
    
    This tool allows write operations to the database through INSERT queries.
    Parameterized queries are REQUIRED for security.
    
    Args:
        db_connection: Database connection instance
        validator: Query validator instance
        query: SQL INSERT query to execute (must use placeholders)
        parameters: Parameterized query values (REQUIRED)
        
    Returns:
        Dictionary containing:
        - success: Boolean indicating if query succeeded
        - insert_id: ID of the inserted row (if successful)
        - affected_rows: Number of rows affected
        - error: Error message (if failed)
        
    Example:
        >>> result = await insert_query_tool(
        ...     db, validator,
        ...     "INSERT INTO devices (device_name, ip_address) VALUES (%s, %s)",
        ...     ["Router-01", "192.168.1.1"]
        ... )
        >>> print(f"Inserted with ID: {result['insert_id']}")
    """
    logger.info(f"Executing INSERT query: {query[:100]}...")
    
    # Validate query
    validation = validator.validate_query(query, "INSERT")
    if not validation["valid"]:
        logger.warning(f"Query validation failed: {validation['error']}")
        return {
            "success": False,
            "error": validation["error"]
        }
    
    # Validate parameters (REQUIRED for INSERT)
    param_validation = validator.validate_parameters(parameters, required=True)
    if not param_validation["valid"]:
        logger.warning(f"Parameter validation failed: {param_validation['error']}")
        return {
            "success": False,
            "error": param_validation["error"]
        }
    
    # Check that query uses placeholders
    if '%s' not in query and '?' not in query:
        logger.warning("INSERT query must use parameterized placeholders")
        return {
            "success": False,
            "error": "INSERT queries must use parameterized placeholders (%s or ?) for security"
        }
    
    # Execute query
    try:
        result = await db_connection.execute_insert(
            query,
            parameters,
            timeout=validator.config.query_timeout
        )
        
        if result["success"]:
            logger.info(
                f"INSERT query successful: ID={result.get('insert_id')}, "
                f"affected_rows={result.get('affected_rows')}"
            )
        else:
            logger.error(f"INSERT query failed: {result.get('error')}")
            # Sanitize error message
            if "error" in result:
                result["error"] = validator.sanitize_error_message(result["error"])
        
        return result
        
    except Exception as e:
        logger.error(f"Unexpected error in insert_query_tool: {e}")
        return {
            "success": False,
            "error": validator.sanitize_error_message(str(e))
        }

# Made with Bob
