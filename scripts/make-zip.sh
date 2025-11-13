#!/bin/bash

# Nom du projet et du fichier ZIP
ZIP_NAME="kamina-os-revolution-netlify.zip"
PROJECT_DIR="$HOME/kamina-os-walk"

echo "📦 Création de l'archive ZIP : $ZIP_NAME"
echo "====================================="

# Aller dans le dossier du projet
cd "$PROJECT_DIR" || { echo "❌ Dossier $PROJECT_DIR introuvable"; exit 1; }

# Supprimer l'ancien ZIP s'il existe
[ -f "$HOME/$ZIP_NAME" ] && rm "$HOME/$ZIP_NAME"

# Créer le nouveau ZIP
zip -r "$HOME/$ZIP_NAME" . > /dev/null

# Vérifier la création
if [ -f "$HOME/$ZIP_NAME" ]; then
    echo "✅ ZIP créé avec succès : $ZIP_NAME"
    
    # Copier vers /sdcard
    cp "$HOME/$ZIP_NAME" /sdcard/ && echo "📂 Copié dans /sdcard/"
else
    echo "❌ Erreur : le ZIP n'a pas été créé."
fi

echo "✅ Terminé."
