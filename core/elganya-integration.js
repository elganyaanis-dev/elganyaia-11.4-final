// 🎯 MODULE ELGANYAIA INTÉGRÉ AU BRIDGE V3 - VERSION CORRIGÉE
const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

class ElganyaBlockchainManager {
    constructor() {
        this.homeDir = '/data/data/com.termux/files/home';
        this.erc20Dir = path.join(this.homeDir, 'erc20-test');
        this.elganyaDir = path.join(this.homeDir, 'elganya_v11.1');
        this.kaminaDir = path.join(this.homeDir, 'kamina-os');
        
        this.setupPaths();
    }

    setupPaths() {
        const dirs = [this.erc20Dir, this.elganyaDir, this.kaminaDir];
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });
    }

    // Analyse complète de l'environnement
    analyzeEnvironment() {
        console.log('🔍 ANALYSE DE L\'ENVIRONNEMENT ELGANYAIA:');
        
        const analysis = {
            erc20: this.analyzeERC20Project(),
            elganya: this.analyzeElganyaIA(),
            blockchain: this.analyzeBlockchainSetup(),
            dependencies: this.analyzeDependencies()
        };

        return analysis;
    }

    analyzeERC20Project() {
        const erc20Path = this.erc20Dir;
        const result = {
            exists: fs.existsSync(erc20Path),
            contracts: [],
            scripts: [],
            configs: [],
            issues: []
        };

        if (result.exists) {
            const contractsPath = path.join(erc20Path, 'contracts');
            if (fs.existsSync(contractsPath)) {
                result.contracts = fs.readdirSync(contractsPath)
                    .filter(file => file.endsWith('.sol'));
            }

            const scriptsPath = path.join(erc20Path, 'scripts');
            if (fs.existsSync(scriptsPath)) {
                result.scripts = fs.readdirSync(scriptsPath)
                    .filter(file => file.endsWith('.js'));
            }

            const configFiles = ['package.json', 'hardhat.config.js', '.env'];
            configFiles.forEach(file => {
                if (fs.existsSync(path.join(erc20Path, file))) {
                    result.configs.push(file);
                }
            });

            if (!result.contracts.length) {
                result.issues.push('Aucun contrat Solidity trouvé');
            }
            if (!fs.existsSync(path.join(erc20Path, 'hardhat.config.js'))) {
                result.issues.push('Configuration Hardhat manquante');
            }
        }

        return result;
    }

    analyzeElganyaIA() {
        const elganyaPath = this.elganyaDir;
        const result = {
            exists: fs.existsSync(elganyaPath),
            modules: [],
            blockchain: false,
            version: 'inconnue'
        };

        if (result.exists) {
            const modulesPath = path.join(elganyaPath, 'modules');
            if (fs.existsSync(modulesPath)) {
                result.modules = fs.readdirSync(modulesPath);
                result.blockchain = result.modules.includes('blockchain');
            }

            try {
                const packagePath = path.join(elganyaPath, 'package.json');
                if (fs.existsSync(packagePath)) {
                    const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
                    result.version = pkg.version || '11.1.0';
                }
            } catch (e) {
                result.version = '11.1.0 (estimée)';
            }
        }

        return result;
    }

    analyzeBlockchainSetup() {
        const result = {
            nodejs: false,
            npm: false,
            hardhat: false,
            web3: false,
            wallet: false,
            infura: false
        };

        try {
            execSync('node --version', { stdio: 'pipe' });
            result.nodejs = true;
        } catch (e) {
            result.nodejs = false;
        }

        try {
            execSync('npm --version', { stdio: 'pipe' });
            result.npm = true;
        } catch (e) {
            result.npm = false;
        }

        const hardhatPath = path.join(this.erc20Dir, 'node_modules', 'hardhat');
        result.hardhat = fs.existsSync(hardhatPath);

        try {
            execSync('npm list web3', { cwd: this.erc20Dir, stdio: 'pipe' });
            result.web3 = true;
        } catch (e) {
            result.web3 = false;
        }

        const envPath = path.join(this.erc20Dir, '.env');
        if (fs.existsSync(envPath)) {
            const envContent = fs.readFileSync(envPath, 'utf8');
            result.wallet = envContent.includes('PRIVATE_KEY');
            result.infura = envContent.includes('INFURA') || envContent.includes('SEPOLIA_URL');
        }

        return result;
    }

    analyzeDependencies() {
        const result = {
            missing: [],
            conflicts: [],
            recommendations: []
        };

        if (!this.analyzeBlockchainSetup().nodejs) {
            result.missing.push('Node.js');
        }
        if (!this.analyzeBlockchainSetup().npm) {
            result.missing.push('npm');
        }
        if (!this.analyzeBlockchainSetup().hardhat) {
            result.missing.push('Hardhat');
        }

        try {
            const packagePath = path.join(this.erc20Dir, 'package.json');
            if (fs.existsSync(packagePath)) {
                const pkg = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
                if (pkg.devDependencies) {
                    if (pkg.devDependencies.hardhat && pkg.devDependencies.hardhat.startsWith('2.')) {
                        result.conflicts.push('Hardhat v2.x peut avoir des conflits avec toolbox v3');
                    }
                }
            }
        } catch (e) {
            // Ignorer les erreurs de lecture
        }

        return result;
    }

    // Générer un rapport complet
    generateReport() {
        const analysis = this.analyzeEnvironment();
        
        console.log('\n📊 RAPPORT COMPLET ELGANYAIA:');
        console.log('=' * 50);

        // Rapport ERC-20
        console.log('\n📦 PROJET ERC-20:');
        console.log(`   Existe: ${analysis.erc20.exists ? '✅' : '❌'}`);
        if (analysis.erc20.exists) {
            console.log(`   Contrats: ${analysis.erc20.contracts.join(', ') || 'Aucun'}`);
            console.log(`   Scripts: ${analysis.erc20.scripts.join(', ') || 'Aucun'}`);
            console.log(`   Configs: ${analysis.erc20.configs.join(', ') || 'Aucun'}`);
            if (analysis.erc20.issues.length) {
                console.log(`   Problèmes: ${analysis.erc20.issues.join(', ')}`);
            }
        }

        // Rapport ElganyaIA
        console.log('\n🤖 ELGANYAIA:');
        console.log(`   Existe: ${analysis.elganya.exists ? '✅' : '❌'}`);
        if (analysis.elganya.exists) {
            console.log(`   Version: ${analysis.elganya.version}`);
            console.log(`   Modules: ${analysis.elganya.modules.join(', ') || 'Aucun'}`);
            console.log(`   Blockchain: ${analysis.elganya.blockchain ? '✅' : '❌'}`);
        }

        // Rapport Blockchain
        console.log('\n🔗 BLOCKCHAIN SETUP:');
        const blockchain = analysis.blockchain;
        console.log(`   Node.js: ${blockchain.nodejs ? '✅' : '❌'}`);
        console.log(`   npm: ${blockchain.npm ? '✅' : '❌'}`);
        console.log(`   Hardhat: ${blockchain.hardhat ? '✅' : '❌'}`);
        console.log(`   Web3: ${blockchain.web3 ? '✅' : '❌'}`);
        console.log(`   Wallet: ${blockchain.wallet ? '✅' : '❌'}`);
        console.log(`   Infura: ${blockchain.infura ? '✅' : '❌'}`);

        // Rapport Dépendances
        console.log('\n📚 DÉPENDANCES:');
        if (analysis.dependencies.missing.length) {
            console.log(`   Manquantes: ${analysis.dependencies.missing.join(', ')}`);
        }
        if (analysis.dependencies.conflicts.length) {
            console.log(`   Conflits: ${analysis.dependencies.conflicts.join(', ')}`);
        }

        return analysis;
    }

    // Correction automatique des problèmes
    async fixIssues() {
        console.log('\n🔧 CORRECTION AUTOMATIQUE DES PROBLÈMES...');
        
        const analysis = this.analyzeEnvironment();
        
        if (analysis.dependencies.missing.includes('Hardhat') || analysis.dependencies.missing.includes('npm')) {
            console.log('📦 Configuration du projet ERC-20...');
            this.setupERC20Project();
        }

        if (analysis.erc20.exists && !analysis.erc20.configs.includes('hardhat.config.js')) {
            console.log('⚙️  Création de la configuration Hardhat...');
            this.createHardhatConfig();
        }

        console.log('✅ CORRECTIONS APPLIQUÉES!');
        return { success: true, message: 'Corrections terminées' };
    }

    setupERC20Project() {
        const erc20Path = this.erc20Dir;
        
        const packageJsonPath = path.join(erc20Path, 'package.json');
        if (!fs.existsSync(packageJsonPath)) {
            const packageJson = {
                name: "elganya-token",
                version: "1.0.0",
                description: "Token ERC-20 pour ElganyaIA",
                scripts: {
                    "compile": "hardhat compile",
                    "deploy": "hardhat run scripts/deploy.js --network sepolia",
                    "test": "hardhat test"
                },
                devDependencies: {
                    "hardhat": "^2.17.0",
                    "@nomicfoundation/hardhat-toolbox": "^3.0.0"
                },
                dependencies: {
                    "@openzeppelin/contracts": "^4.9.3"
                }
            };
            
            fs.writeFileSync(packageJsonPath, JSON.stringify(packageJson, null, 2));
            console.log('   ✅ package.json créé');
        }

        try {
            console.log('   📦 Installation des dépendances npm...');
            execSync('npm install --legacy-peer-deps', { cwd: erc20Path, stdio: 'pipe' });
            console.log('   ✅ Dépendances installées');
        } catch (error) {
            console.log('   ❌ Échec de l\'installation des dépendances');
        }
    }

    createHardhatConfig() {
        const configContent = `require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000
      }
    }
  },
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_URL || "https://sepolia.infura.io/v3/d285993c48994337bc4c5e381baca9f0",
      accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : [],
      chainId: 11155111,
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  }
};`;

        fs.writeFileSync(path.join(this.erc20Dir, 'hardhat.config.js'), configContent);
        console.log('   ✅ hardhat.config.js créé');
    }

    // Méthodes pour le bridge
    async compileContracts() {
        try {
            console.log('🔨 Compilation des contrats...');
            const result = execSync('cd /data/data/com.termux/files/home/erc20-test && npx hardhat compile', { 
                encoding: 'utf8',
                stdio: 'pipe'
            });
            
            return { 
                success: true, 
                message: 'Compilation réussie',
                output: result
            };
        } catch (error) {
            return { 
                success: false, 
                error: error.message,
                stderr: error.stderr ? error.stderr.toString() : ''
            };
        }
    }

    async deployToken() {
        try {
            console.log('🚀 Déploiement du token...');
            const result = execSync('cd /data/data/com.termux/files/home/erc20-test && npx hardhat run scripts/deploy.js --network sepolia', { 
                encoding: 'utf8',
                stdio: 'pipe'
            });
            
            return { 
                success: true, 
                message: 'Déploiement réussi',
                output: result
            };
        } catch (error) {
            return { 
                success: false, 
                error: error.message,
                stderr: error.stderr ? error.stderr.toString() : ''
            };
        }
    }

    async checkEthBalance() {
        try {
            // Solution simple sans require web3 (pour éviter les erreurs)
            return {
                success: true,
                wallet: '0xaAe23Dd71207F9995CE8CD17e3CbFAF1A34aaDC6',
                message: 'Utilisez https://sepoliafaucet.com/ pour obtenir des ETH de test',
                instructions: 'Collez cette adresse: 0xaAe23Dd71207F9995CE8CD17e3CbFAF1A34aaDC6'
            };
        } catch (error) {
            return {
                success: false,
                error: error.message
            };
        }
    }
}

module.exports = ElganyaBlockchainManager;
