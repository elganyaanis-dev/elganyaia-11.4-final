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
