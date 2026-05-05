# SevOne Chat App - Bob Shell Integration

A real-time chat interface that integrates with Bob AI assistant to process user queries, featuring specialized SQL Expert mode for database operations via MCP (Model Context Protocol) server.

## Overview

This application provides an intuitive chat-based interface for interacting with Bob AI, enabling both general code assistance and specialized database querying capabilities. The system uses a modern React frontend communicating with a Node.js backend that orchestrates Bob CLI commands, with optional MCP server integration for secure database access.

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Browser                             │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │         React Frontend (localhost:3000)                    │  │
│  │  • ChatMessage - Display conversation                      │  │
│  │  • ChatInput - User input + mode selector                  │  │
│  │  • TypingIndicator - Loading states                        │  │
│  │  • socketService - API communication                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                             │
                             │ HTTP/SSE (Server-Sent Events)
                             │ REST API Calls
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│              Node.js Backend (localhost:5000)                    │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Express Server + SSE Streaming                            │  │
│  │  • POST /api/chat - Process messages                       │  │
│  │  • GET /api/health - Health check                          │  │
│  │  • Message routing & mode switching                        │  │
│  │  • Real-time event streaming                               │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            │                                     │
│                            ↓                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Bob CLI Integration (Child Process)                       │  │
│  │  • Spawn Bob processes with selected mode                  │  │
│  │  • Stream stdout/stderr in real-time                       │  │
│  │  • Handle process lifecycle & timeouts                     │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Bob AI Assistant                              │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Custom Modes (.bob/custom_modes.yaml)                     │  │
│  │  • Code Mode - General programming assistance              │  │
│  │  • SQL Expert Mode - Database query specialist            │  │
│  └───────────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  MCP Configuration (.bob/mcp.json)                         │  │
│  │  • sevone-mysql-remote - Database connection               │  │
│  │  • SSE transport with Bearer auth                          │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                             │
                             ↓ (SQL Expert Mode Only)
┌─────────────────────────────────────────────────────────────────┐
│              MCP Server (Python) - Optional                      │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Database Tools                                            │  │
│  │  • select_query - Execute SELECT queries                   │  │
│  │  • insert_query - Execute INSERT queries                   │  │
│  │  • Schema validation & query safety checks                 │  │
│  └───────────────────────────────────────────────────────────┘  │
│                            │                                     │
│                            ↓                                     │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  MySQL Database (SevOne Schema)                            │  │
│  │  • Devices, metrics, alerts, configurations                │  │
│  │  • Secure parameterized queries only                       │  │
│  └───────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## How It Works

### Message Flow
1. **User Input** → User types a message and selects a mode (Code or SQL Expert)
2. **Frontend** → React app sends HTTP POST to `/api/chat` with message and mode
3. **Backend** → Express server spawns Bob CLI process with selected mode
4. **Streaming** → Server streams Bob's output via Server-Sent Events (SSE)
5. **Bob Processing** → Bob AI processes the request using appropriate mode
6. **MCP Integration** (SQL Expert mode) → Bob uses MCP tools to query database
7. **Response** → Results stream back through the chain to the user interface
8. **Display** → React components render the formatted response

### Key Features
- **Real-time Streaming**: See Bob's thinking process and responses as they happen
- **Mode Switching**: Toggle between general code assistance and SQL expertise
- **MCP Integration**: Secure database access through standardized protocol
- **Error Handling**: Comprehensive error reporting at each layer
- **Process Management**: Automatic timeout and cleanup of Bob processes

## Features

- 💬 Real-time chat interface built with React
- 🤖 Bob AI assistant integration
- 🔄 WebSocket communication for instant responses
- 🗄️ SQL Expert mode for database queries
- 🎨 Modern, responsive UI
- 🔌 MCP server integration for database access

## Project Structure

```
sevone-chat-app/
├── client/                 # React frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   ├── services/      # API and WebSocket services
│   │   ├── App.js         # Main app component
│   │   └── index.js       # Entry point
│   └── package.json
├── server/                # Node.js backend
│   └── index.js          # Express + Socket.IO server
├── .bob/                  # Bob configuration
│   ├── custom_modes.yaml # Custom Bob modes
│   └── mcp.json          # MCP server config
├── package.json
└── README.md
```

## Prerequisites

- Node.js (v14 or higher)
- npm or yarn
- Bob CLI (for production integration)

## Installation

1. Install all dependencies:
```bash
npm run install-all
```

Or manually:
```bash
# Install backend dependencies
npm install

# Install frontend dependencies
cd client && npm install
```

## Running the Application

### Development Mode

Run both frontend and backend concurrently:
```bash
npm run dev
```

Or run them separately:

**Backend:**
```bash
npm run server
```

**Frontend:**
```bash
npm run client
```

The application will be available at:
- Frontend: http://localhost:3000
- Backend: http://localhost:5000

## Available Modes

### Code Mode (Default)
General purpose AI assistant for code-related tasks.

### SQL Expert Mode
Specialized mode for database queries:
- Analyzes database schema
- Generates SQL queries
- Executes queries via MCP server
- Returns formatted results

## Configuration

### Environment Variables

Create a `.env` file in the root directory:

```env
PORT=5000
CLIENT_URL=http://localhost:3000
NODE_ENV=development
BOB_PATH=/opt/sevone-chat-app
```

**Configuration Options:**
- `PORT`: Backend server port (default: 5000)
- `CLIENT_URL`: Frontend URL for CORS (default: http://localhost:3000)
- `NODE_ENV`: Environment mode (development/production)
- `BOB_PATH`: Path to Bob installation directory (default: /opt/sevone-chat-app)

### Bob Configuration

Bob modes are configured in `.bob/custom_modes.yaml`. The SQL Expert mode is pre-configured to work with the MCP server.

### MCP Server

Database connection is configured in `.bob/mcp.json`:
- Server: sevone-mysql-remote
- Type: SSE
- Authentication: Bearer token

## Usage

1. Start the application
2. Type your query in the chat input
3. Select the appropriate mode (Code or SQL Expert)
4. Bob will process your request and respond
5. For SQL queries, Bob will:
   - Understand your natural language query
   - Generate appropriate SQL
   - Execute via MCP server
   - Return results

## API Endpoints

### REST API
- `GET /api/health` - Health check endpoint

### WebSocket Events

**Client → Server:**
- `chat_message` - Send a message to Bob
- `switch_mode` - Switch Bob mode

**Server → Client:**
- `message_received` - Acknowledgment of message
- `bob_thinking` - Bob is processing
- `bob_response` - Bob's response
- `bob_complete` - Processing complete
- `mode_switched` - Mode change confirmation
- `error` - Error occurred

## Building for Production

```bash
npm run build
```

This will create an optimized production build in `client/build/`.

## Technologies Used

### Frontend
- React.js
- Socket.IO Client
- CSS3 for styling

### Backend
- Node.js
- Express.js
- Socket.IO
- Child Process (for Bob CLI integration)

## Future Enhancements

- [ ] Add authentication
- [ ] Implement chat history persistence
- [ ] Add file upload support
- [ ] Enhance SQL query visualization
- [ ] Add more Bob modes
- [ ] Implement streaming responses
- [ ] Add code syntax highlighting
- [ ] Export chat conversations

## License

ISC

## Support

For issues or questions, please open an issue in the repository.