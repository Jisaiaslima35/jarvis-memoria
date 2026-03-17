#!/bin/bash
# OpenClaw Init Script - executado automaticamente após cada restart
# Configurado via OPENCLAW_DOCKER_INIT_SCRIPT

CONFIG_FILE="${OPENCLAW_STATE_DIR:-/data/.openclaw}/openclaw.json"
LOG_FILE="/tmp/openclaw-init.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== OpenClaw Init Script iniciado ==="

# Aguarda config ser gerado pelo configure.js
for i in {1..10}; do
    if [ -f "$CONFIG_FILE" ]; then
        break
    fi
    log "Aguardando config... tentativa $i/10"
    sleep 1
done

if [ ! -f "$CONFIG_FILE" ]; then
    log "ERRO: Config não encontrado em $CONFIG_FILE"
    exit 0
fi

# Verifica jq
if ! command -v jq &> /dev/null; then
    log "Instalando jq..."
    apt-get update -qq && apt-get install -y -qq jq &>/dev/null
fi

# Lê valores atuais
current_primary=$(jq -r '.agents.defaults.model.primary // empty' "$CONFIG_FILE" 2>/dev/null)
current_stepfun_url=$(jq -r '.models.providers.stepfun.baseUrl // empty' "$CONFIG_FILE" 2>/dev/null)
current_ollama=$(jq -r '.models.providers.ollama.models[0].id // empty' "$CONFIG_FILE" 2>/dev/null)

log "Valores atuais: primary=$current_primary, stepfun_url=$current_stepfun_url, ollama=$current_ollama"

# Aplica correções apenas se necessário
needs_update=0

if [ "$current_primary" != "stepfun/step-3.5-flash" ]; then
    log "Modelo primário incorreto. Aplicando correção..."
    needs_update=1
fi

if [ "$current_stepfun_url" != "https://api.stepfun.ai/v1" ]; then
    log "URL StepFun incorreta. Aplicando correção..."
    needs_update=1
fi

if [ "$current_ollama" != "qwen2.5:7b" ]; then
    log "Modelo Ollama incorreto. Aplicando correção..."
    needs_update=1
fi

if [ "$needs_update" -eq 1 ]; then
    # Aplica correções
    jq '
        .agents.defaults.model.primary = "stepfun/step-3.5-flash" |
        (if .models.providers.stepfun then .models.providers.stepfun.baseUrl = "https://api.stepfun.ai/v1" else . end) |
        (if .models.providers.ollama.models[0] then .models.providers.ollama.models[0].id = "qwen2.5:7b" else . end)
    ' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    
    chmod 600 "$CONFIG_FILE"
    
    # Verifica resultado
    new_primary=$(jq -r '.agents.defaults.model.primary' "$CONFIG_FILE" 2>/dev/null)
    log "Config atualizado: primary=$new_primary"
else
    log "Config já está correto. Nenhuma alteração necessária."
fi

log "=== Init script concluído ==="
