#!/bin/bash
echo "🔤 ENCODEUR URL POUR BRIDGE V3"

if [ -z "$1" ]; then
    echo "Usage: ./encoded-command.sh \"ma commande avec émojis 🎯\""
    exit 1
fi

# Encoder la commande
ENCODED_CMD=$(echo -n "$1" | jq -sRr @uri)

echo "🔗 URL encodée:"
echo "http://localhost:9191/execute?cmd=$ENCODED_CMD"

echo ""
echo "📡 Exécution:"
curl -s "http://localhost:9191/execute?cmd=$ENCODED_CMD" | jq .
