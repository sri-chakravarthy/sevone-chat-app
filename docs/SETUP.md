# SevOne Chat Application - Setup Guide

Complete setup instructions for all three phases of the SevOne Chat Application.

## Prerequisites

### System Requirements
- **Operating System**: macOS, Linux, or Windows
- **Python**: 3.11 or higher
- **MySQL**: 5.7+ or MariaDB 10.3+
- **Bob AI**: Installed and configured
- **Memory**: Minimum 4GB RAM
- **Disk Space**: 500MB free space

### Required Software
```bash
# Check Python version
python --version  # Should be 3.11+

# Check MySQL
mysql --version

# Check Bob AI installation
bob --version
```

## Phase 1: MCP Server Setup

### Step 1: Environment Configuration

1. **Copy environment template**:
```bash
cp .env.example .env
```

2. **Edit `.env` file** with your database credentials:
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

### Step 2: Database Setup

1. **Create MySQL database and user**:
```sql
CREATE DATABASE sevone_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'sevone_user'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT SELECT, INSERT ON sevone_db.* TO 'sevone_user'@'localhost';
FLUSH PRIVILEGES;
```

2. **Run database setup script**:
```bash
python scripts/setup_database.py
```

This will:
- Create tables (devices, metrics, alerts, users)
- Insert sample data
- Verify setup

### Step 3: Install MCP Server Dependencies

```bash
cd mcp-server
pip install -r requirements.txt
```

Or using the project file:
```bash
pip install -e .
```

### Step 4: Test MCP Server

1. **Run unit tests**:
```bash
pytest tests/ -v
```

2. **Test database connection**:
```bash
python -c "
import asyncio
from src.config.settings import DatabaseConfig
from src.database.connection import DatabaseConnection

async def test():
    config = DatabaseConfig.from_env()
    db = DatabaseConnection(config)
    await db.initialize()
    result = await db.test_connection()
    print(f'Connection test: {'✓ Success' if result else '✗ Failed'}')
    await db.close()

asyncio.run(test())
"
```

3. **Start MCP server**:
```bash
python -m src.server
```

The server should start and display:
```
Starting SevOne MySQL MCP Server...
Connecting to database: localhost:3306/sevone_db
Database connection successful
Loading database schema...
Schema loaded: 4 tables found
MCP Server ready
```

## Phase 2: Bob AI Configuration

### Step 1: Locate Bob Configuration

Find your Bob AI configuration directory:
```bash
# macOS/Linux
~/.config/bob/

# Windows
%APPDATA%\bob\
```

### Step 2: Configure MCP Server

1. **Edit or create `bob_config.json`**:
```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "mcp_server.src.server"],
      "cwd": "/path/to/sevone-chat-app-mysql/mcp-server",
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_DATABASE": "sevone_db",
        "MYSQL_USER": "sevone_user",
        "MYSQL_PASSWORD": "your_secure_password"
      }
    }
  }
}
```

2. **Update the `cwd` path** to your actual project directory.

### Step 3: Test Bob AI Connection

1. **Restart Bob AI** to load the new configuration.

2. **Test MCP server connection**:
```bash
# In Bob AI chat
"Can you list the available MCP tools?"
```

Expected response should include:
- `select_query`
- `insert_query`
- `get_schema`

3. **Test schema retrieval**:
```bash
# In Bob AI chat
"Can you get the database schema using the get_schema tool?"
```

### Step 4: Load SQL Expert Prompt

The SQL expert prompt is located at:
```
chat-interface/prompts/sql_expert_prompt.txt
```

You can either:
1. **Copy the prompt** into Bob AI's system prompt field
2. **Reference it** in your Bob AI configuration
3. **Use it** when starting a new chat session

### Step 5: Test Query Generation

Test with sample queries:

1. **Simple SELECT**:
```
"Show me all active devices"
```

2. **Filtered SELECT**:
```
"List devices with IP addresses starting with 192.168"
```

3. **INSERT operation**:
```
"Add a new device named Router-05 with IP 192.168.1.5"
```

Bob AI should:
- Show chain-of-thought reasoning
- Generate appropriate SQL
- Execute using MCP tools
- Display formatted results

## Phase 3: Chat Interface Setup

### Step 1: Install Dependencies

```bash
cd chat-interface
pip install -r requirements.txt
```

### Step 2: Configure Application

1. **Create configuration file** (if needed):
```python
# chat-interface/config.py
import os

BOB_API_ENDPOINT = os.getenv("BOB_API_ENDPOINT", "http://localhost:8080")
BOB_API_KEY = os.getenv("BOB_API_KEY", "")
```

2. **Update environment variables**:
```bash
# Add to .env
BOB_API_ENDPOINT=http://localhost:8080
BOB_API_KEY=your_api_key_here
```

### Step 3: Run Chat Interface

```bash
streamlit run app.py
```

The interface should open in your browser at `http://localhost:8501`.

### Step 4: Test Chat Interface

1. **Test basic query**:
   - Type: "Show me all devices"
   - Verify results display correctly

2. **Test schema browser**:
   - Check sidebar shows database tables
   - Verify columns are displayed

3. **Test error handling**:
   - Try invalid query
   - Verify error message is helpful

## Troubleshooting

### MCP Server Issues

**Problem**: Connection refused
```
Solution:
1. Check MySQL is running: systemctl status mysql
2. Verify credentials in .env
3. Check firewall settings
4. Test connection: mysql -h localhost -u sevone_user -p
```

**Problem**: Import errors
```
Solution:
1. Verify Python version: python --version
2. Reinstall dependencies: pip install -r requirements.txt
3. Check virtual environment is activated
```

**Problem**: Query validation errors
```
Solution:
1. Check query syntax
2. Verify table/column names exist
3. Use parameterized queries for INSERT
4. Check ALLOWED_OPERATIONS in .env
```

### Bob AI Issues

**Problem**: MCP server not found
```
Solution:
1. Check bob_config.json path is correct
2. Verify cwd points to mcp-server directory
3. Restart Bob AI
4. Check Bob AI logs for errors
```

**Problem**: Tools not available
```
Solution:
1. Verify MCP server is running
2. Check Bob AI configuration
3. Test MCP server independently
4. Review Bob AI logs
```

### Chat Interface Issues

**Problem**: Streamlit won't start
```
Solution:
1. Check port 8501 is available
2. Verify dependencies installed
3. Check Python version
4. Try: streamlit run app.py --server.port 8502
```

**Problem**: Bob AI connection failed
```
Solution:
1. Verify Bob AI is running
2. Check BOB_API_ENDPOINT in .env
3. Test Bob AI independently
4. Check API key if required
```

## Verification Checklist

### Phase 1 Verification
- [ ] MySQL database created and accessible
- [ ] Sample data inserted successfully
- [ ] MCP server starts without errors
- [ ] Unit tests pass
- [ ] Database connection test succeeds
- [ ] Schema extraction works

### Phase 2 Verification
- [ ] Bob AI recognizes MCP server
- [ ] All three tools are available
- [ ] Schema retrieval works
- [ ] SELECT queries execute correctly
- [ ] INSERT queries execute correctly
- [ ] Chain-of-thought reasoning is clear
- [ ] Error handling is appropriate

### Phase 3 Verification
- [ ] Chat interface loads successfully
- [ ] Schema browser displays tables
- [ ] Queries execute and display results
- [ ] Chat history persists
- [ ] Error messages are helpful
- [ ] Export functionality works

## Next Steps

After successful setup:

1. **Review Documentation**:
   - Read [DESIGN.md](../DESIGN.md) for architecture details
   - Review [Phase 2 Plan](PHASE2_PLAN.md) for AI configuration
   - Check [Phase 3 Plan](PHASE3_PLAN.md) for interface features

2. **Test Thoroughly**:
   - Run all test suites
   - Try various query types
   - Test error scenarios
   - Verify security features

3. **Customize**:
   - Adjust system prompt for your use case
   - Add custom query examples
   - Configure UI theme
   - Set up monitoring

4. **Deploy**:
   - Choose deployment platform
   - Configure production settings
   - Set up monitoring and logging
   - Create backup procedures

## Support

For issues or questions:
1. Check troubleshooting section above
2. Review documentation in `docs/` directory
3. Check project README.md
4. Contact development team

## Security Notes

- Never commit `.env` file to version control
- Use strong passwords for database
- Regularly update dependencies
- Monitor query logs for suspicious activity
- Implement rate limiting in production
- Use HTTPS for production deployment
- Regularly backup database
- Review and update security configurations

## Performance Tips

- Adjust `MYSQL_POOL_SIZE` based on load
- Increase `QUERY_TIMEOUT` for complex queries
- Use indexes on frequently queried columns
- Monitor connection pool usage
- Cache schema information
- Implement query result pagination
- Use CDN for static assets in production