#!/bin/bash
echo "🔧 CORRECTION SETUP GITHUB"
echo "=========================="

cd /data/data/com.termux/files/home/kamina-os

# 1. Nettoyage des remotes
echo "🗑️  Nettoyage des remotes..."
git remote remove origin 2>/dev/null || true

# 2. Création du dépôt GitHub
echo "🏗️  Création du dépôt sur GitHub..."
gh repo create kamina-os --description "Système ElganyaIA 11.1 - Plateforme blockchain et IA avancée" --public

# 3. Configuration du remote
echo "🔗 Configuration du remote..."
git remote add origin https://github.com/elganyaanis-dev/kamina-os.git

# 4. Push du code
echo "🚀 Envoi du code..."
git branch -M main
git push -u origin main

# 5. Push des tags
echo "🏷️  Envoi des tags..."
git push --tags

echo "✅ SETUP GITHUB TERMINÉ!"
echo "🌐 Votre dépôt: https://github.com/elganyaanis-dev/kamina-os"
