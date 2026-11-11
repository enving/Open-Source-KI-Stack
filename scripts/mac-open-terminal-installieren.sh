#!/bin/bash
# Einmalig mit sudo ausführen:
#   sudo bash scripts/mac-open-terminal-installieren.sh <sandbox-benutzer> <adresse> <schluesseldatei>
# Legt Schlüssel und Startskript im Home des Sandbox-Benutzers ab und richtet einen LaunchDaemon ein
# (Start beim Booten, KeepAlive). Voraussetzung: uv liegt in ~<benutzer>/.local/bin (siehe docs/installationen.md).
set -eu
[ "$(id -u)" = 0 ] || { echo "Bitte mit sudo ausführen." >&2; exit 1; }
U="${1:?Sandbox-Benutzer angeben}"; HOST="${2:?Adresse angeben}"; KEY_SRC="${3:?Pfad zur Schlüsseldatei angeben}"
H="$(dscl . -read "/Users/$U" NFSHomeDirectory | awk '{print $2}')"; [ -d "$H" ] || { echo "Home von $U nicht gefunden." >&2; exit 1; }
[ -x "$H/.local/bin/uvx" ] || { echo "uvx fehlt in $H/.local/bin" >&2; exit 1; }
HERE=$(cd "$(dirname "$0")" && pwd)
install -d -o "$U" -g staff -m 755 "$H/.config" "$H/.local/libexec" "$H/sandbox"
install -o "$U" -g staff -m 600 "$KEY_SRC" "$H/.config/open-terminal.key"
install -o "$U" -g staff -m 755 "$HERE/mac-open-terminal.sh" "$H/.local/libexec/mac-open-terminal.sh"
P=/Library/LaunchDaemons/de.ki-stack.mac-open-terminal.plist
cat > "$P" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>de.ki-stack.mac-open-terminal</string>
<key>UserName</key><string>$U</string>
<key>EnvironmentVariables</key><dict><key>HOME</key><string>$H</string><key>OPEN_TERMINAL_HOST</key><string>$HOST</string></dict>
<key>ProgramArguments</key><array><string>$H/.local/libexec/mac-open-terminal.sh</string></array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/><key>ThrottleInterval</key><integer>30</integer>
<key>StandardErrorPath</key><string>$H/open-terminal.log</string>
<key>StandardOutPath</key><string>$H/open-terminal.log</string>
</dict></plist>
PL
chown root:wheel "$P"; chmod 644 "$P"
launchctl bootout system/de.ki-stack.mac-open-terminal 2>/dev/null || true
launchctl bootstrap system "$P"
echo "Fertig. Prüfen: curl -s -o /dev/null -w '%{http_code}\n' http://$HOST:8000/health  (200 = läuft)"
