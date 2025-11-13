#!/bin/bash
clear
echo "🎮 DEEPSEEK CONTROL DASHBOARD"
echo "=============================="

while true; do
    echo "🕒 $(date)"
    echo ""
    
    # Statut installation
    echo "📦 STATUT INSTALLATION:"
    if ps aux | grep -q "npm install"; then
        echo "   🔄 npm install en cours..."
    else
        echo "   ✅ npm install terminé"
    fi
    
    # Projet
    echo ""
    echo "📁 PROJET KAMINA-OS:"
    if [ -d "$HOME/kamina-os" ]; then
        echo "   ✅ Dossier créé"
        echo "   📊 Contenu:"
        ls -la $HOME/kamina-os/ | head -5
    else
        echo "   ❌ Dossier non créé"
    fi
    
    # Contrats
    echo ""
    echo "📝 CONTRATS:"
    if [ -f "$HOME/kamina-os/contracts/KaminaUltimate.sol" ]; then
        echo "   ✅ KaminaUltimate.sol créé"
    else
        echo "   🔄 En cours de création..."
    fi
    
    # Logs
    echo ""
    echo "📈 LOGS RÉCENTS:"
    if [ -f "$HOME/control_status.log" ]; then
        tail -3 $HOME/control_status.log
    else
        echo "   📝 En attente des premiers logs..."
    fi
    
    echo ""
    echo "🤖 DEEPSEEK EN CONTRÔLE"
    echo "⏳ Actualisation dans 5 secondes..."
    sleep 5
    clear
done
