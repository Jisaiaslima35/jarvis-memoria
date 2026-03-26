#!/bin/bash
# restore-jarvis.sh - Restaura todas as integrações do Jarvis após reiniciar o container
# Versão 2.0 - Atualizado em 26/03/2026

CONTAINER="openclaw-byyduxtw1ux1nragm8yfbdkh"
LOG="/root/restore-jarvis.log"

echo "🤖 Restaurando Jarvis..."
echo "📅 $(date)"
echo "⏳ Aguardando container subir..."
sleep 15

# ── 1. MODELO DE IA ──────────────────────────────────────────────
echo ""
echo "🧠 Configurando modelo de IA..."
docker exec $CONTAINER python3 -c "
import json
with open('/data/config.json') as f:
    c = json.load(f)

def set_model(obj):
    if isinstance(obj, dict):
        if 'primary' in obj:
            obj['primary'] = 'nanogpt/zai-org/glm-4.7'
        if 'fallbacks' in obj:
            obj['fallbacks'] = ['nanogpt/zai-org/glm-4.5', 'nanogpt/glm-4']
        for v in obj.values():
            set_model(v)
    elif isinstance(obj, list):
        for i in obj:
            set_model(i)

set_model(c)
with open('/data/config.json', 'w') as f:
    json.dump(c, f, indent=2)
print('Modelo: nanogpt/zai-org/glm-4.7')
"
echo "✅ Modelo configurado: nanogpt/zai-org/glm-4.7"

# ── 2. CHAVE SSH ─────────────────────────────────────────────────
echo ""
echo "🔐 Copiando chave SSH..."
docker exec $CONTAINER bash -c "mkdir -p /root/.ssh && chmod 700 /root/.ssh"
docker cp /root/.ssh/id_ed25519_jarvis $CONTAINER:/root/.ssh/id_ed25519 2>/dev/null && \
    docker exec $CONTAINER bash -c "chmod 600 /root/.ssh/id_ed25519" && \
    echo "✅ Chave SSH copiada" || echo "⚠️ Chave SSH não encontrada em /root/.ssh/id_ed25519_jarvis"
docker cp /root/.ssh/id_ed25519_jarvis.pub $CONTAINER:/root/.ssh/id_ed25519.pub 2>/dev/null

# ── 3. GITHUB CLI ─────────────────────────────────────────────────
echo ""
echo "🐙 Configurando GitHub CLI..."
docker exec $CONTAINER bash -c "
if ! command -v gh &> /dev/null; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main' > /etc/apt/sources.list.d/github-cli.list
    apt update -q && apt install gh -y -q 2>/dev/null
fi
echo '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' | gh auth login --with-token 2>/dev/null
echo 'GitHub autenticado'
"
echo "✅ GitHub configurado"

# ── 4. GOOGLE WORKSPACE CLI ───────────────────────────────────────
echo ""
echo "📦 Instalando Google Workspace CLI..."
docker exec $CONTAINER bash -c "
if ! command -v gws &> /dev/null; then
    npm install -g @googleworkspace/cli 2>/dev/null
fi
" 2>/dev/null
docker exec $CONTAINER bash -c "mkdir -p /root/.config/gws /data/config/gws"
for f in /root/.config/gws/*.json; do
    [ -f "$f" ] && docker cp "$f" $CONTAINER:/root/.config/gws/ 2>/dev/null
done
# Copia token cache para o path usado pelo Jarvis
docker cp /root/.config/gws/. $CONTAINER:/data/config/gws/ 2>/dev/null
echo "✅ Google Workspace configurado"

# ── 5. API PYTHON (PORTA 5000) ────────────────────────────────────
echo ""
echo "🐍 Verificando API Python (porta 5000)..."
API_RUNNING=$(docker exec $CONTAINER ps aux 2>/dev/null | grep api.py | grep -v grep)
if [ -z "$API_RUNNING" ]; then
    echo "⚠️ API não estava rodando. Subindo..."
    docker exec $CONTAINER bash -c "nohup python3 /root/api.py > /root/api.log 2>&1 &"
    sleep 3
    API_RUNNING=$(docker exec $CONTAINER ps aux 2>/dev/null | grep api.py | grep -v grep)
    [ -n "$API_RUNNING" ] && echo "✅ API subiu na porta 5000" || echo "❌ Falha ao subir API"
else
    echo "✅ API já estava rodando"
fi

# ── 6. REDE DOCKER (jarvis-net) ───────────────────────────────────
echo ""
echo "🌐 Verificando rede Docker jarvis-net..."
docker network create jarvis-net 2>/dev/null
for c in openclaw-byyduxtw1ux1nragm8yfbdkh n8n-o10sa3zdmru50oo4km5z2ose api-wlct6oixolqil0hlhnje5c4o; do
    docker network connect jarvis-net $c 2>/dev/null && echo "✅ $c conectado à jarvis-net" || echo "ℹ️ $c já está na jarvis-net"
done

# ── 7. IDENTITY.MD ────────────────────────────────────────────────
echo ""
echo "📋 Atualizando IDENTITY.md do GitHub..."
docker exec $CONTAINER bash -c "
curl -s https://raw.githubusercontent.com/Jisaiaslima35/jarvis-memoria/main/IDENTITY.md \
    -o /data/workspace/IDENTITY.md 2>/dev/null && echo 'IDENTITY.md atualizado' || echo 'IDENTITY.md nao encontrado no GitHub'
"

# ── 8. TESTES ─────────────────────────────────────────────────────
echo ""
echo "🧪 Executando testes..."

# Teste SSH
RESULT=$(docker exec $CONTAINER bash -c "ssh -o StrictHostKeyChecking=no -i /root/.ssh/id_ed25519 root@156.67.31.108 'echo ok'" 2>/dev/null)
[ "$RESULT" = "ok" ] && echo "✅ SSH funcionando" || echo "⚠️ SSH com problema"

# Teste GitHub
RESULT=$(docker exec $CONTAINER bash -c "gh repo list 2>/dev/null | head -1")
[ -n "$RESULT" ] && echo "✅ GitHub funcionando" || echo "⚠️ GitHub com problema"

# Teste Evolution API
RESULT=$(ssh -i /root/.ssh/id_ed25519 -o StrictHostKeyChecking=no root@156.67.31.108 \
    'curl -s -o /dev/null -w "%{http_code}" "http://10.0.4.4:8080/instance/connectionState/automacaojs" -H "apikey: knCOQV8nWo8X38HxWD2vq3MTU5uTEjkO"' 2>/dev/null)
[ "$RESULT" = "200" ] && echo "✅ Evolution API funcionando" || echo "⚠️ Evolution API: HTTP $RESULT"

# Teste API Python
RESULT=$(docker exec $CONTAINER bash -c "curl -s -o /dev/null -w '%{http_code}' http://localhost:5000" 2>/dev/null)
[ "$RESULT" = "501" ] && echo "✅ API Python na porta 5000 funcionando" || echo "⚠️ API Python: HTTP $RESULT"

# Teste modelo
MODELO=$(docker exec $CONTAINER python3 -c "
import json
with open('/data/config.json') as f:
    c = json.load(f)
def find(obj):
    if isinstance(obj, dict):
        if 'primary' in obj: return obj['primary']
        for v in obj.values():
            r = find(v)
            if r: return r
    elif isinstance(obj, list):
        for i in obj:
            r = find(i)
            if r: return r
print(find(c))
" 2>/dev/null)
echo "🧠 Modelo ativo: $MODELO"

echo ""
echo "✅ Jarvis restaurado com sucesso!"
echo "📅 Finalizado em: $(date)"
