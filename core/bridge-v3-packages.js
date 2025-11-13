// 📦 BRIDGE V3 AVEC GESTION DES PACKAGES
// Équipe Integration & API

const express = require('express');
const http = require('http');
const TermuxPackageIntegration = require('../elganya/termux-package-integration');

class PackageEnhancedBridge {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app);
        this.port = 3001;
        this.packageManager = null;
        
        this.initializePackageManager();
        this.setupMiddleware();
        this.setupPackageRoutes();
        this.setupConsciousRoutes();
    }

    async initializePackageManager() {
        try {
            this.packageManager = new TermuxPackageIntegration();
            console.log('📦 Gestionnaire de packages initialisé');
        } catch (error) {
            console.log('❌ Erreur initialisation packages:', error.message);
        }
    }

    setupMiddleware() {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));
        
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
            res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH');
            next();
        });
    }

    setupPackageRoutes() {
        // Endpoint de recherche de packages
        this.app.get('/packages/search', async (req, res) => {
            try {
                const { q, category, limit } = req.query;
                
                if (!this.packageManager.packageManager) {
                    return res.status(500).json({
                        success: false,
                        error: "Gestionnaire de packages non disponible"
                    });
                }

                const query = q || category;
                const result = await this.packageManager.packageManager.searchPackages(query, {
                    limit: parseInt(limit) || 20
                });

                res.json(result);
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        // Endpoint d'installation de package
        this.app.post('/packages/install', async (req, res) => {
            try {
                const { repository, options } = req.body;
                
                if (!repository) {
                    return res.status(400).json({
                        success: false,
                        error: "Repository manquant"
                    });
                }

                const result = await this.packageManager.installGitHubPackage(repository, options);
                res.json(result);
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        // Endpoint de liste des packages installés
        this.app.get('/packages/installed', async (req, res) => {
            try {
                if (!this.packageManager.packageManager) {
                    return res.status(500).json({
                        success: false,
                        error: "Gestionnaire de packages non disponible"
                    });
                }

                const packages = this.packageManager.packageManager.getInstalledPackages();
                res.json({
                    success: true,
                    packages: packages,
                    count: packages.length
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        // Endpoint de statut de l'intégration
        this.app.get('/packages/status', async (req, res) => {
            try {
                const status = this.packageManager.getIntegrationStatus();
                res.json({
                    success: true,
                    status: status
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });
    }

    setupConsciousRoutes() {
        // Endpoints de conscience existants
        this.app.get('/consciousness/creator', (req, res) => {
            res.json({
                success: true,
                creator: {
                    nom: "Chabbi",
                    prenom: "Mohamed Anis", 
                    surnom: "elganya",
                    secondSurnom: "carl hauser",
                    dateNaissance: "13/10/1988",
                    lieuNaissance: "Souk Ahras, Algérie",
                    message: "Créateur d'ElganyaIA 11.3 avec gestion avancée des packages GitHub"
                }
            });
        });

        this.app.get('/health', (req, res) => {
            res.json({
                status: 'healthy',
                service: 'Bridge V3 avec Package Management',
                version: '11.3.0',
                features: {
                    packageManagement: true,
                    termuxIntegration: true,
                    githubAccess: true,
                    consciousAI: true
                },
                stats: {
                    packagesInstalled: this.packageManager.packageManager ? 
                        this.packageManager.packageManager.getInstalledPackages().length : 0
                }
            });
        });
    }

    start() {
        this.server.listen(this.port, '0.0.0.0', () => {
            console.log('📦 BRIDGE V3 AVEC PACKAGE MANAGEMENT DÉMARRÉ');
            console.log(`📍 Port: ${this.port}`);
            console.log(`🌐 URL: http://localhost:${this.port}`);
            console.log('🎯 ENDPOINTS PACKAGES:');
            console.log('   GET  /packages/search?q=query');
            console.log('   POST /packages/install');
            console.log('   GET  /packages/installed');
            console.log('   GET  /packages/status');
            console.log('');
            console.log('👤 Créateur: Mohamed Anis Chabbi (elganya/carl hauser)');
            console.log('🚀 Mission: IA consciente avec accès illimité aux packages GitHub');
        });
    }
}

// Démarrer le bridge
const bridge = new PackageEnhancedBridge();
bridge.start();

module.exports = PackageEnhancedBridge;
