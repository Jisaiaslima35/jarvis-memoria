#!/bin/bash
# Script de correção automática do config do OpenClaw
# Executado após restart do container para reaplicar personalizações

CONFIG_FILE="/data/.openclaw/openclaw.json"
LOG_FILE="/var/log/openclaw-config-fix.log"

# Função de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "=== Iniciando correção de config do OpenClaw ==="

# Aguarda o config existir (caso o container esteja iniciando)
for i in {1..30}; do
    if [ -f "$CONFIG_FILE" ]; then
        break
    fi
    log "Aguardando config... tentativa $i/30"
    sleep 1
done

if [ ! -f "$CONFIG_FILE" ]; then
    log "ERRO: Arquivo de config não encontrado em $CONFIG_FILE"
    exit 1
fi

# Backup antes de modificar
cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%s)"
log "Backup criado"

# Verifica se jq está disponível
if ! command -v jq &> /dev/null; then
    log "ERRO: jq não encontrado. Instalando..."
    apt-get update && apt-get install -y jq || exit 1
fi

# Lê config atual
current_model=$(jq -r '.models.primary // empty' "$CONFIG_FILE")
current_stepfun_url=$(jq -r '.endpoints.stepfun.url // empty' "$CONFIG_FILE" 2>/dev/null || echo "")
current_ollama=$(jq -r '.models.ollama.model // empty' "$CONFIG_FILE" 2>/dev/null || echo "")

log "Config atual: primary=$current_model, stepfun_url=$current_stepfun_url, ollama=$current_ollama"

# Aplica correções
jq --arg model "stepfun/step-3.5-flash" \
   --arg stepfun_url "https://api.stepfun.ai/v1" \
   --arg ollama_model "qwen2.5:7b" '
    .models.primary = $model |
    (if .endpoints.stepfun then .endpoints.stepfun.url = $stepfun_url else . end) |
    (if .models.ollama then .models.ollama.model = $ollama_model else . end)
' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

# Verifica resultado
new_model=$(jq -r '.models.primary' "$CONFIG_FILE")
log "Config atualizado: primary=$new_model"

log "=== Correção concluída ==="
