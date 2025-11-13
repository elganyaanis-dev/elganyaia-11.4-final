#!/usr/bin/env bash
# Helpers fréquents pour Kamina OS - ELGANYA
# Usage: source scripts/helpers.sh

# Affiche la variable RPC_URL (sécurisé)
kamina_env_show() {
  echo "CHAIN_NAME: ${CHAIN_NAME:-unset}"
  echo "RPC_URL: ${RPC_URL:-$(grep -E '^RPC_URL=' .env 2>/dev/null || true)}"
  echo "DEPLOYER_PK: $(if [ -n "${DEPLOYER_PK:-}" ]; then echo 'SET (hidden)'; else echo 'unset'; fi)"
}

# Lancer tests (placeholder)
kamina_run_tests() {
  echo "Lancer les tests (ajouter vos tests JS/TS/Foundry ici)"
  # npx hardhat test
}

# Générer un nouveau .env sécurisé (interactif)
kamina_env_init() {
  read -rp "Entrer RPC_URL : " _rpc
  read -rsp "Entrer DEPLOYER_PK (clé privée) : " _pk
  echo
  cat > .env << 'ENVEOF'
RPC_URL=${_rpc}
DEPLOYER_PK=${_pk}
CHAIN_NAME=${CHAIN_NAME:-goerli}
ENVEOF
  chmod 600 .env || true
  echo ".env mis à jour et protégé (chmod 600)"
}
