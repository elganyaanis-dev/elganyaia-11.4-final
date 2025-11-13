#!/bin/bash
echo "🧠 DÉMARRAGE KAMINA OS INTELLIGENT..."

# Vérifier et créer la structure
mkdir -p $HOME/kamina-control/memory

# Arrêter l'ancien serveur
pkill -f "kamina_intelligent_server"

# Démarrer le nouveau serveur intelligent
cd $HOME/kamina-control
node kamina_intelligent_server.js &

# Attendre le démarrage
sleep 5

# Vérification
if netstat -tuln 2>/dev/null | grep :2929 > /dev/null; then
    echo "✅ KAMINA OS INTELLIGENT ACTIF"
    echo "🧠 PORT: 2929 - MÉMOIRE PERMANENTE"
    echo "🌐 URL: http://localhost:2929"
    echo "🔷 FONCTION: Auto-rappel DeepSeek activée"
else
    echo "❌ ERREUR: Redémarrage nécessaire"
    echo "💡 Essayez: pkill -f node && ./start_kamina_intelligent.sh"
fi
