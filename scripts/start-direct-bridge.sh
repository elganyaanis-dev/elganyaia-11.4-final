#!/bin/bash
echo "🚀 DÉMARRAGE DU SYSTÈME D'ÉCRITURE DIRECTE"

# Arrêter les anciennes instances
pkill -f "direct-write-bridge"
sleep 2

# Démarrer le bridge
echo "🌉 LANCEMENT DU BRIDGE TCP..."
node core/direct-write-bridge.js > system/direct-logs/direct-bridge.log 2>&1 &

# Attendre le démarrage
sleep 3

# Vérification
if pgrep -f "direct-write-bridge" > /dev/null; then
    echo "✅ BRIDGE ACTIF - Port 9192"
    echo "💬 Pour vous connecter: ./system/control/direct-client.sh"
    echo "📨 Pour envoyer des commandes: ./system/control/send-command.sh \"ma commande\""
else
    echo "❌ ÉCHEC DU DÉMARRAGE"
    exit 1
fi
