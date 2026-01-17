#!/bin/bash
set -e

# Ensure directories exist (volume may be empty on first deploy)
mkdir -p /data/.clawdbot /data/clawd

# Always copy config from template (ensures updates are applied)
echo "Copying config from template..."
cp /root/clawdbot.json /data/.clawdbot/clawdbot.json
cat /data/.clawdbot/clawdbot.json

# Start the gateway
exec clawdbot gateway
