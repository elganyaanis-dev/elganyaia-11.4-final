#!/bin/bash
echo "🔨 SYSTÈME DE COMPILATION MANUEL - $(date)" > $HOME/compile_log.txt

while true; do
    echo "=== CYCLE $(date) ===" >> $HOME/compile_log.txt
    
    # Compilation DIRECTE avec solc
    cd $HOME/kamina-v6
    solc --bin --abi contracts/KaminaV6.sol >> $HOME/compile_log.txt 2>&1
    
    if [ $? -eq 0 ]; then
        echo "🎉 COMPILATION RÉUSSIE AVEC SOLC !" >> $HOME/compile_log.txt
        echo "✅ Fichiers .bin et .abi générés" >> $HOME/compile_log.txt
    else
        echo "⚠️ Erreur solc, mais le système continue..." >> $HOME/compile_log.txt
    fi
    
    # Vérifier la structure
    echo "📁 Structure projet:" >> $HOME/compile_log.txt
    ls -la contracts/ >> $HOME/compile_log.txt
    
    sleep 30
done
