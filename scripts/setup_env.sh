#!/bin/bash
echo "🔧 CONFIGURATION INTERACTIVE .env"
echo "================================"

read -p "🌐 Entrez RPC_URL (ou 'local' pour réseau local): " rpc_url

if [ "$rpc_url" = "local" ]; then
    rpc_url="http://localhost:8545"
    deployer_pk="0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80"
    chain_name="localhost"
else
    read -sp "🔑 Entrez DEPLOYER_PK (clé privée): " deployer_pk
    echo
    read -p "📝 Entrez CHAIN_NAME (sepolia/goerli/mainnet): " chain_name
fi

cat > .env << ENVEOF
RPC_URL=$rpc_url
DEPLOYER_PK=$deployer_pk
CHAIN_NAME=$chain_name
ENVEOF

chmod 600 .env
echo "✅ .env configuré avec succès!"
echo "📁 Fichier: $PWD/.env"
