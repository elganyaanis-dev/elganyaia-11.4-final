#!/bin/bash
echo "⌨️ DÉMARRAGE INTERFACE CLAVIER VIRTUEL..."

pkill -f "keyboard_interface" 2>/dev/null

cd $HOME/kamina-control
node keyboard_interface.js &

sleep 5

echo "🎯 VÉRIFICATION CLAVIER VIRTUEL..."
if curl -s http://localhost:2929/conversation > /dev/null; then
    echo "✅ INTERFACE CLAVIER ACTIVE!"
    echo "🌐 http://localhost:2929"
    echo "⌨️ Clavier virtuel comme DeepSeek"
    echo "🔷 Affichage bloc par bloc"
    echo "👑 CHABBI MOHAMMED ANIS"
    echo ""
    echo "🎯 INSTRUCTIONS:"
    echo "1. Cliquez sur les touches du clavier"
    echo "2. Tapez votre message"
    echo "3. Appuyez sur 'Envoyer'"
    echo "4. Les messages s'affichent bloc par bloc"
else
    echo "❌ ERREUR DÉMARRAGE CLAVIER"
fi
