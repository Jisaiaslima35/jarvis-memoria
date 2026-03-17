---
name: whatsapp-automation
description: Automate WhatsApp messaging, notifications, and responses via OpenClaw WhatsApp channel. Use when users need to send/receive WhatsApp messages programmatically, set up automated WhatsApp notifications, manage WhatsApp conversations, or integrate WhatsApp with other systems. Includes scripts for sending messages, checking status, managing conversations, and handling media.
---

# WhatsApp Automation

## Overview
This skill enables programmatic control of WhatsApp through OpenClaw's WhatsApp channel integration. It provides scripts and workflows for sending messages, automating notifications, managing conversations, and integrating WhatsApp with other services.

## When to Use This Skill
- Send automated WhatsApp messages (alerts, reminders, notifications)
- Receive and process incoming WhatsApp messages
- Manage WhatsApp conversations programmatically
- Integrate WhatsApp with email, calendar, or other services
- Handle WhatsApp media (images, documents, voice notes)
- Set up WhatsApp-based workflows and automations

## Prerequisites
- WhatsApp channel enabled in OpenClaw config (`channels.whatsapp.enabled: true`)
- WhatsApp account linked via QR code (`openclaw channels login`)
- Phone number configured in `allowFrom` for self-chat mode

## Core Capabilities

### 1. Send WhatsApp Messages
Use the `message` tool with `channel: "whatsapp"`:

```json
{
  "action": "send",
  "channel": "whatsapp",
  "target": "+5584921629373",
  "message": "Olá! Esta é uma mensagem automática."
}
```

**Parameters:**
- `target`: Phone number in E.164 format (+ Country Code + Number)
- `message`: Text message content
- `media`: Optional media file path or URL
- `caption`: Optional caption for media

### 2. Send Media Files
Images, documents, audio, video:

```json
{
  "action": "send",
  "channel": "whatsapp",
  "target": "+5584921629373",
  "media": "/path/to/file.pdf",
  "caption": "Documento importante",
  "filename": "documento.pdf"
}
```

### 3. React to Messages
Add emoji reactions to incoming messages:

```json
{
  "action": "react",
  "channel": "whatsapp",
  "target": "+5584921629373",
  "messageId": "message_id_here",
  "emoji": "👍"
}
```

### 4. Check Channel Status
Verify WhatsApp connection:

```bash
openclaw channels status whatsapp
```

## Self-Chat Mode (Recommended)
For personal automation, use WhatsApp "Message yourself" feature:

1. Configure in `openclaw.json`:
```json
{
  "channels": {
    "whatsapp": {
      "enabled": true,
      "selfChatMode": true,
      "dmPolicy": "allowlist",
      "allowFrom": ["+5584921629373"]
    }
  }
}
```

2. Message yourself from your own WhatsApp to trigger OpenClaw responses

## Automation Workflows

### Daily Summary Notification
Send daily reports via WhatsApp:

```bash
#!/bin/bash
# send_daily_summary.sh

MESSAGE=$(cat <<EOF
📊 Resumo Diário - $(date '+%d/%m/%Y')

✅ Tarefas concluídas: X
⏰ Eventos hoje: Y
📧 Emails pendentes: Z

Acesse o painel para mais detalhes.
EOF
)

openclaw message send \
  --channel whatsapp \
  --target "+5584921629373" \
  --message "$MESSAGE"
```

### Alert on Critical Events
Trigger WhatsApp alerts when conditions are met:

```bash
#!/bin/bash
# critical_alert.sh

if [ "$ALERT_TYPE" = "HIGH" ]; then
  openclaw message send \
    --channel whatsapp \
    --target "+5584921629373" \
    --message "🚨 ALERTA CRÍTICO: ${ALERT_MESSAGE}"
fi
```

## Scripts Reference

Available scripts in `scripts/`:

- `send_message.sh` - Send text or media messages
- `check_status.sh` - Check WhatsApp connection status
- `format_number.py` - Format phone numbers to E.164
- `cron_whatsapp.sh` - Cron job template for scheduled messages

## Limitations

- **24-hour rule**: Only reply to messages received within last 24h (WhatsApp Business limitation does not apply to self-chat)
- **Rate limits**: Avoid flooding; respect WhatsApp's rate limits
- **Media size**: Maximum 50MB for inbound, 5MB for outbound
- **Groups**: Requires @mention or activation mode configuration

## Security Notes

- Keep `allowFrom` list restricted to prevent spam
- Use `dmPolicy: "pairing"` for unknown senders
- Never expose credentials or session files
- WhatsApp credentials stored in `~/.openclaw/credentials/whatsapp/`

## Troubleshooting

**"Not linked" error**:
```bash
openclaw channels login  # Re-scan QR code
```

**"Disconnected" error**:
```bash
openclaw doctor  # Run diagnostics
```

**Messages not sending**:
- Verify target number is in E.164 format
- Check if WhatsApp session is active
- Ensure enough storage space on device
