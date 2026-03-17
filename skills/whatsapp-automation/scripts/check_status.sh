#!/bin/bash
# Check WhatsApp connection status

echo "Checking WhatsApp status..."
openclaw channels status whatsapp

if [ $? -eq 0 ]; then
    echo "✅ WhatsApp is connected"
else
    echo "❌ WhatsApp connection issue detected"
    echo ""
    echo "To reconnect, run:"
    echo "  openclaw channels login"
fi
