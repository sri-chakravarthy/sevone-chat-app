"""Database connection management with connection pooling"""
import logging
from typing import Optional, Any, Dict, List
from contextlib import asynccontextmanager
import aiomysql
from aiomysql import Pool

from ..config.settings import DatabaseConfig

logger = logging.getLogger(__name__)


class DatabaseConnection:
    """Manages MySQL database connections with pooling"""
    
    def __init__(self, config: DatabaseConfig):
        """Initialize database connection manager
        
        Args:
            config: Database configuration
        """
        self.config = config
        self._pool: Optional[Pool] = None
        
    async def initialize(self) -> None:
        """Initialize the connection pool"""
        try:
            self._pool = await aiomysql.create_pool(
                host=self.config.host,
                port=self.config.port,
                user=self.config.user,
                password=self.config.password,
                db=self.config.database,
                minsize=1,
                maxsize=self.config.pool_size,
                connect_timeout=self.config.connect_timeout,
                autocommit=False
            )
            logger.info(f"Database connection pool initialized: {self.config.host}:{self.config.port}/{self.config.database}")
        except Exception as e:
            logger.error(f"Failed to initialize database connection pool: {e}")
            raise
    
    async def close(self) -> None:
        """Close the connection pool"""
        if self._pool:
            self._pool.close()
            await self._pool.wait_closed()
            logger.info("Database connection pool closed")
    
    @asynccontextmanager
    async def get_connection(self):
        """Get a connection from the pool
        
        Yields:
            Database connection
        """
        if not self._pool:
            raise RuntimeError("Connection pool not initialized. Call initialize() first.")
        
        async with self._pool.acquire() as conn:
            yield conn
    
    async def execute_select(
        self,
        query: str,
        parameters: Optional[List[Any]] = None,
        timeout: int = 30
    ) -> Dict[str, Any]:
        """Execute a SELECT query
        
        Args:
            query: SQL SELECT query
            parameters: Query parameters for parameterized queries
            timeout: Query timeout in seconds
            
        Returns:
            Dictionary with query results
        """
        import time
        start_time = time.time()
        
        try:
            async with self.get_connection() as conn:
                async with conn.cursor(aiomysql.DictCursor) as cursor:
                    await cursor.execute(query, parameters or [])
                    rows = await cursor.fetchall()
                    
                    execution_time = time.time() - start_time
                    
                    return {
                        "success": True,
                        "rows": rows,
                        "row_count": len(rows),
                        "execution_time": round(execution_time, 3),
                        "columns": [desc[0] for desc in cursor.description] if cursor.description else []
                    }
        except aiomysql.Error as e:
            logger.error(f"Database error executing SELECT: {e}")
            return {
                "success": False,
                "error": str(e),
                "error_code": e.args[0] if e.args else None
            }
        except Exception as e:
            logger.error(f"Unexpected error executing SELECT: {e}")
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }
    
    async def execute_insert(
        self,
        query: str,
        parameters: List[Any],
        timeout: int = 30
    ) -> Dict[str, Any]:
        """Execute an INSERT query with transaction support
        
        Args:
            query: SQL INSERT query
            parameters: Query parameters (required for safety)
            timeout: Query timeout in seconds
            
        Returns:
            Dictionary with insert results
        """
        if not parameters:
            return {
                "success": False,
                "error": "Parameters are required for INSERT queries"
            }
        
        try:
            async with self.get_connection() as conn:
                async with conn.cursor() as cursor:
                    try:
                        await cursor.execute(query, parameters)
                        await conn.commit()
                        
                        return {
                            "success": True,
                            "insert_id": cursor.lastrowid,
                            "affected_rows": cursor.rowcount
                        }
                    except Exception as e:
                        await conn.rollback()
                        raise
        except aiomysql.Error as e:
            logger.error(f"Database error executing INSERT: {e}")
            return {
                "success": False,
                "error": str(e),
                "error_code": e.args[0] if e.args else None
            }
        except Exception as e:
            logger.error(f"Unexpected error executing INSERT: {e}")
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }
    
    async def test_connection(self) -> bool:
        """Test database connection
        
        Returns:
            True if connection is successful, False otherwise
        """
        try:
            async with self.get_connection() as conn:
                async with conn.cursor() as cursor:
                    await cursor.execute("SELECT 1")
                    result = await cursor.fetchone()
                    return result[0] == 1
        except Exception as e:
            logger.error(f"Connection test failed: {e}")
            return False

# Made with Bob
