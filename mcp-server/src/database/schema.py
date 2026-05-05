"""Database schema extraction utilities"""
import logging
from typing import Dict, List, Any, Optional

from .connection import DatabaseConnection

logger = logging.getLogger(__name__)


class SchemaExtractor:
    """Extracts and formats database schema information"""

    def __init__(self, db_connection: DatabaseConnection):
        """Initialize schema extractor

        Args:
            db_connection: Database connection instance
        """
        self.db = db_connection
        self._schema_cache: Optional[Dict[str, Any]] = None

    async def get_schema(self, refresh: bool = False) -> Dict[str, Any]:
        """Get complete database schema

        Args:
            refresh: Force refresh of cached schema

        Returns:
            Dictionary containing schema information
        """
        if self._schema_cache and not refresh:
            return self._schema_cache

        try:
            schema = {
                "database": self.db.config.database,
                "tables": await self._get_tables(),
                "relationships": await self._get_relationships()
            }

            self._schema_cache = schema
            return schema
        except Exception as e:
            logger.error("Failed to extract schema: %s", e)
            return {
                "database": self.db.config.database,
                "tables": [],
                "relationships": [],
                "error": str(e)
            }

    async def _get_tables(self) -> List[Dict[str, Any]]:
        """Get all tables with their columns"""
        tables = []

        query = """
            SELECT TABLE_NAME, TABLE_TYPE, TABLE_COMMENT
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = %s
            ORDER BY TABLE_NAME
        """

        result = await self.db.execute_select(query, [self.db.config.database])

        if not result.get("success"):
            return tables

        for table_row in result.get("rows", []):
            table_name = table_row["TABLE_NAME"]

            columns = await self._get_columns(table_name)
            indexes = await self._get_indexes(table_name)

            tables.append({
                "name": table_name,
                "type": table_row["TABLE_TYPE"],
                "comment": table_row["TABLE_COMMENT"],
                "columns": columns,
                "indexes": indexes
            })

        return tables

    async def _get_columns(self, table_name: str) -> List[Dict[str, Any]]:
        """Get columns for a specific table"""
        query = """
            SELECT
                COLUMN_NAME,
                DATA_TYPE,
                COLUMN_TYPE,
                IS_NULLABLE,
                COLUMN_KEY,
                COLUMN_DEFAULT,
                EXTRA,
                COLUMN_COMMENT
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
            ORDER BY ORDINAL_POSITION
        """

        result = await self.db.execute_select(query, [self.db.config.database, table_name])

        if not result.get("success"):
            return []

        columns = []
        for col in result.get("rows", []):
            columns.append({
                "name": col["COLUMN_NAME"],
                "data_type": col["DATA_TYPE"],
                "column_type": col["COLUMN_TYPE"],
                "nullable": col["IS_NULLABLE"] == "YES",
                "key": col["COLUMN_KEY"],
                "default": col["COLUMN_DEFAULT"],
                "extra": col["EXTRA"],
                "comment": col["COLUMN_COMMENT"]
            })

        return columns

    async def _get_indexes(self, table_name: str) -> List[Dict[str, Any]]:
        """Get indexes for a specific table"""
        query = """
            SELECT
                INDEX_NAME,
                COLUMN_NAME,
                NON_UNIQUE,
                SEQ_IN_INDEX
            FROM information_schema.STATISTICS
            WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s
            ORDER BY INDEX_NAME, SEQ_IN_INDEX
        """

        result = await self.db.execute_select(query, [self.db.config.database, table_name])

        if not result.get("success"):
            return []

        indexes_dict: Dict[str, Dict[str, Any]] = {}
        for row in result.get("rows", []):
            index_name = row["INDEX_NAME"]
            if index_name not in indexes_dict:
                indexes_dict[index_name] = {
                    "name": index_name,
                    "unique": str(row["NON_UNIQUE"]) == "0",
                    "columns": []
                }
            indexes_dict[index_name]["columns"].append(row["COLUMN_NAME"])

        return list(indexes_dict.values())

    async def _get_relationships(self) -> List[Dict[str, Any]]:
        """Get foreign key relationships"""
        query = """
            SELECT
                TABLE_NAME,
                COLUMN_NAME,
                CONSTRAINT_NAME,
                REFERENCED_TABLE_NAME,
                REFERENCED_COLUMN_NAME
            FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = %s
                AND REFERENCED_TABLE_NAME IS NOT NULL
            ORDER BY TABLE_NAME, CONSTRAINT_NAME
        """

        result = await self.db.execute_select(query, [self.db.config.database])

        if not result.get("success"):
            return []

        relationships = []
        for row in result.get("rows", []):
            relationships.append({
                "table": row["TABLE_NAME"],
                "column": row["COLUMN_NAME"],
                "constraint": row["CONSTRAINT_NAME"],
                "referenced_table": row["REFERENCED_TABLE_NAME"],
                "referenced_column": row["REFERENCED_COLUMN_NAME"]
            })

        return relationships

    def format_schema_for_prompt(self, schema: Dict[str, Any]) -> str:
        """Format schema information for AI prompt"""
        lines = [f"DATABASE: {schema['database']}\n"]

        for table in schema.get("tables", []):
            lines.append(f"\nTABLE: {table['name']}")
            if table.get("comment"):
                lines.append(f"  Description: {table['comment']}")

            lines.append("  Columns:")
            for col in table.get("columns", []):
                nullable = "NULL" if col["nullable"] else "NOT NULL"
                key_info = f" [{col['key']}]" if col['key'] else ""
                extra_info = f" {col['extra']}" if col['extra'] else ""
                lines.append(f"    - {col['name']}: {col['column_type']} {nullable}{key_info}{extra_info}")
                if col.get("comment"):
                    lines.append(f"      Comment: {col['comment']}")

            if table.get("indexes"):
                lines.append("  Indexes:")
                for idx in table["indexes"]:
                    unique = "UNIQUE" if idx["unique"] else "INDEX"
                    cols = ", ".join(idx["columns"])
                    lines.append(f"    - {idx['name']} ({unique}): {cols}")

        if schema.get("relationships"):
            lines.append("\nRELATIONSHIPS:")
            for rel in schema["relationships"]:
                lines.append(
                    f"  - {rel['table']}.{rel['column']} -> "
                    f"{rel['referenced_table']}.{rel['referenced_column']}"
                )

        return "\n".join(lines)

# Made with Bob
