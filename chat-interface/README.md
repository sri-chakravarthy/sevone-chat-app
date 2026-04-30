# SevOne Chat Interface (Phase 3)

Web-based chat interface for interacting with the SevOne MySQL database using natural language.

## Status

🚧 **Phase 3 - Not Yet Implemented**

This directory contains placeholder files for the chat interface that will be implemented in Phase 3.

## Planned Features

- **Natural Language Input**: Ask questions in plain English
- **Chat History**: View conversation history
- **SQL Visualization**: See generated SQL queries
- **Result Display**: View query results in table format
- **Schema Browser**: Explore database structure
- **Bob AI Integration**: Powered by Bob AI with specialized SQL prompt

## Technology Stack

- **Framework**: Streamlit (Python-based web framework)
- **Alternative**: Gradio (simpler Python UI framework)
- **AI Integration**: Bob AI with MCP server connection

## Implementation Plan

### Phase 3.1: Basic Interface
- [ ] Create Streamlit app structure
- [ ] Implement chat input/output
- [ ] Add basic styling

### Phase 3.2: Bob AI Integration
- [ ] Connect to Bob AI
- [ ] Load SQL expert prompt
- [ ] Inject database schema into prompt
- [ ] Handle tool calls (select_query, insert_query)

### Phase 3.3: Enhanced Features
- [ ] Add schema browser panel
- [ ] Implement query history
- [ ] Add result export (CSV, JSON)
- [ ] Improve error handling and display

### Phase 3.4: Polish
- [ ] Add loading indicators
- [ ] Improve result formatting
- [ ] Add query examples
- [ ] Create user documentation

## Prerequisites

Before implementing Phase 3:
1. ✅ Phase 1: MCP Server must be completed and tested
2. ⏳ Phase 2: Bob AI integration must be configured
3. ⏳ Database must be set up with sample data

## Future Installation

```bash
cd chat-interface
pip install -r requirements.txt
```

## Future Usage

```bash
streamlit run app.py
```

## Directory Structure

```
chat-interface/
├── app.py                    # Main Streamlit application
├── prompts/
│   └── sql_expert_prompt.txt # System prompt for Bob AI
├── utils/
│   ├── __init__.py
│   ├── bob_client.py         # Bob AI integration (to be implemented)
│   └── formatters.py         # Result formatting (to be implemented)
├── requirements.txt
└── README.md
```

## Notes

This phase will be implemented after:
1. Phase 1 (MCP Server) is complete and tested
2. Phase 2 (Bob AI configuration) is set up
3. Database schema is finalized

See [`DESIGN.md`](../DESIGN.md) for complete architecture details.