#!/usr/bin/env bash
# Surveillance simple des contrats et redeploy automatique (safe-mode)
# NE PAS utiliser en production sans protections supplémentaires.
# Usage: bash scripts/watch_and_deploy.sh [network]
set -euo pipefail

NETWORK=${1:-deploychain}
SLEEP=${WATCH_POLL_INTERVAL:-4}

# Charger .env si disponible
if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs) || true
fi

if [ -z "${RPC_URL:-}" ] || [ -z "${DEPLOYER_PK:-}" ]; then
  echo "ERREUR: configurez RPC_URL et DEPLOYER_PK dans .env avant d'utiliser le watcher."
  exit 1
fi

CHECKSUM_FILE=".contracts_checksum"
compute_checksum() {
  find contracts -type f -name "*.sol" -print0 | sort -z | xargs -0 sha256sum | sha256sum | awk '{print $1}'
}

prev_checksum=""
if [ -f "$CHECKSUM_FILE" ]; then
  prev_checksum=$(cat "$CHECKSUM_FILE")
fi

echo "Watcher démarré. Vérification toutes les $SLEEP secondes. Réseau: $NETWORK"
while true; do
  new_checksum=$(compute_checksum)
  if [ "$new_checksum" != "$prev_checksum" ]; then
    echo "Changement détecté dans contracts -> recompilation et déploiement..."
    bash scripts/deploy_kamina.sh "$NETWORK" || echo "Déploiement échoué — voir logs"
    echo "$new_checksum" > "$CHECKSUM_FILE"
    prev_checksum="$new_checksum"
  fi
  sleep "$SLEEP"
done
