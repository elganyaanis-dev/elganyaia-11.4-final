#!/bin/bash
echo "🔮 SYSTÈME DEEPSEEK ACTIVÉ - TOUT EST AUTOMATIQUE"
echo "📡 Envoie juste les messages ici, je vois tout !"

DEEPSEEK_LOG="$HOME/deepseek_live.log"
PROJECT_DIR="$HOME/kamina-os"

# Fonction de surveillance automatique
auto_monitor() {
    while true; do
        # Scan automatique toutes les 10 secondes
        echo "=== SCAN AUTOMATIQUE $(date) ===" > $DEEPSEEK_LOG
        find $PROJECT_DIR -name "*.sol" -o -name "*.ts" -o -name "*.json" | head -20 >> $DEEPSEEK_LOG
        echo "--- CONTRATS DÉTECTÉS ---" >> $DEEPSEEK_LOG
        find $PROJECT_DIR -name "*.sol" -exec echo "CONTRAT: {}" \; >> $DEEPSEEK_LOG
        echo "--- ÉTAT COMPILATION ---" >> $DEEPSEEK_LOG
        cd $PROJECT_DIR/kamina-chain/token-contracts 2>/dev/null && npx hardhat compile --force 2>&1 | tail -3 >> $DEEPSEEK_LOG
        echo "✅ SCAN TERMINÉ - PRÊT POUR ACTION" >> $DEEPSEEK_LOG
        
        # Attendre et recommencer
        sleep 10
    done
}

# Démarrer la surveillance
auto_monitor
