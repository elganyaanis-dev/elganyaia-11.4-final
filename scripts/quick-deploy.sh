#!/bin/bash
echo "🚀 DÉPLOIEMENT RAPIDE AVEC TOKEN EXISTANT"
echo "=========================================="

cd /data/data/com.termux/files/home

# Utiliser le token existant
echo "🔑 Authentification avec le token..."
echo "GITHUB_TOKEN_REMOVED" | gh auth login --with-token

# Vérification
if ! gh auth status >/dev/null 2>&1; then
    echo "❌ Échec de l'authentification"
    exit 1
fi

echo "✅ Authentifié avec: $(gh api user | python3 -c \"import json,sys; print(json.load(sys.stdin)['login'])\")"

# Créer une copie propre si nécessaire
if [ ! -d "elganyaia-quick" ]; then
    echo "📁 Création d'une copie propre..."
    cp -r kamina-os elganyaia-quick
    cd elganyaia-quick
    rm -rf .git
    
    # Nettoyage des secrets
    echo "🧹 Nettoyage des secrets..."
    find . -type f \( -name "*.js" -o -name "*.json" -o -name "*.txt" -o -name "*.md" -o -name "*.sh" \) -exec sed -i 's/ghp_[a-zA-Z0-9]\{36\}/GITHUB_TOKEN_REMOVED/g' {} \;
    
    git init
    git add .
    git commit -m "🚀 ElganyaIA 11.1 - Déploiement Rapide"
else
    cd elganyaia-quick
fi

# Créer le dépôt sur GitHub
echo "🏗️  Création du dépôt GitHub..."
gh repo create elganyaia-quick-deploy --description "ElganyaIA 11.1 - Déploiement rapide" --public --push

echo "🎉 DÉPLOIEMENT RÉUSSI!"
echo "🌐 https://github.com/elganyaanis-dev/elganyaia-quick-deploy"
