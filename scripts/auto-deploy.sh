#!/bin/bash
echo "🚀 DÉPLOIEMENT AUTOMATIQUE KAMINA-OS QUANTUM"

# 1. Préparer le système
cd /data/data/com.termux/files/home/kamina-os

# 2. Créer les configurations cloud
node -e "
const fs = require('fs');
const configs = {
    'vercel.json': JSON.stringify({
        version: 2,
        builds: [{ src: 'src/core/universal-server.js', use: '@vercel/node' }],
        routes: [{ src: '/(.*)', dest: 'src/core/universal-server.js' }]
    }, null, 2),
    
    'netlify.toml': '
[build]
  command = \"npm install\"
  publish = \"public\"

[[redirects]]
  from = \"/*\"
  to = \"/index.html\"
  status = 200
'
};

Object.entries(configs).forEach(([file, content]) => {
    fs.writeFileSync(file, content);
});
console.log('✅ Configurations cloud créées');
"

# 3. Initialiser Git pour déploiement
git init
git add .
git commit -m "KAMINA-OS Quantum System" || true

# 4. Démarrer le serveur universel
node src/core/universal-server.js
