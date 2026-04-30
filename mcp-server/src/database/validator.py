"""Query validation for security and safety"""
import re
import logging
from typing import Optional, Dict, Any

from ..config.settings import SecurityConfig

logger = logging.getLogger(__name__)


class QueryValidator:
    """Validates SQL queries for security and safety"""
    
    def __init__(self, config: SecurityConfig):
        """Initialize query validator
        
        Args:
            config: Security configuration
        """
        self.config = config
        
        # Dangerous SQL patterns to block
        self.dangerous_patterns = [
            r'\bDROP\b',
            r'\bTRUNCATE\b',
            r'\bDELETE\b.*\bFROM\b(?!\s+WHERE)',  # DELETE without WHERE
            r'\bUPDATE\b.*\bSET\b(?!\s+.*WHERE)',  # UPDATE without WHERE
            r'\bALTER\b',
            r'\bCREATE\b',
            r'\bGRANT\b',
            r'\bREVOKE\b',
            r';\s*DROP',  # SQL injection attempt
            r'--',  # SQL comments (potential injection)
            r'/\*.*\*/',  # Multi-line comments
        ]
        
    def validate_query(self, query: str, operation_type: str) -> Dict[str, Any]:
        """Validate a SQL query
        
        Args:
            query: SQL query to validate
            operation_type: Expected operation type (SELECT or INSERT)
            
        Returns:
            Dictionary with validation result
        """
        # Check query length
        if len(query) > self.config.max_query_length:
            return {
                "valid": False,
                "error": f"Query exceeds maximum length of {self.config.max_query_length} characters"
            }
        
        # Check if query is empty
        if not query.strip():
            return {
                "valid": False,
                "error": "Query cannot be empty"
            }
        
        # Normalize query for checking
        normalized_query = query.upper().strip()
        
        # Check if operation is allowed
        if operation_type.upper() not in self.config.allowed_operations:
            return {
                "valid": False,
                "error": f"Operation {operation_type} is not allowed"
            }
        
        # Validate operation type matches query
        if operation_type.upper() == "SELECT":
            if not normalized_query.startswith("SELECT"):
                return {
                    "valid": False,
                    "error": "Query must start with SELECT for select_query operation"
                }
        elif operation_type.upper() == "INSERT":
            if not normalized_query.startswith("INSERT"):
                return {
                    "valid": False,
                    "error": "Query must start with INSERT for insert_query operation"
                }
        
        # Check for dangerous patterns
        for pattern in self.dangerous_patterns:
            if re.search(pattern, normalized_query, re.IGNORECASE):
                return {
                    "valid": False,
                    "error": f"Query contains potentially dangerous pattern: {pattern}"
                }
        
        # Check for multiple statements (SQL injection prevention)
        if ';' in query.rstrip(';'):
            return {
                "valid": False,
                "error": "Multiple SQL statements are not allowed"
            }
        
        return {
            "valid": True,
            "message": "Query validation passed"
        }
    
    def validate_parameters(self, parameters: Optional[list], required: bool = False) -> Dict[str, Any]:
        """Validate query parameters
        
        Args:
            parameters: List of parameters
            required: Whether parameters are required
            
        Returns:
            Dictionary with validation result
        """
        if required and not parameters:
            return {
                "valid": False,
                "error": "Parameters are required for this operation"
            }
        
        if parameters is not None:
            if not isinstance(parameters, list):
                return {
                    "valid": False,
                    "error": "Parameters must be a list"
                }
            
            # Check for None values (potential SQL injection)
            if None in parameters:
                return {
                    "valid": False,
                    "error": "Parameters cannot contain None values"
                }
        
        return {
            "valid": True,
            "message": "Parameters validation passed"
        }
    
    def sanitize_error_message(self, error: str) -> str:
        """Sanitize error messages to prevent information leakage
        
        Args:
            error: Original error message
            
        Returns:
            Sanitized error message
        """
        # Remove sensitive information from error messages
        sanitized = error
        
        # Remove connection strings
        sanitized = re.sub(r'host=[\w\.-]+', 'host=***', sanitized)
        sanitized = re.sub(r'password=[\w\.-]+', 'password=***', sanitized)
        sanitized = re.sub(r'user=[\w\.-]+', 'user=***', sanitized)
        
        # Remove file paths
        sanitized = re.sub(r'/[\w/\.-]+', '/***', sanitized)
        sanitized = re.sub(r'[A-Z]:\\[\w\\\.-]+', 'C:\\***', sanitized)
        
        return sanitized

# Made with Bob
