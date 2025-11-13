// 🔧 ELGANYAIA 11.3 - INTÉGRATION TERMUX + GITHUB PACKAGES
// Équipe System Integration

class TermuxPackageIntegration {
    constructor() {
        this.termuxAPI = this.detectTermuxEnvironment();
        this.packageManager = null;
        this.integrationStatus = "INITIALIZING";
        
        this.initializeIntegration();
    }

    detectTermuxEnvironment() {
        const isTermux = process.env.PREFIX && process.env.PREFIX.includes('com.termux');
        
        return {
            isTermux: isTermux,
            architecture: process.arch,
            platform: process.platform,
            termuxVersion: process.env.TERMUX_VERSION || 'unknown',
            availableCommands: this.getAvailableCommands()
        };
    }

    getAvailableCommands() {
        const commands = ['pkg', 'apt', 'git', 'node', 'python3', 'php', 'java'];
        const available = [];
        
        commands.forEach(cmd => {
            try {
                require('child_process').execSync(`which ${cmd}`, { stdio: 'ignore' });
                available.push(cmd);
            } catch (e) {
                // Commande non disponible
            }
        });
        
        return available;
    }

    async initializeIntegration() {
        console.log('🔧 INITIALISATION INTÉGRATION TERMUX + GITHUB...');
        
        try {
            const GitHubPackageManager = require('./github-package-manager');
            this.packageManager = new GitHubPackageManager();
            
            this.integrationStatus = "READY";
            console.log('✅ Intégration Termux + GitHub Packages prête');
            
        } catch (error) {
            this.integrationStatus = "ERROR";
            console.log('❌ Erreur initialisation:', error.message);
        }
    }

    async installSystemPackage(packageName) {
        if (!this.termuxAPI.isTermux) {
            return {
                success: false,
                error: "Environment Termux requis"
            };
        }

        console.log(`📦 INSTALLATION SYSTÈME: ${packageName}`);
        
        try {
            const { execSync } = require('child_process');
            
            // Utilisation de pkg (Termux) pour l'installation système
            const output = execSync(`pkg install -y ${packageName}`, {
                encoding: 'utf8',
                stdio: 'pipe'
            });
            
            return {
                success: true,
                package: packageName,
                output: output,
                message: `Package système ${packageName} installé avec succès`
            };
            
        } catch (error) {
            return {
                success: false,
                error: error.message
            };
        }
    }

    async installGitHubPackage(repoFullName, options = {}) {
        if (!this.packageManager) {
            return {
                success: false,
                error: "Gestionnaire de packages non initialisé"
            };
        }

        console.log(`🤖 INSTALLATION PACKAGE GITHUB: ${repoFullName}`);
        
        // Installation du package GitHub
        const result = await this.packageManager.installPackage(repoFullName, options);
        
        if (result.success) {
            // Installation des dépendances système si nécessaire
            const dependencies = result.installation.dependencies || [];
            for (const dep of dependencies) {
                await this.installSystemPackage(dep);
            }
            
            // Configuration automatique si possible
            await this.autoConfigurePackage(repoFullName, result.installation);
        }
        
        return result;
    }

    async autoConfigurePackage(packageName, installation) {
        console.log(`⚙️ CONFIGURATION AUTOMATIQUE: ${packageName}`);
        
        // Configuration basée sur le type de package
        const configStrategies = {
            'node': this.configureNodePackage.bind(this),
            'python': this.configurePythonPackage.bind(this),
            'cli': this.configureCLIPackage.bind(this),
            'library': this.configureLibraryPackage.bind(this)
        };
        
        const packageType = this.detectPackageType(installation);
        const configure = configStrategies[packageType] || configStrategies.library;
        
        return await configure(packageName, installation);
    }

    detectPackageType(installation) {
        const path = installation.path.toLowerCase();
        
        if (path.includes('node') || path.includes('package.json')) return 'node';
        if (path.includes('python') || path.includes('requirements.txt')) return 'python';
        if (path.includes('bin') || path.includes('cli')) return 'cli';
        
        return 'library';
    }

    async configureNodePackage(packageName, installation) {
        try {
            const { execSync } = require('child_process');
            const fs = require('fs');
            
            const packagePath = installation.path;
            const packageJsonPath = `${packagePath}/package.json`;
            
            if (fs.existsSync(packageJsonPath)) {
                // Installation des dépendances npm
                execSync('npm install', { cwd: packagePath, stdio: 'pipe' });
                
                // Construction si nécessaire
                if (fs.existsSync(`${packagePath}/package-lock.json`)) {
                    execSync('npm run build --if-present', { cwd: packagePath, stdio: 'pipe' });
                }
                
                return {
                    success: true,
                    type: 'node',
                    actions: ['npm_install', 'build']
                };
            }
        } catch (error) {
            console.log(`❌ Erreur configuration Node: ${error.message}`);
        }
        
        return { success: false };
    }

    async configurePythonPackage(packageName, installation) {
        try {
            const { execSync } = require('child_process');
            const fs = require('fs');
            
            const packagePath = installation.path;
            const requirementsPath = `${packagePath}/requirements.txt`;
            
            if (fs.existsSync(requirementsPath)) {
                // Installation des dépendances pip
                execSync('pip install -r requirements.txt', { 
                    cwd: packagePath, 
                    stdio: 'pipe' 
                });
                
                return {
                    success: true,
                    type: 'python',
                    actions: ['pip_install']
                };
            }
        } catch (error) {
            console.log(`❌ Erreur configuration Python: ${error.message}`);
        }
        
        return { success: false };
    }

    async configureCLIPackage(packageName, installation) {
        try {
            const fs = require('fs');
            const packagePath = installation.path;
            
            // Recherche des binaires exécutables
            const binDir = `${packagePath}/bin`;
            if (fs.existsSync(binDir)) {
                const files = fs.readdirSync(binDir);
                const executables = files.filter(f => 
                    f.endsWith('.sh') || !f.includes('.') || f.endsWith('.py')
                );
                
                // Rendre les scripts exécutables
                executables.forEach(file => {
                    try {
                        fs.chmodSync(`${binDir}/${file}`, 0o755);
                    } catch (e) {
                        // Ignorer les erreurs de permissions
                    }
                });
                
                return {
                    success: true,
                    type: 'cli',
                    executables: executables
                };
            }
        } catch (error) {
            console.log(`❌ Erreur configuration CLI: ${error.message}`);
        }
        
        return { success: false };
    }

    getIntegrationStatus() {
        return {
            termux: this.termuxAPI,
            packageManager: this.packageManager ? "READY" : "NOT_READY",
            integrationStatus: this.integrationStatus,
            installedPackages: this.packageManager ? 
                this.packageManager.getInstalledPackages() : []
        };
    }

    async searchAndInstall(category, query = null) {
        if (!this.packageManager) {
            return { success: false, error: "Package manager non disponible" };
        }

        const searchQuery = query || category;
        const searchResult = await this.packageManager.searchPackages(searchQuery);
        
        if (!searchResult.success || searchResult.packages.length === 0) {
            return searchResult;
        }

        // Installation du premier package trouvé
        const firstPackage = searchResult.packages[0];
        return await this.installGitHubPackage(firstPackage.full_name);
    }
}

module.exports = TermuxPackageIntegration;
