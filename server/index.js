const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const cors = require('cors');
const { spawn } = require('child_process');
const path = require('path');
require('dotenv').config();

const app = express();
const server = http.createServer(app);
const io = socketIo(server, {
  cors: {
    origin: process.env.CLIENT_URL || "http://localhost:3000",
    methods: ["GET", "POST"]
  }
});

app.use(cors());
app.use(express.json());

// Store active Bob processes per socket
const bobProcesses = new Map();

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('New client connected:', socket.id);

  // Handle chat messages
  socket.on('chat_message', async (data) => {
    const { message, mode } = data;
    console.log(`Received message from ${socket.id}:`, message);

    try {
      // Emit acknowledgment
      socket.emit('message_received', { 
        id: Date.now(), 
        message, 
        timestamp: new Date().toISOString() 
      });

      // Process message with Bob shell
      await processBobCommand(socket, message, mode);
    } catch (error) {
      console.error('Error processing message:', error);
      socket.emit('error', { 
        message: 'Failed to process your request', 
        error: error.message 
      });
    }
  });

  // Handle mode switching
  socket.on('switch_mode', (data) => {
    console.log(`Mode switch requested for ${socket.id}:`, data.mode);
    socket.emit('mode_switched', { mode: data.mode });
  });

  // Handle disconnection
  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
    // Clean up any active Bob processes
    if (bobProcesses.has(socket.id)) {
      const process = bobProcesses.get(socket.id);
      process.kill();
      bobProcesses.delete(socket.id);
    }
  });
});

/**
 * Process command using Bob shell
 */
async function processBobCommand(socket, message, mode = 'code') {
  return new Promise((resolve, reject) => {
    // Emit thinking status
    socket.emit('bob_thinking', { status: 'processing' });

    // Execute actual Bob CLI command
    executeBobCLI(socket, message, mode)
      .then(resolve)
      .catch(reject);
  });
}

/**
 * Execute Bob CLI command
 */
async function executeBobCLI(socket, message, mode) {
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
      shell: false
    });

    let output = '';
    let errorOutput = '';

    // Capture stdout
    bobProcess.stdout.on('data', (data) => {
      const chunk = data.toString();
      output += chunk;
      
      // Stream output to client in real-time
      socket.emit('bob_stream', {
        chunk: chunk,
        timestamp: new Date().toISOString()
      });
    });

    // Capture stderr
    bobProcess.stderr.on('data', (data) => {
      errorOutput += data.toString();
      console.error('Bob stderr:', data.toString());
    });

    // Handle process completion
    bobProcess.on('close', (code) => {
      if (code === 0) {
        // Success - send final response
        socket.emit('bob_response', {
          id: Date.now(),
          message: output || 'Bob completed successfully but returned no output.',
          mode: mode,
          timestamp: new Date().toISOString(),
          type: 'assistant'
        });
        
        socket.emit('bob_complete', { status: 'completed' });
        resolve(output);
      } else {
        // Error
        const errorMessage = `Bob process exited with code ${code}${errorOutput ? ': ' + errorOutput : ''}`;
        console.error(errorMessage);
        
        socket.emit('error', {
          message: 'Bob encountered an error processing your request',
          error: errorMessage
        });
        
        socket.emit('bob_complete', { status: 'error' });
        reject(new Error(errorMessage));
      }
    });

    // Handle process errors
    bobProcess.on('error', (error) => {
      console.error('Bob process error:', error);
      
      socket.emit('error', {
        message: 'Failed to execute Bob command',
        error: error.message
      });
      
      socket.emit('bob_complete', { status: 'error' });
      reject(error);
    });

    // Store process reference for cleanup
    bobProcesses.set(socket.id, bobProcess);

    // Set timeout (5 minutes)
    setTimeout(() => {
      if (bobProcesses.has(socket.id)) {
        bobProcess.kill();
        bobProcesses.delete(socket.id);
        
        socket.emit('error', {
          message: 'Bob command timed out after 5 minutes'
        });
        
        socket.emit('bob_complete', { status: 'timeout' });
        reject(new Error('Command timeout'));
      }
    }, 300000);
  });
}

const PORT = process.env.PORT || 5000;

server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`WebSocket server ready for connections`);
});

// Made with Bob
