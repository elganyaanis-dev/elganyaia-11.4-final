#!/bin/bash
echo "🚀 LANCEMENT DU BRIDGE ELGANYAIA V3"
echo "==================================="

cd /data/data/com.termux/files/home/kamina-os

# Vérifier que Node.js est installé
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé"
    echo "📦 Installation: pkg install nodejs"
    exit 1
fi

# Vérifier les dépendances
echo "🔍 Vérification des dépendances..."
if [ ! -f "core/elganya-integration.js" ]; then
    echo "❌ Module ElganyaIA non trouvé"
    echo "🔄 Exécutez d'abord le script de configuration"
    exit 1
fi

# Démarrer le bridge
echo "🌉 Démarrage du Bridge V3 avec ElganyaIA..."
node core/bridge-v3-permanent.js

# Si le bridge se termine, relancer avec gestion des erreurs
while true; do
    echo "🔄 Redémarrage du bridge..."
    sleep 5
    node core/bridge-v3-permanent.js
done
