"""Database command execution via TCP MySQL or Podman mysql client"""
import asyncio
import csv
import io
import logging
import time
from typing import Optional, Any, Dict, List

import aiomysql

from ..config.settings import DatabaseConfig

logger = logging.getLogger(__name__)


class DatabaseConnection:
    """Executes MySQL queries through TCP MySQL or podman exec and mysql CLI"""

    def __init__(self, config: DatabaseConfig):
        """Initialize database executor

        Args:
            config: Database configuration
        """
        self.config = config
        self._semaphore: Optional[asyncio.Semaphore] = None
        self._pool: Optional[aiomysql.Pool] = None

    async def initialize(self) -> None:
        """Initialize database execution controls"""
        self._semaphore = asyncio.Semaphore(self.config.max_concurrent_commands)

        if self.config.access_mode == "tcp":
            await self._initialize_tcp_pool()

        test_ok = await self.test_connection()
        if not test_ok:
            mode = "TCP MySQL" if self.config.access_mode == "tcp" else "podman mysql executor"
            raise RuntimeError(f"Failed to initialize {mode}")

        if self.config.access_mode == "tcp":
            logger.info(
                "Database executor initialized via TCP for %s:%s/%s",
                self.config.host,
                self.config.port,
                self.config.database,
            )
        else:
            logger.info(
                "Database executor initialized via podman exec for container %s and database %s",
                self.config.podman_container_name,
                self.config.database,
            )

    async def close(self) -> None:
        """Close executor resources"""
        if self._pool:
            self._pool.close()
            await self._pool.wait_closed()
            self._pool = None

        logger.info("Database executor closed")

    async def execute_select(
        self,
        query: str,
        parameters: Optional[List[Any]] = None,
        timeout: int = 30
    ) -> Dict[str, Any]:
        """Execute a SELECT query through configured backend"""
        if self.config.access_mode == "tcp":
            return await self._execute_select_tcp(query, parameters, timeout)

        return await self._execute_select_podman(query, parameters, timeout)

    async def execute_insert(
        self,
        query: str,
        parameters: List[Any],
        timeout: int = 30
    ) -> Dict[str, Any]:
        """Execute an INSERT query through configured backend"""
        if self.config.access_mode == "tcp":
            return await self._execute_insert_tcp(query, parameters, timeout)

        return await self._execute_insert_podman(query, parameters, timeout)

    async def test_connection(self) -> bool:
        """Test database access through configured backend"""
        try:
            if self.config.access_mode == "tcp":
                if not self._pool:
                    raise RuntimeError("TCP connection pool not initialized")

                async with self._pool.acquire() as conn:
                    async with conn.cursor() as cursor:
                        await cursor.execute("SELECT 1")
                        result = await cursor.fetchone()
                        return bool(result) and result[0] == 1

            stdout, _, columns = await self._execute_mysql_command(
                "SELECT 1 AS healthcheck;",
                timeout=self.config.command_timeout
            )
            rows = self._parse_tsv_rows(stdout, columns)
            return bool(rows) and rows[0].get("healthcheck") == "1"
        except Exception as e:
            logger.error("Connection test failed: %s", e)
            return False

    async def _initialize_tcp_pool(self) -> None:
        """Initialize TCP MySQL connection pool"""
        self._pool = await aiomysql.create_pool(
            host=self.config.host,
            port=self.config.port,
            user=self.config.user,
            password=self.config.password,
            db=self.config.database,
            minsize=1,
            maxsize=max(1, self.config.max_concurrent_commands),
            connect_timeout=self.config.command_timeout,
            autocommit=False,
        )

    async def _execute_select_tcp(
        self,
        query: str,
        parameters: Optional[List[Any]],
        timeout: int
    ) -> Dict[str, Any]:
        """Execute a SELECT query through aiomysql"""
        start_time = time.time()

        if not self._pool:
            return {
                "success": False,
                "error": "TCP connection pool not initialized"
            }

        try:
            async with self._pool.acquire() as conn:
                async with conn.cursor(aiomysql.DictCursor) as cursor:
                    await asyncio.wait_for(
                        cursor.execute(query, parameters or []),
                        timeout=min(timeout, self.config.command_timeout),
                    )
                    rows = await asyncio.wait_for(
                        cursor.fetchall(),
                        timeout=min(timeout, self.config.command_timeout),
                    )

                    execution_time = time.time() - start_time
                    return {
                        "success": True,
                        "rows": rows,
                        "row_count": len(rows),
                        "execution_time": round(execution_time, 3),
                        "columns": [desc[0] for desc in cursor.description] if cursor.description else []
                    }
        except aiomysql.Error as e:
            logger.error("Database error executing SELECT over TCP: %s", e)
            return {
                "success": False,
                "error": str(e),
                "error_code": e.args[0] if e.args else None
            }
        except asyncio.TimeoutError:
            logger.error("SELECT query timed out over TCP")
            return {
                "success": False,
                "error": "Query timed out"
            }
        except Exception as e:
            logger.error("Unexpected error executing SELECT over TCP: %s", e)
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }

    async def _execute_insert_tcp(
        self,
        query: str,
        parameters: List[Any],
        timeout: int
    ) -> Dict[str, Any]:
        """Execute an INSERT query through aiomysql"""
        if not parameters:
            return {
                "success": False,
                "error": "Parameters are required for INSERT queries"
            }

        if not self._pool:
            return {
                "success": False,
                "error": "TCP connection pool not initialized"
            }

        try:
            async with self._pool.acquire() as conn:
                async with conn.cursor() as cursor:
                    try:
                        await asyncio.wait_for(
                            cursor.execute(query, parameters),
                            timeout=min(timeout, self.config.command_timeout),
                        )
                        await conn.commit()

                        return {
                            "success": True,
                            "insert_id": cursor.lastrowid,
                            "affected_rows": cursor.rowcount
                        }
                    except Exception:
                        await conn.rollback()
                        raise
        except aiomysql.Error as e:
            logger.error("Database error executing INSERT over TCP: %s", e)
            return {
                "success": False,
                "error": str(e),
                "error_code": e.args[0] if e.args else None
            }
        except asyncio.TimeoutError:
            logger.error("INSERT query timed out over TCP")
            return {
                "success": False,
                "error": "Query timed out"
            }
        except Exception as e:
            logger.error("Unexpected error executing INSERT over TCP: %s", e)
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }

    async def _execute_select_podman(
        self,
        query: str,
        parameters: Optional[List[Any]],
        timeout: int
    ) -> Dict[str, Any]:
        """Execute a SELECT query through mysql CLI"""
        start_time = time.time()

        try:
            rendered_query = self._render_query(query, parameters or [])
            stdout, _, columns = await self._execute_mysql_command(
                rendered_query,
                timeout=timeout
            )
            rows = self._parse_tsv_rows(stdout, columns)

            execution_time = time.time() - start_time
            return {
                "success": True,
                "rows": rows,
                "row_count": len(rows),
                "execution_time": round(execution_time, 3),
                "columns": columns
            }
        except Exception as e:
            logger.error("Unexpected error executing SELECT via podman: %s", e)
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }

    async def _execute_insert_podman(
        self,
        query: str,
        parameters: List[Any],
        timeout: int
    ) -> Dict[str, Any]:
        """Execute an INSERT query with transaction support via mysql CLI"""
        if not parameters:
            return {
                "success": False,
                "error": "Parameters are required for INSERT queries"
            }

        try:
            rendered_query = self._render_query(query, parameters)
            sql = (
                "START TRANSACTION;\n"
                f"{rendered_query.rstrip(';')};\n"
                "SELECT ROW_COUNT() AS affected_rows, LAST_INSERT_ID() AS insert_id;\n"
                "COMMIT;\n"
            )

            stdout, _, columns = await self._execute_mysql_command(sql, timeout=timeout)
            rows = self._parse_tsv_rows(stdout, columns)

            if not rows:
                return {
                    "success": False,
                    "error": "INSERT query completed but no result metadata was returned"
                }

            metadata = rows[-1]
            return {
                "success": True,
                "insert_id": self._coerce_int(metadata.get("insert_id")),
                "affected_rows": self._coerce_int(metadata.get("affected_rows"), default=0)
            }
        except Exception as e:
            logger.error("Unexpected error executing INSERT via podman: %s", e)
            return {
                "success": False,
                "error": f"Unexpected error: {str(e)}"
            }

    async def _execute_mysql_command(
        self,
        sql: str,
        timeout: int
    ) -> tuple[str, str, List[str]]:
        """Execute SQL via podman exec mysql client"""
        if not self._semaphore:
            raise RuntimeError("Executor not initialized. Call initialize() first.")

        command = [
            self.config.podman_binary,
            "exec",
            "-i",
            self.config.podman_container_name,
            self.config.mysql_client_path,
        ]

        if self.config.mysql_defaults_file:
            command.append(f"--defaults-extra-file={self.config.mysql_defaults_file}")

        command.extend([
            "--batch",
            "--raw",
            self.config.database,
        ])

        async with self._semaphore:
            process = await asyncio.create_subprocess_exec(
                *command,
                stdin=asyncio.subprocess.PIPE,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
            )

            try:
                stdout_bytes, stderr_bytes = await asyncio.wait_for(
                    process.communicate(sql.encode("utf-8")),
                    timeout=min(timeout, self.config.command_timeout),
                )
            except asyncio.TimeoutError:
                process.kill()
                await process.wait()
                raise RuntimeError("MySQL command timed out")

        stdout = stdout_bytes.decode("utf-8", errors="replace")
        stderr = stderr_bytes.decode("utf-8", errors="replace")

        if process.returncode != 0:
            raise RuntimeError(
                f"MySQL command failed with exit code {process.returncode}: {stderr.strip() or stdout.strip()}"
            )

        lines = [line for line in stdout.splitlines() if line.strip()]
        if not lines:
            return stdout, stderr, []

        header_reader = csv.reader([lines[0]], delimiter="\t")
        columns = next(header_reader, [])
        data = "\n".join(lines[1:])
        return data, stderr, columns

    def _parse_tsv_rows(self, stdout: str, columns: List[str]) -> List[Dict[str, Any]]:
        """Parse mysql batch output into row dictionaries"""
        if not columns:
            return []

        if not stdout.strip():
            return []

        reader = csv.reader(io.StringIO(stdout), delimiter="\t")
        rows: List[Dict[str, Any]] = []

        for raw_row in reader:
            padded_row = list(raw_row[:len(columns)]) + [""] * max(0, len(columns) - len(raw_row))
            rows.append({
                column: value if value != "NULL" else None
                for column, value in zip(columns, padded_row)
            })

        return rows

    def _render_query(self, query: str, parameters: List[Any]) -> str:
        """Safely render a parameterized query for mysql CLI execution"""
        rendered = query
        placeholder_count = rendered.count("%s") + rendered.count("?")

        if placeholder_count != len(parameters):
            raise ValueError(
                f"Expected {placeholder_count} parameters but received {len(parameters)}"
            )

        for parameter in parameters:
            escaped = self._escape_sql_value(parameter)
            if "%s" in rendered:
                rendered = rendered.replace("%s", escaped, 1)
            else:
                rendered = rendered.replace("?", escaped, 1)

        return rendered

    def _escape_sql_value(self, value: Any) -> str:
        """Escape a Python value as a SQL literal"""
        if value is None:
            return "NULL"

        if isinstance(value, bool):
            return "1" if value else "0"

        if isinstance(value, (int, float)):
            return str(value)

        if isinstance(value, str):
            escaped = (
                value.replace("\\", "\\\\")
                .replace("'", "\\'")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
            )
            return f"'{escaped}'"

        raise TypeError(f"Unsupported parameter type: {type(value).__name__}")

    def _coerce_int(self, value: Any, default: Optional[int] = None) -> Optional[int]:
        """Coerce value to int when possible"""
        if value is None or value == "":
            return default
        return int(value)

# Made with Bob
