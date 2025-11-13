// 📦 ELGANYAIA 11.3 - GESTIONNAIRE DE PACKAGES GITHUB
// Équipe Integration & Package Management

class GitHubPackageManager {
    constructor() {
        this.baseUrl = "https://api.github.com";
        this.rateLimit = { remaining: 60, reset: 0 };
        this.installedPackages = new Map();
        this.packageCache = new Map();
        
        this.initializeManager();
    }

    initializeManager() {
        console.log('📦 INITIALISATION GESTIONNAIRE PACKAGES GITHUB...');
        this.loadInstalledPackages();
        this.startCacheCleanup();
    }

    async searchPackages(query, options = {}) {
        console.log(`🔍 RECHERCHE PACKAGES: "${query}"`);
        
        const searchParams = new URLSearchParams({
            q: query,
            sort: options.sort || 'stars',
            order: options.order || 'desc',
            per_page: options.limit || 30
        });

        try {
            const response = await this.apiCall(`/search/repositories?${searchParams}`);
            
            return {
                success: true,
                query: query,
                total_count: response.total_count,
                packages: response.items.map(repo => ({
                    name: repo.name,
                    full_name: repo.full_name,
                    description: repo.description,
                    url: repo.html_url,
                    stars: repo.stargazers_count,
                    forks: repo.forks_count,
                    language: repo.language,
                    license: repo.license?.name,
                    updated: repo.updated_at,
                    size: repo.size,
                    has_issues: repo.has_issues,
                    open_issues: repo.open_issues_count
                }))
            };
        } catch (error) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    async installPackage(repoFullName, options = {}) {
        console.log(`🔄 INSTALLATION PACKAGE: ${repoFullName}`);
        
        try {
            // Récupération des infos du repo
            const repoInfo = await this.apiCall(`/repos/${repoFullName}`);
            
            // Vérification de la licence (gratuit seulement)
            if (!this.isPackageFree(repoInfo)) {
                return {
                    success: false,
                    error: "Package non gratuit ou licence restrictive"
                };
            }

            // Téléchargement et installation
            const installation = await this.downloadAndInstall(repoInfo, options);
            
            // Enregistrement du package
            this.installedPackages.set(repoFullName, {
                ...installation,
                installed_at: new Date().toISOString(),
                version: repoInfo.default_branch
            });

            this.saveInstalledPackages();
            
            return {
                success: true,
                package: repoFullName,
                installation: installation,
                message: `Package ${repoFullName} installé avec succès`
            };

        } catch (error) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    async downloadAndInstall(repoInfo, options) {
        const downloadUrl = `https://github.com/${repoInfo.full_name}/archive/refs/heads/${repoInfo.default_branch}.zip`;
        const installPath = `packages/${repoInfo.full_name.replace('/', '_')}`;
        
        // Création du répertoire
        const fs = require('fs');
        if (!fs.existsSync('packages')) {
            fs.mkdirSync('packages', { recursive: true });
        }
        if (!fs.existsSync(installPath)) {
            fs.mkdirSync(installPath, { recursive: true });
        }

        // Simulation de téléchargement et extraction
        // En réalité, on utiliserait des librairies comme adm-zip
        console.log(`📥 Téléchargement depuis: ${downloadUrl}`);
        console.log(`📁 Installation dans: ${installPath}`);

        return {
            path: installPath,
            download_url: downloadUrl,
            files: this.simulateFileExtraction(repoInfo),
            dependencies: this.analyzeDependencies(repoInfo)
        };
    }

    simulateFileExtraction(repoInfo) {
        // Simulation de l'extraction des fichiers
        return [
            'package.json',
            'README.md',
            'src/',
            'lib/',
            'bin/',
            'config/'
        ];
    }

    analyzeDependencies(repoInfo) {
        // Analyse des dépendances basée sur les fichiers typiques
        const dependencies = [];
        
        if (repoInfo.language === 'JavaScript') dependencies.push('node', 'npm');
        if (repoInfo.language === 'Python') dependencies.push('python3', 'pip');
        if (repoInfo.language === 'Java') dependencies.push('java', 'maven');
        if (repoInfo.language === 'Go') dependencies.push('golang');
        if (repoInfo.language === 'Rust') dependencies.push('rust');
        
        return dependencies;
    }

    isPackageFree(repoInfo) {
        const restrictiveLicenses = ['commercial', 'proprietary', 'custom'];
        const license = repoInfo.license?.key?.toLowerCase() || '';
        
        return !restrictiveLicenses.some(restrictive => 
            license.includes(restrictive) || 
            repoInfo.license?.name?.toLowerCase().includes(restrictive)
        );
    }

    async apiCall(endpoint) {
        // Vérification du rate limit
        if (this.rateLimit.remaining <= 1) {
            const waitTime = this.rateLimit.reset - Math.floor(Date.now() / 1000);
            if (waitTime > 0) {
                throw new Error(`Rate limit atteint. Réessayez dans ${waitTime} secondes`);
            }
        }

        const response = await fetch(this.baseUrl + endpoint, {
            headers: {
                'User-Agent': 'ElganyaIA-11.3',
                'Accept': 'application/vnd.github.v3+json'
            }
        });

        // Mise à jour du rate limit
        this.rateLimit.remaining = parseInt(response.headers.get('x-ratelimit-remaining') || 60);
        this.rateLimit.reset = parseInt(response.headers.get('x-ratelimit-reset') || 0);

        if (!response.ok) {
            throw new Error(`GitHub API Error: ${response.status} - ${await response.text()}`);
        }

        return await response.json();
    }

    getInstalledPackages() {
        return Array.from(this.installedPackages.entries()).map(([name, info]) => ({
            name,
            ...info
        }));
    }

    async uninstallPackage(repoFullName) {
        if (!this.installedPackages.has(repoFullName)) {
            return {
                success: false,
                error: "Package non installé"
            };
        }

        const packageInfo = this.installedPackages.get(repoFullName);
        
        // Simulation de suppression des fichiers
        console.log(`🗑️ Suppression du package: ${repoFullName}`);
        console.log(`📁 Chemin: ${packageInfo.path}`);

        this.installedPackages.delete(repoFullName);
        this.saveInstalledPackages();

        return {
            success: true,
            package: repoFullName,
            message: "Package désinstallé avec succès"
        };
    }

    loadInstalledPackages() {
        try {
            const fs = require('fs');
            if (fs.existsSync('packages/installed.json')) {
                const data = JSON.parse(fs.readFileSync('packages/installed.json', 'utf8'));
                this.installedPackages = new Map(Object.entries(data));
            }
        } catch (error) {
            console.log('❌ Erreur chargement packages:', error.message);
        }
    }

    saveInstalledPackages() {
        try {
            const fs = require('fs');
            const data = Object.fromEntries(this.installedPackages);
            fs.writeFileSync('packages/installed.json', JSON.stringify(data, null, 2));
        } catch (error) {
            console.log('❌ Erreur sauvegarde packages:', error.message);
        }
    }

    startCacheCleanup() {
        // Nettoyage du cache toutes les heures
        setInterval(() => {
            this.packageCache.clear();
            console.log('🧹 Cache packages nettoyé');
        }, 3600000);
    }

    // Recherche de packages par catégorie
    async searchByCategory(category) {
        const categories = {
            ai: "machine-learning deep-learning artificial-intelligence",
            blockchain: "blockchain cryptocurrency smart-contracts web3",
            networking: "networking p2p distributed decentralized",
            security: "security cryptography encryption privacy",
            tools: "cli terminal command-line productivity"
        };

        const query = categories[category] || category;
        return await this.searchPackages(query);
    }

    // Packages recommandés pour ElganyaIA
    getRecommendedPackages() {
        return [
            {
                name: "transformers",
                full_name: "huggingface/transformers",
                description: "State-of-the-art Machine Learning for JAX, PyTorch and TensorFlow",
                category: "ai"
            },
            {
                name: "web3.js",
                full_name: "ChainSafe/web3.js",
                description: "Ethereum JavaScript API",
                category: "blockchain"
            },
            {
                name: "tronweb",
                full_name: "tronprotocol/tronweb",
                description: "Tron Web3 library for JavaScript",
                category: "blockchain"
            },
            {
                name: "commander",
                full_name: "tj/commander.js",
                description: "node.js command-line interfaces made easy",
                category: "tools"
            },
            {
                name: "chalk",
                full_name: "chalk/chalk",
                description: "Terminal string styling done right",
                category: "tools"
            },
            {
                name: "axios",
                full_name: "axios/axios",
                description: "Promise based HTTP client for the browser and node.js",
                category: "networking"
            },
            {
                name: "socket.io",
                full_name: "socketio/socket.io",
                description: "Realtime application framework",
                category: "networking"
            },
            {
                name: "bcrypt",
                full_name: "kelektiv/node.bcrypt.js",
                description: "bcrypt for Node.js",
                category: "security"
            },
            {
                name: "crypto-js",
                full_name: "brix/crypto-js",
                description: "JavaScript library of crypto standards",
                category: "security"
            }
        ];
    }
}

module.exports = GitHubPackageManager;
