#!/bin/bash
# Richtet Colima als LaunchAgent ein, der nach hartem Absturz (verwaiste Disk-Sperre) selbst wieder startet.
# Der brew-Dienst gibt dort nach dem ersten Fehlschlag auf. Ohne Administratorrechte, alles im eigenen Home.
# Aufruf: scripts/colima-autostart-einrichten.sh     (Voraussetzung: Homebrew-Colima unter /opt/homebrew)
set -euo pipefail
COLIMA=/opt/homebrew/opt/colima/bin/colima
[ -x "$COLIMA" ] || { echo "Colima fehlt unter $COLIMA" >&2; exit 1; }
mkdir -p "$HOME/.local/bin" "$HOME/Library/LaunchAgents"
cat > "$HOME/.local/bin/colima-start-sicher" <<SH
#!/bin/bash
# Startet Colima; entfernt eine verwaiste Disk-Sperre nur, wenn keine VM läuft.
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:/usr/bin:/bin:/usr/sbin:/sbin
L="\$HOME/.colima/_lima/_disks/colima/in_use_by"
if [ -L "\$L" ] && ! pgrep -f "limactl hostagent" >/dev/null; then echo "\$(date) verwaiste Sperre entfernt"; rm -f "\$L"; fi
exec $COLIMA start -f
SH
chmod +x "$HOME/.local/bin/colima-start-sicher"
P="$HOME/Library/LaunchAgents/de.ki-stack.colima.plist"
cat > "$P" <<PL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>Label</key><string>de.ki-stack.colima</string>
<key>ProgramArguments</key><array><string>$HOME/.local/bin/colima-start-sicher</string></array>
<key>RunAtLoad</key><true/><key>KeepAlive</key><true/><key>ThrottleInterval</key><integer>30</integer>
<key>WorkingDirectory</key><string>$HOME</string>
<key>StandardErrorPath</key><string>/opt/homebrew/var/log/colima.log</string>
<key>StandardOutPath</key><string>/opt/homebrew/var/log/colima.log</string>
</dict></plist>
PL
plutil -lint "$P"
# Alten brew-Dienst ersetzen, falls vorhanden (brew services start colima würde ihn wieder anlegen).
[ -f "$HOME/Library/LaunchAgents/sh.brew.colima.plist" ] && { launchctl bootout "gui/$(id -u)/sh.brew.colima" 2>/dev/null || true; mv "$HOME/Library/LaunchAgents/sh.brew.colima.plist" "$HOME/Library/LaunchAgents/sh.brew.colima.plist.ersetzt"; }
launchctl bootout "gui/$(id -u)/de.ki-stack.colima" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$P"
echo "Fertig. Prüfen: colima status"
