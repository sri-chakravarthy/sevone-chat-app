const express = require('express');
const cors = require('cors');
const { spawn } = require('child_process');
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
 * Execute Bob CLI command
 */
async function executeBobCLI(res, message, mode) {
  return new Promise((resolve, reject) => {
    // Map mode to Bob chat mode
    const bobMode = mode === 'SQL-expert' ? 'data-expert' : 'code';
    
    // Get Bob path from environment or use default
    const bobPath = process.env.BOB_PATH || '/opt/sevone-chat-app';
    
    // Construct Bob command
    const bobCommand = 'bash';
    const bobArgs = [
      '-c',
      `cd ${bobPath} && bob -y --chat-mode '${bobMode}' -p '${message.replace(/'/g, "'\\''")}'`
    ];

    console.log(`Executing Bob command: ${bobCommand} ${bobArgs.join(' ')}`);

    // Spawn Bob process
    const bobProcess = spawn(bobCommand, bobArgs, {
      cwd: process.cwd(),
      env: { ...process.env },
      shell: true
    });

    let output = '';
    let errorOutput = '';

    // Capture stdout
    bobProcess.stdout.on('data', (data) => {
      const chunk = data.toString();
      output += chunk;
      
      // Stream output to client in real-time
      res.write(`data: ${JSON.stringify({
        type: 'bob_stream',
        chunk: chunk,
        timestamp: new Date().toISOString()
      })}\n\n`);
    });

    // Capture stderr (Bob may output progress/status here)
    bobProcess.stderr.on('data', (data) => {
      const chunk = data.toString();
      errorOutput += chunk;
      console.error('Bob stderr:', chunk);
      
      // Stream stderr to client as well (for progress updates)
      res.write(`data: ${JSON.stringify({
        type: 'bob_stream',
        chunk: chunk,
        timestamp: new Date().toISOString(),
        isError: false
      })}\n\n`);
    });

    // Handle process completion
    bobProcess.on('close', (code) => {
      if (code === 0) {
        // Clean output by removing wrapper tags
        let cleanedOutput = output;
        
        // Remove ---output--- tags and extract content between them
        const outputMatch = cleanedOutput.match(/---output---\s*([\s\S]*?)\s*---output---/);
        if (outputMatch) {
          cleanedOutput = outputMatch[1].trim();
        }
        
        // Success - send final response
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
      } else {
        // Error
        const errorMessage = `Bob process exited with code ${code}${errorOutput ? ': ' + errorOutput : ''}`;
        console.error(errorMessage);
        
        res.write(`data: ${JSON.stringify({
          type: 'error',
          message: 'Bob encountered an error processing your request',
          error: errorMessage
        })}\n\n`);
        
        res.write(`data: ${JSON.stringify({ 
          type: 'bob_complete', 
          status: 'error' 
        })}\n\n`);
        
        res.end();
        reject(new Error(errorMessage));
      }
    });

    // Handle process errors
    bobProcess.on('error', (error) => {
      console.error('Bob process error:', error);
      
      res.write(`data: ${JSON.stringify({
        type: 'error',
        message: 'Failed to execute Bob command',
        error: error.message
      })}\n\n`);
      
      res.write(`data: ${JSON.stringify({ 
        type: 'bob_complete', 
        status: 'error' 
      })}\n\n`);
      
      res.end();
      reject(error);
    });

    // Set timeout (5 minutes)
    setTimeout(() => {
      bobProcess.kill();
      
      res.write(`data: ${JSON.stringify({
        type: 'error',
        message: 'Bob command timed out after 5 minutes'
      })}\n\n`);
      
      res.write(`data: ${JSON.stringify({ 
        type: 'bob_complete', 
        status: 'timeout' 
      })}\n\n`);
      
      res.end();
      reject(new Error('Command timeout'));
    }, 300000);
  });
}

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`REST API server ready for connections`);
});

// Made with Bob
