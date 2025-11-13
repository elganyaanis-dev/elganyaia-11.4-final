#!/bin/bash
echo "🔍 DIAGNOSTIC SÉCURISÉ ELGANYA_IA"
echo "=== Étape 1: Vérification basique ==="

# Vérification sans commandes risquées
echo "📁 Home directory:"
ls ~/ | grep -E "ELGANYA|android" | head -5

echo ""
echo "📱 Recherche APK existantes:"
find /sdcard/Download -name "*.apk" 2>/dev/null | head -5
find ~ -name "*.apk" 2>/dev/null | head -5

echo ""
echo "🔧 Outils disponibles:"
which zip python ls find

echo ""
echo "📊 Espace disque:"
df -h /data /sdcard 2>/dev/null | head -3

echo "✅ Diagnostic basique terminé"
