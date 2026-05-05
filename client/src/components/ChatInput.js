import React, { useState } from 'react';
import './ChatInput.css';

const ChatInput = ({ onSendMessage, disabled, currentMode, onModeChange }) => {
  const [message, setMessage] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (message.trim() && !disabled) {
      onSendMessage(message);
      setMessage('');
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault();
      handleSubmit(e);
    }
  };

  return (
    <div className="chat-input-container">
      
      <form onSubmit={handleSubmit} className="chat-input-form">
        <textarea
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyPress={handleKeyPress}
          placeholder="Type your message to Bob..."
          disabled={disabled}
          rows="1"
          className="chat-textarea"
        />
        <button 
          type="submit" 
          disabled={disabled || !message.trim()}
          className="send-button"
        >
          {disabled ? '⏳' : '📤'}
        </button>
      </form>
    </div>
  );
};

export default ChatInput;

// Made with Bob
