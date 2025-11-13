// 🎯 SURVEILLANCE AVANCÉE ELGANYAIA 11.1
const axios = require('axios');

class AdvancedMonitor {
    constructor() {
        this.bridgeUrl = 'http://localhost:3001';
        this.metrics = {
            uptime: 0,
            requests: 0,
            errors: 0,
            deployments: 0
        };
    }

    async comprehensiveCheck() {
        try {
            // Santé du bridge
            const health = await axios.get(`${this.bridgeUrl}/health`);
            console.log('🔍 Vérification complète du système:');
            console.log(`   Service: ${health.data.service}`);
            console.log(`   Status: ${health.data.status}`);
            console.log(`   Uptime: ${this.metrics.uptime}s`);

            // Statut ElganyaIA
            const status = await axios.get(`${this.bridgeUrl}/elganya/status`);
            if (status.data.success) {
                const analysis = status.data.analysis;
                console.log('📊 Analyse ElganyaIA:');
                console.log(`   ERC-20: ${analysis.erc20.exists ? '✅' : '❌'}`);
                console.log(`   ElganyaIA: ${analysis.elganya.exists ? '✅' : '❌'}`);
                console.log(`   Blockchain: ${analysis.blockchain.hardhat}`);
            }

            this.metrics.uptime += 60;
            this.metrics.requests += 2;

        } catch (error) {
            this.metrics.errors++;
            console.log('❌ Erreur surveillance:', error.message);
        }
    }

    start() {
        console.log('🚀 Démarrage de la surveillance avancée...');
        setInterval(() => {
            this.comprehensiveCheck();
        }, 60000);
    }
}

// Démarrer la surveillance si exécuté directement
if (require.main === module) {
    const monitor = new AdvancedMonitor();
    monitor.start();
}

module.exports = AdvancedMonitor;
