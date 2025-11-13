#!/bin/bash
echo "🧠 DÉMARRAGE SYSTÈME DEEPSEEK CONTROL..."

# Arrêter les instances existantes
pkill -f "termux_control_server"

# Démarrer le serveur
node $HOME/termux_control_server.js &

# Journal de démarrage
echo "$(date) - Système DeepSeek Control démarré" >> $HOME/deepseek_control.log

# Vérification
sleep 2
if pgrep -f "termux_control_server" > /dev/null; then
    echo "✅ Serveur démarré avec succès!"
    echo "🌐 Ouvrez Chrome et allez sur: http://localhost:8080"
    echo "📱 Interface mobile optimisée"
else
    echo "❌ Erreur lors du démarrage"
fi
