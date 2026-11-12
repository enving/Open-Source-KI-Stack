#!/bin/sh
# Wöchentlicher Gesundheitscheck ohne Sprachmodell: Prüfung, fällige Dateien, Korrekturmuster ab drei Fällen
# (höchstens drei Vorschläge), Skills ohne drei Prüffälle, Logbuch der letzten sieben Tage, offene Vorschläge.
set -eu
. "$(dirname "$0")/gemeinsam.sh"
echo "# OS-Check $(heute)"; echo
echo "## Wiki-Prüfung"; werkzeuge/wiki-pruefen.sh | tail -n 1 || true; echo
echo "## Fällige Dateien"
f=$(werkzeuge/wiki-pruefen.sh --faellig); [ -n "$f" ] && printf '%s\n' "$f" | awk -F'|' '{print "- "$1" (geprüft "$2", Besitzer "$3")"}' || echo "- keine"; echo
echo "## Korrekturmuster ab drei Fällen (höchstens drei)"
awk -F'|' 'NR>2&&$4!=""{gsub(/ /,"",$3);gsub(/ /,"",$4); n[$3" / "$4]++} END{for(k in n) if(n[k]>=3) print n[k]"x "k}' lernschleife/korrekturen.md | sort -rn | head -n 3 | sed 's/^/- /' | grep . || echo "- keine"; echo
echo "## Skills ohne drei Prüffälle"
for d in skills/*/; do n=$(basename "$d"); e=$(ls "evals/$n" 2>/dev/null | grep -c '\.md$' || true); [ "$e" -ge 3 ] || echo "- $n: $e"; done | grep . || echo "- keine"; echo
echo "## Logbuch, letzte sieben Tage"
seit=$(date -d '7 days ago' +%Y-%m-%d)
cat logbuch/*.md 2>/dev/null | awk -F'|' -v s="$seit" 'NF>5&&$2~/[0-9]{4}-/{gsub(/^ +| +$/,"",$2);gsub(/^ +| +$/,"",$3); if(substr($2,1,10)>=s) n[$3]++} END{for(k in n) print "- "k": "n[k]}' | grep . || echo "- keine Läufe"; echo
echo "## Offene Vorschläge (Zweige)"
git branch --list 'vorschlag/*' 2>/dev/null | sed 's/^[ *]*/- /' | grep . || echo "- keine"
