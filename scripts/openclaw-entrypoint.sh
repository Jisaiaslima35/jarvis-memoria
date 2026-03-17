#!/bin/bash
# Entrypoint wrapper para OpenClaw
# Executa correções antes de iniciar o gateway

echo "[OpenClaw Entrypoint] Iniciando..."

# Executa script de correção de config
if [ -f "/data/workspace/scripts/openclaw-config-fix.sh" ]; then
    echo "[OpenClaw Entrypoint] Aplicando correções de config..."
    bash /data/workspace/scripts/openclaw-config-fix.sh
fi

# Inicia o OpenClaw normalmente
echo "[OpenClaw Entrypoint] Iniciando OpenClaw..."
exec /opt/openclaw/app/gateway
