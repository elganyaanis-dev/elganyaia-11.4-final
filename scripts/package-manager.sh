#!/bin/bash
echo "📦 GESTIONNAIRE DE PACKAGES ELGANYAIA 11.3"
echo "=========================================="

cd /data/data/com.termux/files/home/kamina-os

COMMAND=$1
PARAM=$2

case $COMMAND in
    "search")
        echo "🔍 Recherche de packages: $PARAM"
        node -e "
        const GitHubPackageManager = require('./elganya/github-package-manager');
        const manager = new GitHubPackageManager();
        
        manager.searchPackages('$PARAM').then(result => {
            if (result.success) {
                console.log('📊 RÉSULTATS:');
                result.packages.slice(0, 10).forEach((pkg, i) => {
                    console.log(\`\${i + 1}. \${pkg.name} (\${pkg.language})\`);
                    console.log(\`   ⭐ \${pkg.stars} | 🍴 \${pkg.forks}\`);
                    console.log(\`   📝 \${pkg.description}\`);
                    console.log(\`   🔗 \${pkg.url}\`);
                    console.log('');
                });
            } else {
                console.log('❌ Erreur:', result.error);
            }
        });
        "
        ;;
        
    "install")
        echo "🔄 Installation du package: $PARAM"
        node -e "
        const TermuxPackageIntegration = require('./elganya/termux-package-integration');
        const integration = new TermuxPackageIntegration();
        
        setTimeout(async () => {
            const result = await integration.installGitHubPackage('$PARAM');
            if (result.success) {
                console.log('✅ SUCCÈS:');
                console.log('   Package:', result.package);
                console.log('   Message:', result.message);
            } else {
                console.log('❌ ÉCHEC:');
                console.log('   Erreur:', result.error);
            }
        }, 1000);
        "
        ;;
        
    "list")
        echo "📋 Packages installés:"
        node -e "
        const GitHubPackageManager = require('./elganya/github-package-manager');
        const manager = new GitHubPackageManager();
        
        const packages = manager.getInstalledPackages();
        if (packages.length === 0) {
            console.log('ℹ️  Aucun package installé');
        } else {
            packages.forEach((pkg, i) => {
                console.log(\`\${i + 1}. \${pkg.name}\`);
                console.log(\`   📁 Chemin: \${pkg.path}\`);
                console.log(\`   📅 Installé: \${new Date(pkg.installed_at).toLocaleDateString()}\`);
                console.log('');
            });
        }
        "
        ;;
        
    "categories")
        echo "🎯 Catégories de packages disponibles:"
        echo "   🤖 IA & Machine Learning"
        echo "   ⛓️  Blockchain & Crypto"
        echo "   🌐 Networking & P2P"
        echo "   🔐 Sécurité & Cryptographie"
        echo "   🔧 Outils & CLI"
        echo "   📊 Data & Analytics"
        echo ""
        echo "Usage: ./package-manager.sh search IA"
        ;;
        
    "recommended")
        echo "🏆 Packages recommandés:"
        node -e "
        const GitHubPackageManager = require('./elganya/github-package-manager');
        const manager = new GitHubPackageManager();
        
        const recommended = manager.getRecommendedPackages();
        recommended.forEach((pkg, i) => {
            console.log(\`\${i + 1}. \${pkg.name} [\${pkg.category}]\`);
            console.log(\`   📝 \${pkg.description}\`);
            console.log(\`   🔗 \${pkg.full_name}\`);
            console.log('');
        });
        "
        ;;
        
    *)
        echo "📖 UTILISATION:"
        echo "   ./package-manager.sh search <query>      - Rechercher packages"
        echo "   ./package-manager.sh install <user/repo> - Installer package"
        echo "   ./package-manager.sh list                - Lister packages installés"
        echo "   ./package-manager.sh categories          - Voir catégories"
        echo "   ./package-manager.sh recommended         - Packages recommandés"
        echo ""
        echo "🔍 EXEMPLES:"
        echo "   ./package-manager.sh search \"machine learning\""
        echo "   ./package-manager.sh install huggingface/transformers"
        echo "   ./package-manager.sh install axios/axios"
        ;;
esac
