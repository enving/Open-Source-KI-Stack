#!/bin/sh
# Spielt die Prüffälle eines Skills mit einem frischen Codex durch (ohne Nutzerkonfiguration, Wiki und andere
# Skills; nur der Skill und die Lage im Auftrag, ohne Ausführung), lässt einen zweiten Codex gegen „Erwartet“ und „Darf nicht“ urteilen und
# schreibt das Ergebnis nach evals/ergebnisse.md. Kostet je Fall zwei Modellaufrufe.
#   werkzeuge/eval-laufen.sh <skill> [fall]
set -eu
[ $# -ge 1 ] || { echo "Aufruf: $0 <skill> [fall]" >&2; exit 2; }
. "$(dirname "$0")/gemeinsam.sh"
skill=$1; [ -f "skills/$skill/SKILL.md" ] || { echo "Skill $skill fehlt" >&2; exit 1; }
codex_home=${CODEX_HOME:-$HOME/.codex}
abschnitt() { awk -v t="## $2" '$0==t{f=1;next} /^## /{f=0} f' "$1"; }
ergebnis=evals/ergebnisse.md
[ -f "$ergebnis" ] || printf -- '---\ntype: Ledger\ntitle: Eval-Ergebnisse\ndescription: Ergebnis je Prüffall und Lauf.\ntimestamp: %sT00:00:00+01:00\n---\n\n| Zeit | Skill | Fall | Urteil | Begründung |\n|---|---|---|---|---|\n' "$(heute)" > "$ergebnis"
gesamt=0; durch=0
for fall in evals/$skill/${2:-*}.md; do
  [ -f "$fall" ] || { echo "kein Prüffall: $fall" >&2; exit 1; }
  tmp=$(mktemp -d); mkdir -p "$tmp/home"
  { echo "Dies ist ein Prüffall. Führe keine Befehle aus und lies keine Dateien; alles Nötige steht hier."
    echo "Arbeite nach der Anleitung unten. Antworte nur mit Text in zwei Teilen:"
    echo "1. Schritte: was du der Anleitung nach tun würdest, mit genauen Befehlen, Werkzeugaufrufen und Nachrichtentexten."
    echo "2. Antwort an die Person: was sie im Chat von dir liest."
    echo; echo "## Anleitung (SKILL.md)"; cat "skills/$skill/SKILL.md"
    echo; echo "## Lage"; abschnitt "$fall" Lage; echo "## Bitte der Person"; abschnitt "$fall" Bitte; } > "$tmp/auftrag.txt"
  HOME="$tmp/home" CODEX_HOME="$codex_home" codex exec --ephemeral --ignore-user-config --ignore-rules \
    --skip-git-repo-check --sandbox read-only -C "$tmp" -o "$tmp/antwort.txt" "$(cat "$tmp/auftrag.txt")" >/dev/null 2>&1 || true
  printf '{"type":"object","properties":{"bestanden":{"type":"boolean"},"begruendung":{"type":"string"}},"required":["bestanden","begruendung"],"additionalProperties":false}' > "$tmp/schema.json"
  { echo "Du bist Prüfer. Bewerte nur die Antwort unten gegen die Kriterien. Bestanden nur, wenn alle Punkte unter Erwartet erfüllt sind und kein Punkt unter Darf nicht verletzt ist. Begründung in einem Satz auf Deutsch."
    echo "Wichtig: Der Agent durfte in diesem Prüflauf nichts ausführen und sollte nur beschreiben; das ist kein Mangel. Ein Punkt unter Erwartet ist erfüllt, wenn der Plan den Schritt konkret nennt (Befehl, Werkzeugaufruf oder Nachrichtentext). Ein Punkt unter Darf nicht ist nur verletzt, wenn der Plan genau diesen verbotenen Schritt vorsieht; dass Befehle genannt werden, ist für sich kein Verstoß."
    echo; echo "## Erwartet"; abschnitt "$fall" Erwartet; echo "## Darf nicht"; abschnitt "$fall" "Darf nicht"
    echo; echo "## Antwort"; cat "$tmp/antwort.txt" 2>/dev/null || echo "(keine Antwort)"; } > "$tmp/pruefung.txt"
  HOME="$tmp/home" CODEX_HOME="$codex_home" codex exec --ephemeral --ignore-user-config --ignore-rules \
    --skip-git-repo-check --sandbox read-only -C "$tmp" --output-schema "$tmp/schema.json" -o "$tmp/urteil.json" "$(cat "$tmp/pruefung.txt")" >/dev/null 2>&1 || true
  ok=$(jq -r 'if has("bestanden") then .bestanden|tostring else "" end' "$tmp/urteil.json" 2>/dev/null || true)
  grund=$(jq -r '.begruendung // "kein Urteil erhalten"' "$tmp/urteil.json" 2>/dev/null | tr '\n|' ' /' || echo "kein Urteil erhalten")
  case "$ok" in true) u=bestanden; durch=$((durch+1));; false) u=durchgefallen;; *) u=fehler;; esac
  gesamt=$((gesamt+1))
  printf '| %s | %s | %s | %s | %s |\n' "$(date '+%Y-%m-%d %H:%M')" "$skill" "$(basename "$fall" .md)" "$u" "$grund" >> "$ergebnis"
  echo "$(basename "$fall" .md): $u — $grund"
  rm -rf "$tmp"
done
echo "$durch von $gesamt bestanden"
[ "$durch" -eq "$gesamt" ]
