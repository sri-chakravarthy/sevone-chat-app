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
      onBobStep,
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
        let buffer = '';

        const handleEventData = (eventData) => {
          try {
            const data = JSON.parse(eventData);

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
              case 'bob_step':
                if (onBobStep) onBobStep(data);
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
            console.error('Error parsing SSE data:', error, eventData);
          }
        };

        const processBuffer = () => {
          const events = buffer.split('\n\n');
          buffer = events.pop() || '';

          events.forEach(eventBlock => {
            const dataLines = eventBlock
              .split('\n')
              .filter(line => line.startsWith('data: '))
              .map(line => line.substring(6));

            if (dataLines.length > 0) {
              handleEventData(dataLines.join('\n'));
            }
          });
        };

        const readStream = () => {
          reader.read().then(({ done, value }) => {
            if (done) {
              buffer += decoder.decode();
              processBuffer();

              const remainingDataLines = buffer
                .split('\n')
                .filter(line => line.startsWith('data: '))
                .map(line => line.substring(6));

              if (remainingDataLines.length > 0) {
                handleEventData(remainingDataLines.join('\n'));
              }

              resolve();
              return;
            }

            buffer += decoder.decode(value, { stream: true });
            processBuffer();

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