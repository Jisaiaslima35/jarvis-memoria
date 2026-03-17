#!/bin/bash
# Wrapper para enviar notificação de jogos via Telegram
# Chamado pelo cron job diário

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE_DIR="/data/workspace"

# Carregar a chave da API (deve ser configurada via Coolify ou .env)
export API_FOOTBALL_KEY="${API_FOOTBALL_KEY:-SUA_CHAVE_AQUI}"

# Verificar se a chave foi configurada
if [ "$API_FOOTBALL_KEY" = "SUA_CHAVE_AQUI" ]; then
    echo "[ERRO] Chave da API-Football não configurada!"
    echo "Configure API_FOOTBALL_KEY nas variáveis de ambiente do Coolify."
    exit 1
fi

# Executar o script Python e capturar saída
echo "[$(date)] Iniciando busca de jogos..."
python3 "$SCRIPT_DIR/football_notifier.py"

# Verificar se a mensagem foi gerada
if [ -f /tmp/football_notification.txt ]; then
    MESSAGE=$(cat /tmp/football_notification.txt)
    echo "[$(date)] Mensagem gerada com sucesso"
else
    echo "[$(date)] Erro: arquivo de mensagem não foi gerado"
    exit 1
fi

# Limpar arquivo temporário
rm -f /tmp/football_notification.txt
