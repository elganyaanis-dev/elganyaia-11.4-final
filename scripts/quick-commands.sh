#!/bin/bash
# Commandes rapides pour ElganyaIA 11.1

# Statut du système
alias elganya-status="curl -s http://localhost:3001/health | python3 -c \"import json,sys; d=json.load(sys.stdin); print(f'✅ {d.get(\\\"service\\\")} - {d.get(\\\"status\\\")}')\""

# Analyse du projet
alias elganya-analyze="curl -s http://localhost:3001/elganya/status | python3 -c \"import json,sys; d=json.load(sys.stdin); print(f'📊 Analyse: {\\\"SUCCÈS\\\" if d.get(\\\"success\\\") else \\\"ÉCHEC\\\"}')\""

# Redémarrage rapide
alias elganya-restart="pkill -f 'node.*bridge' && sleep 3 && node core/bridge-v3-enhanced.js > logs/bridge.log 2>&1 &"

# Logs en direct
alias elganya-logs="tail -f logs/bridge.log"

# Mise à jour GitHub
alias elganya-push="git add . && git commit -m '🔄 Mise à jour ElganyaIA' && git push"

echo "🔧 ALIAS CRÉÉS:"
echo "   elganya-status    - Statut du bridge"
echo "   elganya-analyze   - Analyse du système"
echo "   elganya-restart   - Redémarrage rapide"
echo "   elganya-logs      - Logs en direct"
echo "   elganya-push      - Mise à jour GitHub"
