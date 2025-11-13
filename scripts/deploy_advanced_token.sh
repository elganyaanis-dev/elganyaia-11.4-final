#!/bin/bash
echo "🚀 DÉPLOIEMENT KAMINA TOKEN AVANCÉ - $(date)" > $HOME/deploy_advanced.log

# Charger l'environnement
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs) || true
fi

# Vérifications de sécurité
if [ -z "${RPC_URL:-}" ] || [ -z "${DEPLOYER_PK:-}" ]; then
    echo "❌ ERREUR: RPC_URL et DEPLOYER_PK requis dans .env" | tee -a $HOME/deploy_advanced.log
    exit 1
fi

# Script Hardhat pour déploiement
cat > scripts/deploy_advanced.js << 'JS'
const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("🔷 Déploiement par:", deployer.address);
  
  // Paramètres: cap = 10M, supply initial = 1M
  const CAP = 10000000;
  const INITIAL_SUPPLY = 1000000;
  
  console.log("📦 Déploiement KaminaTokenAdvanced...");
  const Token = await hre.ethers.getContractFactory("KaminaTokenAdvanced");
  const token = await Token.deploy(CAP, INITIAL_SUPPLY);
  
  await token.waitForDeployment();
  const address = await token.getAddress();
  
  console.log("✅ Contrat déployé à:", address);
  console.log("🎯 Cap:", CAP, "KAMINA-A");
  console.log("💰 Supply initial:", INITIAL_SUPPLY, "KAMINA-A");
  console.log("👑 Owner:", deployer.address);
  
  // Vérifications
  const cap = await token.getCap();
  console.log("🔍 Cap vérifié:", cap.toString());
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
JS

echo "🔨 Compilation et déploiement..." | tee -a $HOME/deploy_advanced.log
npx hardhat compile >> $HOME/deploy_advanced.log 2>&1
npx hardhat run scripts/deploy_advanced.js --network deploychain >> $HOME/deploy_advanced.log 2>&1

echo "🎯 DÉPLOIEMENT TERMINÉ - Voir logs: $HOME/deploy_advanced.log" | tee -a $HOME/deploy_advanced.log
