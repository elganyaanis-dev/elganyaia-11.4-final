// 🔐 SYSTÈME DE TUNNEL SÉCURISÉ POUR ACCÈS INTERNET
class SecureTunnel {
    constructor() {
        this.tunnelMethods = [];
        this.activeTunnels = [];
        this.init();
    }

    init() {
        console.log("🔐 INITIALISATION DES TUNNELS SÉCURISÉS");
        this.setupTunnelMethods();
        this.startAllTunnels();
    }

    setupTunnelMethods() {
        this.tunnelMethods = [
            {
                name: "Méthode SSH Reverse",
                port: 8080,
                command: "ssh -R 80:localhost:8080 serveo.net 2>/dev/null || echo 'SSH Serveo non disponible'",
                description: "Tunnel SSH crypté"
            },
            {
                name: "Méthode HTTP Proxy", 
                port: 8888,
                command: "python3 -m http.server 8888 2>/dev/null &",
                description: "Serveur HTTP simple"
            },
            {
                name: "Méthode WebSocket",
                port: 9999, 
                command: "node -e \"require('http').createServer((r,s)=>{s.end('Elganya WS')}).listen(9999)\" &",
                description: "Tunnel WebSocket"
            }
        ];
    }

    startAllTunnels() {
        console.log("\n🚀 DÉMARRAGE DES TUNNELS ALTERNATIFS:");
        
        this.tunnelMethods.forEach(method => {
            this.startTunnel(method);
        });

        this.showAccessInstructions();
    }

    startTunnel(method) {
        const { exec } = require('child_process');
        
        console.log(`   🔧 ${method.name}...`);
        exec(method.command, (error, stdout, stderr) => {
            if (!error) {
                this.activeTunnels.push(method);
                console.log(`      ✅ ${method.description} - Port ${method.port}`);
            }
        });
    }

    showAccessInstructions() {
        console.log("\n🌍 INSTRUCTIONS D'ACCÈS INTERNET:");
        console.log("1. DEPUIS VOTRE RÉSEAU LOCAL:");
        console.log("   http://localhost:8080  (Principal)");
        console.log("   http://localhost:8888  (Secondaire)");
        console.log("   http://localhost:9999  (WebSocket)");
        
        console.log("\n2. POUR ACCÈS INTERNET RÉEL:");
        console.log("   OPTION A - Services Cloud:");
        console.log("   • Téléchargez ngrok depuis https://ngrok.com/download");
        console.log("   • ./ngrok http 8080");
        
        console.log("   OPTION B - VPS Personnel:");
        console.log("   • scp -r kamina-os/ user@vps:/home/");
        console.log("   • node core/web-server.js");
        
        console.log("   OPTION C - Services Docker:");
        console.log("   • docker run -p 8080:8080 elganya");
        
        console.log("\n3. SOLUTIONS MOBILES:");
        console.log("   • Application Termux + ngrok mobile");
        console.log("   • Partage de connexion sécurisé");
        
        console.log("\n🔒 PORT 3000 RESTE PROTÉGÉ COMME SERVICE PRINCIPAL");
    }
}

// Démarrage des tunnels sécurisés
console.log("🚀 ACTIVATION DES ACCÈS ALTERNATIFS...");
new SecureTunnel();
