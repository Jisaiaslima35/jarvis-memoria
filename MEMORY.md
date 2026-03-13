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

## Google Workspace (gws)
- **Status:** ✅ Configurado e funcionando
- **Binário:** `/usr/local/bin/gws` (dentro do container)
- **Credenciais:** `/root/.config/gws/` (dentro do container)
- **Conta:** brisacamera34@gmail.com
- **Configurado em:** 11/03/2026

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
Sempre usar modelos gratuitos (`:free`). Se um esgotar a cota, alternar automaticamente para o próximo da lista:

1. `nvidia-nim/moonshotai/kimi-k2.5` — atual, melhor desempenho
2. `google/gemini-2.5-flash` — direto Google (token já configurado nas variáveis de ambiente)
3. `openrouter/google/gemini-2.5-flash:free`
4. `openrouter/google/gemini-2.0-flash-exp:free`
5. `openrouter/meta-llama/llama-3.3-70b-instruct:free`
6. `openrouter/qwen/qwen3-4b:free`

## Integrações
| Serviço | Status | Comando |
|---------|--------|---------|
| Gmail | ✅ Ativo | `gws gmail +triage` |
| Google Calendar | ✅ Ativo | `gws calendar` |
| Google Drive | ✅ Ativo | `gws drive` |
| Google Sheets | ✅ Ativo | `gws sheets` |
| SSH VPS | ✅ Ativo | `ssh root@156.67.31.108` |

## Lições Aprendidas
- Sempre usar modelos via OpenRouter com `:free` para não gastar créditos
- O `gws` precisa estar instalado dentro do container via npm
- Credenciais do gws ficam em `/root/.config/gws/` dentro do container
- OAuth do Google: usar o código retornado via curl para autenticar na VPS

## Histórico de Ações Recentes
- Enviou e-mail para milianealexandre277@gmail.com com assunto "🚀 Nova proposta de jantar + novidades!" e corpo "Oi! Decidi que hoje vamos transformar a noite em algo inesquecível: vou buscar você com o carro, trarei o melhor prato e ainda temos um presente especial. Prepare-se para uma aventura gastronómica!" (ID: 19ce4653daed1bd8) em 12/03/2026.
- Enviou e-mail para milianealendre277@gmail.com com assunto "Nos vamos janta fora hoje" e corpo "Vou levar os menino vou de carro te buscar" (ID: 19ce46232a7ec072) em 12/03/2026.
- Implementou script de notificação automática de e-mail para Telegram, agendado via cron diário às 07:00 Brasília.
- Verificou funcionamento de n8n na VPS (processos ativos).
- Atualizou SOUL.md e BOOTSTRAP.md com documentação das conquistas recentes.

---
_Atualizado em: 12/03/2026_

