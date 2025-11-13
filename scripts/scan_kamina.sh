#!/bin/bash
PROJECT="$HOME/kamina-os"
echo "🔍 Scan rapide Kamina OS..."
find $PROJECT -name "*.ts" -o -name "*.sol" -o -name "package.json" | head -10
cd $PROJECT/kamina-contracts 2>/dev/null && echo "📜 Contrats:" && ls contracts/ 2>/dev/null
cd $PROJECT/kamina-mobile 2>/dev/null && echo "📱 Mobile:" && find src -name "*.ts" -o -name "*.tsx" | head -5
