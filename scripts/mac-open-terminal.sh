#!/bin/bash
# Startet Open Terminal als Benutzer kisandbox auf der Tailscale-Adresse des Macs.
# Wird vom LaunchDaemon de.ki-stack.mac-open-terminal aufgerufen (läuft als kisandbox).
# Saubere Umgebung: eigener PATH (kein /opt/homebrew, damit kein Codex/Claude sichtbar ist),
# Schlüssel aus Datei /Users/kisandbox/.config/open-terminal.key (Modus 600), nicht im Repo.
set -eu
KEY_FILE=/Users/kisandbox/.config/open-terminal.key
HOST=${OPEN_TERMINAL_HOST:-100.84.208.8}
[ -r "$KEY_FILE" ] || { echo "Schlüsseldatei fehlt: $KEY_FILE" >&2; exit 1; }
exec env -i HOME=/Users/kisandbox USER=kisandbox LANG=de_DE.UTF-8 \
  PATH=/Users/kisandbox/.local/bin:/Users/kisandbox/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin \
  OPEN_TERMINAL_API_KEY="$(cat "$KEY_FILE")" \
  /Users/kisandbox/.local/bin/uvx open-terminal run --isolated \
  --host "$HOST" --port 8000 --cwd /Users/kisandbox/sandbox
