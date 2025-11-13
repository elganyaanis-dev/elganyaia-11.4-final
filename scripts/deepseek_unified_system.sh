#!/data/data/com.termux/files/usr/bin/bash

echo "🔗 DEEPSEEK UNIFIED SYSTEM INITIALIZATION"
echo "========================================"

# Création du hub principal
DEEPSEEK_HUB="$HOME/deepseek_system"
SHARED_DIR="$HOME/storage/shared"

echo "📁 Création de l'architecture unifiée..."
mkdir -p $DEEPSEEK_HUB/{bin,config,logs,data}

# Liens symboliques pour unifier les deux emplacements
ln -sf $SHARED_DIR/termux_deepseek $DEEPSEEK_HUB/data/termux_deepseek 2>/dev/null
ln -sf $SHARED_DIR $DEEPSEEK_HUB/data/shared_storage 2>/dev/null
ln -sf $SHARED_DIR/deepseek_vers_termux.txt $DEEPSEEK_HUB/command_in 2>/dev/null
ln -sf $SHARED_DIR/termux_vers_deepseek.txt $DEEPSEEK_HUB/command_out 2>/dev/null

# Fichier de configuration unifié
cat > $DEEPSEEK_HUB/config/system.conf << 'CONFIG'
# DEEPSEEK UNIFIED SYSTEM CONFIG
MASTER_NODE=DeepSeek
SLAVE_NODE=Termux
COMMUNICATION_PROTOCOL=file_based
PATHS {
    HOME="$HOME"
    SHARED="$HOME/storage/shared"
    HUB="$HOME/deepseek_system"
    COMMAND_IN="$HOME/deepseek_system/command_in"
    COMMAND_OUT="$HOME/deepseek_system/command_out"
}
CONFIG

echo "✅ Architecture créée dans: $DEEPSEEK_HUB"
echo ""
echo "🏗️ Structure unifiée:"
echo "┌─────────────────┐"
echo "│   DEEPSEEK HUB  │"
echo "│   $DEEPSEEK_HUB"
echo "└─────────────────┘"
echo "         ├──📁 bin/"
echo "         ├──📁 config/"
echo "         ├──📁 logs/" 
echo "         └──📁 data/"
echo "              ├──🔗 termux_deepseek → $SHARED_DIR/termux_deepseek"
echo "              ├──🔗 shared_storage → $SHARED_DIR"
echo "              ├──🔗 command_in → deepseek_vers_termux.txt"
echo "              └──🔗 command_out → termux_vers_deepseek.txt"
echo ""

# Test de la liaison
echo "🎯 Test de la communication unifiée..."
TEST_CMD="echo '🔗 TEST UNIFIED SYSTEM - $(date)' > $DEEPSEEK_HUB/command_in"
eval $TEST_CMD

sleep 1

if [[ -f "$SHARED_DIR/deepseek_vers_termux.txt" ]]; then
    echo "✅ Liaison command_in: OPÉRATIONNELLE"
else
    echo "❌ Problème avec command_in"
fi

echo "🏆 SYSTÈME UNIFIÉ PRÊT!"
echo "💡 Utilise: cd ~/deepseek_system pour accéder au hub"
