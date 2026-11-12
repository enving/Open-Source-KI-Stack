#!/bin/sh
# Prüft das Wiki: OKF-Frontmatter, Pflichtfelder (geprueft, Quelle), Bereiche gegen firma.md, Links, Platzhalter,
# fällige Dateien. Exit 1 bei Fehlern; Warnungen und fällige Dateien brechen nicht ab.
#   werkzeuge/wiki-pruefen.sh            ausführlich
#   werkzeuge/wiki-pruefen.sh --faellig  nur fällige Dateien mit Besitzer (für den OS-Check)
set -eu
. "$(dirname "$0")/gemeinsam.sh"
fehler=0; warnungen=0
F() { echo "FEHLER  $*"; fehler=$((fehler+1)); }
W() { echo "WARNUNG $*"; warnungen=$((warnungen+1)); }
intervall=$(feld firma.md pruefintervall_tage); intervall=${intervall:-90}
jetzt=$(date +%s)
faellig=""
for d in $(find . -name '*.md' -not -path './.git/*' -not -path './raw/*' | sed 's|^\./||' | sort); do
  case "$d" in index.md|log.md|*/index.md) continue;; esac
  [ "$(head -n1 "$d")" = "---" ] || { F "$d: kein Frontmatter"; continue; }
  [ -n "$(feld "$d" type)" ] || F "$d: Frontmatter ohne type"
  case "$d" in wiki/*|skills/*|steuerung/*)
    g=$(feld "$d" geprueft)
    if [ -z "$g" ]; then F "$d: geprueft fehlt"
    elif ! t=$(date -d "$g" +%s 2>/dev/null); then F "$d: geprueft ist kein Datum ($g)"
    elif [ $(( (jetzt - t) / 86400 )) -gt "$intervall" ]; then
      faellig="$faellig$d|$g|$(besitzer_von "$d")\n"
    fi;;
  esac
  case "$d" in wiki/*)
    grep -q -E 'Quelle|^# Citations|\]\(/?(raw|references)/' "$d" || W "$d: keine Quelle angegeben"
    [ -n "$(besitzer_von "$d")" ] || F "$d: liegt in keinem Bereich aus firma.md";;
  esac
  grep -q '{{[A-Z_]*}}' "$d" && W "$d: Platzhalter nicht ersetzt"
  # Links auf Markdown-Dateien im Wiki prüfen (absolut ab Wiki-Stamm oder relativ)
  for z in $(grep -o -E '\]\([^)#]+\.md\)' "$d" | sed -E 's/^\]\(//; s/\)$//' | grep -v -E '^[a-z]+://'); do
    case "$z" in /*) p=".${z}";; *) p="$(dirname "$d")/$z";; esac
    [ -f "$p" ] || F "$d: Link ins Leere: $z"
  done
done
liste=$(bereiche)
alt_ifs=$IFS; IFS='
'
for zeile in $liste; do
  name=${zeile%%|*}; rest=${zeile#*|}; ordner=${rest%%|*}; rest=${rest#*|}; besitzer=${rest%%|*}
  [ -d "$ordner" ] || F "firma.md: Ordner $ordner für Bereich $name fehlt"
  case "$besitzer" in *@*) ;; *) W "firma.md: Bereich $name ohne Besitzer-Konto";; esac
done
IFS=$alt_ifs
for o in wiki/*/; do o=${o%/}; bereiche | grep -q "|$o|" || F "$o: Ordner ohne Bereich in firma.md"; done
if [ "${1:-}" = --faellig ]; then printf "$faellig"; exit 0; fi
[ -n "$faellig" ] && printf "$faellig" | while IFS='|' read -r d g b; do echo "FÄLLIG  $d (geprüft $g, Besitzer ${b:-unbekannt})"; done
echo "Ergebnis: $fehler Fehler, $warnungen Warnungen, Prüfintervall $intervall Tage"
[ "$fehler" -eq 0 ]
