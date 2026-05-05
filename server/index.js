const express = require('express');
const cors = require('cors');
const { exec } = require('child_process');
const path = require('path');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

// Store active Bob processes per request ID
const bobProcesses = new Map();

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

// Chat endpoint - POST request to send messages
app.post('/api/chat', async (req, res) => {
  const { message, mode = 'code' } = req.body;

  if (!message) {
    return res.status(400).json({ error: 'Message is required' });
  }

  console.log(`Received message:`, message);

  try {
    // Set headers for streaming response
    res.setHeader('Content-Type', 'text/event-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.setHeader('Connection', 'keep-alive');

    // Send initial acknowledgment
    res.write(`data: ${JSON.stringify({ 
      type: 'message_received', 
      id: Date.now(), 
      message, 
      timestamp: new Date().toISOString() 
    })}\n\n`);

    // Send thinking status
    res.write(`data: ${JSON.stringify({ 
      type: 'bob_thinking', 
      status: 'processing' 
    })}\n\n`);

    // Execute Bob command
    await executeBobCLI(res, message, mode);

  } catch (error) {
    console.error('Error processing message:', error);
    res.write(`data: ${JSON.stringify({ 
      type: 'error', 
      message: 'Failed to process your request', 
      error: error.message 
    })}\n\n`);
    res.end();
  }
});

/**
 * Execute Bob CLI command using exec (runs in shell, waits for completion)
 */
async function executeBobCLI(res, message, mode) {
  return new Promise((resolve, reject) => {
    // Map mode to Bob chat mode
    const bobMode = mode === 'SQL-expert' ? 'data-expert' : 'code';
    
    // Get Bob path from environment or use default
    const bobPath = process.env.BOB_PATH || '/opt/sevone-chat-app';
    
    // Construct Bob command - escape single quotes in message
    const escapedMessage = message.replace(/'/g, "'\\''");
    const command = `bash -c cd ${bobPath} && bob -y --chat-mode '${bobMode}' -p '${escapedMessage}'`;

    console.log(`Executing Bob command: ${command}`);

    // Execute Bob command with timeout
    const bobProcess = exec(command, {
      maxBuffer: 10 * 1024 * 1024, // 10MB buffer
      timeout: 300000, // 5 minutes timeout
      env: { ...process.env }
    }, (error, stdout, stderr) => {
      // This callback is called when the process completes
      if (error) {
        console.error('Bob execution error:', error);
        
        const errorMessage = error.killed ? 'Bob command timed out after 5 minutes' :
                            `Bob process failed: ${error.message}`;
        
        res.write(`data: ${JSON.stringify({
          type: 'error',
          message: errorMessage,
          error: stderr || error.message
        })}\n\n`);
        
        res.write(`data: ${JSON.stringify({
          type: 'bob_complete',
          status: error.killed ? 'timeout' : 'error'
        })}\n\n`);
        
        res.end();
        reject(error);
        return;
      }

      // Success - process output
      let cleanedOutput = stdout;
      
      // Remove ---output--- tags and extract content between them
      const outputMatch = cleanedOutput.match(/---output---\s*([\s\S]*?)\s*---output---/);
      if (outputMatch) {
        cleanedOutput = outputMatch[1].trim();
      }
      
      // Send final response
      res.write(`data: ${JSON.stringify({
        type: 'bob_response',
        id: Date.now(),
        message: cleanedOutput || 'Bob completed successfully but returned no output.',
        mode: mode,
        timestamp: new Date().toISOString()
      })}\n\n`);
      
      res.write(`data: ${JSON.stringify({
        type: 'bob_complete',
        status: 'completed'
      })}\n\n`);
      
      res.end();
      resolve(cleanedOutput);
    });

    // Stream stdout in real-time (if available)
    if (bobProcess.stdout) {
      bobProcess.stdout.on('data', (data) => {
        const chunk = data.toString();
        res.write(`data: ${JSON.stringify({
          type: 'bob_stream',
          chunk: chunk,
          timestamp: new Date().toISOString()
        })}\n\n`);
      });
    }

    // Stream stderr in real-time (if available)
    if (bobProcess.stderr) {
      bobProcess.stderr.on('data', (data) => {
        const chunk = data.toString();
        console.error('Bob stderr:', chunk);
        res.write(`data: ${JSON.stringify({
          type: 'bob_stream',
          chunk: chunk,
          timestamp: new Date().toISOString(),
          isError: false
        })}\n\n`);
      });
    }
  });
}

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`REST API server ready for connections`);
});

// Made with Bob
