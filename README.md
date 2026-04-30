# SevOne Chat Application with MySQL

A chat-based interface for querying and interacting with a SevOne MySQL database using Bob AI with specialized SQL expertise and chain-of-thought reasoning.

## 🎯 Project Overview

This application provides a natural language interface to interact with SevOne's MySQL database. Users can ask questions in plain English, and the AI agent generates and executes appropriate SQL queries, presenting results in a user-friendly format.

## 🏗️ Architecture

```
User → Chat Interface (Streamlit) → Bob AI Agent → MCP Server → MySQL Database
```

### Components

1. **MCP Server (Phase 1)** - Python-based server providing secure database access
2. **Bob AI Agent (Phase 2)** - AI agent with SQL expertise using prompt-based approach
3. **Chat Interface (Phase 3)** - Web-based UI for user interaction

## 📁 Project Structure

```
sevone-chat-app-mysql/
├── mcp-server/              # Phase 1: MCP Server
│   ├── src/
│   │   ├── config/          # Configuration management
│   │   ├── database/        # Database connection & validation
│   │   ├── tools/           # MCP tools (select_query, insert_query)
│   │   └── server.py        # MCP server entry point
│   ├── tests/               # Unit tests
│   ├── pyproject.toml
│   ├── requirements.txt
│   └── README.md
│
├── chat-interface/          # Phase 3: Chat Interface
│   ├── prompts/             # System prompts for Bob AI
│   ├── utils/               # Utility modules
│   ├── app.py               # Streamlit application
│   ├── requirements.txt
│   └── README.md
│
├── scripts/                 # Utility scripts
│   ├── setup_database.py    # Database initialization
│   ├── extract_schema.py    # Schema extraction
│   └── test_connection.py   # Connection testing
│
├── docs/                    # Documentation
│   ├── DESIGN.md            # Detailed design document
│   ├── PHASE2_PLAN.md       # Phase 2 implementation plan
│   └── PHASE3_PLAN.md       # Phase 3 implementation plan
│
├── .env.example             # Environment variables template
└── README.md                # This file
```

## 🚀 Implementation Status

### ✅ Phase 1: MCP Server (COMPLETE)

**Status**: Implemented and ready for testing

**Features**:
- ✅ Database connection pooling
- ✅ Query validation and security
- ✅ SELECT query tool
- ✅ INSERT query tool
- ✅ Schema extraction tool
- ✅ Comprehensive error handling
- ✅ Unit tests
- ✅ Documentation

**Next Steps**:
1. Set up MySQL database
2. Configure environment variables
3. Install dependencies
4. Run tests
5. Start MCP server

See [`mcp-server/README.md`](mcp-server/README.md) for detailed instructions.

### ⏳ Phase 2: Bob AI Agent (PLANNED)

**Status**: Planned - Not yet started

**Objectives**:
- Configure Bob AI to connect to MCP server
- Create SQL expert system prompt
- Implement chain-of-thought reasoning
- Test query generation and execution
- Validate error handling

**Timeline**: 12-17 hours

See [`docs/PHASE2_PLAN.md`](docs/PHASE2_PLAN.md) for detailed plan.

### ⏳ Phase 3: Chat Interface (PLANNED)

**Status**: Planned - Not yet started

**Objectives**:
- Create Streamlit web interface
- Integrate with Bob AI agent
- Implement chat history
- Add schema browser
- Create result visualization
- Add query examples

**Timeline**: 18-23 hours

See [`docs/PHASE3_PLAN.md`](docs/PHASE3_PLAN.md) for detailed plan.

## 🛠️ Technology Stack

- **Language**: Python 3.11+
- **MCP Framework**: MCP Python SDK
- **Database**: MySQL 5.7+ / MariaDB 10.3+
- **Database Driver**: aiomysql
- **AI Agent**: Bob AI (prompt-based)
- **Web Framework**: Streamlit
- **Testing**: pytest, pytest-asyncio
- **Validation**: pydantic

## 📋 Prerequisites

- Python 3.11 or higher
- MySQL 5.7+ or MariaDB 10.3+
- Bob AI installed and configured
- Access to SevOne MySQL database

## 🚦 Quick Start

### 1. Clone Repository

```bash
git clone <repository-url>
cd sevone-chat-app-mysql
```

### 2. Set Up Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your database credentials
nano .env
```

### 3. Install Phase 1 (MCP Server)

```bash
cd mcp-server
pip install -r requirements.txt

# Run tests
pytest tests/ -v

# Start MCP server
python -m src.server
```

### 4. Configure Phase 2 (Bob AI)

See [`docs/PHASE2_PLAN.md`](docs/PHASE2_PLAN.md) for configuration instructions.

### 5. Run Phase 3 (Chat Interface)

```bash
cd chat-interface
pip install -r requirements.txt
streamlit run app.py
```

## 🔒 Security Features

- **Query Validation**: Blocks dangerous SQL operations (DROP, DELETE, etc.)
- **Parameterized Queries**: Mandatory for INSERT operations
- **SQL Injection Prevention**: Comprehensive validation and sanitization
- **Connection Security**: Secure credential management via environment variables
- **Error Sanitization**: No sensitive information in error messages
- **Access Control**: Read-only SELECT and controlled INSERT operations

## 📊 Database Schema

The application works with the SevOne monitoring database schema:

- **devices**: Network devices being monitored
- **metrics**: Performance metrics collected from devices
- **alerts**: Alerts generated from monitoring
- **users**: System users

See [`scripts/setup_database.py`](scripts/setup_database.py) for schema details.

## 🧪 Testing

### MCP Server Tests

```bash
cd mcp-server
pytest tests/ -v --cov=src --cov-report=html
```

### Integration Tests

```bash
# Test database connection
python scripts/test_connection.py

# Test MCP server
python scripts/test_mcp_server.py
```

## 📖 Documentation

- **[DESIGN.md](DESIGN.md)** - Comprehensive design document
- **[Phase 1 README](mcp-server/README.md)** - MCP Server documentation
- **[Phase 2 Plan](docs/PHASE2_PLAN.md)** - Bob AI implementation plan
- **[Phase 3 Plan](docs/PHASE3_PLAN.md)** - Chat interface plan

## 🎯 Key Design Decisions

### Why Python?
- Simpler and more concise than TypeScript
- Official MCP Python SDK is well-supported
- Mature MySQL libraries
- Streamlit/Gradio provide instant UI
- Easier integration with data science tools

### Why Prompt-Based Instead of Custom Mode?
- No need to build and maintain custom Bob mode
- Easy to update and refine prompts
- Works with any Bob installation
- Prompt changes don't require code deployment
- More transparent and understandable
- Cost-effective

### Why MCP Server?
- Standardized protocol for tool access
- Secure and controlled database access
- Easy integration with Bob AI
- Reusable for other applications

## 🔄 Development Workflow

1. **Phase 1**: Implement and test MCP server
2. **Phase 2**: Configure Bob AI with SQL expert prompt
3. **Phase 3**: Build chat interface
4. **Integration**: Connect all components
5. **Testing**: End-to-end validation
6. **Deployment**: Production deployment

## 🚀 Deployment

### Development

```bash
# Start MCP server
cd mcp-server && python -m src.server

# Start chat interface
cd chat-interface && streamlit run app.py
```

### Production

Options:
- **Streamlit Cloud**: Easy deployment for Streamlit apps
- **Docker**: Containerized deployment
- **Hugging Face Spaces**: Free hosting option
- **AWS/Azure/GCP**: Cloud platform deployment

## 📈 Performance Metrics

**Target Metrics**:
- Query response time: < 2 seconds (90th percentile)
- MCP tool execution: < 500ms
- UI responsiveness: < 100ms
- Query generation accuracy: > 95%

## 🤝 Contributing

1. Follow the existing code structure
2. Add tests for new features
3. Update documentation
4. Follow Python best practices (PEP 8)
5. Use type hints

## 📝 License

Copyright © 2024 SevOne. All rights reserved.

## 👥 Support

For issues and questions, please contact the SevOne development team.

## 🗺️ Roadmap

### Current Phase
- ✅ Phase 1: MCP Server implementation

### Next Steps
- ⏳ Phase 2: Bob AI configuration
- ⏳ Phase 3: Chat interface development

### Future Enhancements
- Query history and favorites
- Result export (CSV, JSON, Excel)
- Data visualization (charts, graphs)
- Multi-database support
- UPDATE/DELETE operations (with controls)
- Voice input
- Scheduled queries
- Alerts and notifications
- Collaboration features
- Audit logging
- Role-based access control

## 📞 Contact

For more information about this project, please refer to the documentation or contact the development team.# sevone-chat-app
