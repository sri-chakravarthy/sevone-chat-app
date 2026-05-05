import React, { useState, useEffect, useRef } from 'react';
import socketService from './services/socketService';
import ChatMessage from './components/ChatMessage';
import ChatInput from './components/ChatInput';
import TypingIndicator from './components/TypingIndicator';
import './App.css';

function App() {
  const [messages, setMessages] = useState([]);
  const [isConnected, setIsConnected] = useState(false);
  const [isTyping, setIsTyping] = useState(false);
  const [currentMode, setCurrentMode] = useState('code');
  const [error, setError] = useState(null);
  const messagesEndRef = useRef(null);

  useEffect(() => {
    // Connect to socket server
    const socket = socketService.connect();

    socket.on('connect', () => {
      setIsConnected(true);
      setError(null);
      addSystemMessage('Connected to Bob server');
    });

    socket.on('disconnect', () => {
      setIsConnected(false);
      addSystemMessage('Disconnected from server');
    });

    // Listen for message acknowledgment
    socketService.onMessageReceived((data) => {
      console.log('Message received:', data);
    });

    // Listen for Bob thinking
    socketService.onBobThinking(() => {
      setIsTyping(true);
    });

    // Listen for Bob response
    socketService.onBobResponse((data) => {
      setIsTyping(false);
      addMessage(data.message, 'assistant', data.mode);
    });

    // Listen for Bob completion
    socketService.onBobComplete(() => {
      setIsTyping(false);
    });

    // Listen for mode switch
    socketService.onModeSwitched((data) => {
      setCurrentMode(data.mode);
      addSystemMessage(`Switched to ${data.mode} mode`);
    });

    // Listen for errors
    socketService.onError((data) => {
      setIsTyping(false);
      setError(data.message);
      addSystemMessage(`Error: ${data.message}`, 'error');
    });

    // Cleanup on unmount
    return () => {
      socketService.removeAllListeners();
      socketService.disconnect();
    };
  }, []);

  useEffect(() => {
    // Scroll to bottom when messages change
    scrollToBottom();
  }, [messages, isTyping]);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  const addMessage = (text, type, mode = currentMode) => {
    const newMessage = {
      id: Date.now(),
      message: text,
      type,
      timestamp: new Date().toISOString(),
      mode
    };
    setMessages(prev => [...prev, newMessage]);
  };

  const addSystemMessage = (text, type = 'system') => {
    const newMessage = {
      id: Date.now(),
      message: text,
      type,
      timestamp: new Date().toISOString()
    };
    setMessages(prev => [...prev, newMessage]);
  };

  const handleSendMessage = (message) => {
    if (!isConnected) {
      setError('Not connected to server');
      return;
    }

    // Add user message to chat
    addMessage(message, 'user');

    // Send to server
    socketService.sendMessage(message, currentMode);
  };

  const handleModeChange = (mode) => {
    setCurrentMode(mode);
    socketService.switchMode(mode);
  };

  const clearError = () => {
    setError(null);
  };

  return (
    <div className="App">
      <header className="app-header">
        <div className="header-content">
          <h1>🤖 Bob Chat Assistant</h1>
          <div className="connection-status">
            <span className={`status-indicator ${isConnected ? 'connected' : 'disconnected'}`}></span>
            <span className="status-text">
              {isConnected ? 'Connected' : 'Disconnected'}
            </span>
          </div>
        </div>
      </header>

      {error && (
        <div className="error-banner">
          <span>{error}</span>
          <button onClick={clearError} className="error-close">×</button>
        </div>
      )}

      <main className="chat-container">
        <div className="messages-container">
          {messages.length === 0 && (
            <div className="welcome-message">
              <h2>👋 Welcome to SevOne Chat!</h2>
              <p>I'm SevOne, your AI assistant. I can help you with:</p>
              <ul>
                <li>Speak to your SevOne instance</li>
              </ul>
            </div>
          )}

          {messages.map((msg) => {
            if (msg.type === 'system' || msg.type === 'error') {
              return (
                <div key={msg.id} className={`system-message ${msg.type}`}>
                  {msg.message}
                </div>
              );
            }
            return (
              <ChatMessage
                key={msg.id}
                message={msg.message}
                type={msg.type}
                timestamp={msg.timestamp}
                mode={msg.mode}
              />
            );
          })}

          {isTyping && <TypingIndicator />}
          <div ref={messagesEndRef} />
        </div>
      </main>

      <footer className="app-footer">
        <ChatInput
          onSendMessage={handleSendMessage}
          disabled={!isConnected || isTyping}
          currentMode={currentMode}
          onModeChange={handleModeChange}
        />
      </footer>
    </div>
  );
}

export default App;

// Made with Bob
