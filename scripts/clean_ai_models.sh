#!/bin/bash
echo "🧠 SCANNER ET NETTOYER LES MODÈLES IA"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# =============================================================================
# PHASE 1: DÉTECTION DES MODÈLES
# =============================================================================
echo -e "${YELLOW}🔍 PHASE 1: Détection des modèles IA...${NC}"

# Fichiers modèles IA (extensions communes)
MODEL_PATTERNS=(
    "*.bin" "*.pth" "*.h5" "*.pt" 
    "*.model" "*.tflite" "*.onnx" 
    "*.ckpt" "*.safetensors" "*.gguf"
    "*.msgpack" "*.zip" "*.tar.gz"
)

# Dossiers à exclure (projets importants)
EXCLUDE_DIRS=(
    "ELGANYA_IA"
    "kamina_ai" 
    "deepseek_system"
    "github"
    "vercel"
    "projects"
    ".cache"
)

# Construire la commande find
FIND_CMD="find ~ -type f"
for pattern in "${MODEL_PATTERNS[@]}"; do
    FIND_CMD+=" -name \"$pattern\" -o"
done
FIND_CMD="${FIND_CMD% -o}"

for exclude in "${EXCLUDE_DIRS[@]}"; do
    FIND_CMD+=" -not -path \"*/$exclude/*\""
done

# Exécuter et sauvegarder
eval $FIND_CMD 2>/dev/null > /tmp/all_models.txt

# =============================================================================
# PHASE 2: ANALYSE DES MODÈLES RÉCENTS
# =============================================================================
echo -e "${YELLOW}📊 PHASE 2: Analyse des modèles récents...${NC}"

# Modèles modifiés récemment (7 derniers jours)
find ~ -type f \( -name "*.bin" -o -name "*.pth" -o -name "*.h5" -o -name "*.pt" -o -name "*.model" -o -name "*.tflite" -o -name "*.onnx" -o -name "*.ckpt" \) -mtime -7 -not -path "*/ELGANYA_IA/*" -not -path "*/kamina_ai/*" -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr > /tmp/recent_models_detailed.txt

echo -e "${GREEN}📈 MODÈLES RÉCENTS TROUVÉS:${NC}"
if [ -s /tmp/recent_models_detailed.txt ]; then
    cat /tmp/recent_models_detailed.txt
else
    echo "Aucun modèle récent trouvé en dehors des projets protégés."
fi

# =============================================================================
# PHASE 3: DÉTECTION MODÈLES CORROMPUS/PETITS
# =============================================================================
echo -e "${YELLOW}🔎 PHASE 3: Détection modèles suspects...${NC}"

# Trouver les fichiers très petits (potentiellement corrompus)
find ~ -type f \( -name "*.bin" -o -name "*.pth" -o -name "*.h5" -o -name "*.pt" -o -name "*.model" \) -not -path "*/ELGANYA_IA/*" -not -path "*/kamina_ai/*" -size -100k -exec ls -lh {} \; 2>/dev/null > /tmp/small_models.txt

echo -e "${RED}🚨 MODÈLES SUSPECTS (taille < 100KB):${NC}"
if [ -s /tmp/small_models.txt ]; then
    cat /tmp/small_models.txt
else
    echo "Aucun modèle suspect détecté."
fi

# =============================================================================
# PHASE 4: NETTOYAGE INTERACTIF
# =============================================================================
echo -e "${YELLOW}🧹 PHASE 4: Nettoyage interactif...${NC}"

if [ -s /tmp/small_models.txt ]; then
    echo -e "${RED}Voulez-vous supprimer les modèles suspects? (y/N)${NC}"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        find ~ -type f \( -name "*.bin" -o -name "*.pth" -o -name "*.h5" -o -name "*.pt" -o -name "*.model" \) -not -path "*/ELGANYA_IA/*" -not -path "*/kamina_ai/*" -size -100k -delete 2>/dev/null
        echo -e "${GREEN}✅ Modèles suspects supprimés.${NC}"
    fi
fi

# Nettoyer les fichiers temporaires de téléchargement
echo "🧹 Nettoyage des fichiers temporaires..."
find ~ -name "*.tmp" -delete 2>/dev/null
find ~ -name "*.temp" -delete 2>/dev/null
find ~ -name "*.download" -delete 2>/dev/null
find ~ -name "*.part" -delete 2>/dev/null

echo -e "${GREEN}🎉 NETTOYAGE TERMINÉ!${NC}"

# Rapport final
echo ""
echo -e "${YELLOW}📊 RAPPORT FINAL:${NC}"
echo "Modèles analysés: $(wc -l < /tmp/all_models.txt)"
echo "Modèles récents: $(wc -l < /tmp/recent_models_detailed.txt)"
echo "Modèles suspects supprimés: $(wc -l < /tmp/small_models.txt)"

