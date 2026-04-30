"""Tests for MCP tools"""
import pytest
from unittest.mock import AsyncMock, MagicMock

from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.config.settings import DatabaseConfig, SecurityConfig
from src.tools.select_query import select_query_tool
from src.tools.insert_query import insert_query_tool


@pytest.fixture
def db_config():
    """Create test database configuration"""
    return DatabaseConfig(
        host="localhost",
        port=3306,
        database="test_db",
        user="test_user",
        password="test_pass"
    )


@pytest.fixture
def security_config():
    """Create test security configuration"""
    return SecurityConfig()


@pytest.fixture
def mock_db_connection(db_config):
    """Create mock database connection"""
    conn = MagicMock(spec=DatabaseConnection)
    conn.config = db_config
    return conn


@pytest.fixture
def validator(security_config):
    """Create query validator"""
    return QueryValidator(security_config)


class TestSelectQueryTool:
    """Tests for select_query tool"""
    
    @pytest.mark.asyncio
    async def test_valid_select_query(self, mock_db_connection, validator):
        """Test valid SELECT query execution"""
        # Mock successful query execution
        mock_db_connection.execute_select = AsyncMock(return_value={
            "success": True,
            "rows": [{"id": 1, "name": "Test"}],
            "row_count": 1,
            "execution_time": 0.05,
            "columns": ["id", "name"]
        })
        
        result = await select_query_tool(
            mock_db_connection,
            validator,
            "SELECT * FROM devices",
            None
        )
        
        assert result["success"] is True
        assert result["row_count"] == 1
        assert len(result["rows"]) == 1
    
    @pytest.mark.asyncio
    async def test_select_with_parameters(self, mock_db_connection, validator):
        """Test SELECT query with parameters"""
        mock_db_connection.execute_select = AsyncMock(return_value={
            "success": True,
            "rows": [{"id": 1, "name": "Router-01"}],
            "row_count": 1,
            "execution_time": 0.05,
            "columns": ["id", "name"]
        })
        
        result = await select_query_tool(
            mock_db_connection,
            validator,
            "SELECT * FROM devices WHERE name = %s",
            ["Router-01"]
        )
        
        assert result["success"] is True
        assert result["rows"][0]["name"] == "Router-01"
    
    @pytest.mark.asyncio
    async def test_invalid_select_query(self, mock_db_connection, validator):
        """Test invalid SELECT query (contains DROP)"""
        result = await select_query_tool(
            mock_db_connection,
            validator,
            "SELECT * FROM devices; DROP TABLE devices;",
            None
        )
        
        assert result["success"] is False
        assert "error" in result
    
    @pytest.mark.asyncio
    async def test_non_select_query(self, mock_db_connection, validator):
        """Test non-SELECT query rejection"""
        result = await select_query_tool(
            mock_db_connection,
            validator,
            "INSERT INTO devices VALUES (1, 'test')",
            None
        )
        
        assert result["success"] is False
        assert "SELECT" in result["error"]


class TestInsertQueryTool:
    """Tests for insert_query tool"""
    
    @pytest.mark.asyncio
    async def test_valid_insert_query(self, mock_db_connection, validator):
        """Test valid INSERT query execution"""
        mock_db_connection.execute_insert = AsyncMock(return_value={
            "success": True,
            "insert_id": 123,
            "affected_rows": 1
        })
        
        result = await insert_query_tool(
            mock_db_connection,
            validator,
            "INSERT INTO devices (name, ip) VALUES (%s, %s)",
            ["Router-01", "192.168.1.1"]
        )
        
        assert result["success"] is True
        assert result["insert_id"] == 123
        assert result["affected_rows"] == 1
    
    @pytest.mark.asyncio
    async def test_insert_without_parameters(self, mock_db_connection, validator):
        """Test INSERT query without parameters (should fail)"""
        result = await insert_query_tool(
            mock_db_connection,
            validator,
            "INSERT INTO devices (name) VALUES ('test')",
            []
        )
        
        assert result["success"] is False
        assert "required" in result["error"].lower()
    
    @pytest.mark.asyncio
    async def test_insert_without_placeholders(self, mock_db_connection, validator):
        """Test INSERT query without placeholders (should fail)"""
        result = await insert_query_tool(
            mock_db_connection,
            validator,
            "INSERT INTO devices (name) VALUES ('test')",
            ["test"]
        )
        
        assert result["success"] is False
        assert "placeholder" in result["error"].lower()
    
    @pytest.mark.asyncio
    async def test_non_insert_query(self, mock_db_connection, validator):
        """Test non-INSERT query rejection"""
        result = await insert_query_tool(
            mock_db_connection,
            validator,
            "SELECT * FROM devices",
            ["test"]
        )
        
        assert result["success"] is False
        assert "INSERT" in result["error"]
    
    @pytest.mark.asyncio
    async def test_dangerous_insert_query(self, mock_db_connection, validator):
        """Test dangerous INSERT query (contains DROP)"""
        result = await insert_query_tool(
            mock_db_connection,
            validator,
            "INSERT INTO devices VALUES (%s); DROP TABLE devices;",
            ["test"]
        )
        
        assert result["success"] is False
        assert "error" in result

# Made with Bob
