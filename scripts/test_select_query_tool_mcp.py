import asyncio
from src.config.settings import DatabaseConfig, SecurityConfig
from src.database.connection import DatabaseConnection
from src.database.validator import QueryValidator
from src.tools.select_query import select_query_tool
from dotenv import load_dotenv
from pathlib import Path


async def test_select():
    # Setup
    env_path = Path(__file__).parent.parent / '.env'
    load_dotenv(env_path)
    db_config = DatabaseConfig.from_env()
    security_config = SecurityConfig.from_env()
    db = DatabaseConnection(db_config)
    await db.initialize()
    validator = QueryValidator(security_config)
    
    # Test simple SELECT
    print("Test 1: Simple SELECT")
    result = await select_query_tool(
        db, validator,
        "SELECT * FROM employees LIMIT 3",
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
        "SELECT * FROM employee_projects WHERE role = %s",
        ["Backend Developer"]
    )
    
    if result["success"]:
        print(f"✓ Success: {result['row_count']} rows returned")
    else:
        print(f"✗ Error: {result['error']}")
    
    await db.close()

asyncio.run(test_select())