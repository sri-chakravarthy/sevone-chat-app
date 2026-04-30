# Phase 2 Quick Start Guide

Get Bob AI working with your database in 5 minutes!

## Quick Setup

### 1. Copy Configuration (30 seconds)

```bash
# Copy Bob config to your Bob AI directory
cp bob_config.json ~/.config/bob/bob_config.json

# Update the path in bob_config.json
# Change "cwd" to your actual mcp-server path
```

### 2. Update Paths (1 minute)

Edit `~/.config/bob/bob_config.json`:

```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "src.server"],
      "cwd": "/Users/YOUR_USERNAME/path/to/sevone-chat-app-mysql/mcp-server",
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_DATABASE": "employee_management",
        "MYSQL_USER": "root",
        "MYSQL_PASSWORD": "${MYSQL_PASSWORD}"
      }
    }
  }
}
```

Get your full path:
```bash
cd mcp-server
pwd  # Copy this output to "cwd"
```

### 3. Set Password (30 seconds)

```bash
# Add to ~/.bashrc or ~/.zshrc
export MYSQL_PASSWORD="your_mysql_password"

# Reload
source ~/.bashrc
```

### 4. Restart Bob AI (30 seconds)

Restart Bob AI to load the new configuration.

### 5. Test It! (2 minutes)

Open Bob AI and try:

```
Can you list the available MCP tools?
```

Expected: Should show `get_schema`, `select_query`, `insert_query`

```
Get the database schema
```

Expected: Should show your database tables and columns

```
Show me all records from [your_table_name]
```

Expected: Should display your data

## That's It!

You're now ready to query your database with natural language!

## Example Queries to Try

### Basic Queries
```
- "Show me all devices"
- "Count how many alerts we have"
- "List all active devices"
- "Show me the first 5 metrics"
```

### Filtered Queries
```
- "Find devices with IP starting with 192.168"
- "Show me critical alerts"
- "List devices in Data Center A"
```

### Complex Queries
```
- "Show me devices that have alerts"
- "Count alerts by severity"
- "Find devices with the most metrics"
```

### Insert Operations
```
- "Add a new device named Router-99 with IP 192.168.99.99"
- "Insert a test device"
```

## Troubleshooting

### Bob AI doesn't see the MCP server

1. Check config file location: `~/.config/bob/bob_config.json`
2. Verify the `cwd` path is correct
3. Restart Bob AI

### "Access denied" error

1. Check password in environment: `echo $MYSQL_PASSWORD`
2. Test MySQL connection: `mysql -u root -p your_database`
3. Update password in shell config

### Tools not working

1. Verify MCP server runs: `cd mcp-server && python -m src.server`
2. Check for errors in server output
3. Verify database connection

## System Prompt (Optional)

For best results, start your Bob AI session with:

```
You are a SQL expert for the SevOne database. When users ask questions:
1. Show your chain-of-thought reasoning
2. Generate appropriate SQL queries
3. Use the MCP tools (get_schema, select_query, insert_query)
4. Format results clearly
5. Explain what the results mean

Always use parameterized queries for INSERT operations.
```

Or use the full prompt from `prompts/sql_expert_system_prompt.md`

## Next Steps

- ✅ Phase 1: MCP Server (Complete)
- ✅ Phase 2: Bob AI Configuration (Complete)
- ⏳ Phase 3: Chat Interface (Next)

See [`docs/PHASE2_SETUP.md`](PHASE2_SETUP.md) for detailed setup instructions.

## Need Help?

- [Troubleshooting Guide](TROUBLESHOOTING.md)
- [Phase 2 Setup Guide](PHASE2_SETUP.md)
- [How Bob Uses MCP](HOW_BOB_USES_MCP.md)