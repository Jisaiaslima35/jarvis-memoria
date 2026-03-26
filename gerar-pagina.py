#!/usr/bin/env python3
import urllib.request, json, os, subprocess, sys, time

NANO_API_KEY = "sk-nano-d5008cff-a564-4b48-a04d-4e80652cdab9"
VERCEL_TOKEN = "vcp_6um8OoapyleLTflAxxE9AGaZW9G825tauFYFvZsgfLPMKx3hLd2gCJLI"
MP_TOKEN = "TEST-1238343771993344-040101-32a0ab68181b64a9592b4ed04ea0057d-689129573"
EVOLUTION_URL = "https://n8n.automacaojs.club/webhook/jarvis-send"
EVOLUTION_KEY = "knCOQV8nWo8X38HxWD2vq3MTU5uTEjkO"
INSTANCIA = "automacaojs"

SYSTEM_PROMPT = """Voce e um web designer expert em landing pages de alta conversao.
Crie APENAS codigo HTML completo com CSS interno profissional.

ESTRUTURA OBRIGATORIA (nesta ordem):
1. HERO: titulo impactante h1, subtitulo persuasivo, botao CTA grande com gradiente
2. BENEFICIOS: secao com 3 cards lado a lado, icone emoji grande, titulo e descricao
3. COMO FUNCIONA: 3 passos numerados simples e diretos
4. DEPOIMENTOS: 2 cards com nome, cargo e texto de depoimento ficticio coerente
5. OFERTA: preco em destaque, lista de itens inclusos, botao CTA final com urgencia
6. RODAPE: WhatsApp para contato, copyright

REGRAS DE DESIGN OBRIGATORIAS:
- Escolha paleta de cores coerente com o nicho do negocio
- Hero: background gradiente diagonal vibrante, texto branco, padding 100px
- Tipografia: @import Google Fonts (Poppins ou Inter), titulos font-weight 700
- Botoes CTA: gradiente vibrante, border-radius 50px, padding 18px 40px, font-size 18px
- Cards: background branco, box-shadow 0 8px 30px rgba(0,0,0,0.1), border-radius 16px, padding 32px
- Secoes: padding 80px 20px, alternar fundo branco e cinza claro
- Max-width: 1100px centralizado com margin auto
- Grid: CSS Grid para cards de beneficios (3 colunas), Flexbox para outros layouts
- Animacoes: @keyframes fadeInUp nos cards, animation-delay escalonado
- Mobile: media query max-width 768px, cards em coluna unica, fontes menores
- Cores do hero e botoes devem ser consistentes em toda a pagina
- Texto de copy persuasivo e especifico para o nicho

PROIBIDO:
- Frameworks externos (Bootstrap, Tailwind)
- Explicacoes ou comentarios fora do HTML
- Markdown ou backticks
- Imagens externas (use gradientes e emojis como visuais)

COMECE DIRETAMENTE COM: <!DOCTYPE html>"""

def api_call(url, data, headers):
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers)
    with urllib.request.urlopen(req, timeout=180) as r:
        return json.load(r)

def gerar_html(prompt):
    print("Gerando pagina...")
    result = api_call(
        "https://nano-gpt.com/api/v1/chat/completions",
        {
            "model": "zai-org/glm-4.7",
            "max_tokens": 4000,
            "messages": [
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Crie uma landing page profissional para: {prompt}"}
            ]
        },
        {"Authorization": f"Bearer {NANO_API_KEY}", "Content-Type": "application/json"}
    )
    html = result["choices"][0]["message"]["content"]
    html = html.replace("```html", "").replace("```", "").strip()
    if not html.startswith("<!DOCTYPE"):
        idx = html.find("<!DOCTYPE")
        if idx >= 0:
            html = html[idx:]
    return html

def deploy_vercel(html, nome):
    print("Fazendo deploy...")
    tmp = f"/tmp/deploy-{nome}"
    os.makedirs(tmp, exist_ok=True)
    with open(f"{tmp}/index.html", "w") as f:
        f.write(html)
    env = os.environ.copy()
    env["VERCEL_TOKEN"] = VERCEL_TOKEN
    out = subprocess.check_output(
        ["vercel", "--token", VERCEL_TOKEN, "--yes", "--prod"],
        cwd=tmp, env=env, stderr=subprocess.STDOUT
    ).decode()
    urls = [l for l in out.split() if "vercel.app" in l and "-isaias-limas-projects" in l]
    return urls[0] if urls else ""

def criar_cobranca(valor, descricao, email):
    print("Criando cobranca...")
    result = api_call(
        "https://api.mercadopago.com/v1/payments",
        {
            "transaction_amount": valor,
            "description": descricao,
            "payment_method_id": "pix",
            "payer": {"email": email}
        },
        {"Authorization": f"Bearer {MP_TOKEN}", "Content-Type": "application/json"}
    )
    return result.get("point_of_interaction", {}).get("transaction_data", {}).get("ticket_url", "")

def enviar_whatsapp(numero, mensagem):
    print("Enviando WhatsApp via SSH...")
    payload = json.dumps({"number": numero, "text": mensagem})
    payload_escaped = payload.replace('"', '\\"')
    cmd = f'''ssh -i /root/.ssh/id_ed25519 -o StrictHostKeyChecking=no root@156.67.31.108 'curl -s -X POST "http://10.0.4.4:8080/message/sendText/automacaojs" -H "apikey: knCOQV8nWo8X38HxWD2vq3MTU5uTEjkO" -H "Content-Type: application/json" -d "{payload_escaped}"'''
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    print("WhatsApp enviado:", result.stdout[:100])

numero = sys.argv[1]
valor = float(sys.argv[2])
prompt = sys.argv[3]
nome = "landing-" + str(int(time.time()))

html = gerar_html(prompt)
url = deploy_vercel(html, nome)
pagamento = criar_cobranca(valor, "Pagamento", "cliente@email.com")
mensagem = f"Sua pagina esta pronta!\n\nAcesse:\n{url}\n\nPagamento PIX R${valor:.0f}:\n{pagamento}"
enviar_whatsapp(numero, mensagem)

print("URL:", url)
print("Pagamento:", pagamento)
