# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         Browser                              │
│  ┌───────────────────────────────────────────────────────┐  │
│  │           React Frontend (Port 3000)                   │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  App.js (Main Component)                        │  │  │
│  │  │  ├── ChatMessage (Display messages)             │  │  │
│  │  │  ├── ChatInput (User input + mode selector)     │  │  │
│  │  │  └── TypingIndicator (Loading state)            │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  │  ┌─────────────────────────────────────────────────┐  │  │
│  │  │  socketService.js (WebSocket Client)            │  │  │
│  │  └─────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ WebSocket Connection
                            │ (Socket.IO)
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              Node.js Backend (Port 5000)                     │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Express Server + Socket.IO                           │  │
│  │  ├── Connection Management                            │  │
│  │  ├── Message Routing                                  │  │
│  │  ├── Mode Switching                                   │  │
│  │  └── Error Handling                                   │  │
│  └───────────────────────────────────────────────────────┘  │
│                            │                                 │
│                            ↓                                 │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Bob Shell Integration                                │  │
│  │  ├── Process Management                               │  │
│  │  ├── Command Execution                                │  │
│  │  └── Response Streaming                               │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Bob Configuration                         │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  .bob/custom_modes.yaml                               │  │
│  │  ├── Code Mode                                        │  │
│  │  └── SQL Expert Mode                                  │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  .bob/mcp.json                                        │  │
│  │  └── MCP Server Connection (Database)                │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### User Message Flow

```
1. User types message
   ↓
2. ChatInput component captures input
   ↓
3. App.js calls socketService.sendMessage()
   ↓
4. WebSocket emits 'chat_message' event
   ↓
5. Backend receives message
   ↓
6. Backend processes with Bob shell
   ↓
7. Backend emits 'bob_response' event
   ↓
8. Frontend receives response
   ↓
9. App.js updates messages state
   ↓
10. ChatMessage component displays response
```

### Mode Switching Flow

```
1. User selects mode from dropdown
   ↓
2. ChatInput calls onModeChange()
   ↓
3. App.js calls socketService.switchMode()
   ↓
4. WebSocket emits 'switch_mode' event
   ↓
5. Backend updates mode context
   ↓
6. Backend emits 'mode_switched' event
   ↓
7. Frontend updates currentMode state
   ↓
8. UI reflects new mode
```

## Component Hierarchy

```
App
├── Header
│   ├── Title
│   └── ConnectionStatus
├── ErrorBanner (conditional)
├── ChatContainer
│   ├── WelcomeMessage (conditional)
│   ├── SystemMessage (multiple)
│   ├── ChatMessage (multiple)
│   │   ├── MessageHeader
│   │   │   ├── Sender
│   │   │   ├── Mode Badge
│   │   │   └── Timestamp
│   │   └── MessageContent
│   └── TypingIndicator (conditional)
└── Footer
    └── ChatInput
        ├── ModeSelector
        └── InputForm
            ├── Textarea
            └── SendButton
```

## WebSocket Events

### Client → Server

| Event | Payload | Description |
|-------|---------|-------------|
| `chat_message` | `{ message, mode }` | Send user message |
| `switch_mode` | `{ mode }` | Change Bob mode |
| `disconnect` | - | Client disconnects |

### Server → Client

| Event | Payload | Description |
|-------|---------|-------------|
| `connect` | - | Connection established |
| `message_received` | `{ id, message, timestamp }` | Message acknowledged |
| `bob_thinking` | `{ status }` | Bob is processing |
| `bob_response` | `{ id, message, mode, timestamp, type }` | Bob's response |
| `bob_complete` | `{ status }` | Processing complete |
| `mode_switched` | `{ mode }` | Mode changed |
| `error` | `{ message, error }` | Error occurred |
| `disconnect` | - | Connection lost |

## File Structure

```
sevone-chat-app/
├── client/                          # React Frontend
│   ├── public/
│   │   ├── index.html
│   │   └── favicon.ico
│   ├── src/
│   │   ├── components/              # React Components
│   │   │   ├── ChatMessage.js       # Message display
│   │   │   ├── ChatMessage.css
│   │   │   ├── ChatInput.js         # User input
│   │   │   ├── ChatInput.css
│   │   │   ├── TypingIndicator.js   # Loading animation
│   │   │   └── TypingIndicator.css
│   │   ├── services/                # Services
│   │   │   └── socketService.js     # WebSocket client
│   │   ├── App.js                   # Main component
│   │   ├── App.css                  # Main styles
│   │   ├── index.js                 # Entry point
│   │   └── index.css                # Global styles
│   └── package.json                 # Frontend dependencies
├── server/                          # Node.js Backend
│   └── index.js                     # Express + Socket.IO server
├── .bob/                            # Bob Configuration
│   ├── custom_modes.yaml            # Bob modes
│   └── mcp.json                     # MCP server config
├── .env                             # Environment variables
├── .gitignore                       # Git ignore rules
├── package.json                     # Backend dependencies
├── setup.sh                         # Setup script
├── README.md                        # Main documentation
├── QUICKSTART.md                    # Quick start guide
├── USAGE.md                         # Usage guide
└── ARCHITECTURE.md                  # This file
```

## Technology Stack

### Frontend
- **React 19.2.5**: UI framework
- **Socket.IO Client 4.6.1**: WebSocket communication
- **Axios 1.6.0**: HTTP requests (future use)
- **CSS3**: Styling with animations

### Backend
- **Node.js**: Runtime environment
- **Express 4.18.2**: Web framework
- **Socket.IO 4.6.1**: WebSocket server
- **CORS 2.8.5**: Cross-origin resource sharing
- **dotenv 16.3.1**: Environment configuration

### Development Tools
- **nodemon**: Auto-restart server
- **concurrently**: Run multiple commands
- **create-react-app**: React boilerplate

## Security Considerations

1. **CORS Configuration**: Restricts frontend origins
2. **Environment Variables**: Sensitive data in .env
3. **Input Validation**: Sanitize user input
4. **Error Handling**: Don't expose internal errors
5. **Connection Management**: Clean up on disconnect

## Performance Optimizations

1. **WebSocket**: Real-time, low-latency communication
2. **React Hooks**: Efficient state management
3. **CSS Animations**: Hardware-accelerated
4. **Message Batching**: Reduce re-renders
5. **Lazy Loading**: Load components as needed

## Scalability

### Current Limitations
- Single server instance
- In-memory message storage
- No authentication
- No message persistence

### Future Improvements
- Load balancing with Redis adapter
- Database for message history
- User authentication (JWT)
- Rate limiting
- Horizontal scaling

## Integration Points

### Bob CLI Integration
```javascript
// Current: Simulated responses
simulateBobResponse(socket, message, mode)

// Future: Actual Bob CLI
const bobProcess = spawn('bob', ['--mode', mode]);
bobProcess.stdin.write(message);
```

### MCP Server Integration
```yaml
# .bob/mcp.json
{
  "mcpServers": {
    "sevone-mysql-remote": {
      "type": "sse",
      "url": "http://server:port/sse",
      "headers": {
        "Authorization": "Bearer token"
      }
    }
  }
}
```

## Deployment

### Development
```bash
npm run dev  # Both frontend and backend
```

### Production
```bash
# Build frontend
cd client && npm run build

# Serve static files from Express
app.use(express.static('client/build'));

# Start server
npm start
```

## Monitoring

### Logs
- Server logs: Console output
- Client logs: Browser console
- WebSocket events: Socket.IO debug mode

### Metrics to Track
- Connection count
- Message throughput
- Response time
- Error rate
- Mode usage

## Testing Strategy

### Unit Tests
- Component rendering
- Service functions
- Event handlers

### Integration Tests
- WebSocket communication
- End-to-end message flow
- Mode switching

### E2E Tests
- User workflows
- Error scenarios
- Performance tests

---

**Last Updated**: 2026-05-05