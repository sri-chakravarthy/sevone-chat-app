# Quick Start Guide

## Installation

### Option 1: Automated Setup (Recommended)
```bash
./setup.sh
```

### Option 2: Manual Setup
```bash
# Install backend dependencies
npm install

# Install frontend dependencies
cd client && npm install && cd ..
```

## Running the Application

### Start Both Frontend and Backend
```bash
npm run dev
```

This will start:
- Backend server on http://localhost:5000
- Frontend React app on http://localhost:3000

### Start Separately

**Backend only:**
```bash
npm run server
```

**Frontend only:**
```bash
npm run client
```

## Using the Chat Interface

1. **Open your browser** to http://localhost:3000

2. **Wait for connection** - You'll see "Connected" status in the header

3. **Select a mode:**
   - **💻 Code Mode**: General purpose AI assistance
   - **🗄️ SQL Expert Mode**: Database queries and SQL help

4. **Type your message** and press Enter or click the send button

5. **Bob will respond** with helpful information

## Example Queries

### Code Mode
```
"Help me write a function to sort an array"
"Explain how async/await works in JavaScript"
"Review this code for best practices"
```

### SQL Expert Mode
```
"Show me all users from the database"
"How do I join two tables?"
"Write a query to find the top 10 customers by revenue"
```

## Features

- ✅ Real-time chat with WebSocket
- ✅ Multiple AI modes (Code, SQL Expert)
- ✅ Message history
- ✅ Typing indicators
- ✅ Connection status monitoring
- ✅ Error handling
- ✅ Responsive design

## Troubleshooting

### Backend won't start
- Check if port 5000 is available
- Verify Node.js is installed: `node --version`
- Check dependencies: `npm install`

### Frontend won't start
- Check if port 3000 is available
- Verify dependencies: `cd client && npm install`
- Clear cache: `cd client && rm -rf node_modules package-lock.json && npm install`

### Can't connect to server
- Ensure backend is running on port 5000
- Check `.env` file has correct `CLIENT_URL`
- Verify firewall settings

### Bob not responding
- Check server logs for errors
- Verify WebSocket connection in browser console
- Restart both frontend and backend

## Configuration

### Environment Variables (.env)
```env
PORT=5000
CLIENT_URL=http://localhost:3000
NODE_ENV=development
```

### Bob Modes (.bob/custom_modes.yaml)
Configure custom Bob modes for specific tasks.

### MCP Server (.bob/mcp.json)
Configure database connection for SQL Expert mode.

## Development

### Project Structure
```
sevone-chat-app/
├── client/              # React frontend
│   ├── src/
│   │   ├── components/  # React components
│   │   ├── services/    # WebSocket service
│   │   ├── App.js       # Main app
│   │   └── App.css      # Styles
│   └── package.json
├── server/              # Node.js backend
│   └── index.js         # Express + Socket.IO
├── .bob/                # Bob configuration
├── package.json         # Backend dependencies
└── README.md
```

### Adding New Features

1. **New Bob Mode**: Edit `.bob/custom_modes.yaml`
2. **New Component**: Add to `client/src/components/`
3. **New API Endpoint**: Add to `server/index.js`
4. **New Socket Event**: Update both client and server

## Next Steps

- [ ] Integrate actual Bob CLI
- [ ] Add authentication
- [ ] Implement chat history persistence
- [ ] Add file upload support
- [ ] Enhance SQL query visualization
- [ ] Add code syntax highlighting

## Support

For issues or questions:
1. Check the logs in terminal
2. Review browser console for errors
3. Refer to README.md for detailed documentation

## License

ISC