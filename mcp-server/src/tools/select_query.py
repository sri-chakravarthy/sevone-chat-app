"""SELECT query tool implementation"""
import logging
from typing import Any, Optional

from ..database.connection import DatabaseConnection
from ..database.validator import QueryValidator

logger = logging.getLogger(__name__)


async def select_query_tool(
    db_connection: DatabaseConnection,
    validator: QueryValidator,
    query: str,
    parameters: Optional[list[Any]] = None
) -> dict[str, Any]:
    """Execute SELECT queries on MySQL database
    
    This tool allows read-only access to the database through SELECT queries.
    It supports parameterized queries for safe data retrieval.
    
    Args:
        db_connection: Database connection instance
        validator: Query validator instance
        query: SQL SELECT query to execute
        parameters: Optional parameterized query values
        
    Returns:
        Dictionary containing:
        - success: Boolean indicating if query succeeded
        - rows: List of result rows (if successful)
        - row_count: Number of rows returned
        - execution_time: Query execution time in seconds
        - columns: List of column names
        - error: Error message (if failed)
        
    Example:
        >>> result = await select_query_tool(
        ...     db, validator,
        ...     "SELECT * FROM devices WHERE device_name = %s",
        ...     ["Router-01"]
        ... )
        >>> print(result["rows"])
    """
    logger.info(f"Executing SELECT query: {query[:100]}...")
    
    # Validate query
    validation = validator.validate_query(query, "SELECT")
    if not validation["valid"]:
        logger.warning(f"Query validation failed: {validation['error']}")
        return {
            "success": False,
            "error": validation["error"]
        }
    
    # Validate parameters
    param_validation = validator.validate_parameters(parameters, required=False)
    if not param_validation["valid"]:
        logger.warning(f"Parameter validation failed: {param_validation['error']}")
        return {
            "success": False,
            "error": param_validation["error"]
        }
    
    # Execute query
    try:
        result = await db_connection.execute_select(
            query,
            parameters,
            timeout=validator.config.query_timeout
        )
        
        if result["success"]:
            logger.info(
                f"SELECT query successful: {result['row_count']} rows in "
                f"{result['execution_time']}s"
            )
        else:
            logger.error(f"SELECT query failed: {result.get('error')}")
            # Sanitize error message
            if "error" in result:
                result["error"] = validator.sanitize_error_message(result["error"])
        
        return result
        
    except Exception as e:
        logger.error(f"Unexpected error in select_query_tool: {e}")
        return {
            "success": False,
            "error": validator.sanitize_error_message(str(e))
        }

# Made with Bob
