#!/bin/sh
# Zählt eine Korrektur: werkzeuge/korrektur-zaehlen.sh <skill-oder-bereich> <muster-kennung> einmalig|regel
set -eu
[ $# -eq 3 ] || { echo "Aufruf: $0 <skill-oder-bereich> <muster-kennung> einmalig|regel" >&2; exit 2; }
case "$3" in einmalig|regel) ;; *) echo "Einordnung: einmalig oder regel" >&2; exit 2;; esac
printf '%s' "$2" | grep -q -E '^[a-z0-9-]+$' || { echo "Muster-Kennung nur a-z, 0-9, -" >&2; exit 2; }
. "$(dirname "$0")/gemeinsam.sh"
printf '| %s | %s | %s | %s |\n' "$(heute)" "$1" "$2" "$3" >> lernschleife/korrekturen.md
echo "gezählt: $1 / $2 ($3), bisher $(grep -c "| $2 |" lernschleife/korrekturen.md)x"
