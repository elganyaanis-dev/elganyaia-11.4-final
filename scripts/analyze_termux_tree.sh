#!/bin/bash
echo "🌳 ANALYSE ARBORESCENCE TERMUX COMPLÈTE"
echo "=========================================="

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# =============================================================================
# FONCTION D'AFFICHAGE ARBORESCENCE
# =============================================================================
generate_tree() {
    local dir="$1"
    local prefix="$2"
    local count=0
    
    for item in "$dir"/*; do
        [ -e "$item" ] || continue
        
        local name=$(basename "$item")
        count=$((count + 1))
        
        # Déterminer le préfixe d'affichage
        local new_prefix="$prefix├── "
        local next_prefix="$prefix│   "
        
        if [ $count -eq $(ls -1 "$dir" | wc -l) ]; then
            new_prefix="$prefix└── "
            next_prefix="$prefix    "
        fi
        
        # Couleur selon le type
        if [ -d "$item" ]; then
            echo -e "${BLUE}$new_prefix${CYAN}📁 $name${NC}"
            generate_tree "$item" "$next_prefix"
        elif [ -f "$item" ]; then
            if [[ "$name" == *.py || "$name" == *.js || "$name" == *.sh ]]; then
                echo -e "${GREEN}$new_prefix📜 $name${NC}"
            elif [[ "$name" == *.txt || "$name" == *.log || "$name" == *.md ]]; then
                echo -e "${YELLOW}$new_prefix📄 $name${NC}"
            elif [[ "$name" == *.json || "$name" == *.yml || "$name" == *.yaml ]]; then
                echo -e "${PURPLE}$new_prefix⚙️  $name${NC}"
            else
                echo -e "${new_prefix}📄 $name"
            fi
        fi
    done
}

# =============================================================================
# ANALYSE SYSTÈME
# =============================================================================
echo -e "${CYAN}📊 STATISTIQUES SYSTÈME:${NC}"
echo "Espace disque: $(df -h ~/ | awk 'NR==2{print $4 " libre sur " $2}')"
echo "Nombre de dossiers: $(find ~ -type d 2>/dev/null | wc -l)"
echo "Nombre de fichiers: $(find ~ -type f 2>/dev/null | wc -l)"
echo ""

# =============================================================================
# ARBORESCENCE PRINCIPALE
# =============================================================================
echo -e "${CYAN}🌳 ARBORESCENCE PRINCIPALE:${NC}"
echo "📁 ~/"
generate_tree "$HOME" ""

# =============================================================================
# PROJETS IA SPÉCIFIQUES
# =============================================================================
echo -e "${CYAN}🤖 PROJETS IA DÉTAILLÉS:${NC}"

# ELGANYA_IA
if [ -d ~/ELGANYA_IA ]; then
    echo -e "${GREEN}📁 ELGANYA_IA/${NC}"
    if [ -d ~/ELGANYA_IA/CORE_SYSTEM ]; then
        echo "  ├── 🧠 CORE_SYSTEM/"
        for file in ~/ELGANYA_IA/CORE_SYSTEM/*; do
            [ -e "$file" ] && echo "  │   └── 📜 $(basename "$file")"
        done
    fi
    if [ -d ~/ELGANYA_IA/API_INTEGRATIONS ]; then
        echo "  ├── 🌐 API_INTEGRATIONS/"
        for file in ~/ELGANYA_IA/API_INTEGRATIONS/*; do
            [ -e "$file" ] && echo "  │   └── 📜 $(basename "$file")"
        done
    fi
    if [ -d ~/ELGANYA_IA/COMMUNICATION ]; then
        echo "  └── 🔌 COMMUNICATION/"
        for file in ~/ELGANYA_IA/COMMUNICATION/*; do
            [ -e "$file" ] && echo "      └── 📄 $(basename "$file")"
        done
    fi
fi

# Kamina AI
if [ -d ~/kamina_ai ]; then
    echo -e "${GREEN}📁 kamina_ai/${NC}"
    find ~/kamina_ai -maxdepth 2 -type d | head -10 | while read dir; do
        if [ "$dir" != "$HOME/kamina_ai" ]; then
            echo "  └── 📁 $(basename "$dir")/"
        fi
    done
fi

# =============================================================================
# CONFIGURATIONS IMPORTANTES
# =============================================================================
echo -e "${CYAN}⚙️ CONFIGURATIONS SYSTÈME:${NC}"
for config in .bashrc .profile .gitconfig .ssh .termux .config; do
    if [ -e ~/$config ]; then
        if [ -d ~/$config ]; then
            echo -e "${GREEN}📁 $config/${NC}"
        else
            echo -e "${YELLOW}📄 $config${NC}"
        fi
    fi
done

# =============================================================================
# PROJETS ET DEPOTS
# =============================================================================
echo -e "${CYAN}🚀 PROJETS ET DÉPÔTS:${NC}"
find ~ -maxdepth 2 -type d -name "*project*" -o -name "*repo*" -o -name "*github*" -o -name "*vercel*" 2>/dev/null | while read dir; do
    if [[ ! "$dir" =~ "ELGANYA_IA" && ! "$dir" =~ "kamina_ai" ]]; then
        echo "📁 $(basename "$(dirname "$dir")")/$(basename "$dir")"
    fi
done

# =============================================================================
# FICHIERS EXÉCUTABLES
# =============================================================================
echo -e "${CYAN}🎯 SCRIPTS EXÉCUTABLES:${NC}"
find ~ -maxdepth 3 -type f -executable -name "*.sh" -o -name "*.py" 2>/dev/null | head -10 | while read script; do
    echo "📜 $(basename "$script") → $script"
done

# =============================================================================
# RAPPORT FINAL
# =============================================================================
echo ""
echo -e "${CYAN}📈 RAPPORT FINAL:${NC}"
echo "Projets IA: $(find ~ -name "*ai*" -type d 2>/dev/null | wc -l)"
echo "Scripts: $(find ~ -name "*.sh" -o -name "*.py" 2>/dev/null | wc -l)"
echo "Fichiers de configuration: $(find ~ -name ".*" -type f 2>/dev/null | wc -l)"
echo "Dernière modification: $(find ~ -type f -exec stat -c %Y {} \; 2>/dev/null | sort -nr | head -1 | xargs -I{} date -d @{} "+%Y-%m-%d %H:%M")"

