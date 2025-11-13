#!/usr/bin/env bash
# Script de déploiement pour KaminaCore via Hardhat
# Usage : source .env && bash scripts/deploy_kamina.sh [network]
# Exemple: bash scripts/deploy_kamina.sh deploychain
set -euo pipefail

# Chargement .env si présent
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs) || true
fi

NETWORK=${1:-deploychain}  # réseau par défaut
echo "Déploiement KaminaCore sur réseau : $NETWORK"

# Vérifications
if [ -z "${RPC_URL:-}" ] || [ -z "${DEPLOYER_PK:-}" ]; then
  echo "ERREUR: RPC_URL et DEPLOYER_PK doivent être définis dans .env ou environnement."
  echo "Copiez .env.example -> .env et remplissez les variables."
  exit 1
fi

# Lancer compilation & déploiement via hardhat script inline
cat > scripts/hh_deploy.js <<'NODE'
const hre = require("hardhat");

async function main() {
  const Kamina = await hre.ethers.getContractFactory("KaminaCore");
  const kamina = await Kamina.deploy();
  await kamina.deployed();
  console.log("KaminaCore deployed to:", kamina.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
NODE

echo "Compilation..."
npx hardhat compile

echo "Execution du deploy script..."
npx hardhat run scripts/hh_deploy.js --network "$NETWORK"
