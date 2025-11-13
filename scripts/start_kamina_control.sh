#!/bin/bash
echo "🔷 DÉMARRAGE KAMINA OS CONTROL..."

# Arrêter l'ancien serveur
pkill -f "kamina_server"

# Démarrer le nouveau serveur
cd $HOME/kamina-control
node kamina_server.js &

# Attendre le démarrage
sleep 3

# Vérification
if netstat -tuln 2>/dev/null | grep :2929 > /dev/null; then
    echo "✅ KAMINA OS ACTIF SUR PORT 2929"
    echo "🌐 OUVREZ CHROME → http://localhost:2929"
    echo "🔷 INTERFACE: KAMINA DASHBOARD"
else
    echo "❌ ERREUR DÉMARRAGE"
fi
