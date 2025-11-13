#!/bin/bash
echo "🔍 Surveillance Déploiement KAMINA OS Revolution..."

while true; do
    echo "=== $(date) ==="
    
    # Test du site Vercel
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://kamina-os-revolution.vercel.app/)
    if [ "$STATUS" = "200" ]; then
        echo "✅ SITE EN LIGNE (HTTP $STATUS)"
        
        # Mise à jour du statut DeepBridge
        echo '{"status": "online", "url": "https://kamina-os-revolution.vercel.app", "timestamp": '$(date +%s)'}' > /sdcard/deepbridge/to_deepseek/site_status.json
    else
        echo "❌ SITE HORS LIGNE (HTTP $STATUS)"
        echo '{"status": "offline", "error": "'$STATUS'", "timestamp": '$(date +%s)'}' > /sdcard/deepbridge/to_deepseek/site_status.json
    fi
    
    # Vérification DeepBridge
    if [ -f "/sdcard/deepbridge/from_deepseek/latest_message.json" ]; then
        echo "📨 Message reçu via DeepBridge:"
        cat /sdcard/deepbridge/from_deepseek/latest_message.json
    fi
    
    sleep 30
done
