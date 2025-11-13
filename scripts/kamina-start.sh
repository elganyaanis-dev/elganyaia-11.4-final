#!/bin/bash
clear
echo ""
echo "    🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷"
echo "    🔷                            🔷"
echo "    🔷        KAMINA OS           🔷"
echo "    🔷      SYSTÈME ACTIVÉ        🔷"
echo "    🔷                            🔷"
echo "    🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷🔷"
echo ""
echo "👑 Propriétaire: CHABBI MOHAMMED ANIS"
echo "🎯 Initialisation du système..."
echo ""

# Arrêt processus existants
pkill -f "keyboard_interface" 2>/dev/null
sleep 2

# Démarrage
cd $HOME/kamina-control

if [ ! -f "keyboard_interface.js" ]; then
    echo "❌ Erreur: Interface non trouvée"
    echo "📁 Vérifiez le dossier kamina-control/"
    exit 1
fi

echo "⌨️ Lancement interface clavier..."
node keyboard_interface.js &

# Attente et vérification
for i in {1..10}; do
    if curl -s http://localhost:2929 > /dev/null 2>&1; then
        echo ""
        echo "✅ SYSTÈME KAMINA OPÉRATIONNEL !"
        echo "🌐 URL: http://localhost:2929"
        echo ""
        echo "🎯 Instructions:"
        echo "• Ouvrez Chrome sur votre téléphone"
        echo "• Tapez: localhost:2929"
        echo "• Le clavier virtuel apparaît"
        echo ""
        echo "🔷 Tapez 'exit' pour arrêter, ou laissez tourner"
        break
    fi
    echo "⏳ Démarrage... ($i/10)"
    sleep 2
done

# Option pour garder le terminal ouvert
echo ""
read -p "🛑 Appuyez sur Entrée pour arrêter le serveur, ou Ctrl+C pour laisser tourner..." 
pkill -f "keyboard_interface"
echo "🔴 Serveur arrêté"
