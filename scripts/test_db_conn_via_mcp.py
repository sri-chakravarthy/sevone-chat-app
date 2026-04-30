import asyncio
import os
from pathlib import Path
from dotenv import load_dotenv
from src.config.settings import DatabaseConfig
from src.database.connection import DatabaseConnection

async def test_connection():
    # Load environment variables from .env file
    env_path = Path(__file__).parent.parent / '.env'
    load_dotenv(env_path)
    
    # Load configuration
    config = DatabaseConfig.from_env()
    print(f"Connecting to: {config.host}:{config.port}/{config.database}")
    print(f"User: {config.user}")
    print(f"Password: {'*' * len(config.password) if config.password else '(empty)'}")
    
    # Create connection
    db = DatabaseConnection(config)
    await db.initialize()
    
    # Test connection
    result = await db.test_connection()
    print(f"Connection test: {'✓ Success' if result else '✗ Failed'}")
    
    await db.close()

# Run test
asyncio.run(test_connection())
