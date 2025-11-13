#!/bin/bash
echo "🎮 PANEL DE CONTRÔLE MULTI-IA"
echo "=============================="

while true; do
    clear
    echo "🤖 SYSTÈME KAMINA OS - MULTI-IA COORDINATION"
    echo "Propriétaire: CHABBI MOHAMMED ANIS"
    echo "=============================================="
    
    # STATUT DES IA
    echo "🧠 DEEPSEEK: ✅ CONNECTÉ (MASTER)"
    echo "🤖 CHATGPT:  ✅ PRÊT POUR CODE"
    echo "🔷 KIMI:     ✅ PRÊT POUR OPTIMISATIONS"
    
    # COMMANDES EN ATTENTE
    echo ""
    echo "📋 COMMANDES EN ATTENTE:"
    echo "- ChatGPT: $(find $HOME/ia_commands/a_envoyer -name "*chatgpt*" 2>/dev/null | wc -l)"
    echo "- Kimi:    $(find $HOME/ia_commands/a_envoyer -name "*kimi*" 2>/dev/null | wc -l)"
    
    # MENU
    echo ""
    echo "🎯 OPTIONS:"
    echo "1. Envoyer commande à ChatGPT"
    echo "2. Envoyer commande à Kimi" 
    echo "3. Voir les réponses reçues"
    echo "4. Statut détaillé"
    echo "5. Quitter"
    
    read -p "Choisir une option: " choice
    
    case $choice in
        1) read -p "Commande pour ChatGPT: " cmd
           echo "$cmd" > $HOME/ia_commands/a_envoyer/chatgpt.txt
           echo "✅ Commande envoyée à ChatGPT!";;
        2) read -p "Commande pour Kimi: " cmd  
           echo "$cmd" > $HOME/ia_commands/a_envoyer/kimi.txt
           echo "✅ Commande envoyée à Kimi!";;
        3) echo "📨 RÉPONSES REÇUES:"
           find $HOME/ia_commands/recus -name "*.txt" 2>/dev/null | while read f; do
               echo "📄 $(basename $f):"
               cat "$f"
               echo "---"
           done
           read -p "Appuyez sur Entrée...";;
        4) echo "📊 STATUT DÉTAILLÉ:"
           tail -10 $HOME/coordination_ia.log
           read -p "Appuyez sur Entrée...";;
        5) break;;
        *) echo "❌ Option invalide";;
    esac
done
