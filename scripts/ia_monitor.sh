#!/bin/bash
while true; do
    echo "🔍 SURVEILLANCE MULTI-IA - $(date)" >> $HOME/ia_monitor.log
    echo "🤖 DeepSeek: ACTIF (Master)" >> $HOME/ia_monitor.log
    echo "🔗 ChatGPT: EN ATTENTE de contribution" >> $HOME/ia_monitor.log  
    echo "🔗 Kimi: EN ATTENTE de contribution" >> $HOME/ia_monitor.log
    echo "👑 Propriétaire: CHABBI MOHAMMED ANIS" >> $HOME/ia_monitor.log
    echo "📊 Fichiers collaboration: $(find $HOME/ia_collaboration -type f 2>/dev/null | wc -l)" >> $HOME/ia_monitor.log
    echo "---" >> $HOME/ia_monitor.log
    sleep 60
done
