"""Configuration settings for MCP Server"""
import os
from typing import List, Literal, cast
from pydantic import BaseModel, Field


class DatabaseConfig(BaseModel):
    """Database execution configuration"""

    access_mode: Literal["podman_exec", "tcp"] = Field(
        default="tcp",
        description="Database access mode"
    )
    database: str = Field(default="sevone_db", description="Database name")

    # TCP mode settings
    host: str = Field(default="localhost", description="MySQL host")
    port: int = Field(default=3306, description="MySQL port")
    user: str = Field(default="sevone_user", description="MySQL user")
    password: str = Field(default="", description="MySQL password")

    # Podman mode settings
    podman_binary: str = Field(default="podman", description="Path to podman binary")
    podman_container_name: str = Field(
        default="nms-nms-nms",
        description="Podman container name hosting mysql client access"
    )
    mysql_client_path: str = Field(
        default="/usr/bin/mysql",
        description="Path to mysql client inside container"
    )
    mysql_defaults_file: str | None = Field(
        default=None,
        description="Optional mysql defaults file path available inside container"
    )

    # Shared execution settings
    command_timeout: int = Field(default=30, description="Query command timeout in seconds")
    max_concurrent_commands: int = Field(
        default=5,
        description="Maximum concurrent podman exec operations"
    )

    @classmethod
    def from_env(cls) -> "DatabaseConfig":
        """Create configuration from environment variables"""
        access_mode = cast(
            Literal["podman_exec", "tcp"],
            os.getenv("DB_ACCESS_MODE", "tcp")
        )

        return cls(
            access_mode=access_mode,
            database=os.getenv("MYSQL_DATABASE", "sevone_db"),
            host=os.getenv("MYSQL_HOST", "localhost"),
            port=int(os.getenv("MYSQL_PORT", "3306")),
            user=os.getenv("MYSQL_USER", "sevone_user"),
            password=os.getenv("MYSQL_PASSWORD", ""),
            podman_binary=os.getenv("PODMAN_BINARY", "podman"),
            podman_container_name=os.getenv("PODMAN_CONTAINER_NAME", "nms-nms-nms"),
            mysql_client_path=os.getenv("MYSQL_CLIENT_PATH", "/usr/bin/mysql"),
            mysql_defaults_file=os.getenv("MYSQL_DEFAULTS_FILE"),
            command_timeout=int(os.getenv("DB_COMMAND_TIMEOUT", "30")),
            max_concurrent_commands=int(os.getenv("DB_MAX_CONCURRENT_COMMANDS", "5"))
        )


class ServerConfig(BaseModel):
    """HTTP/SSE server configuration."""

    host: str = Field(default="0.0.0.0", description="Bind host for the MCP HTTP server")
    port: int = Field(default=8000, description="Bind port for the MCP HTTP server")
    sse_endpoint: str = Field(default="/sse", description="SSE connection endpoint")
    message_endpoint: str = Field(
        default="/messages",
        description="HTTP POST endpoint used by MCP clients for sending messages"
    )
    log_level: str = Field(default="INFO", description="Application log level")

    @classmethod
    def from_env(cls) -> "ServerConfig":
        """Create configuration from environment variables."""
        return cls(
            host=os.getenv("MCP_SERVER_HOST", "0.0.0.0"),
            port=int(os.getenv("MCP_SERVER_PORT", "8000")),
            sse_endpoint=os.getenv("MCP_SSE_ENDPOINT", "/sse"),
            message_endpoint=os.getenv("MCP_MESSAGE_ENDPOINT", "/messages"),
            log_level=os.getenv("LOG_LEVEL", "INFO"),
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
