#!/usr/bin/env bash
# Optionales Setup: erfundene Beispieldaten (Unternehmen/Team) + BPMN-Werkzeug + Git, in einem Aufruf.
# Nichts davon braucht der Stack zum Laufen; es ist zum Ausprobieren und für wiederholbare Tests gedacht.
#
#   ./einrichten.sh --ziel <ordner>                              # nur Tidewell (klein, ohne große Downloads)
#   ./einrichten.sh --ziel <ordner> --mails <ordner-eml> --mails-manifest <manifest.json> --ics <ordner-ics>   # mit Sinabis
#
# Weitere Optionen: --kobench <ordner>   vorhandenes kobench-Repo nutzen (sonst wird der feste Stand geklont)
#                   --praefix <ordner>   wohin `bpmn` installiert wird (Standard ~/.local)
#                   --ohne-bpmn          bpmn nicht installieren (und keine Prozesse bauen)
# Das Ziel muss leer oder neu sein. Es wird nichts gepusht und nichts im Repo geändert.
set -euo pipefail
HIER="$(cd "$(dirname "$0")" && pwd)"
KOBENCH_URL="https://github.com/enving/kobench"
KOBENCH_STAND="395bd756630fe63cf127cb2b214996b638e6eed5"   # fester Stand, aus dem daten/beispiel gelesen wird
ZIEL=""; KOBENCH=""; PRAEFIX="$HOME/.local"; BPMN=1; SIN=()
while [ $# -gt 0 ]; do
  case "$1" in
    --ziel) ZIEL="$2"; shift 2;;
    --kobench) KOBENCH="$2"; shift 2;;
    --praefix) PRAEFIX="$2"; shift 2;;
    --ohne-bpmn) BPMN=0; shift;;
    --mails) SIN+=(--mails "$2"); shift 2;;
    --mails-manifest) SIN+=(--mails-manifest "$2"); shift 2;;
    --ics) SIN+=(--ics "$2"); shift 2;;
    -h|--help) sed -n 2,13p "$0"; exit 0;;
    *) echo "Unbekannte Option: $1 (siehe --help)" >&2; exit 2;;
  esac
done
[ -n "$ZIEL" ] || { echo "--ziel fehlt (siehe --help)" >&2; exit 2; }
if [ -e "$ZIEL" ] && [ -n "$(ls -A "$ZIEL" 2>/dev/null)" ]; then echo "Abbruch: $ZIEL ist nicht leer." >&2; exit 1; fi

AUFRAEUMEN=""; trap '[ -n "$AUFRAEUMEN" ] && rm -rf "$AUFRAEUMEN"' EXIT
if [ -z "$KOBENCH" ]; then
  echo "== kobench holen (fester Stand ${KOBENCH_STAND:0:7})"
  AUFRAEUMEN="$(mktemp -d)"; KOBENCH="$AUFRAEUMEN/kobench"
  git init -q "$KOBENCH" && git -C "$KOBENCH" fetch -q --depth 1 "$KOBENCH_URL" "$KOBENCH_STAND" && git -C "$KOBENCH" checkout -q FETCH_HEAD
fi

if [ "$BPMN" = 1 ]; then
  echo "== bpmn installieren"
  if PATH="$PRAEFIX/bin:$PATH" command -v bpmn >/dev/null && [ "$(PATH="$PRAEFIX/bin:$PATH" bpmn --version)" = "$(sed -n 's/^VERSION="\(.*\)"/\1/p' "$HIER/installieren-bpmn.sh")" ]; then
    echo "bpmn in der festen Version schon vorhanden."
  else
    "$HIER/installieren-bpmn.sh" "$PRAEFIX" | tail -1
  fi
  export PATH="$PRAEFIX/bin:$PATH"
fi

echo "== Daten bauen"
python3 -I "$HIER/bauen.py" --kobench "$KOBENCH" --ziel "$ZIEL" ${SIN[@]+"${SIN[@]}"}
if [ "$BPMN" = 1 ]; then echo "== Prozesse bauen"; "$HIER/prozesse.sh" "$ZIEL"; fi
echo "== Git anlegen"
"$HIER/git-einrichten.sh" "$ZIEL"
echo "Fertig: $ZIEL"
[ "$BPMN" = 1 ] && echo "bpmn nutzen: export PATH=\"$PRAEFIX/bin:\$PATH\""
exit 0
