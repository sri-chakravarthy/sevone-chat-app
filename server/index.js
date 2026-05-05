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
 * Execute Bob CLI command using spawn (collects output and sends final result)
 */
async function executeBobCLI(res, message, mode) {
  return new Promise((resolve, reject) => {
    // Map mode to Bob chat mode
    const bobMode = mode === 'SQL-expert' ? 'data-expert' : 'code';
    
    // Get Bob path from environment or use default
    const bobPath = process.env.BOB_PATH || '/opt/sevone-chat-app';
    
    console.log(`Executing Bob command in ${bobPath} with mode ${bobMode}`);

    // Spawn Bob process
    const bobProcess = spawn('bash', ['-c', `cd ${bobPath} && bob -y --chat-mode '${bobMode}' -p '${message}'`], {
      env: { ...process.env },
      shell: true
    });

    let fullOutput = '';
    let fullError = '';
    let hasError = false;

    // Collect stdout
    bobProcess.stdout.on('data', (data) => {
      const chunk = data.toString();
      fullOutput += chunk;
      console.log('Bob stdout:', chunk);
    });

    // Collect stderr
    bobProcess.stderr.on('data', (data) => {
      const chunk = data.toString();
      fullError += chunk;
      console.log('Bob stderr:', chunk);
    });

    // Handle process completion
    bobProcess.on('close', (code) => {
      console.log(`Bob process exited with code ${code}`);
      console.log('Full output:', fullOutput);
      
      if (code !== 0) {
        hasError = true;
        res.write(`data: ${JSON.stringify({
          type: 'error',
          message: `Bob process exited with code ${code}`,
          error: fullError || fullOutput
        })}\n\n`);
        
        res.write(`data: ${JSON.stringify({
          type: 'bob_complete',
          status: 'error'
        })}\n\n`);
        
        res.end();
        reject(new Error(`Process exited with code ${code}`));
        return;
      }

      // Extract content between ---output--- tags if present
      let cleanedOutput = fullOutput;
      const outputMatch = fullOutput.match(/---output---\s*([\s\S]*?)\s*---output---/);


      // Send final response only
      res.write(`data: ${JSON.stringify({
        type: 'bob_response',
        id: Date.now(),
        message: cleanedOutput || fullOutput || 'Bob completed successfully but returned no output.',
        mode: mode,
        timestamp: new Date().toISOString()
      })}\n\n`);

      // Send completion event
      res.write(`data: ${JSON.stringify({
        type: 'bob_complete',
        status: 'completed'
      })}\n\n`);

      res.end();
      resolve(cleanedOutput);
    });

    // Handle process errors
    bobProcess.on('error', (error) => {
      console.error('Bob process error:', error);
      
      res.write(`data: ${JSON.stringify({
        type: 'error',
        message: 'Failed to start Bob process',
        error: error.message
      })}\n\n`);
      
      res.write(`data: ${JSON.stringify({
        type: 'bob_complete',
        status: 'error'
      })}\n\n`);
      
      res.end();
      reject(error);
    });

    // Set timeout
    const timeout = setTimeout(() => {
      console.log('Bob process timeout - killing process');
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
      reject(new Error('Timeout'));
    }, 300000); // 5 minutes

    // Clear timeout on process completion
    bobProcess.on('close', () => {
      clearTimeout(timeout);
    });
  });
}

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`REST API server ready for connections`);
});

// Made with Bob
