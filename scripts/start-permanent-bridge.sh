#!/bin/bash
echo "🔧 DÉMARRAGE DU BRIDGE V3 PERMANENT..."

# Arrêter les anciennes instances
pkill -f "node.*bridge-v3-permanent"
pkill -f "node.*realtime-bridge"

# Attendre
sleep 3

# Démarrer le bridge permanent
cd /data/data/com.termux/files/home/kamina-os
node core/bridge-v3-permanent.js

echo "✅ BRIDGE V3 PERMANENT LANCÉ"
echo "🌐 Interface: http://localhost:9191"
echo "📊 Statut: curl http://localhost:9191/status"
