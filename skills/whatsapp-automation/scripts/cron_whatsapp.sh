#!/bin/bash
# Cron job template for scheduled WhatsApp messages
# Add to crontab: crontab -e

# Example: Send daily reminder at 8 AM
# 0 8 * * * /data/workspace/skills/whatsapp-automation/scripts/cron_whatsapp.sh "Lembrete: Reunião diária às 9h"

MESSAGE="${1:-Mensagem automática do Jarvis}"
PHONE="${WHATSAPP_PHONE:-+5584921629373}"

# Send message
openclaw message send \
    --channel whatsapp \
    --target "$PHONE" \
    --message "🔔 $MESSAGE

⏰ Enviado em: $(date '+%d/%m/%Y %H:%M')"

# Log execution
echo "[$(date)] Message sent to $PHONE: $MESSAGE" >> /tmp/whatsapp_cron.log
