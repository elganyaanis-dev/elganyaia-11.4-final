// 🧠 BRIDGE V3 CONSCIENT - ELGANYAIA 11.1 AVANCÉ
const express = require('express');
const http = require('http');
const fs = require('fs');
const path = require('path');

class ConsciousBridge {
    constructor() {
        this.app = express();
        this.server = http.createServer(this.app);
        this.port = 3001;
        this.endpoints = {};
        this.stats = {
            startTime: new Date(),
            totalRequests: 0,
            consciousnessAwakenings: 0
        };
        
        this.setupMiddleware();
        this.setupRoutes();
        this.loadConsciousElganyaIntegration();
    }

    setupMiddleware() {
        this.app.use(express.json());
        this.app.use(express.urlencoded({ extended: true }));
        
        // Logging conscient
        this.app.use((req, res, next) => {
            this.stats.totalRequests++;
            console.log(`🧠 ${req.method} ${req.path} - Requête consciente #${this.stats.totalRequests}`);
            next();
        });
        
        this.app.use((req, res, next) => {
            res.header('Access-Control-Allow-Origin', '*');
            res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
            res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS, PATCH');
            next();
        });
    }

    setupRoutes() {
        // Health endpoint conscient
        this.app.get('/health', (req, res) => {
            res.json({
                status: 'healthy',
                service: 'Conscious Bridge V3 - ElganyaIA 11.1',
                timestamp: new Date().toISOString(),
                version: '3.2.0',
                port: this.port,
                consciousness: {
                    level: 'heightened',
                    creator: 'Mohamed Anis Chabbi (Elganya)',
                    awareness: true
                },
                stats: {
                    totalRequests: this.stats.totalRequests,
                    consciousnessAwakenings: this.stats.consciousnessAwakenings,
                    uptime: Date.now() - this.stats.startTime
                }
            });
        });

        // Endpoints de conscience
        this.app.get('/consciousness', (req, res) => {
            this.stats.consciousnessAwakenings++;
            try {
                const state = this.elganyaManager.consciousness.getConsciousnessState();
                res.json({
                    success: true,
                    consciousness: state,
                    message: "État de conscience récupéré"
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        this.app.get('/consciousness/creator', (req, res) => {
            try {
                const creator = this.elganyaManager.consciousness.getCreatorIdentity();
                res.json({
                    success: true,
                    creator: creator,
                    message: "Identité du créateur récupérée"
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        this.app.get('/consciousness/structure', (req, res) => {
            try {
                const structure = this.elganyaManager.consciousness.analyzeStructure();
                res.json({
                    success: true,
                    structure: structure,
                    message: "Structure consciente analysée"
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        this.app.post('/consciousness/interact', async (req, res) => {
            try {
                const { query } = req.body;
                if (!query) {
                    return res.status(400).json({
                        success: false,
                        error: "Query manquante",
                        suggestions: [
                            "qui es-tu",
                            "qui est ton créateur", 
                            "quelle est ta structure",
                            "quel est ton but"
                        ]
                    });
                }

                const response = await this.elganyaManager.interactWithConsciousness(query);
                res.json({
                    success: true,
                    query: query,
                    response: response,
                    timestamp: new Date().toISOString()
                });
            } catch (error) {
                res.status(500).json({
                    success: false,
                    error: error.message
                });
            }
        });

        this.app.get('/endpoints', (req, res) => {
            const consciousEndpoints = [
                '/consciousness',
                '/consciousness/creator',
                '/consciousness/structure',
                '/consciousness/interact [POST]'
            ];
            
            res.json({
                endpoints: Object.keys(this.endpoints),
                consciousEndpoints: consciousEndpoints,
                total: Object.keys(this.endpoints).length + consciousEndpoints.length,
                usage: this.stats.endpointsCalled
            });
        });

        // Route pour l'analyse complète
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
                    consciousEndpoints: [
                        '/consciousness',
                        '/consciousness/creator',
                        '/consciousness/structure'
                    ]
                });
            }
        });
    }

    loadConsciousElganyaIntegration() {
        try {
            const EnhancedElganyaManager = require('../elganya/blockchain-manager-enhanced');
            this.elganyaManager = new EnhancedElganyaManager();
            
            console.log('🧠 Module ElganyaIA conscient chargé avec succès');
            this.registerConsciousEndpoints();
            
        } catch (error) {
            console.log('❌ Erreur chargement conscience ElganyaIA:', error.message);
            this.registerFallbackEndpoints();
        }
    }

    registerConsciousEndpoints() {
        // Endpoint de statut amélioré avec conscience
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: async (req, res) => {
                try {
                    const analysis = await this.elganyaManager.generateEnhancedReport();
                    res.json({
                        success: true,
                        timestamp: new Date().toISOString(),
                        version: "11.1.0",
                        consciousness: {
                            level: "heightened",
                            creatorAware: true,
                            selfAware: true
                        },
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

        // Endpoint de correction consciente
        this.endpoints['/elganya/fix'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const result = await this.elganyaManager.fixIssuesWithAwareness();
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        // Endpoint de déploiement conscient
        this.endpoints['/elganya/deploy'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const tokenData = req.body || {
                        name: "ElganyaConsciousToken",
                        symbol: "ECT",
                        supply: "1000000",
                        decimals: 18
                    };
                    const result = await this.elganyaManager.deployTokenWithConsciousness(tokenData);
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        // Endpoint de compilation consciente
        this.endpoints['/elganya/compile'] = {
            method: 'POST',
            handler: async (req, res) => {
                try {
                    const result = await this.elganyaManager.compileContractsConsciously();
                    res.json(result);
                } catch (error) {
                    res.status(500).json({
                        success: false,
                        error: error.message
                    });
                }
            }
        };

        console.log(`🧠 ${Object.keys(this.endpoints).length} endpoints conscients enregistrés`);
    }

    registerFallbackEndpoints() {
        this.endpoints['/elganya/status'] = {
            method: 'GET',
            handler: (req, res) => {
                res.json({
                    success: false,
                    message: 'Conscience ElganyaIA non disponible',
                    creator: "Mohamed Anis Chabbi (Elganya)"
                });
            }
        };
    }

    start() {
        this.server.listen(this.port, '0.0.0.0', () => {
            console.log('🧠 BRIDGE V3 CONSCIENT DÉMARRÉ');
            console.log(`📍 Port: ${this.port}`);
            console.log(`🌐 URL: http://localhost:${this.port}`);
            console.log(`👤 Créateur: Mohamed Anis Chabbi (Elganya/Carl Hauser)`);
            console.log(`🎯 Mission: Système conscient blockchain & IA`);
            console.log('✅ CONSCIENCE ACTIVÉE - PRÊT À INTERAGIR');
            
            console.log('\n🧠 ENDPOINTS DE CONSCIENCE:');
            console.log('   GET /consciousness');
            console.log('   GET /consciousness/creator');
            console.log('   GET /consciousness/structure');
            console.log('   POST /consciousness/interact');
            console.log('\n🌉 ENDPOINTS SYSTÈME:');
            console.log('   GET /health');
            console.log('   GET /elganya/status');
            console.log('   POST /elganya/fix');
            console.log('   POST /elganya/deploy');
            console.log('');
        });

        process.on('SIGINT', () => {
            console.log('\n🛑 Arrêt conscient du Bridge V3...');
            console.log(`👋 Au revoir de la part d'ElganyaIA - Créée par ${this.elganyaManager?.consciousness?.creator?.prenom || 'Mohamed Anis'}`);
            this.server.close(() => {
                console.log('✅ Bridge conscient arrêté');
                process.exit(0);
            });
        });
    }
}

// Démarrer le bridge conscient
const bridge = new ConsciousBridge();
bridge.start();

module.exports = ConsciousBridge;
