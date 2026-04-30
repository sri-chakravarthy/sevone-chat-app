# Phase 3: Chat Interface Implementation Plan

## Overview

Phase 3 focuses on creating a user-friendly web-based chat interface using Streamlit that connects users to the Bob AI agent configured in Phase 2.

## Status

⏳ **Phase 3 - Planned (Not Yet Started)**

## Objectives

1. Create intuitive chat interface using Streamlit
2. Integrate with Bob AI agent from Phase 2
3. Display query results in user-friendly format
4. Provide schema browsing capabilities
5. Implement chat history and session management
6. Add query examples and help features

## Architecture

```
User Browser → Streamlit App → Bob AI Agent → MCP Server → MySQL Database
      ↓              ↓              ↓              ↓
   Chat UI      Session Mgmt   SQL Generation  Query Exec
      ↓              ↓              ↓              ↓
   Display      History Store  Result Format  Data Return
```

## Technology Stack

- **Frontend Framework**: Streamlit (Python-based)
- **Alternative**: Gradio (simpler option)
- **State Management**: Streamlit session state
- **Styling**: Streamlit built-in themes + custom CSS
- **AI Integration**: Bob AI client library

## Implementation Steps

### Step 1: Basic Streamlit Setup

**File**: `chat-interface/app.py`

**Core Components**:
```python
import streamlit as st

# Page configuration
st.set_page_config(
    page_title="SevOne Database Chat",
    page_icon="💬",
    layout="wide"
)

# Main layout
st.title("SevOne Database Chat Assistant")

# Sidebar for schema browser
with st.sidebar:
    st.header("Database Schema")
    # Schema display

# Main chat area
chat_container = st.container()

# Input area
user_input = st.chat_input("Ask a question about your database...")
```

**Tasks**:
- [ ] Create basic Streamlit app structure
- [ ] Set up page configuration
- [ ] Create main layout (sidebar + chat area)
- [ ] Add basic styling
- [ ] Test app launches successfully

### Step 2: Bob AI Integration

**File**: `chat-interface/utils/bob_client.py`

**Integration Approach**:
```python
class BobAIClient:
    def __init__(self, prompt_template: str, schema: dict):
        self.prompt_template = prompt_template
        self.schema = schema
        self.system_prompt = self._build_system_prompt()
    
    def _build_system_prompt(self) -> str:
        # Inject schema into prompt template
        return self.prompt_template.format(schema=self.schema)
    
    async def send_message(self, user_message: str) -> dict:
        # Send message to Bob AI
        # Return response with reasoning and results
        pass
```

**Tasks**:
- [ ] Create Bob AI client wrapper
- [ ] Implement message sending
- [ ] Handle tool calls (select_query, insert_query)
- [ ] Parse and format responses
- [ ] Add error handling
- [ ] Test with sample queries

### Step 3: Chat Interface Components

**Components to Implement**:

1. **Message Display**
   ```python
   def display_message(role: str, content: str, metadata: dict = None):
       with st.chat_message(role):
           st.write(content)
           if metadata:
               with st.expander("Details"):
                   st.json(metadata)
   ```

2. **Query Result Display**
   ```python
   def display_query_results(results: dict):
       if results["success"]:
           st.dataframe(results["rows"])
           st.caption(f"Rows: {results['row_count']} | Time: {results['execution_time']}s")
       else:
           st.error(results["error"])
   ```

3. **SQL Query Display**
   ```python
   def display_sql_query(query: str):
       with st.expander("Generated SQL"):
           st.code(query, language="sql")
   ```

**Tasks**:
- [ ] Implement message display component
- [ ] Create result table display
- [ ] Add SQL query visualization
- [ ] Implement error message display
- [ ] Add loading indicators
- [ ] Test all components

### Step 4: Schema Browser

**File**: `chat-interface/utils/schema_browser.py`

**Features**:
- Display all tables
- Show columns for each table
- Display data types and constraints
- Show relationships (foreign keys)
- Search functionality

**Implementation**:
```python
def display_schema_browser(schema: dict):
    st.sidebar.header("📊 Database Schema")
    
    # Search box
    search = st.sidebar.text_input("Search tables/columns")
    
    # Table list
    for table in schema["tables"]:
        with st.sidebar.expander(f"📋 {table['name']}"):
            for column in table["columns"]:
                st.write(f"• {column['name']}: {column['data_type']}")
```

**Tasks**:
- [ ] Create schema browser component
- [ ] Add table expansion/collapse
- [ ] Implement column display
- [ ] Add search functionality
- [ ] Show relationships
- [ ] Test with sample schema

### Step 5: Session Management

**Features**:
- Chat history persistence
- Session state management
- Clear history option
- Export chat history

**Implementation**:
```python
# Initialize session state
if "messages" not in st.session_state:
    st.session_state.messages = []

if "schema" not in st.session_state:
    st.session_state.schema = load_schema()

# Add message to history
def add_message(role: str, content: str):
    st.session_state.messages.append({
        "role": role,
        "content": content,
        "timestamp": datetime.now()
    })

# Display chat history
for message in st.session_state.messages:
    display_message(message["role"], message["content"])
```

**Tasks**:
- [ ] Implement session state management
- [ ] Add chat history storage
- [ ] Create clear history function
- [ ] Add export functionality
- [ ] Test session persistence

### Step 6: Query Examples & Help

**Features**:
- Pre-defined example queries
- Query templates
- Help documentation
- Keyboard shortcuts

**Example Queries**:
```python
EXAMPLE_QUERIES = {
    "Basic Queries": [
        "Show all active devices",
        "List devices with high CPU usage",
        "Count total alerts by severity"
    ],
    "Complex Queries": [
        "Show devices with alerts in the last 24 hours",
        "Find top 5 devices by metric value",
        "List devices without recent metrics"
    ],
    "Insert Operations": [
        "Add a new device named Router-03",
        "Insert a metric for device Router-01"
    ]
}
```

**Tasks**:
- [ ] Create example query library
- [ ] Add quick-select buttons
- [ ] Implement help documentation
- [ ] Add tooltips and hints
- [ ] Test example queries

### Step 7: Result Formatting

**File**: `chat-interface/utils/formatters.py`

**Formatters**:
```python
def format_table_result(rows: list, columns: list) -> str:
    # Format as markdown table
    pass

def format_insert_result(result: dict) -> str:
    # Format insert confirmation
    pass

def format_error(error: str) -> str:
    # Format error message with suggestions
    pass

def format_reasoning(reasoning: str) -> str:
    # Format chain-of-thought reasoning
    pass
```

**Tasks**:
- [ ] Implement table formatter
- [ ] Create insert result formatter
- [ ] Add error formatter
- [ ] Implement reasoning formatter
- [ ] Add export formatters (CSV, JSON)
- [ ] Test all formatters

### Step 8: Advanced Features

**Features to Add**:

1. **Query History**
   - Save previous queries
   - Quick re-run
   - Favorite queries

2. **Result Export**
   - CSV download
   - JSON download
   - Copy to clipboard

3. **Visualization**
   - Charts for numeric data
   - Graphs for time series
   - Pie charts for distributions

4. **Settings**
   - Theme selection
   - Result limit configuration
   - Auto-refresh toggle

**Tasks**:
- [ ] Implement query history
- [ ] Add export functionality
- [ ] Create basic visualizations
- [ ] Add settings panel
- [ ] Test advanced features

### Step 9: Error Handling & Validation

**Error Scenarios**:
1. Bob AI connection failure
2. MCP server unavailable
3. Database connection error
4. Invalid query generation
5. Timeout errors

**Implementation**:
```python
try:
    response = await bob_client.send_message(user_input)
    display_response(response)
except ConnectionError:
    st.error("Unable to connect to Bob AI. Please check configuration.")
except TimeoutError:
    st.warning("Query timed out. Try a simpler query.")
except Exception as e:
    st.error(f"An error occurred: {str(e)}")
    logger.error(f"Error: {e}", exc_info=True)
```

**Tasks**:
- [ ] Add comprehensive error handling
- [ ] Implement retry logic
- [ ] Add user-friendly error messages
- [ ] Create error logging
- [ ] Test error scenarios

### Step 10: Testing & Optimization

**Test Categories**:

1. **UI Testing**
   - Layout responsiveness
   - Component rendering
   - User interactions
   - Mobile compatibility

2. **Integration Testing**
   - Bob AI connection
   - Query execution
   - Result display
   - Error handling

3. **Performance Testing**
   - Load time
   - Response time
   - Large result sets
   - Concurrent users

4. **User Experience Testing**
   - Ease of use
   - Clarity of responses
   - Help effectiveness
   - Error message quality

**Tasks**:
- [ ] Create test plan
- [ ] Execute UI tests
- [ ] Perform integration tests
- [ ] Run performance tests
- [ ] Conduct user testing
- [ ] Document issues and fixes

## Deliverables

1. **Application Files**
   - `app.py` - Main Streamlit application
   - `utils/bob_client.py` - Bob AI integration
   - `utils/formatters.py` - Result formatters
   - `utils/schema_browser.py` - Schema browser component

2. **Configuration**
   - `requirements.txt` - Python dependencies
   - `.streamlit/config.toml` - Streamlit configuration
   - `config.py` - Application settings

3. **Documentation**
   - `README.md` - Setup and usage instructions
   - `USER_GUIDE.md` - End-user documentation
   - `DEPLOYMENT.md` - Deployment instructions

4. **Assets**
   - Custom CSS styles
   - Example queries
   - Help documentation

## Success Criteria

- [ ] Chat interface is intuitive and easy to use
- [ ] Bob AI integration works seamlessly
- [ ] Query results display correctly
- [ ] Schema browser is functional
- [ ] Chat history persists across sessions
- [ ] Error handling is comprehensive
- [ ] Response time < 3 seconds for typical queries
- [ ] Mobile-friendly interface
- [ ] User satisfaction > 4.5/5

## Dependencies

**Prerequisites**:
- ✅ Phase 1: MCP Server complete and tested
- ✅ Phase 2: Bob AI configured and validated
- ⏳ Streamlit installed
- ⏳ Bob AI client library available

## Timeline Estimate

- **Step 1-2**: 3-4 hours (Basic setup and Bob integration)
- **Step 3-4**: 4-5 hours (Chat components and schema browser)
- **Step 5-6**: 3-4 hours (Session management and examples)
- **Step 7-8**: 4-5 hours (Formatting and advanced features)
- **Step 9-10**: 4-5 hours (Error handling and testing)

**Total**: 18-23 hours

## Deployment Options

1. **Local Development**
   ```bash
   streamlit run app.py
   ```

2. **Streamlit Cloud**
   - Push to GitHub
   - Connect to Streamlit Cloud
   - Deploy automatically

3. **Docker Container**
   ```dockerfile
   FROM python:3.11
   WORKDIR /app
   COPY . .
   RUN pip install -r requirements.txt
   CMD ["streamlit", "run", "app.py"]
   ```

4. **Hugging Face Spaces**
   - Create Space
   - Upload files
   - Configure environment

## Risk Mitigation

**Risks**:
1. Bob AI integration complexity
2. Performance with large result sets
3. User experience issues
4. Deployment challenges

**Mitigations**:
1. Thorough testing of Bob AI integration
2. Result pagination and limits
3. User testing and feedback
4. Multiple deployment options

## Next Steps

After Phase 3 completion:
1. User acceptance testing
2. Performance optimization
3. Documentation finalization
4. Production deployment
5. User training
6. Ongoing maintenance and improvements

## References

- [DESIGN.md](../DESIGN.md) - Overall architecture
- [Phase 1 README](../mcp-server/README.md) - MCP Server
- [Phase 2 Plan](PHASE2_PLAN.md) - Bob AI configuration
- Streamlit Documentation - UI framework
- Bob AI Documentation - Integration guide