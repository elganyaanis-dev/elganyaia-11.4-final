#!/bin/bash
echo "🔍 SURVEILLANCE DU BRIDGE V3"
echo "============================"

cd /data/data/com.termux/files/home/kamina-os

while true; do
    echo "$(date): Vérification du bridge..."
    
    # Vérifier si le bridge répond
    if curl -s http://localhost:3000/health > /dev/null; then
        echo "✅ Bridge en ligne"
    else
        echo "❌ Bridge hors ligne, redémarrage..."
        pkill -f "node core/bridge-v3-fixed.js"
        sleep 2
        ./scripts/start-bridge-fixed.sh &
        sleep 5
    fi
    
    sleep 30
done
