"""Database setup script for SevOne chat application"""
import asyncio
import sys
from pathlib import Path

# Add parent directory to path for imports
sys.path.insert(0, str(Path(__file__).parent.parent))

from mcp_server.src.config.settings import DatabaseConfig
from mcp_server.src.database.connection import DatabaseConnection


async def create_sample_schema():
    """Create sample database schema for testing"""
    
    # Sample schema for SevOne monitoring system
    schema_sql = """
    -- Devices table
    CREATE TABLE IF NOT EXISTS devices (
        device_id INT AUTO_INCREMENT PRIMARY KEY,
        device_name VARCHAR(255) NOT NULL UNIQUE,
        ip_address VARCHAR(45) NOT NULL,
        device_type VARCHAR(50),
        location VARCHAR(255),
        status ENUM('active', 'inactive', 'maintenance') DEFAULT 'active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_device_name (device_name),
        INDEX idx_ip_address (ip_address),
        INDEX idx_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Network devices being monitored';

    -- Metrics table
    CREATE TABLE IF NOT EXISTS metrics (
        metric_id BIGINT AUTO_INCREMENT PRIMARY KEY,
        device_id INT NOT NULL,
        metric_type VARCHAR(50) NOT NULL,
        metric_name VARCHAR(255) NOT NULL,
        value DECIMAL(20, 4),
        unit VARCHAR(20),
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE CASCADE,
        INDEX idx_device_metric (device_id, metric_type),
        INDEX idx_timestamp (timestamp),
        INDEX idx_metric_type (metric_type)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Performance metrics collected from devices';

    -- Alerts table
    CREATE TABLE IF NOT EXISTS alerts (
        alert_id INT AUTO_INCREMENT PRIMARY KEY,
        device_id INT NOT NULL,
        alert_type VARCHAR(50) NOT NULL,
        severity ENUM('critical', 'high', 'medium', 'low', 'info') NOT NULL,
        message TEXT NOT NULL,
        acknowledged BOOLEAN DEFAULT FALSE,
        acknowledged_by VARCHAR(100),
        acknowledged_at TIMESTAMP NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        resolved_at TIMESTAMP NULL,
        FOREIGN KEY (device_id) REFERENCES devices(device_id) ON DELETE CASCADE,
        INDEX idx_device_alerts (device_id),
        INDEX idx_severity (severity),
        INDEX idx_acknowledged (acknowledged),
        INDEX idx_created_at (created_at)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Alerts generated from monitoring';

    -- Users table (for tracking who made changes)
    CREATE TABLE IF NOT EXISTS users (
        user_id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(100) NOT NULL UNIQUE,
        email VARCHAR(255) NOT NULL UNIQUE,
        full_name VARCHAR(255),
        role ENUM('admin', 'operator', 'viewer') DEFAULT 'viewer',
        active BOOLEAN DEFAULT TRUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_login TIMESTAMP NULL,
        INDEX idx_username (username),
        INDEX idx_email (email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='System users';
    """
    
    return schema_sql


async def insert_sample_data():
    """Generate sample data insertion SQL"""
    
    sample_data_sql = """
    -- Sample devices
    INSERT INTO devices (device_name, ip_address, device_type, location, status) VALUES
    ('Router-Core-01', '192.168.1.1', 'Router', 'Data Center A', 'active'),
    ('Switch-Access-01', '192.168.1.10', 'Switch', 'Data Center A', 'active'),
    ('Switch-Access-02', '192.168.1.11', 'Switch', 'Data Center A', 'active'),
    ('Firewall-Edge-01', '192.168.1.254', 'Firewall', 'Data Center A', 'active'),
    ('Server-Web-01', '192.168.2.10', 'Server', 'Data Center B', 'active')
    ON DUPLICATE KEY UPDATE device_name=device_name;

    -- Sample users
    INSERT INTO users (username, email, full_name, role) VALUES
    ('admin', 'admin@sevone.com', 'System Administrator', 'admin'),
    ('operator1', 'operator1@sevone.com', 'Network Operator', 'operator'),
    ('viewer1', 'viewer1@sevone.com', 'Network Viewer', 'viewer')
    ON DUPLICATE KEY UPDATE username=username;
    """
    
    return sample_data_sql


async def main():
    """Main setup function"""
    print("SevOne Database Setup Script")
    print("=" * 50)
    
    # Load configuration
    config = DatabaseConfig.from_env()
    
    print(f"\nConnecting to database:")
    print(f"  Host: {config.host}:{config.port}")
    print(f"  Database: {config.database}")
    print(f"  User: {config.user}")
    
    # Create connection
    db = DatabaseConnection(config)
    
    try:
        await db.initialize()
        print("\n✓ Database connection established")
        
        # Test connection
        if not await db.test_connection():
            print("\n✗ Connection test failed!")
            return
        
        print("✓ Connection test passed")
        
        # Create schema
        print("\nCreating database schema...")
        schema_sql = await create_sample_schema()
        
        # Execute schema creation (split by semicolon)
        statements = [s.strip() for s in schema_sql.split(';') if s.strip()]
        
        for statement in statements:
            if statement:
                result = await db.execute_select(statement, None)
                if not result.get("success"):
                    print(f"✗ Error executing statement: {result.get('error')}")
                    return
        
        print("✓ Schema created successfully")
        
        # Insert sample data
        print("\nInserting sample data...")
        sample_sql = await insert_sample_data()
        
        statements = [s.strip() for s in sample_sql.split(';') if s.strip()]
        
        for statement in statements:
            if statement:
                # Use execute_select for INSERT as well (it's a workaround for setup)
                result = await db.execute_select(statement, None)
                if not result.get("success"):
                    print(f"✗ Error inserting data: {result.get('error')}")
                    # Continue anyway as data might already exist
        
        print("✓ Sample data inserted")
        
        # Verify setup
        print("\nVerifying setup...")
        result = await db.execute_select("SELECT COUNT(*) as count FROM devices", None)
        if result.get("success"):
            count = result["rows"][0]["count"]
            print(f"✓ Found {count} devices in database")
        
        print("\n" + "=" * 50)
        print("Database setup completed successfully!")
        print("\nYou can now start the MCP server:")
        print("  cd mcp-server")
        print("  python -m src.server")
        
    except Exception as e:
        print(f"\n✗ Error during setup: {e}")
        import traceback
        traceback.print_exc()
    finally:
        await db.close()
        print("\nDatabase connection closed")


if __name__ == "__main__":
    asyncio.run(main())

# Made with Bob
