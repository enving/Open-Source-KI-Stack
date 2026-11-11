#!/usr/bin/env bash
# Installiert Node.js (LTS 24) in fester Version ohne Administratorrechte, wenn keine passende Version im PATH ist.
# Gebraucht für den bpmn-cli (Node 24 oder neuer). Läuft auch in einer bereinigten Dienstumgebung ohne Homebrew.
# Aufruf: ./installieren-node.sh [präfix]   (Standard: ~/.local; danach liegen node, npm, npx in <präfix>/bin)
# Die Prüfsumme wird gegen SHASUMS256.txt von nodejs.org geprüft (HTTPS); ohne passende Summe wird nichts entpackt.
set -euo pipefail
VERSION="v24.22.2"
PRAEFIX="${1:-$HOME/.local}"
case "$(uname -s)-$(uname -m)" in
  Darwin-arm64) PLATTFORM="darwin-arm64";; Darwin-x86_64) PLATTFORM="darwin-x64";;
  Linux-x86_64) PLATTFORM="linux-x64";; Linux-aarch64|Linux-arm64) PLATTFORM="linux-arm64";;
  *) echo "Plattform nicht vorgesehen: $(uname -s)-$(uname -m)" >&2; exit 1;;
esac
if [ -x "$PRAEFIX/bin/node" ] && [ "$("$PRAEFIX/bin/node" -v)" = "$VERSION" ]; then echo "Node $VERSION liegt schon in $PRAEFIX/bin."; exit 0; fi
DATEI="node-$VERSION-$PLATTFORM.tar.gz"; URL="https://nodejs.org/dist/$VERSION"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
curl -fsSL "$URL/$DATEI" -o "$TMP/$DATEI"
SOLL="$(curl -fsSL "$URL/SHASUMS256.txt" | awk -v f="$DATEI" '$2==f {print $1}')"
[ -n "$SOLL" ] || { echo "Keine Prüfsumme für $DATEI gefunden." >&2; exit 1; }
IST="$(shasum -a 256 "$TMP/$DATEI" | awk '{print $1}')"
[ "$SOLL" = "$IST" ] || { echo "Prüfsumme stimmt nicht ($IST statt $SOLL). Abbruch." >&2; exit 1; }
ZIEL="$PRAEFIX/opt/node-$VERSION"; rm -rf "$ZIEL"; mkdir -p "$ZIEL" "$PRAEFIX/bin"
tar -xzf "$TMP/$DATEI" -C "$ZIEL" --strip-components=1
for b in node npm npx; do ln -sf "$ZIEL/bin/$b" "$PRAEFIX/bin/$b"; done
echo "Node $("$PRAEFIX/bin/node" -v) installiert in $ZIEL. Pfad: export PATH=\"$PRAEFIX/bin:\$PATH\""
