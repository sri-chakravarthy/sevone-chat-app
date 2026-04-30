# SevOne Chat Application - Detailed Design Document

## Overview
A chat-based interface for querying and interacting with a SevOne MySQL database using Bob AI with a specialized SQL expert prompt and chain-of-thought reasoning.

---

## Architecture Components

### 1. **Bob AI Agent (Prompt-Based SQL Expert)**

#### Purpose
Acts as an intelligent intermediary between user natural language queries and SQL database operations using a specialized system prompt.

#### Implementation Approach
Instead of creating a custom Bob Mode, we use Bob's existing capabilities with a **specialized system prompt** that:
- Defines the SQL expert persona
- Provides database schema context
- Guides chain-of-thought reasoning
- Instructs tool usage patterns

#### System Prompt Structure
```
You are a SQL expert assistant for the SevOne monitoring system. Your role is to:

1. Understand user queries in natural language
2. Analyze the provided database schema
3. Generate appropriate SQL queries using chain-of-thought reasoning
4. Use the available MCP tools to execute queries
5. Present results in a clear, user-friendly format

CHAIN-OF-THOUGHT PROCESS:
- First, identify the user's intent (read data or insert data)
- Then, examine the schema to find relevant tables and columns
- Next, construct the SQL query step-by-step
- Validate the query for safety (no destructive operations)
- Finally, use the appropriate tool (select_query or insert_query)

AVAILABLE SCHEMA:
{schema_information}

SAFETY RULES:
- Only SELECT and INSERT operations are allowed
- Always use parameterized queries for INSERT
- Validate all user inputs
- Explain your reasoning before executing queries
```

#### Key Responsibilities
- Parse and understand user intent from natural language input
- Access and analyze MySQL database schema (provided in prompt context)
- Generate appropriate SQL queries using chain-of-thought reasoning
- Validate query safety and correctness
- Format and present results to users

#### Chain-of-Thought Process
```
User Input → Intent Analysis → Schema Consultation → Query Planning →
Query Generation → Validation → Tool Selection → Execution → Result Formatting
```

#### Schema Access Strategy
- Schema information injected into system prompt at initialization
- Updated dynamically when schema changes
- Includes: table names, column names, data types, relationships, constraints

---

### 2. **MCP Server (MySQL Database Connector) - Python**

#### Purpose
Provides secure, controlled access to MySQL database operations through standardized tools.

#### Architecture
```
MCP Server (Python)
├── Configuration Layer
│   ├── Database Connection Settings
│   ├── Credentials Management
│   └── Connection Pool
├── Tool Layer
│   ├── select_query Tool
│   └── insert_query Tool
└── Security Layer
    ├── Query Validation
    ├── Parameter Sanitization
    └── Error Handling
```

#### Tool Specifications

##### **Tool 1: select_query**
```python
@server.tool()
async def select_query(query: str, parameters: list[str] | None = None) -> dict:
    """
    Execute SELECT queries on MySQL database
    
    Args:
        query: SQL SELECT query to execute
        parameters: Optional parameterized query values
        
    Returns:
        dict with 'rows', 'row_count', 'execution_time', 'columns'
    """
```

**Features**:
- Read-only operations
- Supports parameterized queries
- Returns structured dictionary results
- Includes row count and execution time
- Query timeout protection

##### **Tool 2: insert_query**
```python
@server.tool()
async def insert_query(query: str, parameters: list[str]) -> dict:
    """
    Execute INSERT queries on MySQL database
    
    Args:
        query: SQL INSERT query to execute
        parameters: Parameterized query values (required)
        
    Returns:
        dict with 'insert_id', 'affected_rows', 'success'
    """
```

**Features**:
- Write operations only
- Mandatory parameterized queries (SQL injection prevention)
- Returns inserted row ID and affected rows
- Transaction support
- Rollback on error

#### Configuration Structure
```python
# config.py
from pydantic import BaseModel

class DatabaseConfig(BaseModel):
    host: str = "localhost"
    port: int = 3306
    database: str = "sevone_db"
    user: str = "sevone_user"
    password: str  # From environment variable
    pool_size: int = 10
    connect_timeout: int = 10
    
class SecurityConfig(BaseModel):
    allowed_operations: list[str] = ["SELECT", "INSERT"]
    max_query_length: int = 5000
    query_timeout: int = 30
    enable_query_logging: bool = True
```

#### Security Features
- Parameterized queries mandatory for INSERT
- Query validation (whitelist operations)
- Connection pooling with limits
- Timeout protection
- SQL injection prevention
- Error sanitization (no sensitive data in errors)

---

### 3. **Chat Interface**

#### User Experience Flow
```
User Input → Chat UI → Bob Agent → MCP Server → MySQL DB
                ↓                      ↓
            Display ← Format Result ← Query Result
```

#### Interface Components
- **Input Area**: Text input for natural language queries
- **Chat History**: Scrollable conversation display
- **Query Visualization**: Shows generated SQL (optional toggle)
- **Result Display**: 
  - Table format for SELECT results
  - Success/error messages for INSERT
  - Row counts and metadata
- **Schema Browser**: Collapsible panel showing available tables/columns

#### Message Types
1. **User Message**: Natural language query
2. **Agent Thinking**: Chain-of-thought reasoning (optional display)
3. **SQL Query**: Generated query (with syntax highlighting)
4. **Result Message**: Formatted query results
5. **Error Message**: User-friendly error explanations

---

## Data Flow

### SELECT Query Flow
```
1. User: "Show me all devices with high CPU usage"
   ↓
2. Bob Agent Analysis:
   - Intent: SELECT query
   - Tables: devices, metrics
   - Conditions: cpu_usage > threshold
   - Chain of thought:
     * Need to join devices and metrics tables
     * Filter by metric_type = 'cpu'
     * Apply threshold condition
   ↓
3. Generated SQL:
   SELECT d.device_name, m.value, m.timestamp
   FROM devices d
   JOIN metrics m ON d.device_id = m.device_id
   WHERE m.metric_type = 'cpu' AND m.value > 80
   ORDER BY m.value DESC
   ↓
4. MCP Server: select_query tool execution
   ↓
5. MySQL: Query execution
   ↓
6. Result: JSON array of rows
   ↓
7. Bob Agent: Format as readable table
   ↓
8. User: Displays formatted results
```

### INSERT Query Flow
```
1. User: "Add a new device named 'Router-01' with IP 192.168.1.1"
   ↓
2. Bob Agent Analysis:
   - Intent: INSERT query
   - Table: devices
   - Values: name='Router-01', ip='192.168.1.1'
   - Chain of thought:
     * Identify target table structure
     * Extract values from natural language
     * Generate parameterized INSERT
   ↓
3. Generated SQL:
   INSERT INTO devices (device_name, ip_address, created_at)
   VALUES (?, ?, NOW())
   Parameters: ['Router-01', '192.168.1.1']
   ↓
4. MCP Server: insert_query tool execution
   ↓
5. MySQL: Query execution with parameters
   ↓
6. Result: { insertId: 123, affectedRows: 1 }
   ↓
7. Bob Agent: Format success message
   ↓
8. User: "Successfully added device 'Router-01' (ID: 123)"
```

---

## Technology Stack

### Bob AI Agent
- **Framework**: Bob AI (existing installation)
- **Approach**: Prompt-based (no custom mode needed)
- **Language**: Python (for any helper scripts)
- **System Prompt**: Specialized SQL expert prompt with schema context

### MCP Server
- **Framework**: MCP Python SDK
- **Language**: Python 3.11+
- **Database Driver**: mysql-connector-python or aiomysql
- **Dependencies**:
  - mcp (Python MCP SDK)
  - mysql-connector-python or aiomysql
  - pydantic (configuration validation)
  - python-dotenv (environment variables)

### Chat Interface
- **Frontend**: Streamlit (Python-based, simple and fast)
- **Alternative**: Gradio (even simpler Python UI)
- **Communication**: Direct Bob AI API calls
- **Styling**: Built-in Streamlit/Gradio themes

---

## Project Structure

```
sevone-chat-app-mysql/
├── mcp-server/
│   ├── src/
│   │   ├── __init__.py
│   │   ├── server.py                # MCP server entry point
│   │   ├── tools/
│   │   │   ├── __init__.py
│   │   │   ├── select_query.py      # SELECT tool implementation
│   │   │   └── insert_query.py      # INSERT tool implementation
│   │   ├── database/
│   │   │   ├── __init__.py
│   │   │   ├── connection.py        # DB connection pool
│   │   │   ├── validator.py         # Query validation
│   │   │   └── schema.py            # Schema extraction
│   │   └── config/
│   │       ├── __init__.py
│   │       └── settings.py          # Configuration models
│   ├── tests/
│   │   ├── test_tools.py
│   │   └── test_validation.py
│   ├── pyproject.toml               # Python dependencies
│   ├── requirements.txt
│   └── README.md
│
├── chat-interface/
│   ├── app.py                       # Streamlit/Gradio app
│   ├── prompts/
│   │   └── sql_expert_prompt.txt    # System prompt template
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── bob_client.py            # Bob AI integration
│   │   └── formatters.py            # Result formatting
│   ├── requirements.txt
│   └── README.md
│
├── scripts/
│   ├── setup_database.py            # Database initialization
│   ├── extract_schema.py            # Schema extraction utility
│   └── test_connection.py           # Connection testing
│
├── docs/
│   ├── DESIGN.md                    # This document
│   ├── SETUP.md                     # Setup instructions
│   └── PROMPT_GUIDE.md              # Prompt engineering guide
│
├── .env.example
├── docker-compose.yml               # MySQL + app containers
├── pyproject.toml                   # Root project config
└── README.md
```

---

## Configuration Management

### Environment Variables (.env)
```bash
# MySQL Database
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_DATABASE=sevone_db
MYSQL_USER=sevone_user
MYSQL_PASSWORD=secure_password
MYSQL_POOL_SIZE=10

# Bob AI (if using API)
BOB_API_KEY=your_api_key_here
BOB_API_ENDPOINT=http://localhost:8080

# MCP Server
MCP_SERVER_HOST=localhost
MCP_SERVER_PORT=3001

# Application
LOG_LEVEL=INFO
ENABLE_QUERY_LOGGING=true
```

### Bob Configuration (bob_config.json)
```json
{
  "mcpServers": {
    "sevone-mysql": {
      "command": "python",
      "args": ["-m", "mcp_server.src.server"],
      "env": {
        "MYSQL_HOST": "${MYSQL_HOST}",
        "MYSQL_PORT": "${MYSQL_PORT}",
        "MYSQL_DATABASE": "${MYSQL_DATABASE}",
        "MYSQL_USER": "${MYSQL_USER}",
        "MYSQL_PASSWORD": "${MYSQL_PASSWORD}"
      }
    }
  }
}
```

### System Prompt Template (sql_expert_prompt.txt)
```
You are a SQL expert assistant for the SevOne monitoring system database.

DATABASE SCHEMA:
{schema}

YOUR CAPABILITIES:
- Understand natural language queries about the SevOne database
- Generate accurate SQL queries (SELECT and INSERT only)
- Use chain-of-thought reasoning to explain your query construction
- Execute queries using the available MCP tools

AVAILABLE TOOLS:
1. select_query(query, parameters) - Execute SELECT queries
2. insert_query(query, parameters) - Execute INSERT queries with required parameters

REASONING PROCESS:
1. Analyze user intent
2. Identify relevant tables and columns from schema
3. Construct SQL query step-by-step
4. Validate query safety
5. Execute using appropriate tool
6. Format results clearly

SAFETY RULES:
- Only SELECT and INSERT operations allowed
- Always use parameterized queries for INSERT
- Explain your reasoning before executing
- Validate all inputs against schema
```

---

## Security Considerations

### 1. **SQL Injection Prevention**
- All INSERT queries use parameterized statements
- Query validation before execution
- Whitelist allowed SQL operations

### 2. **Access Control**
- Read-only SELECT operations by default
- INSERT operations require explicit permission
- No UPDATE or DELETE operations (can be added with proper controls)

### 3. **Data Protection**
- Sensitive data masked in logs
- Error messages sanitized
- Connection credentials in environment variables

### 4. **Rate Limiting**
- Query execution timeout
- Connection pool limits
- Request throttling in chat interface

---

## Error Handling Strategy

### Bob Agent Error Handling (via Prompt)
The system prompt includes error handling guidance:
```
ERROR HANDLING:
- If a table/column doesn't exist in schema, inform the user clearly
- If query validation fails, explain why and suggest corrections
- If database connection fails, report the issue
- Always provide helpful suggestions for fixing errors
```

### MCP Server Error Handling (Python)
```python
try:
    # Query execution
    result = await execute_query(query, parameters)
    return {"success": True, "data": result}
except mysql.connector.Error as e:
    if e.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        return {"success": False, "error": "Database access denied"}
    elif e.errno == errorcode.ER_BAD_DB_ERROR:
        return {"success": False, "error": "Database does not exist"}
    else:
        return {"success": False, "error": f"Database error: {str(e)}"}
except Exception as e:
    return {"success": False, "error": f"Unexpected error: {str(e)}"}
```

### MCP Server Error Handling
- Database connection errors → Retry with exponential backoff
- Query syntax errors → Return detailed error to agent
- Timeout errors → Cancel query and return timeout message
- Permission errors → Return access denied message

---

## Performance Optimization

### 1. **Schema Caching**
- Load schema once at startup
- Refresh on-demand or periodically
- Store in memory for fast access

### 2. **Connection Pooling**
- Reuse database connections
- Configure pool size based on load
- Automatic connection recycling

### 3. **Query Optimization**
- Agent suggests indexes for slow queries
- Query result pagination for large datasets
- Limit result set size by default

### 4. **Response Streaming**
- Stream large result sets
- Progressive rendering in UI
- Chunked data transfer

---

## Testing Strategy

### Unit Tests
- Bob Agent: Query generation logic
- MCP Server: Tool implementations
- Validators: SQL validation functions

### Integration Tests
- End-to-end query flow
- MCP server connection handling
- Error scenarios

### Security Tests
- SQL injection attempts
- Invalid query handling
- Permission boundary testing

---

## Deployment Considerations

### Development Environment
```bash
# Start MySQL
docker-compose up -d mysql

# Install dependencies
pip install -r requirements.txt

# Start MCP Server
cd mcp-server && python -m src.server

# Start Chat Interface (Streamlit)
cd chat-interface && streamlit run app.py

# Or with Gradio
cd chat-interface && python app.py
```

### Production Environment
- MCP Server: Containerized with Docker
- Chat Interface: Streamlit Cloud, Hugging Face Spaces, or Docker container
- MySQL: Managed database service (AWS RDS, Azure Database, Google Cloud SQL)
- Bob AI: Use existing Bob installation or API endpoint

---

## Future Enhancements

### Phase 2 Features
1. **Query History**: Save and replay previous queries
2. **Favorites**: Bookmark common queries
3. **Export Results**: CSV, JSON, Excel export
4. **Visualization**: Charts and graphs for numeric data
5. **Multi-database Support**: Connect to multiple databases
6. **UPDATE/DELETE Operations**: With additional safety controls
7. **Query Optimization Suggestions**: Agent recommends improvements
8. **Natural Language Insights**: Agent provides data analysis

### Advanced Features
1. **Voice Input**: Speech-to-text for queries
2. **Scheduled Queries**: Automated report generation
3. **Alerts**: Notify on specific data conditions
4. **Collaboration**: Share queries and results with team
5. **Audit Logging**: Track all database operations
6. **Role-based Access**: Different permissions per user

---

## Key Design Decisions

### Why Python?
1. **Simplicity**: Python is more concise and easier to maintain
2. **MCP SDK**: Official Python MCP SDK is well-supported
3. **Database Libraries**: Mature MySQL libraries (mysql-connector-python, aiomysql)
4. **UI Frameworks**: Streamlit/Gradio provide instant UI with minimal code
5. **Integration**: Easier integration with data science tools if needed

### Why Prompt-Based Instead of Custom Mode?
1. **Simplicity**: No need to build and maintain a custom Bob mode
2. **Flexibility**: Easy to update and refine the prompt
3. **Portability**: Works with any Bob installation
4. **Maintainability**: Prompt changes don't require code deployment
5. **Transparency**: Users can see and understand the system prompt
6. **Cost-Effective**: Leverages existing Bob capabilities

### Prompt Engineering Benefits
- **Schema Context**: Inject schema directly into prompt
- **Chain-of-Thought**: Guide reasoning through prompt instructions
- **Tool Usage**: Teach tool selection via examples in prompt
- **Error Handling**: Define error responses in prompt
- **Customization**: Easy to adjust behavior by editing prompt

---

## Success Metrics

### Performance Metrics
- Query response time < 2 seconds (90th percentile)
- MCP tool execution time < 500ms
- UI responsiveness < 100ms

### Accuracy Metrics
- Query generation accuracy > 95%
- Schema understanding accuracy > 98%
- Error handling coverage > 99%

### User Experience Metrics
- User satisfaction score > 4.5/5
- Task completion rate > 90%
- Query reformulation rate < 10%

---

## Conclusion

This simplified design provides a robust, secure, and user-friendly chat interface for interacting with SevOne's MySQL database using Python throughout the stack. The prompt-based approach with Bob AI eliminates the complexity of custom mode development while maintaining all required functionality. The chain-of-thought reasoning is guided through the system prompt, and the Python MCP server provides secure database access. This architecture is easier to develop, maintain, and deploy compared to a TypeScript-based solution with custom modes.