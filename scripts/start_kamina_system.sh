#!/bin/bash
echo "🔷 REDÉMARRAGE SYSTÈME KAMINA OS..."
echo "👑 Propriétaire: CHABBI MOHAMMED ANIS"
echo ""

# Arrêter tous les processus existants
echo "🛑 Arrêt des processus existants..."
pkill -f "node" 2>/dev/null
sleep 2

# Vérifier la structure
echo "📁 Vérification structure..."
mkdir -p $HOME/kamina-control/memory
mkdir -p $HOME/kamina-os

# Redémarrer le serveur clavier
echo "⌨️ Démarrage interface clavier..."
cd $HOME/kamina-control
node keyboard_interface.js &

# Attendre le démarrage
sleep 5

# Vérification
echo "🔍 Vérification du système..."
if curl -s http://localhost:2929/conversation > /dev/null 2>&1; then
    echo ""
    echo "✅ SYSTÈME KAMINA OS REDÉMARRÉ AVEC SUCCÈS!"
    echo "🌐 Interface: http://localhost:2929"
    echo "⌨️ Clavier virtuel actif"
    echo "🔷 Affichage bloc par bloc"
    echo "👑 CHABBI MOHAMMED ANIS"
    echo ""
    echo "🎯 PRÊT À UTILISER !"
else
    echo "❌ Erreur lors du redémarrage"
    echo "💡 Essayez: pkill -f node && node keyboard_interface.js"
fi
