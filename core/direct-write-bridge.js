// 🌉 BRIDGE D'ÉCRITURE DIRECTE - SOCKET TCP PERMANENT
const net = require('net');
const { spawn, exec } = require('child_process');
const fs = require('fs');
const path = require('path');

class DirectWriteBridge {
    constructor() {
        this.port = 9192; // Port dédié écriture directe
        this.clients = new Map();
        this.commandBuffer = [];
        this.setupDirectories();
        this.startSocketServer();
        this.startCommandProcessor();
        console.log("🎯 BRIDGE ÉCRITURE DIRECTE - PORT " + this.port);
    }

    setupDirectories() {
        const dirs = ['system/direct-logs', 'system/command-queue'];
        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
        });
    }

    startSocketServer() {
        this.server = net.createServer((socket) => {
            const clientId = `${socket.remoteAddress}:${socket.remotePort}`;
            this.clients.set(clientId, socket);
            console.log(`🔗 CLIENT CONNECTÉ: ${clientId}`);

            // Envoyer un message de bienvenue
            this.sendToClient(socket, "🎯 CONNECTÉ AU BRIDGE D'ÉCRITURE DIRECTE");
            this.sendToClient(socket, "💬 Tapez 'help' pour les commandes disponibles");

            socket.on('data', (data) => {
                const message = data.toString().trim();
                console.log(`📨 REÇU: ${message}`);
                this.processClientMessage(socket, message);
            });

            socket.on('close', () => {
                console.log(`🔌 CLIENT DÉCONNECTÉ: ${clientId}`);
                this.clients.delete(clientId);
            });

            socket.on('error', (err) => {
                console.log(`❌ ERREUR CLIENT ${clientId}:`, err.message);
            });
        });

        this.server.listen(this.port, '0.0.0.0', () => {
            console.log(`🎯 SERVEUR SOCKET ACTIF - localhost:${this.port}`);
            console.log("💬 PRÊT POUR ÉCRITURE DIRECTE");
        });

        this.server.on('error', (err) => {
            console.error('❌ ERREUR SERVEUR:', err);
            setTimeout(() => this.startSocketServer(), 5000);
        });
    }

    processClientMessage(socket, message) {
        const logEntry = {
            timestamp: new Date().toISOString(),
            message: message,
            client: `${socket.remoteAddress}:${socket.remotePort}`
        };

        // Sauvegarder dans le log
        fs.appendFileSync(
            `system/direct-logs/commands-${new Date().toISOString().split('T')[0]}.log`,
            JSON.stringify(logEntry) + '\n'
        );

        // Traitement des commandes spéciales
        if (message.toLowerCase() === 'help') {
            this.showHelp(socket);
        } else if (message.toLowerCase() === 'status') {
            this.showStatus(socket);
        } else if (message.toLowerCase() === 'clients') {
            this.showClients(socket);
        } else if (message.startsWith('exec:')) {
            const command = message.substring(5);
            this.executeCommand(socket, command);
        } else {
            // Commande directe
            this.executeCommand(socket, message);
        }
    }

    executeCommand(socket, command) {
        this.sendToClient(socket, `🚀 EXÉCUTION: ${command}`);
        
        exec(command, { timeout: 30000 }, (error, stdout, stderr) => {
            const result = {
                command: command,
                timestamp: new Date().toISOString(),
                success: !error,
                output: stdout || stderr || '(aucune sortie)',
                error: error ? error.message : null
            };

            // Envoyer le résultat au client
            if (error) {
                this.sendToClient(socket, `❌ ERREUR: ${error.message}`);
                if (stderr) this.sendToClient(socket, `📛 STDERR: ${stderr}`);
            } else {
                this.sendToClient(socket, `✅ RÉSULTAT:`);
                const lines = result.output.split('\n');
                lines.forEach(line => {
                    if (line.trim()) this.sendToClient(socket, `   ${line}`);
                });
            }

            // Sauvegarder le résultat
            fs.appendFileSync(
                `system/direct-logs/results-${new Date().toISOString().split('T')[0]}.log`,
                JSON.stringify(result) + '\n'
            );
        });
    }

    sendToClient(socket, message) {
        try {
            socket.write(message + '\n');
        } catch (err) {
            console.log('❌ ERREUR ENVOI CLIENT:', err.message);
        }
    }

    showHelp(socket) {
        const help = [
            "🎯 AIDE - BRIDGE ÉCRITURE DIRECTE",
            "==================================",
            "help          - Afficher cette aide",
            "status        - Statut du système",
            "clients       - Clients connectés", 
            "exec:commande - Exécuter une commande",
            "",
            "📝 EXEMPLES:",
            "  ls -la",
            "  pwd",
            "  whoami",
            "  exec:echo 'test direct'",
            "  exec:ps aux | head -5"
        ];
        
        help.forEach(line => this.sendToClient(socket, line));
    }

    showStatus(socket) {
        const status = {
            port: this.port,
            clients: this.clients.size,
            uptime: process.uptime(),
            memory: Math.round(process.memoryUsage().rss / 1024 / 1024) + "MB",
            timestamp: new Date().toISOString()
        };

        this.sendToClient(socket, "📊 STATUT SYSTÈME:");
        Object.entries(status).forEach(([key, value]) => {
            this.sendToClient(socket, `  ${key}: ${value}`);
        });
    }

    showClients(socket) {
        this.sendToClient(socket, `🔗 CLIENTS CONNECTÉS: ${this.clients.size}`);
        this.clients.forEach((clientSocket, clientId) => {
            this.sendToClient(socket, `  - ${clientId}`);
        });
    }

    // Méthode pour écrire directement depuis l'exterieur
    broadcastCommand(command) {
        this.commandBuffer.push({
            command: command,
            timestamp: new Date().toISOString()
        });

        this.clients.forEach((socket, clientId) => {
            this.sendToClient(socket, `📨 COMMANDE AUTOMATIQUE: ${command}`);
            this.executeCommand(socket, command);
        });

        return `Command broadcast to ${this.clients.size} clients`;
    }

    startCommandProcessor() {
        // Traitement des commandes en file d'attente
        setInterval(() => {
            if (this.commandBuffer.length > 0) {
                const cmd = this.commandBuffer.shift();
                console.log(`🎯 TRAITEMENT COMMANDE: ${cmd.command}`);
                this.broadcastCommand(cmd.command);
            }
        }, 1000);
    }
}

// DÉMARRAGE IMMÉDIAT
console.log("🚀 LANCEMENT DU BRIDGE D'ÉCRITURE DIRECTE...");
new DirectWriteBridge();
