# Phase 2: Bob AI Agent Implementation Plan

## Overview

Phase 2 focuses on configuring Bob AI to work as a SQL expert using the MCP server created in Phase 1. This phase uses a **prompt-based approach** rather than creating a custom Bob mode.

## Status

⏳ **Phase 2 - Planned (Not Yet Started)**

## Objectives

1. Configure Bob AI to connect to the MCP server
2. Create and optimize the SQL expert system prompt
3. Test the AI agent's ability to generate and execute queries
4. Validate chain-of-thought reasoning
5. Ensure proper error handling and user feedback

## Architecture

```
User Query → Bob AI (with SQL Expert Prompt) → MCP Server → MySQL Database
                ↓                                    ↓
            Chain-of-Thought                   Query Results
                ↓                                    ↓
            SQL Generation                    Formatted Response
```

## Implementation Steps

### Step 1: MCP Server Configuration

**File**: `bob_config.json` (in Bob AI configuration directory)

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

**Tasks**:
- [ ] Locate Bob AI configuration directory
- [ ] Create or update `bob_config.json`
- [ ] Set environment variables for database connection
- [ ] Test MCP server connection from Bob AI
- [ ] Verify tools are available (select_query, insert_query, get_schema)

### Step 2: System Prompt Development

**File**: `chat-interface/prompts/sql_expert_prompt.txt`

**Prompt Structure**:
1. **Role Definition**: Define Bob as SQL expert for SevOne
2. **Schema Context**: Inject database schema information
3. **Capabilities**: List available tools and operations
4. **Reasoning Process**: Define chain-of-thought steps
5. **Safety Rules**: Specify security constraints
6. **Error Handling**: Define error response patterns
7. **Response Format**: Specify output structure

**Tasks**:
- [ ] Create base system prompt
- [ ] Add schema injection mechanism
- [ ] Define chain-of-thought template
- [ ] Add example queries and responses
- [ ] Test prompt with various query types
- [ ] Refine based on testing results

### Step 3: Schema Integration

**Approach**: Dynamic schema loading

```python
# Pseudo-code for schema integration
schema = await mcp_client.call_tool("get_schema", {"refresh": False})
formatted_schema = format_schema_for_prompt(schema)
system_prompt = base_prompt.replace("{schema}", formatted_schema)
```

**Tasks**:
- [ ] Create schema extraction script
- [ ] Format schema for prompt injection
- [ ] Implement schema caching mechanism
- [ ] Add schema refresh capability
- [ ] Test with different database schemas

### Step 4: Chain-of-Thought Implementation

**Process Flow**:
```
1. User Query Analysis
   ↓
2. Intent Identification (SELECT vs INSERT)
   ↓
3. Schema Consultation
   ↓
4. Query Planning
   ↓
5. SQL Generation
   ↓
6. Validation
   ↓
7. Tool Selection
   ↓
8. Execution
   ↓
9. Result Formatting
```

**Prompt Instructions**:
```
REASONING PROCESS:
Before executing any query, you must:
1. Analyze the user's intent
2. Identify relevant tables and columns from the schema
3. Plan the SQL query structure
4. Generate the SQL query
5. Validate it meets safety requirements
6. Execute using the appropriate tool
7. Format the results for the user

Always show your reasoning before executing queries.
```

**Tasks**:
- [ ] Define reasoning steps in prompt
- [ ] Add examples of chain-of-thought reasoning
- [ ] Test reasoning quality with sample queries
- [ ] Refine prompt based on reasoning accuracy

### Step 5: Tool Usage Patterns

**SELECT Query Pattern**:
```
User: "Show me all active devices"

Bob's Reasoning:
1. Intent: Retrieve data (SELECT query)
2. Table: devices
3. Condition: status = 'active'
4. Query: SELECT * FROM devices WHERE status = 'active'

Bob executes: select_query(query, parameters)
```

**INSERT Query Pattern**:
```
User: "Add a new device named Router-02 with IP 192.168.1.2"

Bob's Reasoning:
1. Intent: Add data (INSERT query)
2. Table: devices
3. Values: name='Router-02', ip='192.168.1.2'
4. Query: INSERT INTO devices (device_name, ip_address) VALUES (%s, %s)
5. Parameters: ['Router-02', '192.168.1.2']

Bob executes: insert_query(query, parameters)
```

**Tasks**:
- [ ] Document tool usage patterns in prompt
- [ ] Add examples for each tool
- [ ] Test tool selection accuracy
- [ ] Validate parameter handling

### Step 6: Error Handling

**Error Scenarios**:
1. Invalid table/column names
2. Query validation failures
3. Database connection errors
4. Permission errors
5. Syntax errors

**Prompt Instructions**:
```
ERROR HANDLING:
- If a table/column doesn't exist, inform the user and suggest alternatives
- If query validation fails, explain why and provide corrections
- If database connection fails, report the issue clearly
- Always provide helpful suggestions for fixing errors
- Never expose sensitive information in error messages
```

**Tasks**:
- [ ] Define error handling patterns in prompt
- [ ] Test error scenarios
- [ ] Validate error message quality
- [ ] Ensure no sensitive data leakage

### Step 7: Testing & Validation

**Test Categories**:

1. **Basic Queries**
   - Simple SELECT statements
   - Filtered SELECT with WHERE
   - JOIN operations
   - Aggregate functions (COUNT, SUM, AVG)

2. **Complex Queries**
   - Multi-table JOINs
   - Subqueries
   - GROUP BY with HAVING
   - ORDER BY and LIMIT

3. **INSERT Operations**
   - Single row insert
   - Multiple column insert
   - Parameterized inserts

4. **Error Cases**
   - Invalid table names
   - Invalid column names
   - SQL injection attempts
   - Dangerous operations (DROP, DELETE)

5. **Edge Cases**
   - Empty result sets
   - Large result sets
   - Special characters in data
   - NULL values

**Tasks**:
- [ ] Create test query suite
- [ ] Execute all test queries
- [ ] Document results and issues
- [ ] Refine prompt based on test results
- [ ] Achieve >95% accuracy on test suite

### Step 8: Performance Optimization

**Optimization Areas**:
1. Schema caching to reduce load time
2. Query result pagination for large datasets
3. Prompt length optimization
4. Response time monitoring

**Tasks**:
- [ ] Implement schema caching
- [ ] Add query result limits
- [ ] Optimize prompt length
- [ ] Monitor and log performance metrics

## Deliverables

1. **Configuration Files**
   - `bob_config.json` - MCP server configuration
   - `.env` - Environment variables

2. **Prompt Files**
   - `sql_expert_prompt.txt` - Base system prompt
   - `prompt_examples.md` - Example queries and responses

3. **Documentation**
   - `PHASE2_SETUP.md` - Setup instructions
   - `PHASE2_TESTING.md` - Test results and validation
   - `PROMPT_GUIDE.md` - Prompt engineering guide

4. **Test Suite**
   - `test_queries.json` - Test query collection
   - `test_results.md` - Test execution results

## Success Criteria

- [ ] Bob AI successfully connects to MCP server
- [ ] All three tools are accessible (select_query, insert_query, get_schema)
- [ ] Schema is correctly loaded and injected into prompt
- [ ] Chain-of-thought reasoning is clear and logical
- [ ] Query generation accuracy > 95%
- [ ] Error handling is appropriate and helpful
- [ ] No security vulnerabilities (SQL injection, etc.)
- [ ] Response time < 5 seconds for typical queries

## Dependencies

**Prerequisites**:
- ✅ Phase 1: MCP Server must be complete and tested
- ✅ MySQL database must be set up
- ⏳ Bob AI must be installed and configured

**Required for Phase 3**:
- All Phase 2 deliverables must be complete
- Bob AI must be validated and working correctly

## Timeline Estimate

- **Step 1-2**: 2-3 hours (Configuration and base prompt)
- **Step 3-4**: 3-4 hours (Schema integration and reasoning)
- **Step 5-6**: 2-3 hours (Tool patterns and error handling)
- **Step 7**: 4-5 hours (Comprehensive testing)
- **Step 8**: 1-2 hours (Optimization)

**Total**: 12-17 hours

## Risk Mitigation

**Risks**:
1. Prompt may not generate accurate SQL
2. Chain-of-thought may be unclear
3. Error handling may be insufficient
4. Performance may be slow

**Mitigations**:
1. Iterative prompt refinement with testing
2. Clear reasoning templates in prompt
3. Comprehensive error scenarios in prompt
4. Schema caching and query optimization

## Next Steps

After Phase 2 completion:
1. Validate all functionality
2. Document any issues or limitations
3. Proceed to Phase 3 (Chat Interface)
4. Integrate Bob AI with web interface

## References

- [DESIGN.md](../DESIGN.md) - Overall architecture
- [Phase 1 README](../mcp-server/README.md) - MCP Server documentation
- Bob AI Documentation - Tool usage and configuration
- MCP Protocol Specification - Server/client communication