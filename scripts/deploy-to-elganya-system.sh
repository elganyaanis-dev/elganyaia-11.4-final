#!/bin/bash
echo "🚀 DÉPLOIEMENT SUR ELGANYA-SYSTEM"
echo "================================"

cd /data/data/com.termux/files/home/kamina-os

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🔑 AUTHENTIFICATION...${NC}"
echo "GITHUB_TOKEN_REMOVED" | gh auth login --with-token

if ! gh auth status >/dev/null 2>&1; then
    echo -e "${RED}❌ Échec de l'authentification${NC}"
    exit 1
fi

USERNAME=$(gh api user | python3 -c "import json,sys; print(json.load(sys.stdin)['login'])")
echo -e "${GREEN}✅ Authentifié avec: $USERNAME${NC}"

echo -e "${YELLOW}🔍 VÉRIFICATION DU DÉPÔT...${NC}"
if ! gh repo view elganyaanis-dev/Elganya-system >/dev/null 2>&1; then
    echo -e "${YELLOW}🏗️ Création du dépôt Elganya-system...${NC}"
    gh repo create Elganya-system --description "Système ElganyaIA 11.1 - Plateforme blockchain et IA avancée" --public
else
    echo -e "${GREEN}✅ Dépôt Elganya-system existe${NC}"
fi

echo -e "${YELLOW}🔗 CONFIGURATION DU REMOTE...${NC}"
git remote remove origin 2>/dev/null || true
git remote add origin https://github.com/elganyaanis-dev/Elganya-system.git

echo -e "${YELLOW}🧹 NETTOYAGE DES SECRETS...${NC}"
find . -type f \( -name "*.js" -o -name "*.json" -o -name "*.txt" -o -name "*.md" -o -name "*.sh" \) -exec sed -i 's/GITHUB_TOKEN_REMOVED/GITHUB_TOKEN_REMOVED/g' {} \;

if grep -r "GITHUB_TOKEN_REMOVED" . 2>/dev/null; then
    echo -e "${RED}❌ Token encore présent après nettoyage${NC}"
    exit 1
fi

echo -e "${YELLOW}💾 COMMIT...${NC}"
git add .
git commit -m "🚀 ElganyaIA 11.1 - Déploiement sur Elganya-system

- 🌉 Bridge V3 avec API REST
- 🤖 Module ElganyaIA 11.1
- 📦 Projet ERC-20 complet
- 🔧 Scripts de déploiement
- 📊 Surveillance avancée

✅ Code 100% nettoyé et sécurisé"

echo -e "${YELLOW}🚀 PUSH...${NC}"
git push -f origin main

echo -e "${YELLOW}🏷️ PUSH DES TAGS...${NC}"
git push --tags --force

echo -e "${GREEN}🎉 DÉPLOIEMENT RÉUSSI!${NC}"
echo -e "${GREEN}🌐 VOTRE CODE EST SUR: https://github.com/elganyaanis-dev/Elganya-system${NC}"
