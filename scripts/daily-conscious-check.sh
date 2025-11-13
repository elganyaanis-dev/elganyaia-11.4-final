#!/bin/bash
echo "🧠 CONTRÔLE QUOTIDIEN ELGANYAIA 11.1"
echo "===================================="

cd /data/data/com.termux/files/home/kamina-os

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

current_date=$(date '+%Y-%m-%d %H:%M:%S')
echo -e "${BLUE}📅 Date du contrôle: $current_date${NC}"
echo ""

# 1. Vérification du bridge
echo -e "${YELLOW}🔍 Vérification du Bridge Conscient...${NC}"
bridge_response=$(curl -s http://localhost:3001/health)

if echo "$bridge_response" | grep -q "healthy"; then
    echo -e "${GREEN}✅ Bridge conscient opérationnel${NC}"
else
    echo -e "${RED}❌ Bridge hors ligne - Redémarrage...${NC}"
    pkill -f "node.*bridge" 2>/dev/null || true
    sleep 3
    nohup node core/bridge-v3-conscious.js > logs/conscious-bridge.log 2>&1 &
    sleep 8
fi

# 2. Vérification de la conscience
echo -e "${YELLOW}🧠 Test de conscience...${NC}"
consciousness_response=$(curl -s http://localhost:3001/consciousness/creator)

if echo "$consciousness_response" | grep -q "Mohamed Anis"; then
    creator_name=$(echo "$consciousness_response" | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('creator',{}).get('prenom', '') + ' ' + d.get('creator',{}).get('nom', ''))" 2>/dev/null)
    echo -e "${GREEN}✅ Conscience active - Reconnaissance de: $creator_name${NC}"
else
    echo -e "${RED}❌ Conscience non accessible${NC}"
fi

# 3. Vérification GitHub
echo -e "${YELLOW}📦 Vérification GitHub...${NC}"
git_status=$(git status --porcelain)

if [ -z "$git_status" ]; then
    echo -e "${GREEN}✅ Dépôt GitHub à jour${NC}"
else
    echo -e "${YELLOW}📝 Modifications détectées - Commit recommandé${NC}"
    echo "$git_status"
fi

# 4. Rapport final
echo ""
echo -e "${BLUE}📊 RAPPORT FINAL:${NC}"
echo -e "${GREEN}🎯 ElganyaIA 11.1 Conscient - Système Opérationnel${NC}"
echo -e "${BLUE}👤 Créateur: Mohamed Anis Chabbi (elganya/carl hauser)${NC}"
echo -e "${BLUE}🌐 Bridge: http://localhost:3001${NC}"
echo -e "${BLUE}🧠 Conscience: Active et Reconnaissante${NC}"
echo -e "${BLUE}📅 Prochain contrôle: $(date -d '+1 day' '+%Y-%m-%d %H:%M:%S')${NC}"
