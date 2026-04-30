# Manual Testing Guide for MCP Server

This guide provides step-by-step instructions for manually testing the MCP server.

## Prerequisites

Before testing, ensure you have:
1. MySQL database running
2. Environment variables configured in `.env`
3. Dependencies installed: `pip install -r mcp-server/requirements.txt`
4. Sample data loaded (optional but recommended)

## Quick Setup

```bash
# 1. Set up environment
cp .env.example .env
# Edit .env with your database credentials

# 2. Install dependencies
cd mcp-server
pip install -r requirements.txt

# 3. Set up database (optional - creates sample data)
cd ..
python scripts/setup_database.py
```

## Method 1: Using Python REPL (Recommended for Quick Tests)

### Test 1: Database Connection

```bash
cd mcp-server
python
```

```python
import asyncio
from src.config.settings import DatabaseConfig
from src.database.connection import DatabaseConnection

async def test_connection():
    # Load configuration
    config = DatabaseConfig.from_env()
    print(f"Connecting to: {config.host}:{config.port}/{config.database}")
    
    # Create connection
    db = DatabaseConnection(config)
    await db.initialize()
    
    # Test connection
    result = await db.test_connection()
    print(f"Connection test: {'✓ Success' if result else '✗ Failed'}")
    
    await db.close()

# Run test
asyncio.run(test_connection())
```

**Expected Output**:
```
Connecting to: localhost:3306/sevone_db
Connection test: ✓ Success
```

### Test 2: Schema Extraction

```python
import asyncio
from src.config.settings import DatabaseConfig
from src.database.connection import DatabaseConnection
from src.database.schema import SchemaExtractor

async def test_schema():
    config = DatabaseConfig.from_env()
    db = DatabaseConnection(config)
    await db.initialize()
    
    # Extract schema
    extractor = SchemaExtractor(db)
    schema = await extractor.get_schema()
    
    print(f"Database: {schema['database']}")
    print(f"Tables found: {len(schema['tables'])}")
    
    for table in schema['tables']:
        print(f"\nTable: {table['name']}")
        print(f"  Columns: {len(table['columns'])}")
        for col in table['columns'][:3]:  # Show first 3 columns
            print(f"    - {col['name']}: {col['data_type']}")
    
    await db.close()

asyncio.run(test_schema())
```

**Expected Output**:
```
Database: sevone_db
Tables found: 4

Table: devices
  Columns: 8
    - device_id: int
    - device_name: varchar
    - ip_address: varchar

Table: metrics
  Columns: 7
    - metric_id: bigint
    - device_id: int
    - metric_type: varchar
...
```

### Test 3: SELECT Query Tool

```python
import asyncio
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.tools.select_query import select_query_tool

async def test_select():
    # Setup
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    await db.initialize()
    validator = QueryValidator(security_config)
    
    # Test simple SELECT
    print("Test 1: Simple SELECT")
    result = await select_query_tool(
        db, validator,
        "SELECT * FROM devices LIMIT 3",
        None
    )
    
    if result["success"]:
        print(f"✓ Success: {result['row_count']} rows returned")
        print(f"  Execution time: {result['execution_time']}s")
        print(f"  Columns: {result['columns']}")
        for row in result['rows']:
            print(f"  Row: {row}")
    else:
        print(f"✗ Error: {result['error']}")
    
    # Test parameterized SELECT
    print("\nTest 2: Parameterized SELECT")
    result = await select_query_tool(
        db, validator,
        "SELECT * FROM devices WHERE status = %s",
        ["active"]
    )
    
    if result["success"]:
        print(f"✓ Success: {result['row_count']} rows returned")
    else:
        print(f"✗ Error: {result['error']}")
    
    await db.close()

asyncio.run(test_select())
```

**Expected Output**:
```
Test 1: Simple SELECT
✓ Success: 3 rows returned
  Execution time: 0.05s
  Columns: ['device_id', 'device_name', 'ip_address', ...]
  Row: {'device_id': 1, 'device_name': 'Router-Core-01', ...}
  Row: {'device_id': 2, 'device_name': 'Switch-Access-01', ...}
  Row: {'device_id': 3, 'device_name': 'Switch-Access-02', ...}

Test 2: Parameterized SELECT
✓ Success: 5 rows returned
```

### Test 4: INSERT Query Tool

```python
import asyncio
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.tools.insert_query import insert_query_tool

async def test_insert():
    # Setup
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    await db.initialize()
    validator = QueryValidator(security_config)
    
    # Test INSERT
    print("Test: INSERT new device")
    result = await insert_query_tool(
        db, validator,
        "INSERT INTO devices (device_name, ip_address, device_type, location) VALUES (%s, %s, %s, %s)",
        ["Test-Router-99", "192.168.99.99", "Router", "Test Lab"]
    )
    
    if result["success"]:
        print(f"✓ Success!")
        print(f"  Insert ID: {result['insert_id']}")
        print(f"  Affected rows: {result['affected_rows']}")
    else:
        print(f"✗ Error: {result['error']}")
    
    await db.close()

asyncio.run(test_insert())
```

**Expected Output**:
```
Test: INSERT new device
✓ Success!
  Insert ID: 6
  Affected rows: 1
```

### Test 5: Query Validation

```python
import asyncio
from src.config.settings import SecurityConfig
from src.database.validator import QueryValidator

async def test_validation():
    validator = QueryValidator(SecurityConfig.from_env())
    
    # Test 1: Valid SELECT
    print("Test 1: Valid SELECT query")
    result = validator.validate_query("SELECT * FROM devices", "SELECT")
    print(f"  Result: {'✓ Valid' if result['valid'] else '✗ Invalid'}")
    if not result['valid']:
        print(f"  Error: {result['error']}")
    
    # Test 2: SQL Injection attempt
    print("\nTest 2: SQL Injection attempt")
    result = validator.validate_query(
        "SELECT * FROM devices; DROP TABLE devices;",
        "SELECT"
    )
    print(f"  Result: {'✓ Valid' if result['valid'] else '✗ Invalid (Expected)'}")
    if not result['valid']:
        print(f"  Error: {result['error']}")
    
    # Test 3: Dangerous operation
    print("\nTest 3: Dangerous operation (DELETE)")
    result = validator.validate_query("DELETE FROM devices", "DELETE")
    print(f"  Result: {'✓ Valid' if result['valid'] else '✗ Invalid (Expected)'}")
    if not result['valid']:
        print(f"  Error: {result['error']}")
    
    # Test 4: INSERT without parameters
    print("\nTest 4: INSERT without placeholders")
    result = validator.validate_query(
        "INSERT INTO devices VALUES (1, 'test')",
        "INSERT"
    )
    print(f"  Result: {'✓ Valid' if result['valid'] else '✗ Invalid (Expected)'}")

asyncio.run(test_validation())
```

**Expected Output**:
```
Test 1: Valid SELECT query
  Result: ✓ Valid

Test 2: SQL Injection attempt
  Result: ✗ Invalid (Expected)
  Error: Query contains potentially dangerous pattern: ;\s*DROP

Test 3: Dangerous operation (DELETE)
  Result: ✗ Invalid (Expected)
  Error: Operation DELETE is not allowed

Test 4: INSERT without placeholders
  Result: ✓ Valid
```

## Method 2: Using Test Script

Create a test script for easier repeated testing:

```bash
# Create test script
cat > mcp-server/test_manual.py << 'EOF'
#!/usr/bin/env python3
"""Manual testing script for MCP server"""
import asyncio
import sys
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.database.schema import SchemaExtractor
from src.tools.select_query import select_query_tool
from src.tools.insert_query import insert_query_tool

async def main():
    print("=" * 60)
    print("MCP Server Manual Test Suite")
    print("=" * 60)
    
    # Setup
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    validator = QueryValidator(security_config)
    
    try:
        # Test 1: Connection
        print("\n[1/5] Testing database connection...")
        await db.initialize()
        if await db.test_connection():
            print("✓ Connection successful")
        else:
            print("✗ Connection failed")
            return
        
        # Test 2: Schema extraction
        print("\n[2/5] Testing schema extraction...")
        extractor = SchemaExtractor(db)
        schema = await extractor.get_schema()
        print(f"✓ Found {len(schema['tables'])} tables")
        
        # Test 3: SELECT query
        print("\n[3/5] Testing SELECT query...")
        result = await select_query_tool(
            db, validator,
            "SELECT COUNT(*) as count FROM devices",
            None
        )
        if result["success"]:
            count = result['rows'][0]['count']
            print(f"✓ SELECT successful: {count} devices found")
        else:
            print(f"✗ SELECT failed: {result['error']}")
        
        # Test 4: Query validation
        print("\n[4/5] Testing query validation...")
        dangerous = validator.validate_query(
            "SELECT * FROM devices; DROP TABLE devices;",
            "SELECT"
        )
        if not dangerous['valid']:
            print("✓ Dangerous query blocked")
        else:
            print("✗ Dangerous query not blocked!")
        
        # Test 5: Parameterized query
        print("\n[5/5] Testing parameterized query...")
        result = await select_query_tool(
            db, validator,
            "SELECT * FROM devices WHERE status = %s LIMIT 1",
            ["active"]
        )
        if result["success"]:
            print(f"✓ Parameterized query successful")
        else:
            print(f"✗ Parameterized query failed: {result['error']}")
        
        print("\n" + "=" * 60)
        print("All tests completed!")
        print("=" * 60)
        
    except Exception as e:
        print(f"\n✗ Error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await db.close()

if __name__ == "__main__":
    asyncio.run(main())
EOF

# Make executable
chmod +x mcp-server/test_manual.py

# Run tests
cd mcp-server
python test_manual.py
```

**Expected Output**:
```
============================================================
MCP Server Manual Test Suite
============================================================

[1/5] Testing database connection...
✓ Connection successful

[2/5] Testing schema extraction...
✓ Found 4 tables

[3/5] Testing SELECT query...
✓ SELECT successful: 5 devices found

[4/5] Testing query validation...
✓ Dangerous query blocked

[5/5] Testing parameterized query...
✓ Parameterized query successful

============================================================
All tests completed!
============================================================
```

## Method 3: Using MCP Inspector (Advanced)

If you have the MCP Inspector tool installed:

```bash
# Install MCP Inspector
npm install -g @modelcontextprotocol/inspector

# Run MCP server with inspector
cd mcp-server
mcp-inspector python -m src.server
```

This will open a web interface where you can:
1. See available tools
2. Test tool calls interactively
3. View request/response logs
4. Debug issues

## Method 4: Using Unit Tests

Run the existing test suite:

```bash
cd mcp-server

# Run all tests
pytest tests/ -v

# Run specific test file
pytest tests/test_tools.py -v

# Run with coverage
pytest tests/ --cov=src --cov-report=html

# Run specific test
pytest tests/test_tools.py::TestSelectQueryTool::test_valid_select_query -v
```

## Common Test Scenarios

### Scenario 1: Test with Real Data

```python
import asyncio
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.tools.select_query import select_query_tool

async def test_real_queries():
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    await db.initialize()
    validator = QueryValidator(security_config)
    
    queries = [
        ("List all devices", "SELECT * FROM devices"),
        ("Count devices by type", "SELECT device_type, COUNT(*) as count FROM devices GROUP BY device_type"),
        ("Find devices by IP", "SELECT * FROM devices WHERE ip_address LIKE %s", ["192.168.1.%"]),
        ("Recent alerts", "SELECT * FROM alerts ORDER BY created_at DESC LIMIT 5"),
    ]
    
    for name, query, *params in queries:
        print(f"\n{name}:")
        result = await select_query_tool(db, validator, query, params[0] if params else None)
        if result["success"]:
            print(f"  ✓ {result['row_count']} rows in {result['execution_time']}s")
        else:
            print(f"  ✗ {result['error']}")
    
    await db.close()

asyncio.run(test_real_queries())
```

### Scenario 2: Test Error Handling

```python
import asyncio
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.tools.select_query import select_query_tool

async def test_errors():
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    await db.initialize()
    validator = QueryValidator(security_config)
    
    error_cases = [
        ("Invalid table", "SELECT * FROM nonexistent_table"),
        ("Invalid column", "SELECT invalid_column FROM devices"),
        ("SQL injection", "SELECT * FROM devices WHERE id = 1; DROP TABLE devices;"),
        ("Missing WHERE", "DELETE FROM devices"),
    ]
    
    for name, query in error_cases:
        print(f"\n{name}:")
        result = await select_query_tool(db, validator, query, None)
        if not result["success"]:
            print(f"  ✓ Correctly blocked: {result['error'][:50]}...")
        else:
            print(f"  ✗ Should have been blocked!")
    
    await db.close()

asyncio.run(test_errors())
```

## Troubleshooting

### Issue: Connection Refused

```bash
# Check MySQL is running
systemctl status mysql  # Linux
brew services list | grep mysql  # macOS

# Test connection manually
mysql -h localhost -u sevone_user -p sevone_db
```

### Issue: Import Errors

```bash
# Ensure you're in the right directory
cd mcp-server

# Reinstall dependencies
pip install -r requirements.txt

# Check Python path
python -c "import sys; print('\n'.join(sys.path))"
```

### Issue: Environment Variables Not Loaded

```bash
# Check .env file exists
ls -la ../.env

# Load manually in Python
from dotenv import load_dotenv
load_dotenv('../.env')
```

## Next Steps

After manual testing:
1. Run full test suite: `pytest tests/ -v`
2. Check test coverage: `pytest tests/ --cov=src --cov-report=html`
3. Review logs for any warnings
4. Proceed to Phase 2 (Bob AI configuration)

## Additional Resources

- [MCP Server README](../mcp-server/README.md)
- [Setup Guide](SETUP.md)
- [Phase 2 Plan](PHASE2_PLAN.md)