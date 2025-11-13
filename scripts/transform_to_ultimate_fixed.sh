#!/bin/bash
echo "🎯 TRANSFORMATION ULTIMATE - VERSION CORRIGÉE"

# Utiliser les copies locales existantes au lieu de cloner
echo "📦 Transformation kamina-os → kamina-os-ultimate"
if [ -d "~/kamina-original" ]; then
    cp -r ~/kamina-original ~/kamina-os-ultimate
    echo "✅ kamina-os-ultimate créé depuis kamina-original"
else
    echo "❌ kamina-original non trouvé"
fi

echo "🚀 Transformation kamina-os-revolution → kamina-os-ultimate-v2"
if [ -d "~/storage/shared/kamina-deploy" ]; then
    cp -r ~/storage/shared/kamina-deploy ~/kamina-os-ultimate-v2
    echo "✅ kamina-os-ultimate-v2 créé depuis kamina-deploy"
else
    echo "❌ kamina-deploy non trouvé"
fi

# Configurer Git pour les nouveaux dossiers
echo "🔧 Configuration Git..."
for ultimate_dir in "kamina-os-ultimate" "kamina-os-ultimate-v2"; do
    if [ -d "$ultimate_dir" ]; then
        cd "$ultimate_dir"
        if [ -d ".git" ]; then
            echo "🐙 Configuration Git pour $ultimate_dir"
            # Changer le remote pour pointer vers les nouveaux noms
            git remote set-url origin "https://github.com/elganyaanis-dev/$ultimate_dir.git" 2>/dev/null || echo "Remote non configuré"
        fi
        cd ..
    fi
done

echo ""
echo "🎯 STRUCTURE FINALE CRÉÉE:"
echo "📁 kamina-os-ultimate/     (depuis kamina-original)"
echo "📁 kamina-os-ultimate-v2/  (depuis kamina-deploy/kamina-os-revolution)"
echo ""
echo "🌐 PROCHAINES ÉTAPES:"
echo "1. Créer les repositories sur GitHub: https://github.com/new"
echo "2. Pusher le code: cd kamina-os-ultimate && git push origin main"
echo "3. Configurer Vercel pour chaque repo"
