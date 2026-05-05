import React from 'react';
import './ChatMessage.css';

const ChatMessage = ({ message, type, timestamp, mode }) => {
  const formatTimestamp = (ts) => {
    const date = new Date(ts);
    return date.toLocaleTimeString('en-US', { 
      hour: '2-digit', 
      minute: '2-digit' 
    });
  };

  const formatMessage = (text) => {
    // Simple markdown-like formatting
    const lines = text.split('\n');
    return lines.map((line, index) => {
      // Code blocks
      if (line.startsWith('```')) {
        return null;
      }
      
      // Bold text
      line = line.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
      
      // Inline code
      line = line.replace(/`(.*?)`/g, '<code>$1</code>');
      
      return (
        <span key={index}>
          <span dangerouslySetInnerHTML={{ __html: line }} />
          {index < lines.length - 1 && <br />}
        </span>
      );
    });
  };

  return (
    <div className={`chat-message ${type}`}>
      <div className="message-header">
        <span className="message-sender">
          {type === 'user' ? '👤 You' : '🤖 Bob'}
        </span>
        {mode && type === 'assistant' && (
          <span className="message-mode">{mode}</span>
        )}
        <span className="message-timestamp">
          {formatTimestamp(timestamp)}
        </span>
      </div>
      <div className="message-content">
        {formatMessage(message)}
      </div>
    </div>
  );
};

export default ChatMessage;

// Made with Bob
