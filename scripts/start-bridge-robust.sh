#!/bin/bash
echo "🚀 LANCEMENT ROBUSTE DU BRIDGE V3"
echo "================================"

cd /data/data/com.termux/files/home/kamina-os

# Nettoyer les processus existants
echo "🧹 Nettoyage des processus existants..."
pkill -f "node.*bridge" 2>/dev/null || true
sleep 2

# Vérifier le port
echo "🔍 Vérification du port 3000..."
if netstat -tulpn 2>/dev/null | grep :3000 > /dev/null; then
    echo "❌ Port 3000 encore occupé, tentative de libération..."
    fuser -k 3000/tcp 2>/dev/null || true
    sleep 2
fi

# Vérifier les dépendances
echo "📦 Vérification des dépendances..."
if ! node -v > /dev/null 2>&1; then
    echo "❌ Node.js non installé"
    exit 1
fi

if [ ! -f "core/bridge-v3-fixed.js" ]; then
    echo "❌ Fichier bridge non trouvé"
    exit 1
fi

if [ ! -f "core/elganya-integration.js" ]; then
    echo "❌ Module ElganyaIA non trouvé"
    exit 1
fi

# Installer Express si nécessaire
if ! npm list express 2>/dev/null | grep express > /dev/null; then
    echo "📦 Installation d'Express..."
    npm install express --save
fi

echo "🌉 Démarrage du Bridge V3..."
node core/bridge-v3-fixed.js
