#!/bin/bash
# WhatsApp Message Sender
# Usage: ./send_message.sh <phone> <message> [media_path]

PHONE="$1"
MESSAGE="$2"
MEDIA="$3"

if [ -z "$PHONE" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <phone> <message> [media_path]"
    echo "Example: $0 '+5584921629373' 'Hello World'"
    exit 1
fi

# Format phone number (ensure + prefix)
if [[ ! "$PHONE" =~ ^\+ ]]; then
    PHONE="+$PHONE"
fi

if [ -n "$MEDIA" ] && [ -f "$MEDIA" ]; then
    # Send with media
    openclaw message send \
        --channel whatsapp \
        --target "$PHONE" \
        --message "$MESSAGE" \
        --media "$MEDIA" \
        --caption "$MESSAGE"
else
    # Send text only
    openclaw message send \
        --channel whatsapp \
        --target "$PHONE" \
        --message "$MESSAGE"
fi

echo "Message sent to $PHONE"
