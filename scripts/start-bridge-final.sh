#!/bin/bash
echo "🚀 DÉMARRAGE DÉFINITIF DU BRIDGE V3"
echo "==================================="

cd /data/data/com.termux/files/home/kamina-os

# Nettoyage complet
echo "🧹 Nettoyage des processus..."
pkill -f "node.*bridge" 2>/dev/null || true
pkill -f "node.*3000" 2>/dev/null || true
pkill -f "node.*3001" 2>/dev/null || true
sleep 3

# Vérifier Express
echo "📦 Vérification des dépendances..."
if ! npm list express 2>/dev/null | grep express > /dev/null; then
    echo "📦 Installation d'Express..."
    npm install express --save
fi

# Vérifier les fichiers
if [ ! -f "core/bridge-v3-port-3001.js" ]; then
    echo "❌ Bridge port 3001 non trouvé"
    exit 1
fi

if [ ! -f "core/elganya-integration.js" ]; then
    echo "❌ Module ElganyaIA non trouvé"
    exit 1
fi

echo "🌉 Démarrage du Bridge V3 sur le port 3001..."
node core/bridge-v3-port-3001.js
