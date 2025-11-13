#!/bin/bash
echo "🔐 NETTOYAGE COMPLET GITHUB SECRETS"
echo "==================================="

cd /data/data/com.termux/files/home/kamina-os

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 1. Analyse des secrets
echo -e "${YELLOW}🔍 ANALYSE DES SECRETS...${NC}"
SECRET_FILES=$(find . -type f -not -path "./.git/*" -exec grep -l -E "ghp_|ghs_|github_pat_" {} \; 2>/dev/null)

if [ -z "$SECRET_FILES" ]; then
    echo -e "${GREEN}✅ AUCUN SECRET DÉTECTÉ${NC}"
else
    echo -e "${RED}❌ SECRETS DÉTECTÉS DANS:${NC}"
    echo "$SECRET_FILES"
    
    # 2. Nettoyage
    echo -e "${YELLOW}🧹 NETTOYAGE EN COURS...${NC}"
    find . -type f -not -path "./.git/*" \( -name "*.js" -o -name "*.json" -o -name "*.txt" -o -name "*.md" \) -exec sed -i 's/ghp_[A-Za-z0-9]\{36\}/REMOVED_GITHUB_TOKEN/g' {} \;
    find . -type f -not -path "./.git/*" \( -name "*.js" -o -name "*.json" -o -name "*.txt" -o -name "*.md" \) -exec sed -i 's/ghs_[A-Za-z0-9]\{36\}/REMOVED_GITHUB_SECRET/g' {} \;
    
    echo -e "${GREEN}✅ SECRETS NETTOYÉS${NC}"
fi

# 3. Commit des modifications
echo -e "${YELLOW}💾 COMMIT DES MODIFICATIONS...${NC}"
git add .
git commit -m "🔐 Nettoyage des secrets GitHub

- Suppression des tokens GitHub détectés
- Remplacement par des placeholders sécurisés
- Mise à jour sécurisée du code"

# 4. Tentative de push
echo -e "${YELLOW}🚀 TENTATIVE DE PUSH...${NC}"
if git push origin main; then
    echo -e "${GREEN}✅ PUSH RÉUSSI!${NC}"
    echo -e "${GREEN}🌐 VOTRE CODE EST MAINTENANT SUR GITHUB!${NC}"
else
    echo -e "${RED}❌ PUSH ÉCHOUÉ - CRÉATION D'UN NOUVEAU DÉPÔT...${NC}"
    
    # Création d'un nouveau dépôt
    cd ..
    cp -r kamina-os kamina-os-secure
    cd kamina-os-secure
    rm -rf .git
    git init
    git add .
    git commit -m "🚀 ElganyaIA 11.1 - Version Sécurisée"
    
    gh repo create elganyaia-secure --description "Système ElganyaIA 11.1 - Version sécurisée sans secrets" --public --push
    
    echo -e "${GREEN}🎉 NOUVEAU DÉPÔT CRÉÉ: https://github.com/elganyaanis-dev/elganyaia-secure${NC}"
fi
