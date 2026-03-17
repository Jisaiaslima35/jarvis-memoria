#!/usr/bin/env python3
"""
Notificador de Jogos de Futebol via API-Football
Usa apenas módulos built-in (sem requests)
"""

import urllib.request
import urllib.error
import json
import os
import sys
from datetime import datetime, timedelta
from typing import Dict, List

API_KEY = os.getenv('API_FOOTBALL_KEY', 'f6188cf30e711ef0bcd5db126e1cdc52')
API_URL = "https://v3.football.api-sports.io"

LEAGUES = {
    'brasileirao': {'id': 71, 'name': 'Campeonato Brasileiro Série A', 'season': 2024},
    'libertadores': {'id': 13, 'name': 'CONMEBOL Libertadores', 'season': 2024},
    'sulamericana': {'id': 11, 'name': 'CONMEBOL Sudamericana', 'season': 2024}
}

def fetch_api(url: str) -> Dict:
    """Faz requisição GET para a API."""
    req = urllib.request.Request(
        url,
        headers={
            'x-apisports-key': API_KEY,
            'Accept': 'application/json'
        }
    )
    
    with urllib.request.urlopen(req, timeout=30) as response:
        return json.loads(response.read().decode('utf-8'))

def get_today_matches() -> Dict[str, Dict]:
    """Busca jogos do dia."""
    now = datetime.now()
    today_start = now.strftime('%Y-%m-%d')
    today_end = (now + timedelta(days=1)).strftime('%Y-%m-%d')
    
    all_matches = {}
    
    for league_key, league_info in LEAGUES.items():
        try:
            url = f"{API_URL}/fixtures?from={today_start}&to={today_end}&league={league_info['id']}&season={league_info['season']}&timezone=America/Sao_Paulo"
            
            data = fetch_api(url)
            matches = data.get('response', [])
            errors = data.get('errors', {})
            
            if errors:
                continue
            
            today_matches = [m for m in matches if m['fixture']['date'][:10] == today_start]
            
            if today_matches:
                all_matches[league_key] = {
                    'name': league_info['name'],
                    'matches': today_matches
                }
                
        except Exception as e:
            print(f"Erro em {league_key}: {e}", file=sys.stderr)
            continue
    
    return all_matches

def format_matches(matches_data: Dict) -> str:
    """Formata mensagem para Telegram."""
    date_str = datetime.now().strftime('%d/%m/%Y')
    lines = ["⚽ *JOGOS DO DIA* ⚽\n", f"📅 *{date_str}*\n"]
    
    if not matches_data:
        lines.append("\n🚫 *Nenhum jogo hoje.*")
        lines.append("\n_Volto amanhã com novidades!_")
        return '\n'.join(lines)
    
    emojis = {'brasileirao': '🇧🇷', 'libertadores': '🏆', 'sulamericana': '🌎'}
    
    for key, data in matches_data.items():
        lines.append(f"\n{emojis.get(key, '⚽')} *{data['name']}*")
        lines.append("─" * 25)
        
        for m in data['matches']:
            fixture = m['fixture']
            teams = m['teams']
            
            try:
                t = datetime.fromisoformat(fixture['date'].replace('Z', '+00:00'))
                time_str = t.strftime('%H:%M')
            except:
                time_str = fixture['date'][-8:-3] if fixture.get('date') else '??'
            
            lines.append(f"`{time_str}` *{teams['home']['name']}* vs *{teams['away']['name']}*")
    
    lines.append("\n📲 _Jarvis | Auto_")
    return '\n'.join(lines)

def main():
    matches = get_today_matches()
    return format_matches(matches)

if __name__ == '__main__':
    print(main())
