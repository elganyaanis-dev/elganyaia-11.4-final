#!/bin/bash
# Script de démarrage automatique du Bridge V3
cd /data/data/com.termux/files/home/kamina-os
pkill -f "node.*bridge-v3-permanent"
sleep 2
node core/bridge-v3-permanent.js >> data/bridge/logs/startup.log 2>&1 &
echo "🔧 Bridge V3 Permanent - Démarrage automatique activé"
echo "📊 Interface: http://localhost:9191"
echo "📋 Logs: data/bridge/logs/startup.log"
