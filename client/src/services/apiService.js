import axios from 'axios';

class ApiService {
  constructor() {
    this.baseURL = process.env.REACT_APP_API_URL || 'http://9.60.155.22:5000';
    this.eventSource = null;
  }

  /**
   * Check server health
   */
  async checkHealth() {
    try {
      const response = await axios.get(`${this.baseURL}/api/health`);
      return response.data;
    } catch (error) {
      console.error('Health check failed:', error);
      throw error;
    }
  }

  /**
   * Send a chat message and receive streaming response
   */
  sendMessage(message, mode = 'code', callbacks = {}) {
    const {
      onMessageReceived,
      onBobThinking,
      onBobStream,
      onBobResponse,
      onBobComplete,
      onError
    } = callbacks;

    // Close any existing connection
    if (this.eventSource) {
      this.eventSource.close();
    }

    // Create EventSource for Server-Sent Events
    return new Promise((resolve, reject) => {
      // Make POST request with fetch to get streaming response
      fetch(`${this.baseURL}/api/chat`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ message, mode })
      })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }

        const reader = response.body.getReader();
        const decoder = new TextDecoder();

        const readStream = () => {
          reader.read().then(({ done, value }) => {
            if (done) {
              resolve();
              return;
            }

            // Decode the chunk
            const chunk = decoder.decode(value, { stream: true });
            
            // Split by newlines to handle multiple events
            const lines = chunk.split('\n');
            
            lines.forEach(line => {
              if (line.startsWith('data: ')) {
                try {
                  const data = JSON.parse(line.substring(6));
                  
                  // Handle different event types
                  switch (data.type) {
                    case 'message_received':
                      if (onMessageReceived) onMessageReceived(data);
                      break;
                    case 'bob_thinking':
                      if (onBobThinking) onBobThinking(data);
                      break;
                    case 'bob_stream':
                      if (onBobStream) onBobStream(data);
                      break;
                    case 'bob_response':
                      if (onBobResponse) onBobResponse(data);
                      break;
                    case 'bob_complete':
                      if (onBobComplete) onBobComplete(data);
                      break;
                    case 'error':
                      if (onError) onError(data);
                      break;
                    default:
                      console.log('Unknown event type:', data.type);
                  }
                } catch (error) {
                  console.error('Error parsing SSE data:', error);
                }
              }
            });

            // Continue reading
            readStream();
          }).catch(error => {
            console.error('Stream reading error:', error);
            if (onError) onError({ message: 'Stream reading error', error: error.message });
            reject(error);
          });
        };

        readStream();
      })
      .catch(error => {
        console.error('Fetch error:', error);
        if (onError) onError({ message: 'Failed to connect to server', error: error.message });
        reject(error);
      });
    });
  }

  /**
   * Cancel ongoing request
   */
  cancelRequest() {
    if (this.eventSource) {
      this.eventSource.close();
      this.eventSource = null;
    }
  }
}

export default new ApiService();

// Made with Bob