#!/usr/bin/env bash
# Installiert den bpmn-cli (github.com/Miragon/bpmn-cli, MIT) mit festgelegter Version ohne Administratorrechte.
# Vor 1.0 kann eine Nebenversion Befehle ändern; deshalb ist die Version fest. Anheben: bewusst, nach Test von prozesse.sh.
# Aufruf: ./installieren-bpmn.sh [präfix]   (Standard: ~/.local, danach liegt `bpmn` in <präfix>/bin)
set -euo pipefail
VERSION="0.10.0"
PRAEFIX="${1:-$HOME/.local}"
command -v node >/dev/null || { echo "Node.js fehlt (Version 24 oder neuer nötig)." >&2; exit 1; }
[ "$(node -p 'process.versions.node.split(".")[0]')" -ge 24 ] || { echo "Node.js $(node -v) ist zu alt, nötig: 24 oder neuer." >&2; exit 1; }
npm install -g --prefix "$PRAEFIX" "@miragon/bpmn-cli@$VERSION"
echo "Installiert: $("$PRAEFIX/bin/bpmn" --version). Pfad ergänzen: export PATH=\"$PRAEFIX/bin:\$PATH\""
