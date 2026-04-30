"""Configuration settings for MCP Server"""
import os
from typing import List
from pydantic import BaseModel, Field


class DatabaseConfig(BaseModel):
    """Database connection configuration"""
    host: str = Field(default="localhost", description="MySQL host")
    port: int = Field(default=3306, description="MySQL port")
    database: str = Field(default="sevone_db", description="Database name")
    user: str = Field(default="sevone_user", description="Database user")
    password: str = Field(description="Database password")
    pool_size: int = Field(default=10, description="Connection pool size")
    connect_timeout: int = Field(default=10, description="Connection timeout in seconds")
    
    @classmethod
    def from_env(cls) -> "DatabaseConfig":
        """Create configuration from environment variables"""
        return cls(
            host=os.getenv("MYSQL_HOST", "localhost"),
            port=int(os.getenv("MYSQL_PORT", "3306")),
            database=os.getenv("MYSQL_DATABASE", "sevone_db"),
            user=os.getenv("MYSQL_USER", "sevone_user"),
            password=os.getenv("MYSQL_PASSWORD", ""),
            pool_size=int(os.getenv("MYSQL_POOL_SIZE", "10")),
            connect_timeout=int(os.getenv("MYSQL_CONNECT_TIMEOUT", "10"))
        )


class SecurityConfig(BaseModel):
    """Security configuration for query validation"""
    allowed_operations: List[str] = Field(
        default=["SELECT", "INSERT"],
        description="Allowed SQL operations"
    )
    max_query_length: int = Field(
        default=5000,
        description="Maximum query length in characters"
    )
    query_timeout: int = Field(
        default=30,
        description="Query execution timeout in seconds"
    )
    enable_query_logging: bool = Field(
        default=True,
        description="Enable query logging"
    )
    
    @classmethod
    def from_env(cls) -> "SecurityConfig":
        """Create configuration from environment variables"""
        return cls(
            allowed_operations=os.getenv("ALLOWED_OPERATIONS", "SELECT,INSERT").split(","),
            max_query_length=int(os.getenv("MAX_QUERY_LENGTH", "5000")),
            query_timeout=int(os.getenv("QUERY_TIMEOUT", "30")),
            enable_query_logging=os.getenv("ENABLE_QUERY_LOGGING", "true").lower() == "true"
        )

# Made with Bob
