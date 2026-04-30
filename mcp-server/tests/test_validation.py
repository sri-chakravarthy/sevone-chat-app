"""Tests for query validation"""
import pytest

from src.database.validator import QueryValidator
from src.config.settings import SecurityConfig


@pytest.fixture
def validator():
    """Create query validator with default config"""
    config = SecurityConfig()
    return QueryValidator(config)


class TestQueryValidation:
    """Tests for query validation"""
    
    def test_valid_select_query(self, validator):
        """Test valid SELECT query"""
        result = validator.validate_query(
            "SELECT * FROM devices WHERE id = 1",
            "SELECT"
        )
        assert result["valid"] is True
    
    def test_valid_insert_query(self, validator):
        """Test valid INSERT query"""
        result = validator.validate_query(
            "INSERT INTO devices (name, ip) VALUES (%s, %s)",
            "INSERT"
        )
        assert result["valid"] is True
    
    def test_query_with_drop(self, validator):
        """Test query containing DROP (should fail)"""
        result = validator.validate_query(
            "SELECT * FROM devices; DROP TABLE devices;",
            "SELECT"
        )
        assert result["valid"] is False
        assert "dangerous" in result["error"].lower()
    
    def test_query_with_delete_no_where(self, validator):
        """Test DELETE without WHERE (should fail)"""
        result = validator.validate_query(
            "DELETE FROM devices",
            "DELETE"
        )
        assert result["valid"] is False
    
    def test_query_with_sql_comment(self, validator):
        """Test query with SQL comment (should fail)"""
        result = validator.validate_query(
            "SELECT * FROM devices -- comment",
            "SELECT"
        )
        assert result["valid"] is False
    
    def test_multiple_statements(self, validator):
        """Test multiple SQL statements (should fail)"""
        result = validator.validate_query(
            "SELECT * FROM devices; SELECT * FROM users;",
            "SELECT"
        )
        assert result["valid"] is False
        assert "multiple" in result["error"].lower()
    
    def test_empty_query(self, validator):
        """Test empty query (should fail)"""
        result = validator.validate_query("", "SELECT")
        assert result["valid"] is False
        assert "empty" in result["error"].lower()
    
    def test_query_too_long(self, validator):
        """Test query exceeding max length (should fail)"""
        long_query = "SELECT * FROM devices WHERE " + " OR ".join([f"id = {i}" for i in range(1000)])
        result = validator.validate_query(long_query, "SELECT")
        assert result["valid"] is False
        assert "length" in result["error"].lower()
    
    def test_wrong_operation_type(self, validator):
        """Test query with wrong operation type (should fail)"""
        result = validator.validate_query(
            "INSERT INTO devices VALUES (1, 'test')",
            "SELECT"
        )
        assert result["valid"] is False
        assert "SELECT" in result["error"]
    
    def test_disallowed_operation(self, validator):
        """Test disallowed operation (should fail)"""
        result = validator.validate_query(
            "UPDATE devices SET name = 'test'",
            "UPDATE"
        )
        assert result["valid"] is False
        assert "not allowed" in result["error"].lower()


class TestParameterValidation:
    """Tests for parameter validation"""
    
    def test_valid_parameters(self, validator):
        """Test valid parameters"""
        result = validator.validate_parameters(["value1", "value2"], required=False)
        assert result["valid"] is True
    
    def test_required_parameters_missing(self, validator):
        """Test required parameters missing (should fail)"""
        result = validator.validate_parameters(None, required=True)
        assert result["valid"] is False
        assert "required" in result["error"].lower()
    
    def test_parameters_not_list(self, validator):
        """Test parameters not a list (should fail)"""
        result = validator.validate_parameters("not a list", required=False)
        assert result["valid"] is False
        assert "list" in result["error"].lower()
    
    def test_parameters_with_none(self, validator):
        """Test parameters containing None (should fail)"""
        result = validator.validate_parameters(["value1", None, "value2"], required=False)
        assert result["valid"] is False
        assert "None" in result["error"]
    
    def test_empty_parameters_not_required(self, validator):
        """Test empty parameters when not required"""
        result = validator.validate_parameters([], required=False)
        assert result["valid"] is True


class TestErrorSanitization:
    """Tests for error message sanitization"""
    
    def test_sanitize_host(self, validator):
        """Test sanitization of host information"""
        error = "Connection failed to host=192.168.1.100"
        sanitized = validator.sanitize_error_message(error)
        assert "192.168.1.100" not in sanitized
        assert "***" in sanitized
    
    def test_sanitize_password(self, validator):
        """Test sanitization of password information"""
        error = "Authentication failed with password=secret123"
        sanitized = validator.sanitize_error_message(error)
        assert "secret123" not in sanitized
        assert "***" in sanitized
    
    def test_sanitize_user(self, validator):
        """Test sanitization of user information"""
        error = "Access denied for user=admin"
        sanitized = validator.sanitize_error_message(error)
        assert "admin" not in sanitized
        assert "***" in sanitized
    
    def test_sanitize_file_path_unix(self, validator):
        """Test sanitization of Unix file paths"""
        error = "Error reading /home/user/config.ini"
        sanitized = validator.sanitize_error_message(error)
        assert "/home/user/config.ini" not in sanitized
        assert "***" in sanitized
    
    def test_sanitize_file_path_windows(self, validator):
        """Test sanitization of Windows file paths"""
        error = "Error reading C:\\Users\\admin\\config.ini"
        sanitized = validator.sanitize_error_message(error)
        assert "C:\\Users\\admin\\config.ini" not in sanitized
        assert "***" in sanitized

# Made with Bob
