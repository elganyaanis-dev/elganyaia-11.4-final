#!/bin/bash
echo "🔍 DIAGNOSTIC COMPLET ELGANYA_IA - $(date)"
echo "=========================================="

# 1. VÉRIFICATION DES AUTORISATIONS TERMUX
echo ""
echo "1. 🔐 AUTORISATIONS TERMUX:"
termux-setup-storage
echo "✅ Autorisations stockage configurées"

# 2. VÉRIFICATION ARBORESCENCE COMPLÈTE
echo ""
echo "2. 📁 ARBORESCENCE PROJETS TERMUX:"
echo "=== HOME DIRECTORY ==="
ls -la ~/ | grep -E "ELGANYA|android|project" | head -10

echo ""
echo "=== ELGANYA_IA STRUCTURE ==="
find ~/ELGANYA_IA -type f -name "*.apk" 2>/dev/null
find ~/ELGANYA_IA -type d -name "APK*" -o -name "*CONSTR*" 2>/dev/null

echo ""
echo "=== STOCKAGE INTERNE ==="
ls -la /sdcard/Download/ | grep -i elganya

# 3. VÉRIFICATION CRÉATION APK RÉCENTE
echo ""
echo "3. 📱 RECHERCHE APK RÉCENTES:"
find ~ -name "*.apk" -type f -mtime -1 2>/dev/null
find /sdcard -name "*elganya*.apk" -type f 2>/dev/null 2>/dev/null

# 4. TEST D'ÉCRITURE STOCKAGE
echo ""
echo "4. 🧪 TEST D'ÉCRITURE STOCKAGE:"
TEST_FILE="/sdcard/Download/test_elganya_$(date +%s).txt"
echo "Test d'écriture Termux - $(date)" > $TEST_FILE

if [ -f "$TEST_FILE" ]; then
    echo "✅ Écriture stockage: FONCTIONNE"
    echo "📁 Fichier test: $TEST_FILE"
    rm $TEST_FILE
else
    echo "❌ Écriture stockage: ÉCHEC"
    echo "📌 Solution: Exécutez 'termux-setup-storage'"
fi

# 5. VÉRIFICATION OUTILS PACKAGING
echo ""
echo "5. 🛠️ OUTILS PACKAGING DISPONIBLES:"
tools=("zip" "unzip" "python" "java" "aapt" "dx")
for tool in "${tools[@]}"; do
    if command -v $tool &>/dev/null; then
        echo "✅ $tool: $(which $tool)"
    else
        echo "❌ $tool: MANQUANT"
    fi
done

# 6. ÉTAT DES PROCESSUS EN COURS
echo ""
echo "6. 🔄 PROCESSUS ELGANYA_IA ACTIFS:"
ps aux | grep -E "python|sh.*elganya|build.*apk" | grep -v grep

# 7. RAPPORT DE SITUATION
echo ""
echo "7. 📊 RAPPORT DE SITUATION:"
if find /sdcard/Download -name "*elganya*.apk" | grep -q .; then
    echo "🎯 STATUT: APK TROUVÉE DANS TÉLÉCHARGEMENTS"
    find /sdcard/Download -name "*elganya*.apk" | while read apk; do
        echo "   📱 $apk ($(du -h "$apk" | cut -f1))"
    done
else
    echo "🎯 STATUT: AUCUNE APK TROUVÉE"
    echo "💡 CAUSES POSSIBLES:"
    echo "   • Construction APK échouée"
    echo "   • Problème permissions stockage"
    echo "   • Fichier sous un autre nom"
fi
