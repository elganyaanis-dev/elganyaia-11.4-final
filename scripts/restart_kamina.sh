#!/bin/bash
echo "🔷 REDÉMARRAGE KAMINA OS..."
cd $HOME/kamina-control
pkill -f node 2>/dev/null
sleep 2
node permanent_connection.js
