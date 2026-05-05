# SevOne Chat App - Bob Shell Integration

A chat interface that integrates with Bob shell to process user queries, with support for SQL queries via MCP server.

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