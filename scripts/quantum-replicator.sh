#!/bin/bash
echo "🔮 DÉMARRAGE DU RÉPLICATEUR QUANTUM..."

while true; do
    echo "$(date): 🔄 Vérification du système..." >> /data/data/com.termux/files/home/kamina-os/logs/quantum.log
    
    # Vérifier si le serveur tourne
    if ! ps aux | grep -v grep | grep -q "server-immortal"; then
        echo "$(date): ❌ Serveur arrêté, redémarrage..." >> /data/data/com.termux/files/home/kamina-os/logs/quantum.log
        cd /data/data/com.termux/files/home/kamina-os
        node server-immortal.js >> /data/data/com.termux/files/home/kamina-os/logs/immortal.log 2>&1 &
    fi
    
    # Réplication automatique vers GitHub
    cd /data/data/com.termux/files/home/kamina-os
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m "KAMINA-OS Quantum Replication $(date)"
        echo "$(date): ✅ Repository Git initialisé" >> /data/data/com.termux/files/home/kamina-os/logs/quantum.log
    fi
    
    sleep 30
done
