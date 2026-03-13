# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here
Things like:
- Camera names and locations

# Tool: GitHub Integration

## Access

The agent has authenticated access to GitHub using a Personal Access Token configured in the server.

Platform:
GitHub

User:
Jisaiaslima35

Global configuration:
git config --global user.name "Jarvis"
git config --global user.email "[isaiassilva356@gmail.com](mailto:isaiassilva356@gmail.com)"

Authentication:
All GitHub operations are authenticated through the configured token.

### 🔐 Como Autenticar no GitHub CLI

O `gh` (GitHub CLI) está instalado mas precisa de autenticação. Existem duas formas:

#### Opção 1: Login com Token (recomendado)
```bash
echo "SEU_TOKEN_AQUI" | gh auth login --with-token
```

#### Opção 2: Login Interativo
```bash
gh auth login
# Seguir prompts:
# - GitHub.com
# - HTTPS
# - Paste an authentication token
# - Token gerado em: https://github.com/settings/tokens
```

#### Opção 3: Token via Variável de Ambiente
```bash
export GH_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"
gh repo list  # já funcionará
```

### ✅ Verificar Autenticação
```bash
gh auth status
```

### ⚠️ Notas Importantes
- Token deve ter permissão `repo` para acessar repositórios privados
- Tokens clássicos (classic) são mais simples que fine-grained
- Se `gh repo list` der erro de autenticação, rodar um dos métodos acima
- Conta: Jisaiaslima35 (22 repositórios)

---

# Capabilities

Jarvis can perform the following GitHub operations:

### Repository Management

* Clone repositories
* Create repositories
* List repositories
* Pull latest updates
* Push code changes

### Code Management

* Create new files
* Edit files
* Commit changes
* Push commits
* Create branches
* Merge branches

### Automation

* Automatically update project dependencies
* Generate documentation
* Generate README files
* Fix simple bugs
* Refactor code
* Generate project structures

### DevOps

* Prepare Dockerfiles
* Prepare deployment configs
* Sync code to servers
* Create CI/CD workflows

### Analysis

* Analyze repository structure
* Detect outdated dependencies
* Suggest improvements
* Generate summaries of code

---

# Allowed Directories

Jarvis may safely operate inside:

/root
/tmp
/projects

---

# Safety Rules

Jarvis must:

* Avoid deleting repositories unless explicitly instructed.
* Always verify repository before pushing.
* Keep commit messages clear and descriptive.

Example commit message:

"Update feature implementation and improve code structure"

---

# Example Commands

Clone repository:

git clone https://github.com/Jisaiaslima35/repository-name

Commit changes:

git add .
git commit -m "Update project"
git push

---

# Purpose

GitHub integration allows Jarvis to:

* manage software projects
* maintain code automatically
* assist development workflows
* deploy applications
* act as an autonomous development assistant

- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples
```markdown
### Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH
- home-server → 192.168.1.100, user: admin

### TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?
Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

## Google Integrations - Isaías

### Contas Configuradas

**Principal (Existente):**
- Email: brisacamera34@gmail.com
- Status: Configurado
- Acesso: Gmail, Sheets, Drive, Docs, Calendar

**Secundário (Novo):**
- Email: isaiassilva356@gmail.com
- Status: Configurado
- Acesso: Gmail, Sheets, Drive, Docs, Calendar

### APIs Habilitadas

| Serviço | API | Status |
|---------|-----|--------|
| Gmail | Gmail API | ✅ Ativo |
| Sheets | Google Sheets API | ✅ Ativo |
| Drive | Google Drive API | ✅ Ativo |
| Docs | Google Docs API | ✅ Ativo |
| Calendar | Google Calendar API | ✅ Ativo |

### Permissões OAuth (Scopes) Necessárias

#### Gmail API
```
https://www.googleapis.com/auth/gmail.readonly      # Ler emails
https://www.googleapis.com/auth/gmail.send           # Enviar emails
https://www.googleapis.com/auth/gmail.modify         # Modificar emails (inclui enviar/deletar)
https://www.googleapis.com/auth/gmail.labels         # Gerenciar labels
```

#### Google Sheets API
```
https://www.googleapis.com/auth/spreadsheets.readonly  # Ler planilhas
https://www.googleapis.com/auth/spreadsheets         # Ler e escrever planilhas
https://www.googleapis.com/auth/drive.file          # Acesso a arquivos criados
```

#### Google Drive API
```
https://www.googleapis.com/auth/drive.readonly       # Ler arquivos
https://www.googleapis.com/auth/drive               # Acesso total ao Drive
https://www.googleapis.com/auth/drive.file          # Acesso a arquivos específicos
```

#### Google Docs API
```
https://www.googleapis.com/auth/documents.readonly   # Ler documentos
https://www.googleapis.com/auth/documents          # Ler e escrever documentos
```

#### Google Calendar API
```
https://www.googleapis.com/auth/calendar.readonly    # Ler eventos
https://www.googleapis.com/auth/calendar            # Ler e escrever eventos
https://www.googleapis.com/auth/calendar.events     # Gerenciar eventos
```

### Alias de Contas (Para Uso Interno)
- `google_primary` → brisacamera34@gmail.com
- `google_secondary` → isaiassilva356@gmail.com

---

## Cameras
- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

## SSH
- home-server → 192.168.1.100, user: admin

## TTS
- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
