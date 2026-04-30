# Phase 2 Setup Guide: Bob AI Configuration

This guide walks you through configuring Bob AI to use the MCP server for SQL database queries.

## Prerequisites

- ✅ Phase 1 complete (MCP server running)
- ✅ MySQL database accessible
- ✅ Bob AI installed and working
- ✅ MCP server tested and functional

## Step 1: Locate Bob AI Configuration Directory

Bob AI stores its configuration in a specific directory depending on your OS:

### macOS/Linux
```bash
~/.config/bob/
```

### Windows
```bash
%APPDATA%\bob\
```

### Find Your Config Directory
```bash
# Check if directory exists
ls -la ~/.config/bob/

# If it doesn't exist, create it
mkdir -p ~/.config/bob/
```

## Step 2: Copy Bob Configuration File

Copy the `bob_config.json` file to Bob's configuration directory:

```bash
# From project root
cp bob_config.json ~/.config/bob/bob_config.json

# Or create a symlink (recommended for easier updates)
ln -s $(pwd)/bob_config.json ~/.config/bob/bob_config.json
```

## Step 3: Update Configuration Paths

Edit the `bob_config.json` file to use your actual paths:

```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "src.server"],
      "cwd": "/FULL/PATH/TO/YOUR/PROJECT/mcp-server",
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_DATABASE": "your_database_name",
        "MYSQL_USER": "your_mysql_user",
        "MYSQL_PASSWORD": "${MYSQL_PASSWORD}"
      }
    }
  }
}
```

**Important**: Replace `/FULL/PATH/TO/YOUR/PROJECT/` with your actual project path.

To get your full path:
```bash
cd /path/to/sevone-chat-app-mysql/mcp-server
pwd
# Copy this output to the "cwd" field
```

## Step 4: Set Environment Variable for Password

For security, set the MySQL password as an environment variable:

### macOS/Linux (bash/zsh)
```bash
# Add to ~/.bashrc or ~/.zshrc
export MYSQL_PASSWORD="your_mysql_password"

# Reload shell
source ~/.bashrc  # or source ~/.zshrc
```

### Alternative: Use .env File
Bob AI can also read from your project's `.env` file if configured properly.

## Step 5: Restart Bob AI

After updating the configuration:

```bash
# If Bob AI is running, restart it
# The method depends on how you're running Bob AI

# For CLI:
# Just start a new session

# For GUI/Service:
# Restart the application
```

## Step 6: Verify MCP Server Connection

Test that Bob AI can see the MCP server:

### Test 1: List Available Tools

In Bob AI chat:
```
Can you list the available MCP tools?
```

**Expected Response**:
```
I have access to the following MCP tools:

1. get_schema - Retrieve the complete database schema
2. select_query - Execute SELECT queries on the database
3. insert_query - Execute INSERT queries on the database
```

### Test 2: Get Database Schema

```
Can you get the database schema using the get_schema tool?
```

**Expected Response**:
```
Here's the database schema:

DATABASE: your_database_name

TABLE: devices
  Columns:
    - device_id: int NOT NULL [PRI] auto_increment
    - device_name: varchar(255) NOT NULL
    - ip_address: varchar(45) NOT NULL
    ...

TABLE: metrics
  ...
```

### Test 3: Simple Query

```
Show me all devices in the database
```

**Expected Response**:
Bob AI should:
1. Show chain-of-thought reasoning
2. Generate appropriate SQL
3. Execute using select_query tool
4. Display formatted results

## Step 7: Load SQL Expert System Prompt

The system prompt is located at `prompts/sql_expert_system_prompt.md`.

### Option A: Copy to Bob AI

If Bob AI supports custom system prompts:
```bash
# Copy the prompt
cat prompts/sql_expert_system_prompt.md

# Paste into Bob AI's system prompt configuration
```

### Option B: Use in Chat Session

Start each chat session by providing the prompt:
```
I want you to act as a SQL expert for the SevOne database. 
[Paste the content of sql_expert_system_prompt.md]
```

### Option C: Create a Bob AI Mode (Advanced)

If Bob AI supports custom modes, create a "SQL Expert" mode with the system prompt.

## Step 8: Test Complete Workflow

Test the full workflow with these queries:

### Test 1: Simple SELECT
```
User: "Show me all active devices"
```

Bob AI should:
- ✓ Analyze intent
- ✓ Generate SQL query
- ✓ Execute select_query tool
- ✓ Format and display results

### Test 2: Filtered Query
```
User: "Find devices with IP addresses starting with 192.168.1"
```

Bob AI should:
- ✓ Use parameterized query
- ✓ Apply LIKE filter correctly
- ✓ Display matching devices

### Test 3: JOIN Query
```
User: "Show me devices that have alerts"
```

Bob AI should:
- ✓ Identify need for JOIN
- ✓ Join devices and alerts tables
- ✓ Display combined results

### Test 4: INSERT Operation
```
User: "Add a new device named Test-Router with IP 192.168.99.99"
```

Bob AI should:
- ✓ Generate INSERT query
- ✓ Use parameterized values
- ✓ Execute insert_query tool
- ✓ Confirm successful insertion

### Test 5: Error Handling
```
User: "Show me data from the nonexistent_table"
```

Bob AI should:
- ✓ Attempt query
- ✓ Receive error
- ✓ Explain error clearly
- ✓ Suggest correct table name

## Troubleshooting

### Issue: Bob AI Can't Find MCP Server

**Symptoms**: "MCP server 'sevone-mysql' not found"

**Solutions**:
1. Check `bob_config.json` is in the correct location
2. Verify the `cwd` path is correct
3. Restart Bob AI
4. Check Bob AI logs for errors

### Issue: MCP Server Starts But Tools Not Available

**Symptoms**: "No tools available" or "Tool not found"

**Solutions**:
1. Verify MCP server starts successfully:
   ```bash
   cd mcp-server
   python -m src.server
   ```
2. Check for errors in server output
3. Verify database connection works
4. Check Bob AI can communicate with the server

### Issue: Database Connection Fails

**Symptoms**: "Access denied" or "Can't connect to MySQL"

**Solutions**:
1. Verify MySQL is running
2. Check credentials in `bob_config.json`
3. Test connection manually:
   ```bash
   mysql -h localhost -u your_user -p your_database
   ```
4. Check `.env` file has correct password
5. Verify environment variable is set

### Issue: Queries Execute But Results Are Wrong

**Symptoms**: Incorrect data or unexpected results

**Solutions**:
1. Check database has correct data
2. Verify schema matches expectations
3. Test queries directly in MySQL
4. Check Bob AI's SQL generation logic
5. Review system prompt for clarity

## Verification Checklist

Before proceeding to Phase 3, verify:

- [ ] Bob AI recognizes the MCP server
- [ ] All three tools are available (get_schema, select_query, insert_query)
- [ ] Schema retrieval works correctly
- [ ] Simple SELECT queries execute successfully
- [ ] Parameterized queries work
- [ ] JOIN queries work
- [ ] INSERT queries execute successfully
- [ ] Error handling is appropriate
- [ ] Chain-of-thought reasoning is clear
- [ ] Results are formatted well

## Configuration Files Reference

### bob_config.json
Location: `~/.config/bob/bob_config.json` or project root
Purpose: Tells Bob AI how to start and connect to the MCP server

### sql_expert_system_prompt.md
Location: `prompts/sql_expert_system_prompt.md`
Purpose: Instructs Bob AI on how to act as a SQL expert

### .env
Location: Project root
Purpose: Stores database credentials securely

## Next Steps

After Phase 2 is complete and verified:

1. **Document any issues** encountered during setup
2. **Test thoroughly** with various query types
3. **Refine the system prompt** based on Bob AI's responses
4. **Proceed to Phase 3** - Chat Interface implementation

## Getting Help

If you encounter issues:

1. Check the [Troubleshooting Guide](TROUBLESHOOTING.md)
2. Review [Phase 2 Plan](PHASE2_PLAN.md) for detailed information
3. Check Bob AI documentation for MCP configuration
4. Verify MCP server logs for errors
5. Test database connection independently

## Example Session

Here's what a successful Phase 2 setup looks like:

```
You: Hello! Can you help me query the database?

Bob: Hello! I'm your SQL expert assistant for the SevOne database. 
I can help you query devices, alerts, metrics, and more. 
Would you like me to show you the database schema first?

You: Yes, please show me the schema.

Bob: Let me retrieve the database schema for you.

[Bob calls get_schema tool]

Here's the database structure:

DATABASE: sevone_db

TABLE: devices (5 rows)
  - device_id: int (Primary Key)
  - device_name: varchar(255)
  - ip_address: varchar(45)
  - device_type: varchar(50)
  - location: varchar(255)
  - status: enum('active','inactive','maintenance')

TABLE: metrics (120 rows)
  - metric_id: bigint (Primary Key)
  - device_id: int (Foreign Key → devices)
  - metric_type: varchar(50)
  - value: decimal(20,4)
  - timestamp: timestamp

TABLE: alerts (12 rows)
  - alert_id: int (Primary Key)
  - device_id: int (Foreign Key → devices)
  - severity: enum('critical','high','medium','low','info')
  - message: text
  - acknowledged: boolean

What would you like to query?

You: Show me all active devices

Bob: I'll find all active devices for you.

**Analysis**:
- Intent: Retrieve device information
- Operation: SELECT query
- Table: devices
- Condition: status = 'active'

**SQL Query**:
```sql
SELECT * FROM devices WHERE status = 'active'
```

[Bob calls select_query tool]

**Results**:
Found 5 active devices:

1. Router-Core-01 (192.168.1.1) - Router in Data Center A
2. Switch-Access-01 (192.168.1.10) - Switch in Data Center A
3. Switch-Access-02 (192.168.1.11) - Switch in Data Center A
4. Firewall-Edge-01 (192.168.1.254) - Firewall in Data Center A
5. Server-Web-01 (192.168.2.10) - Server in Data Center B

All devices are currently active and operational.
```

This shows Phase 2 is working correctly!

## Summary

Phase 2 configures Bob AI to:
- ✅ Connect to the MCP server
- ✅ Discover and use database tools
- ✅ Generate SQL queries from natural language
- ✅ Execute queries safely
- ✅ Format and present results clearly

Once verified, you're ready for Phase 3: Chat Interface!