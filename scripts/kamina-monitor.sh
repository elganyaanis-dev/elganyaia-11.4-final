#!/data/data/com.termux/files/usr/bin/bash

echo "🔧 Démarrage du monitor KAMINA-OS..."

while true; do
    if ! ps aux | grep -v grep | grep -q "node.*kamina-server"; then
        echo "$(date): ❌ Serveur arrêté, redémarrage..." >> /data/data/com.termux/files/home/kamina-os/logs/monitor.log
        cd /data/data/com.termux/files/home/kamina-os
        node src/core/kamina-server.js >> /data/data/com.termux/files/home/kamina-os/logs/runtime.log 2>&1 &
        sleep 5
    fi
    sleep 10
done
