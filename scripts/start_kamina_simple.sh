#!/bin/bash
echo "🔷 DÉMARRAGE KAMINA SIMPLE..."

# Arrêter les anciens processus
pkill -f "simple_server" 2>/dev/null

# Aller dans le dossier
cd $HOME/kamina-control

# Démarrer le serveur
node simple_server.js &

# Attendre
sleep 3

# Vérification
echo "🔍 VÉRIFICATION..."
if curl -s http://localhost:2929/status > /dev/null; then
    echo "✅ KAMINA OS SIMPLE ACTIF!"
    echo "🌐 OUVREZ: http://localhost:2929"
    echo "📱 Dans Chrome sur votre téléphone"
else
    echo "❌ ÉCHEC DÉMARRAGE"
    echo "💡 Essayez: node --version pour vérifier Node.js"
fi
