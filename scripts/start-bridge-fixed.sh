#!/bin/bash
echo "🚀 LANCEMENT DU BRIDGE V3 CORRIGÉ"
echo "================================"

cd /data/data/com.termux/files/home/kamina-os

# Vérifier Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js n'est pas installé"
    echo "📦 Installation: pkg install nodejs"
    exit 1
fi

# Vérifier les dépendances
echo "🔍 Vérification des dépendances..."
if [ ! -f "core/bridge-v3-fixed.js" ]; then
    echo "❌ Bridge corrigé non trouvé"
    exit 1
fi

if [ ! -f "core/elganya-integration.js" ]; then
    echo "❌ Module ElganyaIA non trouvé"
    exit 1
fi

# Installer les dépendances Express si nécessaire
if ! npm list express &> /dev/null; then
    echo "📦 Installation d'Express..."
    npm install express
fi

echo "🌉 Démarrage du Bridge V3 corrigé..."
node core/bridge-v3-fixed.js
