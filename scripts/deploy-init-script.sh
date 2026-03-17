#!/bin/bash
# Script para fazer deploy do init script na VPS

set -e

SCRIPT_SOURCE="/data/workspace/scripts/openclaw-init.sh"
VPS_HOST="156.67.31.108"
CONTAINER_NAME="openclaw-byyduxtw1ux1nragm8yfbdkh"
INIT_DIR="/data/.openclaw/scripts"

echo "=== Deploy do Init Script OpenClaw ==="

# Cria diretório no container
ssh root@$VPS_HOST "docker exec $CONTAINER_NAME mkdir -p $INIT_DIR"

# Copia o script
docker cp "$SCRIPT_SOURCE" "$CONTAINER_NAME:$INIT_DIR/init.sh" 2>/dev/null || {
    # Fallback via scp
    scp "$SCRIPT_SOURCE" "root@$VPS_HOST:/tmp/init.sh"
    ssh root@$VPS_HOST "docker cp /tmp/init.sh $CONTAINER_NAME:$INIT_DIR/init.sh"
}

# Dá permissão de execução
ssh root@$VPS_HOST "docker exec $CONTAINER_NAME chmod +x $INIT_DIR/init.sh"

echo "Script copiado para: $INIT_DIR/init.sh"
echo ""
echo "=== Proximo passo ==="
echo "Adicione esta variavel de ambiente no Coolify:"
echo ""
echo "  OPENCLAW_DOCKER_INIT_SCRIPT=/data/.openclaw/scripts/init.sh"
echo ""
echo "E reinicie o container pelo Coolify."
