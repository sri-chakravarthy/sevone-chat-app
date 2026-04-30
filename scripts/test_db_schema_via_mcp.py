import asyncio
from src.config.settings import DatabaseConfig
from src.database.connection import DatabaseConnection
from src.database.schema import SchemaExtractor
from dotenv import load_dotenv
from pathlib import Path

async def test_schema():
    env_path = Path(__file__).parent.parent / '.env'
    load_dotenv(env_path)
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