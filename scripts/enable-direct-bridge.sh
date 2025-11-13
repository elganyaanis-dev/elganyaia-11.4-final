#!/bin/bash
echo "🔧 ACTIVATION PERMANENTE DU BRIDGE D'ÉCRITURE DIRECTE"

# Créer le service de démarrage automatique
mkdir -p ~/.termux/boot

cat > ~/.termux/boot/start-direct-bridge << 'END'
#!/bin/bash
sleep 10
cd /data/data/com.termux/files/home/kamina-os
./scripts/start-direct-bridge.sh
END

chmod +x ~/.termux/boot/start-direct-bridge

echo "✅ SERVICE CRÉÉ: ~/.termux/boot/start-direct-bridge"
echo "🔌 Le bridge démarrera automatiquement au boot de Termux"
echo ""
echo "🎯 POUR UTILISER MAINTENANT:"
echo "   ./system/control/direct-control-panel.sh"
echo ""
echo "📨 POUR ENVOYER DES COMMANDES DIRECTES:"
echo "   ./system/control/send-command.sh \"ls -la\""
END
