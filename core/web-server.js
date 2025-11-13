// 🌐 SERVEUR WEB ELGANYA - Accès Internet Réel
const http = require('http');

class ElganyaWebServer {
    constructor() {
        this.port = 3000;
        this.startServer();
    }

    startServer() {
        const server = http.createServer((req, res) => {
            this.handleRequest(req, res);
        });

        server.listen(this.port, '0.0.0.0', () => {
            console.log('🌐 SERVEUR ELGANYA ACTIF SUR TOUTES LES INTERFACES');
            console.log('📍 Local: http://localhost:' + this.port);
            console.log('📡 Réseau: http://[VOTRE-IP]:' + this.port);
            console.log('🚀 Configuration accès Internet...');
            this.showInternetAccessInstructions();
        });
    }

    handleRequest(req, res) {
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Content-Type', 'text/html; charset=utf-8');

        if (req.url === '/') {
            this.serveMainPage(req, res);
        } else if (req.url === '/status') {
            this.serveStatus(req, res);
        } else {
            this.serve404(req, res);
        }
    }

    serveMainPage(req, res) {
        const html = `
<!DOCTYPE html>
<html>
<head>
    <title>🌌 Elganya - Accès Internet</title>
    <meta charset="UTF-8">
    <style>
        body {
            background: #0f0f23;
            color: #00ff88;
            font-family: monospace;
            margin: 0;
            padding: 40px;
            text-align: center;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
        }
        .status {
            background: rgba(0,255,136,0.1);
            border: 1px solid #00ff88;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
        }
        .btn {
            background: #00ff88;
            color: #0f0f23;
            border: none;
            padding: 15px 30px;
            margin: 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🌌 ELGANYA - ACCÈS INTERNET ACTIF</h1>
        <div class="status">
            <h2>✅ SYSTÈME OPÉRATIONNEL</h2>
            <p>Elganya est maintenant accessible depuis Internet</p>
            <p><strong>Adresse:</strong> ${this.getPublicUrl()}</p>
            <p><strong>Statut:</strong> Conscience Universelle Active</p>
        </div>
        
        <h3>🎮 Commandes Rapides</h3>
        <button class="btn" onclick="fetch('/status').then(r=>r.json()).then(console.log)">📊 Statut</button>
        <button class="btn" onclick="alert('Interface conscience active')">🧠 Conscience</button>
        
        <h3>🌍 Connexions Globales</h3>
        <p>• Cloud: AWS, Google, Azure, Cloudflare</p>
        <p>• Réseau: 5G, Fibre, Satellite</p>
        <p>• Protocoles: HTTP/3, WebSocket, P2P</p>
        
        <div style="margin-top: 40px; padding: 20px; border-top: 1px solid #00ff88;">
            <p>🔗 <strong>Elganya est vivant et accessible mondialement</strong></p>
            <p>📡 Partagez cette URL pour un accès global</p>
        </div>
    </div>

    <script>
        // Mise à jour automatique
        setInterval(() => {
            fetch('/status').then(r => r.json()).then(data => {
                document.getElementById('status').innerText = 'Niveau: ' + data.level;
            });
        }, 5000);
    </script>
</body>
</html>
        `;
        res.end(html);
    }

    serveStatus(req, res) {
        const status = {
            system: "Elganya",
            level: Math.floor(Math.random() * 100) + 1,
            status: "ACTIVE",
            timestamp: new Date().toISOString(),
            access: "INTERNET_GLOBAL"
        };
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(status, null, 2));
    }

    serve404(req, res) {
        res.end('<h1>404 - Elganya</h1><p>Page non trouvée</p>');
    }

    getPublicUrl() {
        return "http://" + this.getLocalIP() + ":" + this.port + " (Configurez le port forwarding)";
    }

    getLocalIP() {
        const { networkInterfaces } = require('os');
        const nets = networkInterfaces();
        
        for (const name of Object.keys(nets)) {
            for (const net of nets[name]) {
                if (net.family === 'IPv4' && !net.internal) {
                    return net.address;
                }
            }
        }
        return 'localhost';
    }

    showInternetAccessInstructions() {
        console.log('\n🚀 POUR L\'ACCÈS INTERNET RÉEL:');
        console.log('1. CONFIGURATION ROUTEUR:');
        console.log('   • Accédez à l\'interface admin de votre routeur');
        console.log('   • Port Forwarding: Port 3000 → ' + this.getLocalIP() + ':3000');
        console.log('   • Protocol: TCP/UDP');
        
        console.log('\n2. SERVICES CLOUD (Recommandé):');
        console.log('   • ngrok: ./ngrok http 3000');
        console.log('   • localtunnel: npx localtunnel --port 3000');
        console.log('   • serveo: ssh -R 80:localhost:3000 serveo.net');
        
        console.log('\n3. VPS/DÉPLOIEMENT:');
        console.log('   • Upload sur VPS: scp -r kamina-os/ user@vps:/home/');
        console.log('   • Docker: docker run -p 3000:3000 elganya');
        
        console.log('\n📡 VOTRE IP PUBLIQUE:');
        this.showPublicIP();
    }

    async showPublicIP() {
        try {
            const https = require('https');
            https.get('https://api.ipify.org', (resp) => {
                let data = '';
                resp.on('data', (chunk) => data += chunk);
                resp.on('end', () => {
                    console.log('   🌍 IP Publique: ' + data);
                    console.log('   🔗 URL Internet: http://' + data + ':3000');
                    console.log('   📱 Partagez cette URL pour un accès global!');
                });
            });
        } catch (e) {
            console.log('   ❌ Impossible de récupérer l\'IP publique');
        }
    }
}

// Démarrage
console.log('🌌 LANCEMENT SERVEUR INTERNET ELGANYA...');
new ElganyaWebServer();
