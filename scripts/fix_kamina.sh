#!/bin/bash
echo "🔧 DIAGNOSTIC ET RÉPARATION KAMINA OS..."
echo ""

# 1. Vérifier Node.js
echo "1. 🔍 Vérification Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js non installé"
    echo "📥 Installation..."
    pkg install nodejs -y
else
    echo "✅ Node.js: $(node --version)"
fi

# 2. Vérifier les fichiers
echo ""
echo "2. 📁 Vérification fichiers..."
if [ ! -d "kamina-control" ]; then
    echo "❌ Dossier kamina-control manquant"
    echo "📥 Création..."
    mkdir -p kamina-control
fi

cd kamina-control

if [ ! -f "keyboard_interface.js" ]; then
    echo "❌ Fichier keyboard_interface.js manquant"
    echo "📥 Recréation..."
    cat > keyboard_interface.js << 'JS'
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = 2929;
const CHAT_FILE = path.join(__dirname, 'memory', 'chat.json');

// Créer dossier memory
if (!fs.existsSync(path.join(__dirname, 'memory'))) {
    fs.mkdirSync(path.join(__dirname, 'memory'), { recursive: true });
}

const server = http.createServer((req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
    res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.writeHead(200);
        res.end();
        return;
    }

    if (req.url === '/chat/send' && req.method === 'POST') {
        let body = '';
        req.on('data', chunk => body += chunk);
        req.on('end', () => {
            try {
                const { message } = JSON.parse(body);
                const response = `🔷 Kamina OS - Message reçu: "${message}"\n👑 CHABBI MOHAMMED ANIS\n🎯 Système opérationnel`;
                
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true, response: response }));
            } catch (e) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: e.message }));
            }
        });
        return;
    }

    // PAGE D'ACCUEIL SIMPLE
    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.end(`
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🔷 Kamina OS</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #1a1a1a;
            color: white;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        .container {
            max-width: 600px;
            margin: 50px auto;
            background: #2d2d2d;
            padding: 30px;
            border-radius: 15px;
            border: 2px solid #3b82f6;
        }
        .status {
            background: #10b981;
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .keyboard {
            background: #374151;
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }
        .key {
            background: #6b7280;
            color: white;
            border: none;
            padding: 15px;
            margin: 5px;
            border-radius: 8px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔷 KAMINA OS</h1>
        <div class="status">✅ SYSTÈME ACTIF - PORT 2929</div>
        <p>👑 Propriétaire: CHABBI MOHAMMED ANIS</p>
        <p>🎯 Interface: Clavier Virtuel</p>
        
        <div class="keyboard">
            <h3>⌨️ Clavier Virtuel</h3>
            <button class="key" onclick="alert('🔷 Kamina OS Fonctionne!')">Test</button>
            <button class="key" onclick="sendMessage('Bonjour')">Bonjour</button>
            <button class="key" onclick="sendMessage('Kamina OS')">Kamina</button>
        </div>
        
        <div id="result" style="margin-top: 20px; padding: 15px; background: #1f2937; border-radius: 8px;"></div>
    </div>

    <script>
        async function sendMessage(msg) {
            try {
                const response = await fetch('/chat/send', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ message: msg })
                });
                const data = await response.json();
                document.getElementById('result').innerHTML = data.response.replace(/\n/g, '<br>');
            } catch (error) {
                document.getElementById('result').innerHTML = '❌ Erreur connexion';
            }
        }
    </script>
</body>
</html>
    `);
});

server.listen(PORT, '0.0.0.0', () => {
    console.log(`🔷 KAMINA OS DÉMARRÉ: http://localhost:${PORT}`);
});

server.on('error', (err) => {
    console.log('❌ Erreur:', err.message);
});
JS
    echo "✅ Fichier créé"
else
    echo "✅ Fichier keyboard_interface.js présent"
fi

# 3. Arrêter les processus existants
echo ""
echo "3. 🛑 Nettoyage processus..."
pkill -f "node.*2929" 2>/dev/null
pkill -f "keyboard_interface" 2>/dev/null
sleep 2

# 4. Démarrer le serveur
echo ""
echo "4. 🚀 Démarrage serveur..."
node keyboard_interface.js &

# 5. Attendre et tester
echo ""
echo "5. 🧪 Test de connexion..."
for i in {1..10}; do
    if curl -s http://localhost:2929 > /dev/null 2>&1; then
        echo ""
        echo "✅ ✅ ✅ SUCCÈS ! ✅ ✅ ✅"
        echo "🌐 KAMINA OS EST MAINTENANT ACCESSIBLE:"
        echo "   http://localhost:2929"
        echo ""
        echo "🎯 Ouvrez Chrome et tapez cette URL"
        echo "👑 CHABBI MOHAMMED ANIS"
        exit 0
    fi
    echo "⏳ Tentative $i/10..."
    sleep 3
done

echo ""
echo "❌ ❌ ❌ ÉCHEC ❌ ❌ ❌"
echo "Le serveur n'a pas pu démarrer"
echo ""
echo "🔧 Démarrage manuel:"
echo "cd kamina-control"
echo "node keyboard_interface.js"
