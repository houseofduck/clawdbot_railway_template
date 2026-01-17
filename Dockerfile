FROM node:22-bookworm-slim

# Install git (required for some npm dependencies)
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Install clawdbot globally
RUN npm install -g clawdbot@latest

# Create persistent data directories
RUN mkdir -p /data/.clawdbot /data/clawd && \
    chown -R node:node /data

# Use existing node user (UID 1000) for security
USER node
WORKDIR /home/node

# Set environment for persistent storage
ENV CLAWDBOT_STATE_DIR=/data/.clawdbot
ENV HOME=/home/node

EXPOSE 18789

COPY --chown=node:node start.sh /home/node/start.sh
RUN chmod +x /home/node/start.sh

CMD ["/home/node/start.sh"]
