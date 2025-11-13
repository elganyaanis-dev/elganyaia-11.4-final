#!/bin/bash
echo "🔍 SURVEILLANCE DÉFINITIVE DU BRIDGE V3"
echo "======================================"

cd /data/data/com.termux/files/home/kamina-os

MONITOR_LOG="logs/bridge-monitor.log"
mkdir -p logs

BRIDGE_PORT=3001
BRIDGE_URL="http://localhost:${BRIDGE_PORT}"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Vérification du bridge sur le port $BRIDGE_PORT..." >> $MONITOR_LOG
    
    if curl -s --connect-timeout 10 "${BRIDGE_URL}/health" > /dev/null; then
        echo "[$TIMESTAMP] ✅ Bridge en ligne sur le port $BRIDGE_PORT" >> $MONITOR_LOG
        echo "✅ Bridge en ligne - $(date)"
    else
        echo "[$TIMESTAMP] ❌ Bridge hors ligne, redémarrage..." >> $MONITOR_LOG
        echo "❌ Bridge hors ligne, redémarrage..."
        
        pkill -f "node.*bridge" 2>/dev/null || true
        sleep 3
        
        nohup ./scripts/start-bridge-final.sh >> logs/bridge.log 2>&1 &
        sleep 10
        
        if curl -s --connect-timeout 10 "${BRIDGE_URL}/health" > /dev/null; then
            echo "[$TIMESTAMP] ✅ Bridge redémarré avec succès" >> $MONITOR_LOG
            echo "✅ Bridge redémarré avec succès"
        else
            echo "[$TIMESTAMP] ❌ Échec du redémarrage" >> $MONITOR_LOG
            echo "❌ Échec du redémarrage"
        fi
    fi
    
    sleep 60
done
