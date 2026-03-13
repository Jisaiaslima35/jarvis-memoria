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
2. `openrouter/deepseek/deepseek-chat:free` — bom desempenho, opção sólida
3. `google/gemini-2.5-flash` — direto Google (token já configurado nas variáveis de ambiente)
4. `openrouter/mistralai/mistral-7b-instruct:free` — leve e rápido
5. `openrouter/nousresearch/nous-capybara-7b:free` — fallback adicional
6. `openrouter/google/gemini-2.5-flash:free`
7. `openrouter/google/gemini-2.0-flash-exp:free`
8. `openrouter/meta-llama/llama-3.3-70b-instruct:free`
9. `openrouter/qwen/qwen3-4b:free`

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
_Atualizado em: 13/03/2026

