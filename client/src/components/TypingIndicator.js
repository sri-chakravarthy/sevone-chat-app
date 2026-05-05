import React from 'react';
import './TypingIndicator.css';

const TypingIndicator = () => {
  return (
    <div className="typing-indicator">
      <div className="typing-indicator-content">
        <span className="typing-dot"></span>
        <span className="typing-dot"></span>
        <span className="typing-dot"></span>
      </div>
      <span className="typing-text">Bob is thinking...</span>
    </div>
  );
};

export default TypingIndicator;

// Made with Bob
