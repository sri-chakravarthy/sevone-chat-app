# How Bob AI Uses the MCP Server

This document explains how Bob AI interacts with the MCP server - it's completely different from the manual testing scripts!

## The Key Difference

**Manual Testing (What You Do)**:
- You write Python scripts to test the MCP server directly
- You call functions like `select_query_tool()` in Python
- This is just for development/testing

**Bob AI Usage (What Happens in Production)**:
- Bob AI communicates with the MCP server via the **MCP Protocol** (JSON-RPC over stdio)
- Bob AI doesn't write Python code - it uses the MCP tools as **built-in capabilities**
- The MCP server runs as a **separate process** that Bob AI talks to

## Architecture Flow

```
┌─────────────────────────────────────────────────────────────┐
│                         User                                 │
│  "Show me all active devices"                                │
└────────────────────────┬────────────────────────────────────┘
                         │ (natural language)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Bob AI Agent                            │
│  • Reads system prompt with SQL expertise                    │
│  • Analyzes user intent                                      │
│  • Generates SQL: SELECT * FROM devices WHERE status='active'│
│  • Decides to use: select_query tool                         │
└────────────────────────┬────────────────────────────────────┘
                         │ (MCP Protocol - JSON-RPC)
                         │ {
                         │   "method": "tools/call",
                         │   "params": {
                         │     "name": "select_query",
                         │     "arguments": {
                         │       "query": "SELECT * FROM devices WHERE status='active'",
                         │       "parameters": null
                         │     }
                         │   }
                         │ }
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                    MCP Server Process                        │
│  • Receives JSON-RPC request                                 │
│  • Validates the query                                       │
│  • Executes against MySQL                                    │
│  • Returns results as JSON                                   │
└────────────────────────┬────────────────────────────────────┘
                         │ (JSON response)
                         │ {
                         │   "success": true,
                         │   "rows": [...],
                         │   "row_count": 5
                         │ }
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                      Bob AI Agent                            │
│  • Receives results                                          │
│  • Formats for user                                          │
│  • Presents in chat interface                                │
└────────────────────────┬────────────────────────────────────┘
                         │ (formatted response)
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                         User                                 │
│  Sees: "Found 5 active devices: Router-01, Switch-01..."    │
└─────────────────────────────────────────────────────────────┘
```

## How Bob AI Discovers and Uses Tools

### Step 1: Bob AI Starts MCP Server

When Bob AI starts, it reads `bob_config.json`:

```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "mcp_server.src.server"],
      "env": { ... }
    }
  }
}
```

Bob AI then:
1. Spawns the MCP server as a subprocess
2. Connects to it via stdin/stdout
3. Sends a `tools/list` request

### Step 2: MCP Server Advertises Tools

The MCP server responds with available tools:

```json
{
  "tools": [
    {
      "name": "select_query",
      "description": "Execute SELECT queries on MySQL database",
      "inputSchema": {
        "type": "object",
        "properties": {
          "query": { "type": "string" },
          "parameters": { "type": "array" }
        }
      }
    },
    {
      "name": "insert_query",
      "description": "Execute INSERT queries on MySQL database",
      "inputSchema": { ... }
    },
    {
      "name": "get_schema",
      "description": "Get database schema",
      "inputSchema": { ... }
    }
  ]
}
```

### Step 3: Bob AI Uses Tools

When Bob AI needs to query the database:

**User asks**: "Show me all devices"

**Bob AI thinks** (chain-of-thought):
```
1. User wants to see devices
2. I need to query the devices table
3. I'll use SELECT query
4. I have a tool called "select_query" for this
5. I'll call it with the appropriate SQL
```

**Bob AI calls tool** (via MCP Protocol):
```json
{
  "jsonrpc": "2.0",
  "method": "tools/call",
  "params": {
    "name": "select_query",
    "arguments": {
      "query": "SELECT * FROM devices",
      "parameters": null
    }
  },
  "id": 1
}
```

**MCP Server responds**:
```json
{
  "jsonrpc": "2.0",
  "result": {
    "content": [
      {
        "type": "text",
        "text": "Query executed successfully in 0.05s\nRows returned: 5\n\nResults:\n..."
      }
    ]
  },
  "id": 1
}
```

**Bob AI formats and shows to user**:
```
I found 5 devices in the database:

1. Router-Core-01 (192.168.1.1)
2. Switch-Access-01 (192.168.1.10)
3. Switch-Access-02 (192.168.1.11)
4. Firewall-Edge-01 (192.168.1.254)
5. Server-Web-01 (192.168.2.10)
```

## Real Example: Complete Flow

### User Query
```
User: "How many alerts do we have with critical severity?"
```

### Bob AI Processing

**Step 1: Analyze Intent**
```
Bob AI thinks:
- User wants a count
- Filtering by severity = 'critical'
- Need to query alerts table
- Use COUNT() function
```

**Step 2: Generate SQL**
```sql
SELECT COUNT(*) as count 
FROM alerts 
WHERE severity = 'critical'
```

**Step 3: Call MCP Tool**
```json
{
  "method": "tools/call",
  "params": {
    "name": "select_query",
    "arguments": {
      "query": "SELECT COUNT(*) as count FROM alerts WHERE severity = %s",
      "parameters": ["critical"]
    }
  }
}
```

**Step 4: Receive Response**
```json
{
  "result": {
    "success": true,
    "rows": [{"count": 12}],
    "row_count": 1,
    "execution_time": 0.03
  }
}
```

**Step 5: Format for User**
```
Bob AI responds:
"There are currently 12 alerts with critical severity in the system."
```

## Key Points

### 1. No Python Scripts in Production
- Bob AI **never writes or executes Python code**
- It uses the MCP Protocol (JSON-RPC) to communicate
- The MCP server handles all Python execution

### 2. Tools Are Like Functions
- Bob AI sees tools as built-in functions it can call
- Just like it can "read files" or "execute commands"
- It can now "query database" via MCP tools

### 3. System Prompt Guides Usage
The system prompt tells Bob AI:
```
AVAILABLE TOOLS:
1. select_query(query, parameters) - Execute SELECT queries
2. insert_query(query, parameters) - Execute INSERT queries
3. get_schema(refresh) - Get database schema

When user asks about data, use select_query.
When user wants to add data, use insert_query.
Always show your reasoning before calling tools.
```

### 4. Bob AI Handles Everything
- Query generation
- Parameter extraction
- Tool selection
- Result formatting
- Error handling
- User communication

## Comparison: Manual Testing vs Production

### Manual Testing (Development)
```python
# You write this to test
import asyncio
from src.tools.select_query import select_query_tool

async def test():
    result = await select_query_tool(db, validator, "SELECT * FROM devices", None)
    print(result)

asyncio.run(test())
```

### Production (Bob AI)
```
User: "Show me all devices"

Bob AI (internally):
1. Analyzes: User wants device list
2. Generates: SELECT * FROM devices
3. Calls: select_query tool via MCP Protocol
4. Receives: Results from MCP server
5. Formats: "Here are your devices: ..."
6. Shows: Formatted response to user
```

**You never write the production code - Bob AI does it all!**

## Configuration Example

### bob_config.json
```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "mcp_server.src.server"],
      "cwd": "/path/to/mcp-server",
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_DATABASE": "sevone_db",
        "MYSQL_USER": "sevone_user",
        "MYSQL_PASSWORD": "secret"
      }
    }
  }
}
```

This tells Bob AI:
- Start the MCP server using Python
- Run it from the mcp-server directory
- Pass these environment variables
- Connect to it via stdin/stdout

## What You Need to Do

### Phase 1 (Done ✅)
- Implement MCP server
- Test it manually to ensure it works
- Verify tools function correctly

### Phase 2 (Next)
1. **Configure Bob AI** to connect to MCP server
2. **Create system prompt** that teaches Bob AI about:
   - Database schema
   - Available tools
   - How to generate SQL
   - When to use each tool
3. **Test with Bob AI** by asking questions
4. **Refine prompt** based on results

### Phase 3 (Later)
- Build chat interface
- Connect to Bob AI
- Let users interact naturally

## Testing the Integration

Once Bob AI is configured, test like this:

```
You: "Can you list the available tools?"
Bob: "I have access to these tools:
      - select_query: Execute SELECT queries
      - insert_query: Execute INSERT queries  
      - get_schema: Get database schema"

You: "Get the database schema"
Bob: [Calls get_schema tool]
     "The database has 4 tables: devices, metrics, alerts, users..."

You: "Show me all active devices"
Bob: [Generates SQL, calls select_query tool]
     "I found 5 active devices:
      1. Router-Core-01 (192.168.1.1)
      2. Switch-Access-01 (192.168.1.10)
      ..."
```

## Summary

**Manual Testing Scripts**: For you to verify MCP server works
**Bob AI Usage**: Automatic via MCP Protocol - no scripts needed!

Bob AI:
1. Reads your system prompt (SQL expert instructions)
2. Discovers available MCP tools
3. Generates SQL based on user questions
4. Calls appropriate MCP tool
5. Formats and presents results

You just need to:
1. ✅ Build MCP server (Phase 1 - Done!)
2. ⏳ Configure Bob AI and create prompt (Phase 2)
3. ⏳ Build chat interface (Phase 3)

The MCP Protocol handles all the communication automatically!