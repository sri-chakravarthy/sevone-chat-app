# SevOne MySQL MCP Server

MCP (Model Context Protocol) Server for secure MySQL database access for the SevOne monitoring system.

## Features

- **Secure Database Access**: Read-only SELECT and controlled INSERT operations
- **Query Validation**: Comprehensive SQL injection prevention and query validation
- **Connection Pooling**: Efficient database connection management
- **Schema Extraction**: Automatic database schema discovery and formatting
- **Parameterized Queries**: Mandatory for INSERT operations to prevent SQL injection
- **Error Handling**: Sanitized error messages to prevent information leakage

## Installation

### Prerequisites

- Python 3.11 or higher
- MySQL 5.7+ or MariaDB 10.3+
- Access to SevOne MySQL database

### Install Dependencies

```bash
cd mcp-server
pip install -r requirements.txt
```

Or using the project file:

```bash
pip install -e .
```

## Configuration

### Environment Variables

Create a `.env` file in the `mcp-server` directory:

```bash
# MySQL Database Configuration
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=sevone_db
MYSQL_USER=sevone_user
MYSQL_PASSWORD=your_secure_password
MYSQL_POOL_SIZE=10
MYSQL_CONNECT_TIMEOUT=10

# Security Configuration
ALLOWED_OPERATIONS=SELECT,INSERT
MAX_QUERY_LENGTH=5000
QUERY_TIMEOUT=30
ENABLE_QUERY_LOGGING=true
```

### Bob AI Configuration

Add the MCP server to your Bob configuration file (`bob_config.json`):

```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "mcp_server.src.server"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_DATABASE": "sevone_db",
        "MYSQL_USER": "sevone_user",
        "MYSQL_PASSWORD": "your_password"
      }
    }
  }
}
```

## Usage

### Running the MCP Server

```bash
cd mcp-server
python -m src.server
```

### Available Tools

#### 1. select_query

Execute SELECT queries on the database.

**Parameters:**
- `query` (string, required): SQL SELECT query
- `parameters` (array, optional): Parameterized query values

**Example:**
```python
{
  "query": "SELECT * FROM devices WHERE device_name = %s",
  "parameters": ["Router-01"]
}
```

#### 2. insert_query

Execute INSERT queries on the database.

**Parameters:**
- `query` (string, required): SQL INSERT query with placeholders
- `parameters` (array, required): Parameterized query values

**Example:**
```python
{
  "query": "INSERT INTO devices (device_name, ip_address) VALUES (%s, %s)",
  "parameters": ["Router-01", "192.168.1.1"]
}
```

#### 3. get_schema

Retrieve the complete database schema.

**Parameters:**
- `refresh` (boolean, optional): Force refresh of cached schema

**Example:**
```python
{
  "refresh": false
}
```

## Security Features

### Query Validation

- Only SELECT and INSERT operations allowed
- Blocks dangerous SQL patterns (DROP, DELETE, TRUNCATE, etc.)
- Prevents SQL injection through parameterized queries
- Validates query length and structure

### Connection Security

- Connection pooling with configurable limits
- Query timeout protection
- Automatic connection recycling
- Secure credential management via environment variables

### Error Handling

- Sanitized error messages
- No sensitive information in logs
- Graceful error recovery
- Transaction rollback on INSERT failures

## Testing

Run the test suite:

```bash
cd mcp-server
pytest tests/ -v
```

Run with coverage:

```bash
pytest tests/ --cov=src --cov-report=html
```

## Development

### Code Formatting

```bash
black src/ tests/
```

### Linting

```bash
ruff check src/ tests/
```

### Type Checking

```bash
mypy src/
```

## Project Structure

```
mcp-server/
├── src/
│   ├── __init__.py
│   ├── server.py              # MCP server entry point
│   ├── config/
│   │   ├── __init__.py
│   │   └── settings.py        # Configuration models
│   ├── database/
│   │   ├── __init__.py
│   │   ├── connection.py      # Database connection pool
│   │   ├── validator.py       # Query validation
│   │   └── schema.py          # Schema extraction
│   └── tools/
│       ├── __init__.py
│       ├── select_query.py    # SELECT tool
│       └── insert_query.py    # INSERT tool
├── tests/
│   ├── test_tools.py
│   └── test_validation.py
├── pyproject.toml
├── requirements.txt
└── README.md
```

## Troubleshooting

### Connection Issues

1. Verify MySQL is running: `mysql -h localhost -u sevone_user -p`
2. Check firewall settings
3. Verify credentials in `.env` file
4. Check MySQL user permissions

### Query Validation Errors

- Ensure queries start with SELECT or INSERT
- Use parameterized queries for INSERT operations
- Avoid SQL comments (--) in queries
- Check query length limits

### Performance Issues

- Adjust `MYSQL_POOL_SIZE` for concurrent connections
- Increase `QUERY_TIMEOUT` for complex queries
- Use indexes on frequently queried columns
- Monitor connection pool usage

## License

Copyright © 2024 SevOne. All rights reserved.

## Support

For issues and questions, please contact the SevOne development team.