#!/bin/bash
echo "🔍 Surveillance KAMINA OS Revolution..."
while true; do
  echo "$(date): Vérification du statut..."
  curl -s https://kamina-os-revolution.vercel.app/ > /dev/null && \
    echo "✅ Site en ligne" || echo "❌ Site hors ligne"
  
  # Vérification DeepBridge
  if [ -f "/sdcard/deepbridge/bridge_status.json" ]; then
    echo "🌐 DeepBridge actif"
  fi
  sleep 60
done
