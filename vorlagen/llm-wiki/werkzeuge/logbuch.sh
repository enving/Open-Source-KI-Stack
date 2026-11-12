#!/bin/sh
# Eine Zeile ins Logbuch des Monats: werkzeuge/logbuch.sh <skill> <auslöser> <ergebnis> [offene Punkte]
# Ohne Kundendaten und Namen; Rollen statt Personen.
set -eu
[ $# -ge 3 ] || { echo "Aufruf: $0 <skill> <auslöser> <ergebnis> [offene Punkte]" >&2; exit 2; }
. "$(dirname "$0")/gemeinsam.sh"
mkdir -p logbuch; datei="logbuch/$(date +%Y-%m).md"
[ -f "$datei" ] || printf -- '---\ntype: Logbook\ntitle: Logbuch %s\ndescription: Ein Eintrag je erledigtem Skill-Lauf.\ntimestamp: %sT00:00:00+01:00\n---\n\n| Zeit | Skill | Auslöser | Ergebnis | Offen |\n|---|---|---|---|---|\n' "$(date +%Y-%m)" "$(heute)" > "$datei"
z() { printf '%s' "$1" | tr '\n|' ' /'; }
printf '| %s | %s | %s | %s | %s |\n' "$(date '+%Y-%m-%d %H:%M')" "$(z "$1")" "$(z "$2")" "$(z "$3")" "$(z "${4:--}")" >> "$datei"
echo "Logbuch: $datei"
