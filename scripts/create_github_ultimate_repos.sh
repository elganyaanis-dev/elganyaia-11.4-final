#!/bin/bash
echo "🌐 CRÉATION REPOSITORIES ULTIMATE SUR GITHUB..."

GITHUB_TOKEN="GITHUB_TOKEN_REMOVED"

create_repo() {
    local repo_name=$1
    local description=$2
    
    echo "🔧 Création: $repo_name"
    response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        "https://api.github.com/user/repos" \
        -d "{\"name\":\"$repo_name\",\"description\":\"$description\",\"private\":false}")
    
    if echo "$response" | grep -q "created_at"; then
        echo "✅ REPO CRÉÉ: https://github.com/elganyaanis-dev/$repo_name"
        return 0
    else
        echo "❌ Erreur création: $repo_name"
        return 1
    fi
}

# Créer les repositories
create_repo "kamina-os-ultimate" "Version Ultimate de Kamina OS - Système complet"
create_repo "kamina-os-ultimate-v2" "Version Ultimate V2 de Kamina OS - Déploiement avancé"

echo ""
echo "🎯 PROCHAINES COMMANDES:"
echo "cd kamina-os-ultimate && git remote set-url origin https://github.com/elganyaanis-dev/kamina-os-ultimate.git"
echo "cd kamina-os-ultimate-v2 && git remote set-url origin https://github.com/elganyaanis-dev/kamina-os-ultimate-v2.git"
