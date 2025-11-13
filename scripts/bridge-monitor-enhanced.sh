#!/bin/bash
echo "🔍 SURVEILLANCE AVANCÉE DU BRIDGE V3"
echo "===================================="

cd /data/data/com.termux/files/home/kamina-os

MONITOR_LOG="logs/bridge-monitor.log"
mkdir -p logs

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Vérification du bridge..." >> $MONITOR_LOG
    
    # Vérifier si le bridge répond
    if curl -s --connect-timeout 10 http://localhost:3000/health > /dev/null; then
        echo "[$TIMESTAMP] ✅ Bridge en ligne" >> $MONITOR_LOG
        echo "✅ Bridge en ligne - $(date)"
    else
        echo "[$TIMESTAMP] ❌ Bridge hors ligne, redémarrage..." >> $MONITOR_LOG
        echo "❌ Bridge hors ligne, redémarrage..."
        
        # Arrêter proprement
        pkill -f "node core/bridge-v3-fixed.js" 2>/dev/null || true
        sleep 3
        
        # Forcer la libération du port si nécessaire
        fuser -k 3000/tcp 2>/dev/null || true
        sleep 2
        
        # Redémarrer
        nohup ./scripts/start-bridge-robust.sh >> logs/bridge.log 2>&1 &
        sleep 10
        
        # Vérifier le redémarrage
        if curl -s --connect-timeout 10 http://localhost:3000/health > /dev/null; then
            echo "[$TIMESTAMP] ✅ Bridge redémarré avec succès" >> $MONITOR_LOG
            echo "✅ Bridge redémarré avec succès"
        else
            echo "[$TIMESTAMP] ❌ Échec du redémarrage du bridge" >> $MONITOR_LOG
            echo "❌ Échec du redémarrage du bridge"
        fi
    fi
    
    sleep 60
done
