#!/bin/bash

# RAM Alert Script for VPS
# Sends Telegram alert when RAM usage exceeds 90%

# Configuration
THRESHOLD=90
CHAT_ID="7845271497"
BOT_TOKEN="$(/opt/openclaw/app/bin/openclaw config.get telegram.bot_token 2>/dev/null || echo "")"

# If bot token not found in config, try environment variable
if [ -z "$BOT_TOKEN" ]; then
    BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
fi

# If still not found, exit (should be configured)
if [ -z "$BOT_TOKEN" ]; then
    echo "Error: Telegram bot token not configured"
    exit 1
fi

# Get RAM usage percentage
USAGE=$(ssh root@156.67.31.108 "free | awk '/Mem:/ {printf \"%.0f\", \$3/\$2 * 100}'")

# Check if usage exceeds threshold
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    # Get detailed info for message
    MEM_INFO=$(ssh root@156.67.31.108 "free -h")
    
    # Send Telegram message
    MESSAGE="🚨 *ALERTA DE RAM* 🚨\n\nA utilização de RAM na VPS atingiu *$USAGE%* (limite: $THRESHOLD%)\n\nDetalhes:\n\`\`\`$MEM_INFO\`\`\`\n\nHorário: $(TZ='America/Sao_Paulo' date '+%d/%m/%Y %H:%M:%S')"
    
    curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE" \
        -d parse_mode="Markdown" >/dev/null
        
    # Also log locally
    echo "$(TZ='America/Sao_Paulo' date): RAM alert triggered - $USAGE%" >> /data/workspace/logs/ram_alert.log
fi