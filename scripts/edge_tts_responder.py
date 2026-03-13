#!/usr/bin/env python3
"""
Edge TTS Responder para OpenClaw/Jarvis
Responde em áudio quando o usuário enviar mensagens de voz
"""

import sys
import subprocess
import tempfile
import os

def responder_por_voz(texto_resposta, voz="pt-BR-AntonioNeural"):
    """
    Converte texto em áudio usando Edge TTS e envia de volta
    Vozes disponíveis em pt-BR:
    - pt-BR-AntonioNeural (masculina)
    - pt-BR-FranciscaNeural (feminina)
    - pt-BR-ThalitaNeural (feminina)
    """
    try:
        # Criar arquivo temporário
        with tempfile.NamedTemporaryFile(suffix=".mp3", delete=False) as tmp:
            output_file = tmp.name
        
        # Gerar áudio com Edge TTS
        cmd = [
            "edge-tts",
            "--voice", voz,
            "--text", texto_resposta,
            "--write-media", output_file
        ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"Erro ao gerar áudio: {result.stderr}", file=sys.stderr)
            return None
        
        return output_file
        
    except Exception as e:
        print(f"Erro: {e}", file=sys.stderr)
        return None

def listar_vozes():
    """Lista todas as vozes disponíveis em pt-BR"""
    try:
        result = subprocess.run(
            ["edge-tts", "--list-voices"],
            capture_output=True,
            text=True
        )
        
        # Filtrar apenas vozes em português do Brasil
        vozes_ptbr = [linha for linha in result.stdout.split('\n') 
                      if 'pt-BR' in linha]
        return vozes_ptbr
        
    except Exception as e:
        return [f"Erro: {e}"]

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python3 edge_tts_responder.py 'texto para converter'")
        print("     python3 edge_tts_responder.py --list-voices")
        sys.exit(1)
    
    if sys.argv[1] == "--list-voices":
        print("Vozes disponíveis em pt-BR:")
        for voz in listar_vozes():
            print(voz)
    else:
        texto = " ".join(sys.argv[1:])
        arquivo = responder_por_voz(texto)
        if arquivo:
            print(f"Áudio gerado: {arquivo}")
        else:
            print("Falha ao gerar áudio")
            sys.exit(1)
