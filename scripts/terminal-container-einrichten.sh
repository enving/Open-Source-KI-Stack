#!/usr/bin/env bash
# Richtet im Open-Terminal-Container (Volume für /home/user) Node, bpmn-cli und Codex ein.
# Nutzt die vorhandenen Skripte beispieldaten/installieren-node.sh und installieren-bpmn.sh (feste Versionen,
# Prüfsumme für Node) und ergänzt Codex. Ohne Administratorrechte; alles landet im Home des Containers.
# Aufruf: scripts/terminal-container-einrichten.sh <containername>
# Danach einmal anmelden (nicht im Skript, das Konto gehört der Person): docker exec -it <container> codex login --device-auth
set -euo pipefail
C="${1:?Containername angeben (docker ps)}"
CODEX_VERSION="0.167.1"   # fest; vor 1.0 können Nebenversionen Befehle ändern
HERE="$(cd "$(dirname "$0")/.." && pwd)"
docker exec "$C" true
docker exec -i "$C" bash -s -- < "$HERE/beispieldaten/installieren-node.sh"
docker exec -i "$C" bash -s -- < "$HERE/beispieldaten/installieren-bpmn.sh"
docker exec -e CODEX_VERSION="$CODEX_VERSION" "$C" bash -c 'export PATH="$HOME/.local/bin:$PATH"; npm install -g --prefix "$HOME/.local" "@openai/codex@$CODEX_VERSION"'
docker exec "$C" bash -c 'export PATH="$HOME/.local/bin:$PATH"; echo "node $(node -v), bpmn $(bpmn --version), $(codex --version)"'
