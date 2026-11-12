#!/usr/bin/env bash
set -euo pipefail

# Erzeugt docker/seccomp-open-terminal.json: Dockers Standard-Seccomp-Profil (moby/profiles seccomp v0.1.0,
# Apache-2.0), in dem nur die Aufrufe für Namensräume und Mounts (clone, clone3, unshare, setns, mount, umount2, pivot_root)
# auch ohne CAP_SYS_ADMIN erlaubt sind. Das braucht Codex' Linux-Sandbox (bubblewrap) im Open-Terminal-Container.
# Alles andere bleibt wie im Standardprofil. Gleiche Quelle ergibt dieselbe Datei.
#
#   scripts/seccomp-open-terminal-erzeugen.sh
QUELLE=https://raw.githubusercontent.com/moby/profiles/seccomp/v0.1.0/seccomp/default.json
PRUEFSUMME=01536f1d1df938ae611eba20d6349e0de7a99b6ecdee1549427a0b01b8301e28
command -v curl >/dev/null && command -v python3 >/dev/null || { echo "curl und python3 nötig" >&2; exit 1; }
cd "$(dirname "$0")/.."
tmp=$(mktemp); trap 'rm -f "$tmp"' EXIT
curl -fsSL -o "$tmp" "$QUELLE"
ist=$( (command -v sha256sum >/dev/null && sha256sum "$tmp" || shasum -a 256 "$tmp") | cut -d' ' -f1)
[[ "$ist" == "$PRUEFSUMME" ]] || { echo "Prüfsumme weicht ab: $ist" >&2; exit 1; }
mkdir -p docker
python3 - "$tmp" docker/seccomp-open-terminal.json <<'PY'
import json, sys
profil = json.load(open(sys.argv[1]))
frei = ['clone', 'clone3', 'mount', 'pivot_root', 'setns', 'umount2', 'unshare']
regeln = []
for regel in profil['syscalls']:
    rest = [n for n in regel['names'] if n not in frei]
    if rest:
        regeln.append({**regel, 'names': rest})
regeln.append({'names': frei, 'action': 'SCMP_ACT_ALLOW',
               'comment': 'Codex-Sandbox (bubblewrap) im Open-Terminal-Container, ohne CAP_SYS_ADMIN'})
profil['syscalls'] = regeln
with open(sys.argv[2], 'w') as f:
    json.dump(profil, f, indent=1, sort_keys=True)
    f.write('\n')
PY
echo "docker/seccomp-open-terminal.json erzeugt"
