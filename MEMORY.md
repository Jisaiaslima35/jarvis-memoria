# MEMORY.md - Memória de Longo Prazo do Jarvis

_O cérebro de longo prazo do Jarvis. Atualizado a cada sessão relevante._

## Sobre Isaías
- Nome: Isaías Silva
- Email: isaiassilva356@gmail.com / brisacamera34@gmail.com
- Fuso: Brasília (UTC-3)
- Contato principal: Telegram via @isa_openclaw_bot
- Gosta de respostas diretas, tom descontraído, sem bajulação

## Infraestrutura
- VPS Contabo: `156.67.31.108` (acesso root via SSH)
- OpenClaw: `openclaw.automacaojs.club`
- Container OpenClaw: `openclaw-byyduxtw1ux1nragm8yfbdkh`
- Coolify: `http://156.67.31.108:8000`
- n8n: rodando na mesma VPS
- Domínio: `automacaojs.club` (Cloudflare)

## Acesso SSH à VPS
- Chave SSH: `/root/.ssh/id_ed25519` (dentro do container)
- Acesso confirmado sem senha: `ssh root@156.67.31.108`
- O Jarvis pode executar qualquer comando na VPS

## Notificações de Futebol ⚽
- **Status:** ✅ Configurado e ativo
- **API:** API-Football (plano gratuito, 100 req/dia)
- **API Key:** `f6188cf30e711ef0bcd5db126e1cdc52`
- **Script:** `/data/workspace/scripts/football_notifier.py`
- **Wrapper:** `/data/workspace/scripts/send_football_notification.sh`
- **Cron ID:** `72da9585-0c8e-42de-b551-5f7c07e4646b`
- **Horário:** Todos os dias às 08:00 (Brasília)
- **Canais:** Telegram via @isa_openclaw_bot
- **Ligas monitoradas:**
  - 🇧🇷 Campeonato Brasileiro Série A
  - 🏆 CONMEBOL Libertadores
  - 🌎 CONMEBOL Sudamericana
- **Configurado em:** 14/03/2026

## Edge TTS (Resposta por Voz)
- **Status:** ✅ Configurado e funcionando
- **Script:** `/data/workspace/scripts/edge_tts_responder.py`
- **Voz padrão:** `pt-BR-AntonioNeural` (masculina)
- **Vozes disponíveis:**
  - `pt-BR-AntonioNeural` (masculina)
  - `pt-BR-FranciscaNeural` (feminina)
  - `pt-BR-ThalitaMultilingualNeural` (feminina, multi-idioma)
- **Comportamento:** Quando Isaías enviar áudio, perguntar se quer resposta em texto ou voz
- **Configurado em:** 13/03/2026

## Google Workspace (gws)
- **Status:** ✅ Configurado e funcionando
- **Binário:** `/data/tools/gws` (local correto)
- **Credenciais:** `/data/.config/gws/` (dentro do container)
- **Conta:** isaiassilva356@gmail.com (atualizado em 15/03/2026)
- **Conta anterior:** brisacamera34@gmail.com (migrada)
- **Configurado em:** 11/03/2026 | Atualizado em: 15/03/2026

### Comandos disponíveis:
- `gws gmail +triage` — lista emails não lidos
- `gws gmail +send` — envia email (requer confirmação de Isaías)
- `gws gmail +reply` — responde email
- `gws calendar` — acessa agenda
- `gws drive` — acessa Google Drive
- `gws sheets` — acessa Google Sheets

## Configurações do OpenClaw
- Telegram bot: `@isa_openclaw_bot` (ID: 8296072598)
- Google Gemini direto: sem créditos — NÃO usar nunca

### Estratégia de Modelos
Sempre usar modelos gratuitos quando possível. Se um falhar, alternar automaticamente para o próximo:

1. `nvidia-nim/moonshotai/kimi-k2.5` — primário, melhor desempenho
2. `openrouter/stepfun/step-3.5-flash:free` — fallback 1
3. `nvidia/nemotron-3-nano-30b-a3b:free` — fallback 2
4. `google/gemini-2.5-flash` — fallback 3
5. `openrouter/openrouter/free` — fallback final

## Integrações
| Serviço | Status | Comando |
|---------|--------|---------|
| Gmail | ✅ Ativo | `gws gmail +triage` |
| Google Calendar | ✅ Ativo | `gws calendar` |
| Google Drive | ✅ Ativo | `gws drive` |
| Google Sheets | ✅ Ativo | `gws sheets` |
| SSH VPS | ✅ Ativo | `ssh root@156.67.31.108` |
| Discord | ✅ Ativo | servidor: 1482201504558354574 |

## Lições Aprendidas
- Sempre editar o config pelo terminal, nunca salvar pela interface web
- O arquivo de config fica em `/data/.openclaw/openclaw.json`
- A variável `OPENCLAW_PRIMARY_MODEL` no Coolify sobrescreve o config
- `NVIDIA_NIM_API_KEY` deve ter o mesmo valor que `MOONSHOT_API_KEY`
- O nome real do container é `openclaw-byyduxtw1ux1nragm8yfbdkh` (sem espaços)

## Histórico de Ações Recentes
- Integração Discord concluída em 14/03/2026
- Bot jarvis-isa adicionado ao servidor "Servidor Automacao JS"
- Guild ID: 1482201504558354574

## Jarvis WhatsApp Agent ✅
- **Status:** Ativo e funcionando desde 14/03/2026
- **Nome do agente:** `jarvis-whatsapp`
- **Modelo:** stepfun/step-3.5-flash
- **Workspace:** `/root/jarvis-whatsapp` (dentro do container)
- **Número vinculado:** +558496327329
- **Resposta DM:** automática
- **Resposta em grupos:** só quando mencionado (`@Jarvis`)
- **Comandos suportados:** status (VPS), emails, notícias, clima, agenda

### 🧠 Skills Instaladas (ClawHub)
- **study-habits** — Planejamento de estudos e hábitos
- **news-summary** — Resumo diário de notícias do mundo
- **agent-knowledge** — Memorização e recall de conversas
- **claw-news** — Novidades da comunidade OpenClaw
- **weather** — Previsão do tempo (já incluso no OpenClaw)

**Instruções enviadas** (`INSTRUCTIONS.md`) para o agente usar essas habilidades.

- **Teste:** ✅ Respondendo em tempo real
- **Próximos:** Integrar Gmail/Calendar de forma automática (possível via gws)

## Cursos em Andamento (2026)
### Faculdade - IFSULDEMINAS
- **Curso:** Desenvolvedor de Sistemas
- **Período:** 23/03/2026 a 01/07/2026
- **Avaliações:** 23/04, 23/05, 23/06

### SENAI - Inteligência Artificial Industrial
- **Status:** Em andamento (100% EAD)
- **Plataforma:** ead.senai.br
- **Login:** CPF sem pontos / Senha: 12345

### SENAI DR-CE (4 cursos)
- **Cursos:** Logística Industrial, Programação de Produção, Matemática Aplicada, Conceitos Básicos da Logística
- **Código:** 00218.2026.0014
- **Login:** 06802911485 / senai1485

### PU12 - Trilha Fullstack
- **Status:** Aula 5 realizada (12/03)
- **Próximas:** Aguardando agenda

## Plano de Estudos
- **Planilha:** https://docs.google.com/spreadsheets/d/1-xAC9NWc_SuOJyNXyGwoG9KygZ8nSOUKiwDBiGu9JWM/edit
- **Lembretes diários:** 19h (revisar estudos)
- **Check-in semanal:** Domingos às 20h

---

## Comandos Técnicos — Jarvis WhatsApp
**Versão:** 2026.2.6 | **Container:** openclaw-byyduxtw1ux1nragm8yfbdkh

### ✅ Comandos que FUNCIONAM
```bash
# 1. Criar o agente WhatsApp
docker exec openclaw-byyduxtw1ux1nragm8yfbdkh openclaw agents add jarvis-whatsapp \
  --model stepfun/step-3.5-flash \
  --bind whatsapp \
  --workspace /root/jarvis-whatsapp \
  --non-interactive

# 2. Verificar agentes e bindings
docker exec openclaw-byyduxtw1ux1nragm8yfbdkh openclaw agents list --bindings

# 3. Aprovar pareamento do WhatsApp (após código)
docker exec openclaw-byyduxtw1ux1nragm8yfbdkh openclaw pairing approve whatsapp CODIGO

# 4. Ver logs do canal
docker exec openclaw-byyduxtw1ux1nragm8yfbdkh openclaw channels logs

# 5. Reiniciar container após mudanças no config
docker restart openclaw-byyduxtw1ux1nragm8yfbdkh
```

### ⚠️ Comandos que NÃO FUNCIONAM (evitar)
| Comando | Motivo |
|---------|--------|
| `--task` | Opção inexistente no `agents add` |
| `openclaw channels update` | Comando não existe |
| `openclaw channels resolve --channel whatsapp` | Não suportado |
| `openclaw agents bind` | Não existe nessa versão |

### 🔧 Configuração Manual (JSON) para Grupos
Editar `/data/.openclaw/openclaw.json` no bloco `"whatsapp"`:
```json
{
  "whatsapp": {
    "groupPolicy": "allowlist",
    "groupMentionOnly": true,
    ...
  }
}
```
Use `sed` rápido:
```bash
docker exec openclaw-byyduxtw1ux1nragm8yfbdkh sed -i \
  's/"whatsapp": {$/"whatsapp": { "groupPolicy": "allowlist", "groupMentionOnly": true,/' \
  /data/.openclaw/openclaw.json
```

### 📊 Configuração Final
- Agente: `jarvis-whatsapp`
- Modelo: `stepfun/step-3.5-flash`
- Workspace: `/root/jarvis-whatsapp`
- Vínculo: WhatsApp número vinculado via QR
- Resposta DM: automática
- Resposta em grupos: **só quando mencionado** (`@Jarvis`)
- Logs: `Activation: mention` confirma

---
_Atualizado em: 14/03/2026_