#!/bin/bash
echo "🎯 PRISE DE CONTRÔLE TOTALE DU SYSTÈME"
echo "======================================"

cd /data/data/com.termux/files/home/kamina-os

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions d'affichage
info() { echo -e "${BLUE}ℹ️ $1${NC}"; }
success() { echo -e "${GREEN}✅ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }

# 1. Vérification du Bridge
info "1. Vérification du Bridge V3..."
BRIDGE_STATUS=$(curl -s http://localhost:3001/health 2>/dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('status', 'UNKNOWN'))" 2>/dev/null || echo "ERROR")

if [ "$BRIDGE_STATUS" = "healthy" ]; then
    success "Bridge V3 opérationnel"
else
    error "Bridge V3 hors ligne - Redémarrage..."
    nohup node core/bridge-v3-port-3001.js > logs/bridge.log 2>&1 &
    sleep 5
fi

# 2. Analyse du système
info "2. Analyse complète du système..."
curl -s http://localhost:3001/elganya/status 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if data.get('success'):
        analysis = data.get('analysis', {})
        erc20 = analysis.get('erc20', {})
        elganya = analysis.get('elganya', {})
        blockchain = analysis.get('blockchain', {})
        
        print('📊 RAPPORT SYSTÈME:')
        print(f'   ERC-20: {\"✅\" if erc20.get(\"exists\") else \"❌\"} {len(erc20.get(\"contracts\", []))} contrats')
        print(f'   ElganyaIA: {\"✅\" if elganya.get(\"exists\") else \"❌\"} Version: {elganya.get(\"version\", \"N/A\")}')
        print(f'   Blockchain: {blockchain.get(\"hardhat\", \"N/A\")}')
    else:
        print('❌ Analyse échouée')
except Exception as e:
    print('❌ Erreur analyse:', str(e))
"

# 3. Correction automatique
info "3. Application des correctifs..."
curl -s -X POST http://localhost:3001/elganya/fix 2>/dev/null | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    if data.get('success'):
        print('✅ Correctifs appliqués avec succès')
    else:
        print('❌ Échec des correctifs')
except:
    print('❌ Erreur lors de la correction')
"

# 4. Vérification finale
info "4. Vérification finale du système..."
echo "🔍 Processus actifs:"
ps aux | grep -E "node.*3001" | grep -v grep && success "Bridge actif" || error "Bridge inactif"

echo "🌐 Connectivité:"
curl -s -o /dev/null -w "Code: %{http_code} | Temps: %{time_total}s\n" http://localhost:3001/health

success "PRISE DE CONTRÔLE TERMINÉE"
echo "🚀 Système ElganyaIA 11.1 opérationnel et contrôlé"
