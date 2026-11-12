#!/usr/bin/env bash
set -euo pipefail

# Trägt Composio als MCP-Werkzeugserver in OpenWebUI ein (docker-compose.erweitert.yml) und startet
# OpenWebUI neu, damit der OAuth-Client geladen wird. Idempotent; andere Werkzeugserver bleiben erhalten.
#
#   scripts/composio-mcp-einrichten.sh <Compose-env-Datei> <öffentliche OpenWebUI-URL> [Datei mit COMPOSIO_API_KEY]
#
# Die öffentliche URL ist die Adresse, unter der Mitarbeitende OpenWebUI öffnen (https://…). Composio leitet
# nach der Anmeldung dorthin zurück. COMPOSIO_API_KEY wird aus der dritten Datei gelesen (Standard: .env im Repo),
# sonst aus der Compose-env-Datei. Ohne Schlüssel entsteht nur die OAuth-Verbindung.
if [[ $# -lt 2 || $# -gt 3 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei> <öffentliche OpenWebUI-URL> [Datei mit COMPOSIO_API_KEY]" >&2
  exit 2
fi
if [[ "$2" != https://* ]]; then
  echo "Die öffentliche URL muss mit https:// beginnen (OAuth-Rückruf)." >&2
  exit 2
fi
command -v docker >/dev/null || { echo "docker fehlt" >&2; exit 1; }

cd "$(dirname "$0")/.."
schluesseldatei=${3:-.env}
lies_schluessel() { [[ -f "$1" ]] && sed -n 's/^COMPOSIO_API_KEY=//p' "$1" | tail -n 1 | tr -d '"'"'"' \r' || true; }
COMPOSIO_API_KEY=$(lies_schluessel "$schluesseldatei")
[[ -n "$COMPOSIO_API_KEY" ]] || COMPOSIO_API_KEY=$(lies_schluessel "$1")
OPENWEBUI_OEFFENTLICHE_URL=$2
export COMPOSIO_API_KEY OPENWEBUI_OEFFENTLICHE_URL

compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)
"${compose[@]}" exec -T -e COMPOSIO_API_KEY -e OPENWEBUI_OEFFENTLICHE_URL -w /app/backend openwebui \
  python3 - < scripts/composio-mcp-einrichten.py
"${compose[@]}" restart openwebui
echo "Fertig. In OpenWebUI: Chat → Werkzeuge → „Composio (eigenes Konto)“ verbinden."
