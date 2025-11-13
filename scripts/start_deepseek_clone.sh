#!/bin/bash
echo "🔷 DÉMARRAGE DEEPSEEK CLONE..."

pkill -f "deepseek_clone_server" 2>/dev/null

cd $HOME/kamina-control
node deepseek_clone_server.js &

sleep 5

echo "🎯 VÉRIFICATION..."
if curl -s http://localhost:2929/conversation > /dev/null; then
    echo "✅ DEEPSEEK CLONE ACTIF!"
    echo "🌐 http://localhost:2929"
    echo "💬 Interface IDENTIQUE à DeepSeek Chat"
    echo "👑 CHABBI MOHAMMED ANIS"
    echo "🔷 Conversations persistantes"
else
    echo "❌ ERREUR DÉMARRAGE"
fi
