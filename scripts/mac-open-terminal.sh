#!/bin/bash
# Startet Open Terminal als dedizierter Sandbox-Benutzer auf einer festen Adresse (z. B. Tailscale-Adresse des Macs).
# Wird vom LaunchDaemon aufgerufen, der als dieser Benutzer läuft (siehe mac-open-terminal-installieren.sh).
# Saubere Umgebung: eigener PATH ohne /opt/homebrew (kein fremdes Codex/Claude sichtbar), Schlüssel aus Datei
# ~/.config/open-terminal.key (Modus 600), nicht im Repo. Die Adresse kommt aus der Umgebung des Daemons.
set -eu
KEY_FILE="$HOME/.config/open-terminal.key"
HOST="${OPEN_TERMINAL_HOST:?OPEN_TERMINAL_HOST fehlt}"
[ -r "$KEY_FILE" ] || { echo "Schlüsseldatei fehlt: $KEY_FILE" >&2; exit 1; }
exec env -i HOME="$HOME" USER="$(id -un)" LANG=de_DE.UTF-8 \
  PATH="$HOME/.local/bin:$HOME/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin" \
  OPEN_TERMINAL_API_KEY="$(cat "$KEY_FILE")" \
  "$HOME/.local/bin/uvx" open-terminal run --isolated \
  --host "$HOST" --port 8000 --cwd "$HOME/sandbox"
