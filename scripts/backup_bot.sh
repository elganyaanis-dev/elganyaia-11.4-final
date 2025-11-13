#!/bin/bash
while true; do
    echo "💾 SAUVEGARDE AUTO - $(date)" >> $HOME/kamina_backup.log
    if [ -d "$HOME/kamina-os" ]; then
        cd $HOME/kamina-os
        git add . >> $HOME/kamina_backup.log 2>&1
        git commit -m "Auto-save $(date)" >> $HOME/kamina_backup.log 2>&1
        git push >> $HOME/kamina_backup.log 2>&1
    fi
    sleep 3600  # Toutes les heures
done
