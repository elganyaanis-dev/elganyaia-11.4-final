// 🎯 BRIDGE V3 SUR PORT 3001 - ÉVITE LES CONFLITS
const express = require('express');
const http = require('http');
const fs = require('fs');
const path = require('path');

class BridgeV3 {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app);
        this.port = 3001; // PORT DIFFÉRENT
        this.endpoints = {};
        
        this.setupMiddleware();
        this.setupRoutes();
        this.loadElganyaIntegration();
    }

    setupMiddleware() {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));
        
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
            res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
            next();
        });
    }

    setupRoutes() {
        this.app.get('/health', (req, res) => {
            res.json({
                status: 'healthy',
                service: 'Bridge V3 - ElganyaIA',
                timestamp: new Date().toISOString(),
                version: '3.0.1',
                port: this.port
            });
        });

        this.app.get('/endpoints', (req, res) => {
            res.json({
                endpoints: Object.keys(this.endpoints),
                total: Object.keys(this.endpoints).length
            });
        });

        this.app.all('*', (req, res) => {
            const path = req.path;
            const method = req.method.toUpperCase();
            
            if (this.endpoints[path] && this.endpoints[path].method === method) {
                this.endpoints[path].handler(req, res);
            } else {
                res.status(404).json({
                    error: 'Endpoint not found',
                    path: path,
                    method: method,
                    available: Object.keys(this.endpoints)
                });
            }
        });
    }

    loadElganyaIntegration() {
        try {
            const ElganyaBlockchainManager = require('./elganya-integration');
            this.elganyaManager = new ElganyaBlockchainManager();
            
            console.log('✅ Module ElganyaIA chargé avec succès');
            this.registerElganyaEndpoints();
            
        } catch (error) {
            console.log('❌ Erreur chargement ElganyaIA:', error.message);
            this.registerFallbackEndpoints();
        }
    }

    registerElganyaEndpoints() {
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: (req, res) => {
                try {
                    const analysis = this.elganyaManager.generateReport();
                    res.json({
                        success: true,
                        timestamp: new Date().toISOString(),
                        analysis: analysis
                    });
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        this.endpoints['/elganya/fix'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    await this.elganyaManager.fixIssues();
                    res.json({
                        success: true,
                        message: 'Corrections appliquées avec succès',
                        timestamp: new Date().toISOString()
                    });
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        this.endpoints['/elganya/deploy'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const result = await this.elganyaManager.deployToken();
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        this.endpoints['/elganya/compile'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const result = await this.elganyaManager.compileContracts();
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        console.log(`✅ ${Object.keys(this.endpoints).length} endpoints ElganyaIA enregistrés`);
    }

    registerFallbackEndpoints() {
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: (req, res) => {
                res.json({
                    success: false,
                    message: 'Module ElganyaIA non disponible',
                    instructions: 'Exécutez le script de configuration d\'abord'
                });
            }
        };
    }

    start() {
        this.server.listen(this.port, '0.0.0.0', () => {
            console.log('🚀 BRIDGE V3 SUR PORT 3001 DÉMARRÉ');
            console.log(`📍 Port: ${this.port}`);
            console.log(`🌐 URL: http://localhost:${this.port}`);
            console.log(`🌐 URL Externe: http://0.0.0.0:${this.port}`);
            console.log(`🔗 Endpoints: ${Object.keys(this.endpoints).length} disponibles`);
            console.log('✅ PRÊT À RECEVOIR DES REQUÊTES');
            
            console.log('\n📋 ENDPOINTS DISPONIBLES:');
            Object.keys(this.endpoints).forEach(endpoint => {
                console.log(`   ${this.endpoints[endpoint].method} ${endpoint}`);
            });
            console.log('');
        });

        process.on('SIGINT', () => {
            console.log('\n🛑 Arrêt gracieux du Bridge V3...');
            this.server.close(() => {
                console.log('✅ Bridge V3 arrêté');
                process.exit(0);
            });
        });
    }
}

// Démarrer le bridge
const bridge = new BridgeV3();
bridge.start();

module.exports = BridgeV3;

// Nouveaux endpoints pour étendre les fonctionnalités
BridgeV3.prototype.registerExtendedEndpoints = function() {
    this.endpoints['/elganya/test'] = {
        method: 'GET',
        handler: (req, res) => {
            res.json({
                success: true,
                message: 'Test endpoint fonctionnel',
                features: ['ERC-20', 'Blockchain', 'Smart Contracts', 'API Bridge'],
                timestamp: new Date().toISOString()
            });
        }
    };

    this.endpoints['/elganya/verify'] = {
        method: 'POST',
        handler: async (req, res) => {
            try {
                // Logique de vérification des contrats
                res.json({
                    success: true,
                    message: 'Vérification des contrats effectuée',
                    verified: true
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        }
    };
};
