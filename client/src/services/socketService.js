import { io } from 'socket.io-client';

class SocketService {
  constructor() {
    this.socket = null;
    this.connected = false;
  }

  connect(url = 'http://localhost:5000') {
    if (this.socket && this.connected) {
      return this.socket;
    }

    this.socket = io(url, {
      transports: ['websocket'],
      reconnection: true,
      reconnectionDelay: 1000,
      reconnectionAttempts: 5
    });

    this.socket.on('connect', () => {
      console.log('Connected to server');
      this.connected = true;
    });

    this.socket.on('disconnect', () => {
      console.log('Disconnected from server');
      this.connected = false;
    });

    this.socket.on('connect_error', (error) => {
      console.error('Connection error:', error);
    });

    return this.socket;
  }

  disconnect() {
    if (this.socket) {
      this.socket.disconnect();
      this.socket = null;
      this.connected = false;
    }
  }

  sendMessage(message, mode = 'code') {
    if (this.socket && this.connected) {
      this.socket.emit('chat_message', { message, mode });
    } else {
      console.error('Socket not connected');
    }
  }

  switchMode(mode) {
    if (this.socket && this.connected) {
      this.socket.emit('switch_mode', { mode });
    }
  }

  onMessageReceived(callback) {
    if (this.socket) {
      this.socket.on('message_received', callback);
    }
  }

  onBobThinking(callback) {
    if (this.socket) {
      this.socket.on('bob_thinking', callback);
    }
  }

  onBobResponse(callback) {
    if (this.socket) {
      this.socket.on('bob_response', callback);
    }
  }

  onBobComplete(callback) {
    if (this.socket) {
      this.socket.on('bob_complete', callback);
    }
  }

  onModeSwitched(callback) {
    if (this.socket) {
      this.socket.on('mode_switched', callback);
    }
  }

  onError(callback) {
    if (this.socket) {
      this.socket.on('error', callback);
    }
  }

  removeAllListeners() {
    if (this.socket) {
      this.socket.removeAllListeners();
    }
  }
}

export default new SocketService();

// Made with Bob
