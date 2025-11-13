#!/bin/bash
echo "💬 DÉMARRAGE KAMINA CHAT..."

# Arrêter les anciens processus
pkill -f "kamina_chat_server" 2>/dev/null

# Créer dossiers nécessaires
mkdir -p $HOME/kamina-control/memory

# Démarrer le serveur chat
cd $HOME/kamina-control
node kamina_chat_server.js &

# Attendre le démarrage
sleep 5

# Vérification
echo "🔍 VÉRIFICATION CHAT KAMINA..."
if curl -s http://localhost:2929/chat/messages > /dev/null; then
    echo "✅ KAMINA CHAT ACTIF!"
    echo "🌐 OUVREZ: http://localhost:2929"
    echo "💬 Écrivez directement dans l'interface!"
    echo "👑 Propriétaire: CHABBI MOHAMMED ANIS"
else
    echo "❌ ÉCHEC DÉMARRAGE CHAT"
    echo "💡 Vérifiez que Node.js est installé: node --version"
fi
