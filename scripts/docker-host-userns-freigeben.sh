#!/usr/bin/env bash
set -euo pipefail

# Ubuntu ab 23.10 (auch die Colima-VM) sperrt Benutzer-Namensräume für Programme ohne eigenes AppArmor-Profil
# (kernel.apparmor_restrict_unprivileged_userns=1). Codex' Sandbox im Open-Terminal-Container scheitert daran mit
# „loopback: Failed RTM_NEWADDR“. Dieses Skript setzt den Schalter auf 0, sofort und dauerhaft.
# Der Schalter gilt für den ganzen Docker-Host. Auf einem gemeinsam genutzten Server vorher abwägen.
#
#   scripts/docker-host-userns-freigeben.sh            Colima (Profil default) oder lokaler Linux-Host
#   scripts/docker-host-userns-freigeben.sh <Profil>   anderes Colima-Profil
SCHALTER=kernel.apparmor_restrict_unprivileged_userns
ZEILE="$SCHALTER=0"

if command -v colima >/dev/null 2>&1 && colima status ${1:+--profile "$1"} >/dev/null 2>&1; then
  profil=${1:-default}
  konfig="${COLIMA_HOME:-$HOME/.colima}/$profil/colima.yaml"
  [[ -f "$konfig" ]] || { echo "Colima-Konfiguration fehlt: $konfig" >&2; exit 1; }
  colima ssh --profile "$profil" -- sh -c "[ -e /proc/sys/${SCHALTER//.//} ] && sudo sysctl -w $ZEILE || echo 'Schalter gibt es hier nicht, nichts zu tun'"
  if grep -q "$SCHALTER" "$konfig"; then
    echo "Provisionierung in $konfig bereits vorhanden"
  elif grep -q '^provision: \[\]$' "$konfig"; then
    cp "$konfig" "$konfig.vor-userns.bak"
    python3 - "$konfig" "$SCHALTER" <<'PY'
import sys
pfad, schalter = sys.argv[1], sys.argv[2]
text = open(pfad).read()
block = ("provision:\n"
         "  - mode: system\n"
         f"    script: \"[ -e /proc/sys/{schalter.replace('.', '/')} ] && sysctl -w {schalter}=0 || true\"\n")
open(pfad, 'w').write(text.replace('provision: []\n', block, 1))
PY
    echo "Provisionierung eingetragen in $konfig (Sicherung: $konfig.vor-userns.bak)"
  else
    echo "In $konfig steht schon eine Provisionierung. Diesen Eintrag von Hand ergänzen:" >&2
    echo "  - mode: system" >&2
    echo "    script: sysctl -w $ZEILE" >&2
    exit 1
  fi
elif [[ "$(uname -s)" == Linux ]]; then
  if [[ ! -e /proc/sys/${SCHALTER//.//} ]]; then
    echo "Schalter gibt es auf diesem Kernel nicht, nichts zu tun"
    exit 0
  fi
  sudo sysctl -w "$ZEILE"
  echo "$ZEILE" | sudo tee /etc/sysctl.d/60-open-terminal-userns.conf >/dev/null
  echo "Dauerhaft in /etc/sysctl.d/60-open-terminal-userns.conf"
else
  echo "Weder laufendes Colima noch Linux gefunden. Den Schalter auf dem Docker-Host setzen: sysctl -w $ZEILE" >&2
  exit 1
fi
