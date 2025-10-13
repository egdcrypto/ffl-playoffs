#!/bin/bash
# Orchestration Framework: Send messages to engineers
# Usage: ./send-message.sh <engineer-channel> "<message>"

CHANNEL=$1
MESSAGE=$2

if [ -z "$CHANNEL" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: ./send-message.sh <channel> \"<message>\""
    echo "Example: ./send-message.sh ffl-dev:1 \"Fix the feature file\""
    exit 1
fi

# Create messages directory if it doesn't exist
mkdir -p .messages

# Extract engineer number from channel (e.g., ffl-dev:1 -> 1)
ENGINEER=$(echo $CHANNEL | cut -d':' -f2)

# Create timestamp
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Create message file
MESSAGE_FILE=".messages/engineer-${ENGINEER}-${TIMESTAMP}.txt"

cat > "$MESSAGE_FILE" <<EOF
To: $CHANNEL
From: Product Manager
Timestamp: $(date '+%Y-%m-%d %H:%M:%S')
---
$MESSAGE
EOF

echo "✅ Message sent to $CHANNEL"
echo "📝 Saved to: $MESSAGE_FILE"
