#!/bin/bash
echo "🧠 DÉMARRAGE KAMINA AI AUTONOME..."

pkill -f "kamina_autonomous_server" 2>/dev/null

cd $HOME/kamina-control
node kamina_autonomous_server.js &

sleep 5

if curl -s http://localhost:2929/chat/messages > /dev/null; then
    echo "✅ SYSTÈME AUTONOME ACTIF!"
    echo "🌐 http://localhost:2929"
    echo "🔷 FONCTIONNE MÊME SANS DEEPSEEK CHAT"
    echo "💬 Écrivez directement - Réponses automatiques!"
else
    echo "❌ ERREUR DÉMARRAGE"
fi
