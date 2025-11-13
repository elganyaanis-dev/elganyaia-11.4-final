#!/bin/bash
echo "🧠 DÉMARRAGE COORDINATEUR MULTI-IA..."

pkill -f "multi_ai_coordinator" 2>/dev/null

cd $HOME/kamina-control
node multi_ai_coordinator.js &

sleep 5

echo "🎯 VÉRIFICATION SYSTÈME MULTI-IA..."
if curl -s http://localhost:2929/ai-list > /dev/null; then
    echo "✅ COORDINATEUR MULTI-IA ACTIF!"
    echo "🌐 http://localhost:2929"
    echo "🧠 IA disponibles: DeepSeek, ChatGPT, Kimi, Claude, Gemini"
    echo "🎯 Coordination intelligente automatique"
    echo "💬 Vraie boîte de dialogue comme DeepSeek"
    echo "👑 CHABBI MOHAMMED ANIS"
else
    echo "❌ ERREUR DÉMARRAGE MULTI-IA"
fi
