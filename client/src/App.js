import React, { useState, useEffect, useRef } from 'react';
import apiService from './services/apiService';
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
  const activeAssistantMessageIdRef = useRef(null);
  const messagesEndRef = useRef(null);

  useEffect(() => {
    // Check server health on mount
    checkServerHealth();

    // Set up periodic health checks
    const healthCheckInterval = setInterval(checkServerHealth, 30000); // Every 30 seconds

    return () => {
      clearInterval(healthCheckInterval);
      apiService.cancelRequest();
    };
  }, []);

  useEffect(() => {
    // Scroll to bottom when messages change
    scrollToBottom();
  }, [messages, isTyping]);

  const checkServerHealth = async () => {
    try {
      await apiService.checkHealth();
      setIsConnected(true);
      setError(null);
    } catch (error) {
      setIsConnected(false);
      console.error('Server health check failed:', error);
    }
  };

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

  const ensureStreamingAssistantMessage = (mode = currentMode) => {
    if (activeAssistantMessageIdRef.current) {
      return activeAssistantMessageIdRef.current;
    }

    const messageId = Date.now();
    activeAssistantMessageIdRef.current = messageId;

    setMessages(prev => [...prev, {
      id: messageId,
      message: '',
      type: 'assistant',
      timestamp: new Date().toISOString(),
      mode
    }]);

    return messageId;
  };

  const appendToAssistantMessage = (chunk, mode = currentMode) => {
    const messageId = ensureStreamingAssistantMessage(mode);

    setMessages(prev => prev.map(msg => (
      msg.id === messageId
        ? { ...msg, message: `${msg.message}${chunk}`, mode }
        : msg
    )));
  };

  const finalizeAssistantMessage = (finalMessage, mode = currentMode) => {
    const messageId = ensureStreamingAssistantMessage(mode);

    setMessages(prev => prev.map(msg => (
      msg.id === messageId
        ? { ...msg, message: finalMessage || msg.message, mode }
        : msg
    )));
  };

  const resetStreamingAssistantMessage = () => {
    activeAssistantMessageIdRef.current = null;
  };

  const handleSendMessage = async (message) => {
    if (!isConnected) {
      setError('Not connected to server');
      return;
    }

    // Add user message to chat
    addMessage(message, 'user');

    try {
      resetStreamingAssistantMessage();

      await apiService.sendMessage(message, currentMode, {
        onMessageReceived: (data) => {
          console.log('Message received:', data);
        },
        onBobThinking: () => {
          setIsTyping(true);
          addSystemMessage('Bob is thinking...', 'system');
        },
        onBobStream: (data) => {
          setIsTyping(false);

          if (data.stream === 'stdout' && data.chunk) {
            appendToAssistantMessage(data.chunk, currentMode);
          }

          if (data.stream === 'stderr' && data.chunk?.trim()) {
            addSystemMessage(`Bob step: ${data.chunk.trim()}`, 'system');
          }
        },
        onBobResponse: (data) => {
          setIsTyping(false);
          finalizeAssistantMessage(data.message, data.mode);
        },
        onBobComplete: (data) => {
          setIsTyping(false);
          addSystemMessage(`Bob completed: ${data.status}`, 'system');
          resetStreamingAssistantMessage();
          console.log('Bob completed:', data.status);
        },
        onError: (data) => {
          setIsTyping(false);
          setError(data.message);
          addSystemMessage(`Error: ${data.message}`, 'error');
          resetStreamingAssistantMessage();
        },
        onBobStep: (data) => {
          if (data.message) {
            addSystemMessage(`Bob step: ${data.message}`, 'system');
          }
        }
      });
    } catch (error) {
      setIsTyping(false);
      setError('Failed to send message');
      addSystemMessage(`Error: Failed to send message`, 'error');
      resetStreamingAssistantMessage();
      console.error('Error sending message:', error);
    }
  };

  const handleModeChange = (mode) => {
    setCurrentMode(mode);
    addSystemMessage(`Switched to ${mode} mode`);
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
