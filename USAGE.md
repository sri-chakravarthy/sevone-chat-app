# Usage Guide - SevOne Chat App

## Overview

The SevOne Chat App is a web-based chat interface that integrates with Bob AI assistant to help you with code, database queries, and other tasks.

## Starting the Application

### Quick Start
```bash
# Start both frontend and backend
npm run dev
```

The application will open automatically at:
- **Frontend**: http://localhost:3000
- **Backend**: http://localhost:5000

## Interface Overview

### Header
- **Title**: Shows "🤖 Bob Chat Assistant"
- **Connection Status**: Green dot = Connected, Red dot = Disconnected

### Chat Area
- **Welcome Message**: Displayed when you first open the app
- **Message History**: Shows all your conversations with Bob
- **User Messages**: Purple gradient bubbles on the right
- **Bob Responses**: Light gray bubbles on the left
- **Typing Indicator**: Animated dots when Bob is thinking

### Input Area
- **Mode Selector**: Choose between Code and SQL Expert modes
- **Text Input**: Type your message (supports multi-line with Shift+Enter)
- **Send Button**: Click or press Enter to send

## Using Different Modes

### 💻 Code Mode (Default)

Best for:
- Writing and reviewing code
- Explaining programming concepts
- Debugging help
- Best practices advice
- File operations

**Example queries:**
```
"Write a function to validate email addresses"
"Explain the difference between let and const"
"How do I handle errors in async functions?"
"Review this code for security issues"
```

### 🗄️ SQL Expert Mode

Best for:
- Database queries
- SQL syntax help
- Data analysis
- Schema design
- Query optimization

**Example queries:**
```
"Show me all users registered in the last 30 days"
"How do I create an index on multiple columns?"
"Write a query to find duplicate records"
"Explain the difference between INNER JOIN and LEFT JOIN"
```

**Note**: SQL Expert mode connects to your database via the MCP server configured in `.bob/mcp.json`

## Features

### Real-time Communication
- Messages are sent and received instantly via WebSocket
- No page refresh needed
- Connection status is always visible

### Message Formatting
Bob's responses support:
- **Bold text**: `**text**`
- `Inline code`: \`code\`
- Multi-line text
- Lists and structured content

### Error Handling
- Connection errors are displayed in a red banner
- Failed messages can be resent
- Automatic reconnection attempts

### Responsive Design
- Works on desktop, tablet, and mobile
- Adapts to different screen sizes
- Touch-friendly interface

## Keyboard Shortcuts

- **Enter**: Send message
- **Shift + Enter**: New line in message
- **Escape**: Clear input (when focused)

## Tips for Best Results

### Writing Good Queries

1. **Be Specific**
   - ❌ "Help me with code"
   - ✅ "Write a Python function to sort a list of dictionaries by a specific key"

2. **Provide Context**
   - ❌ "Fix this"
   - ✅ "This JavaScript function throws an error when the array is empty. How can I fix it?"

3. **Use the Right Mode**
   - Code questions → Code Mode
   - Database questions → SQL Expert Mode

### SQL Expert Mode Tips

1. **Describe Your Data**
   ```
   "I have a users table with columns: id, name, email, created_at.
   Show me users who signed up this month."
   ```

2. **Ask for Explanations**
   ```
   "Explain this query and suggest optimizations:
   SELECT * FROM orders WHERE user_id IN (SELECT id FROM users)"
   ```

3. **Request Multiple Options**
   ```
   "Show me three different ways to find the top 10 customers by revenue"
   ```

## Troubleshooting

### "Disconnected" Status

**Cause**: Backend server is not running or connection failed

**Solution**:
1. Check if backend is running: `npm run server`
2. Verify port 5000 is not in use
3. Check browser console for errors
4. Restart the application

### Messages Not Sending

**Cause**: Not connected to server or input is disabled

**Solution**:
1. Wait for "Connected" status
2. Check if Bob is still processing previous message
3. Refresh the page
4. Check server logs for errors

### Bob Not Responding

**Cause**: Server error or Bob process issue

**Solution**:
1. Check server terminal for error messages
2. Verify Bob configuration in `.bob/custom_modes.yaml`
3. Restart the backend server
4. Check MCP server connection (for SQL mode)

### Slow Responses

**Cause**: Complex queries or server load

**Solution**:
1. Break complex queries into smaller parts
2. Be more specific in your questions
3. Check server resources
4. Verify network connection

## Advanced Usage

### Custom Bob Modes

Edit `.bob/custom_modes.yaml` to add custom modes:

```yaml
customModes:
  - slug: my-custom-mode
    name: My Custom Mode
    description: Description of what this mode does
    roleDefinition: You are an expert in...
    customInstructions: |-
      Instructions for Bob...
    groups:
      - read
      - edit
      - command
    source: project
```

Then update the mode selector in `client/src/components/ChatInput.js`

### Configuring MCP Server

Edit `.bob/mcp.json` to change database connection:

```json
{
  "mcpServers": {
    "your-server-name": {
      "type": "sse",
      "url": "http://your-server:port/sse",
      "headers": {
        "Authorization": "Bearer your-token"
      },
      "alwaysAllow": []
    }
  }
}
```

### Environment Configuration

Edit `.env` to customize:

```env
PORT=5000                          # Backend port
CLIENT_URL=http://localhost:3000   # Frontend URL
NODE_ENV=development               # Environment
```

## Best Practices

1. **Start Simple**: Begin with basic queries to understand Bob's capabilities
2. **Iterate**: Refine your questions based on Bob's responses
3. **Save Important Responses**: Copy useful code or queries to your files
4. **Use Appropriate Modes**: Switch modes based on your task
5. **Provide Feedback**: If Bob's response isn't helpful, rephrase your question

## Security Notes

- Never share sensitive credentials in chat
- Review generated SQL queries before executing on production
- Keep your `.env` file secure and never commit it
- Regularly update dependencies for security patches

## Getting Help

If you encounter issues:

1. Check the logs in your terminal
2. Review browser console (F12) for errors
3. Refer to QUICKSTART.md for setup issues
4. Check README.md for detailed documentation

## Next Steps

- Explore different query types
- Try both Code and SQL Expert modes
- Customize Bob modes for your specific needs
- Integrate with your actual Bob CLI installation
- Add authentication for production use

---

**Happy Chatting with Bob! 🤖**