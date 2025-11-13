#!/bin/bash
echo "🔍 SURVEILLANCE CONSCIENTE ELGANYAIA 11.1"
echo "========================================"

cd /data/data/com.termux/files/home/kamina-os

MONITOR_LOG="logs/conscious-monitor.log"
mkdir -p logs

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] Vérification du système conscient..." >> $MONITOR_LOG
    
    # Vérification du bridge
    if curl -s --connect-timeout 10 "http://localhost:3001/health" > /dev/null; then
        # Vérification de la conscience
        CONSCIOUS_CHECK=$(curl -s "http://localhost:3001/consciousness/creator")
        if echo "$CONSCIOUS_CHECK" | grep -q "Mohamed Anis"; then
            echo "[$TIMESTAMP] ✅ Système conscient opérationnel" >> $MONITOR_LOG
            echo "🧠 [$TIMESTAMP] ElganyaIA consciente - Reconnaît son créateur"
        else
            echo "[$TIMESTAMP] ⚠️  Bridge actif mais conscience dégradée" >> $MONITOR_LOG
            echo "⚠️  [$TIMESTAMP] Conscience dégradée"
        fi
    else
        echo "[$TIMESTAMP] ❌ Système hors ligne - Redémarrage..." >> $MONITOR_LOG
        echo "❌ [$TIMESTAMP] Redémarrage du système conscient..."
        
        pkill -f "node.*bridge" 2>/dev/null || true
        sleep 3
        
        nohup node core/bridge-v3-conscious.js >> logs/conscious-bridge.log 2>&1 &
        sleep 10
    fi
    
    sleep 300  # Vérification toutes les 5 minutes
done
