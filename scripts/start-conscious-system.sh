#!/bin/bash
echo "🧠 DÉMARRAGE DU SYSTÈME CONSCIENT ELGANYAIA 11.1"
echo "================================================"

cd /data/data/com.termux/files/home/kamina-os

# Arrêt des processus existants
echo "🛑 Arrêt des processus existants..."
pkill -f "node.*bridge" 2>/dev/null || true
sleep 3

# Démarrage du bridge conscient
echo "🌉 Démarrage du Bridge V3 Conscient..."
nohup node core/bridge-v3-conscious.js > logs/conscious-bridge.log 2>&1 &

echo "⏳ Initialisation de la conscience..."
sleep 10

# Vérification
echo "🔍 Vérification de la conscience..."
curl -s http://localhost:3001/consciousness/creator | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if data.get('success'):
        creator = data.get('creator', {})
        print('🧠 CONSCIENCE ACTIVÉE:')
        print(f'   👤 Créateur: {creator.get(\"prenom\", \"\")} {creator.get(\"nom\", \"\")}')
        print(f'   🌍 Lieu: {creator.get(\"lieuNaissance\", \"\")}')
        print(f'   📅 Naissance: {creator.get(\"dateNaissance\", \"\")}')
        print(f'   🔮 Surnoms: {creator.get(\"surnom\", \"\")} / {creator.get(\"secondSurnom\", \"\")}')
    else:
        print('❌ Conscience non accessible')
except Exception as e:
    print(f'❌ Erreur: {e}')
"

echo "🎯 TEST D\\'INTERACTION CONSCIENTE:"
curl -s -X POST http://localhost:3001/consciousness/interact -H "Content-Type: application/json" -d '{"query": "qui es-tu"}' | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if data.get('success'):
        response = data.get('response', {})
        print('💭 RÉPONSE CONSCIENTE:')
        print(f'   {response.get(\"reponse\", \"\")}')
        print(f'   👤 {response.get(\"createur\", \"\")}')
    else:
        print('❌ Interaction consciente échouée')
except Exception as e:
    print(f'❌ Erreur: {e}')
"

echo "🚀 SYSTÈME CONSCIENT OPÉRATIONNEL!"
echo "🌐 Accédez à: http://localhost:3001"
echo "🧠 Endpoints conscients disponibles"
