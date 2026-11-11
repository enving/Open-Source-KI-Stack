#!/bin/bash
# Einmalig mit sudo ausführen:  sudo bash scripts/mac-open-terminal-installieren.sh <Pfad-zur-Schlüsseldatei>
# Legt Schlüssel und Startskript für kisandbox ab und richtet einen LaunchDaemon ein (Start beim Booten, KeepAlive).
set -eu
[ "$(id -u)" = 0 ] || { echo "Bitte mit sudo ausführen." >&2; exit 1; }
KEY_SRC=${1:?Pfad zur Schlüsseldatei angeben}
HERE=$(cd "$(dirname "$0")" && pwd)
install -d -o kisandbox -g staff -m 755 /Users/kisandbox/.config /Users/kisandbox/.local/libexec
install -o kisandbox -g staff -m 600 "$KEY_SRC" /Users/kisandbox/.config/open-terminal.key
install -o kisandbox -g staff -m 755 "$HERE/mac-open-terminal.sh" /Users/kisandbox/.local/libexec/mac-open-terminal.sh
cat > /Library/LaunchDaemons/de.ki-stack.mac-open-terminal.plist <<'PL'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>de.ki-stack.mac-open-terminal</string>
<key>UserName</key><string>kisandbox</string>
<key>ProgramArguments</key><array><string>/Users/kisandbox/.local/libexec/mac-open-terminal.sh</string></array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/><key>ThrottleInterval</key><integer>30</integer>
<key>StandardErrorPath</key><string>/Users/kisandbox/open-terminal.log</string>
<key>StandardOutPath</key><string>/Users/kisandbox/open-terminal.log</string>
</dict></plist>
PL
chown root:wheel /Library/LaunchDaemons/de.ki-stack.mac-open-terminal.plist; chmod 644 /Library/LaunchDaemons/de.ki-stack.mac-open-terminal.plist
launchctl bootout system/de.ki-stack.mac-open-terminal 2>/dev/null || true
launchctl bootstrap system /Library/LaunchDaemons/de.ki-stack.mac-open-terminal.plist
echo "Fertig. Prüfen: curl -s -o /dev/null -w '%{http_code}\n' http://100.84.208.8:8000/health  (401/200 = läuft)"
