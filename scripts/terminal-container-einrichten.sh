#!/usr/bin/env bash
# Richtet im Open-Terminal-Container (Volume terminal-home, /home/user) Node, bpmn-cli und Codex ein.
# Läuft auf dem Mac, ruft docker exec auf; ohne Administratorrechte, alles landet im Volume.
# Aufruf: scripts/terminal-container-einrichten.sh [containername]
# Danach einmal anmelden (nicht im Skript, Konto ist Tristans): docker exec -it <container> codex login --device-auth
set -euo pipefail
C="${1:-kobe-erweitert-open-terminal-1}"
NODE_VERSION="v24.22.2"   # bpmn-cli braucht Node >= 24
CODEX_VERSION="0.167.1"   # fest, Befehle ändern sich vor 1.0
HERE="$(cd "$(dirname "$0")/.." && pwd)"
docker exec "$C" true
docker exec -e NODE_VERSION="$NODE_VERSION" -e CODEX_VERSION="$CODEX_VERSION" "$C" bash -s <<'IN'
set -euo pipefail
P=$HOME/.local; mkdir -p "$P/bin" "$P/opt"
if ! "$P/bin/node" --version 2>/dev/null | grep -q "^$NODE_VERSION$"; then
  case "$(uname -m)" in aarch64|arm64) A=arm64;; x86_64) A=x64;; esac
  curl -fsSL "https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-$A.tar.xz" | tar -xJ -C "$P/opt"
  mv "$P/opt/node-$NODE_VERSION-linux-$A" "$P/opt/node-$NODE_VERSION"
  for b in node npm npx; do ln -sf "$P/opt/node-$NODE_VERSION/bin/$b" "$P/bin/$b"; done
fi
export PATH="$P/bin:$PATH"
npm install -g --prefix "$P" "@openai/codex@$CODEX_VERSION"
IN
docker exec -i "$C" bash -s < "$HERE/beispieldaten/installieren-bpmn.sh"
docker exec "$C" sh -c 'echo "node $(node -v), bpmn $(bpmn --version), $(codex --version)"'
