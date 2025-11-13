// 🚀 BRIDGE V3 AMÉLIORÉ - ELGANYAIA 11.1
const express = require('express');
const http = require('http');
const fs = require('fs');
const path = require('path');

class EnhancedBridge {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app);
        this.port = 3001;
        this.endpoints = {};
        this.stats = {
            startTime: new Date(),
            totalRequests: 0,
            endpointsCalled: {}
        };
        
        this.setupMiddleware();
        this.setupRoutes();
        this.loadElganyaIntegration();
    }

    setupMiddleware() {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));
        
        // Logging des requêtes
        this.app.use((req, res, next) => {
            this.stats.totalRequests++;
            const endpoint = req.path;
            this.stats.endpointsCalled[endpoint] = (this.stats.endpointsCalled[endpoint] || 0) + 1;
            
            console.log(`📨 ${req.method} ${endpoint} - Total: ${this.stats.totalRequests}`);
            next();
        });
        
        // CORS
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
            res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH');
            next();
        });
    }

    setupRoutes() {
        // Health endpoint amélioré
        this.app.get('/health', (req, res) => {
            res.json({
                status: 'healthy',
                service: 'Enhanced Bridge V3 - ElganyaIA 11.1',
                timestamp: new Date().toISOString(),
                version: '3.1.0',
                port: this.port,
                uptime: process.uptime(),
                memory: process.memoryUsage(),
                stats: {
                    totalRequests: this.stats.totalRequests,
                    uptime: Date.now() - this.stats.startTime
                }
            });
        });

        // Endpoints étendus
        this.app.get('/endpoints', (req, res) => {
            res.json({
                endpoints: Object.keys(this.endpoints),
                total: Object.keys(this.endpoints).length,
                usage: this.stats.endpointsCalled
            });
        });

        // Stats détaillées
        this.app.get('/stats', (req, res) => {
            res.json({
                system: {
                    nodeVersion: process.version,
                    platform: process.platform,
                    arch: process.arch,
                    uptime: process.uptime()
                },
                bridge: {
                    startTime: this.stats.startTime,
                    totalRequests: this.stats.totalRequests,
                    endpoints: Object.keys(this.endpoints).length
                },
                memory: process.memoryUsage()
            });
        });

        // Route catch-all pour les endpoints dynamiques
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
                    available: Object.keys(this.endpoints),
                    suggestion: 'Check /endpoints for available routes'
                });
            }
        });
    }

    loadElganyaIntegration() {
        try {
            // Chargement du module ElganyaIA 11.1
            const ElganyaBlockchainManager = require('../elganya/blockchain-manager');
            this.elganyaManager = new ElganyaBlockchainManager();
            
            console.log('✅ Module ElganyaIA 11.1 chargé avec succès');
            this.registerElganyaEndpoints();
            
        } catch (error) {
            console.log('❌ Erreur chargement ElganyaIA:', error.message);
            this.registerFallbackEndpoints();
        }
    }

    registerElganyaEndpoints() {
        // Endpoint de statut amélioré
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: async (req, res) => {
                try {
                    const analysis = await this.elganyaManager.generateReport();
                    res.json({
                        success: true,
                        timestamp: new Date().toISOString(),
                        version: "11.1.0",
                        analysis: analysis,
                        system: {
                            bridge: "Enhanced V3",
                            status: "operational"
                        }
                    });
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        // Endpoint de correction
        this.endpoints['/elganya/fix'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const result = await this.elganyaManager.fixIssues();
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        // Endpoint de déploiement
        this.endpoints['/elganya/deploy'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const tokenData = req.body || {
                        name: "ElganyaToken",
                        symbol: "ELG",
                        supply: "1000000",
                        decimals: 18
                    };
                    const result = await this.elganyaManager.deployToken(tokenData);
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        // Endpoint de compilation
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

        // Nouveaux endpoints
        this.endpoints['/elganya/version'] = {
            method: 'GET',
            handler: (req, res) => {
                res.json({
                    elganya: "11.1.0",
                    bridge: "3.1.0",
                    node: process.version,
                    timestamp: new Date().toISOString()
                });
            }
        };

        console.log(`✅ ${Object.keys(this.endpoints).length} endpoints ElganyaIA 11.1 enregistrés`);
    }

    registerFallbackEndpoints() {
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: (req, res) => {
                res.json({
                    success: false,
                    message: 'Module ElganyaIA non disponible',
                    instructions: 'Vérifiez la configuration du système'
                });
            }
        };
    }

    start() {
        this.server.listen(this.port, '0.0.0.0', () => {
            console.log('🚀 BRIDGE V3 AMÉLIORÉ DÉMARRÉ');
            console.log(`📍 Port: ${this.port}`);
            console.log(`🌐 URL: http://localhost:${this.port}`);
            console.log(`🔗 Endpoints: ${Object.keys(this.endpoints).length} disponibles`);
            console.log('✅ PRÊT À RECEVOIR DES REQUÊTES');
            
            console.log('\n📋 ENDPOINTS DISPONIBLES:');
            Object.keys(this.endpoints).forEach(endpoint => {
                console.log(`   ${this.endpoints[endpoint].method} ${endpoint}`);
            });
            console.log('\n🎯 ENDPOINTS SYSTÈME:');
            console.log('   GET /health');
            console.log('   GET /endpoints');
            console.log('   GET /stats');
            console.log('   GET /elganya/version');
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
const bridge = new EnhancedBridge();
bridge.start();

module.exports = EnhancedBridge;
