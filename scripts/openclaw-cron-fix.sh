#!/bin/bash
# Script de correção de config OpenClaw - executado via cron no HOST
# Este script roda na VPS e executa comandos dentro do container

CONTAINER_NAME="openclaw-byyduxtw1ux1nragm8yfbdkh"
CONFIG_FILE="/data/.openclaw/openclaw.json"
LOG_FILE="/var/log/openclaw-cron-fix.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Verifica se container está rodando
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    log "Container $CONTAINER_NAME não está rodando. Pulando..."
    exit 0
fi

log "=== Verificando config do OpenClaw ==="

# Instala jq no container se necessário
docker exec "$CONTAINER_NAME" bash -c "command -v jq &>/dev/null || (apt-get update -qq && apt-get install -y -qq jq)" 2>/dev/null

# Lê config atual via docker exec
current_primary=$(docker exec "$CONTAINER_NAME" jq -r '.agents.defaults.model.primary // empty' "$CONFIG_FILE" 2>/dev/null)
current_stepfun_url=$(docker exec "$CONTAINER_NAME" jq -r '.models.providers.stepfun.baseUrl // empty' "$CONFIG_FILE" 2>/dev/null)
current_ollama=$(docker exec "$CONTAINER_NAME" jq -r '.models.providers.ollama.models[0].id // empty' "$CONFIG_FILE" 2>/dev/null)

log "Valores atuais: primary=$current_primary, stepfun_url=$current_stepfun_url, ollama=$current_ollama"

# Verifica se precisa corrigir
needs_fix=0

if [ "$current_primary" != "stepfun/step-3.5-flash" ]; then
    log "Modelo primário incorreto: $current_primary"
    needs_fix=1
fi

if [ "$current_stepfun_url" != "https://api.stepfun.ai/v1" ]; then
    log "URL StepFun incorreta: $current_stepfun_url"
    needs_fix=1
fi

if [ "$current_ollama" != "qwen2.5:7b" ]; then
    log "Modelo Ollama incorreto: $current_ollama"
    needs_fix=1
fi

if [ "$needs_fix" -eq 0 ]; then
    log "Config está correto. Nenhuma ação necessária."
    exit 0
fi

log "Aplicando correções..."

# Aplica correções
docker exec "$CONTAINER_NAME" bash -c "
    jq '
        .agents.defaults.model.primary = \"stepfun/step-3.5-flash\" |
        (if .models.providers.stepfun then .models.providers.stepfun.baseUrl = \"https://api.stepfun.ai/v1\" else . end) |
        (if .models.providers.ollama.models[0] then .models.providers.ollama.models[0].id = \"qwen2.5:7b\" else . end)
    ' $CONFIG_FILE > ${CONFIG_FILE}.tmp && mv ${CONFIG_FILE}.tmp $CONFIG_FILE && chmod 600 $CONFIG_FILE
"

if [ $? -eq 0 ]; then
    log "Correções aplicadas com sucesso!"
    # Verifica resultado
    new_primary=$(docker exec "$CONTAINER_NAME" jq -r '.agents.defaults.model.primary // empty' "$CONFIG_FILE" 2>/dev/null)
    log "Novo valor primary: $new_primary"
else
    log "ERRO ao aplicar correções"
    exit 1
fi

log "=== Concluído ==="
