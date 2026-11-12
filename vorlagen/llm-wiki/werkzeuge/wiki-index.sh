#!/bin/sh
# Erzeugt index.md aus firma.md und den description-Feldern: eine Zeile je Bereich, darunter eine je Datei.
set -eu
. "$(dirname "$0")/gemeinsam.sh"
zeile() { printf -- '- [%s](%s) — %s\n' "$(feld "$1" title)" "$1" "$(feld "$1" description)"; }
{
  printf -- '---\nokf_version: "0.1"\n---\n\n# Wiki von %s\n\n' "$(awk '/^# /{sub(/^# /,"");print;exit}' firma.md)"
  printf 'Erzeugt von `werkzeuge/wiki-index.sh` am %s. Nicht von Hand ändern.\n\n' "$(heute)"
  printf -- '- [Firmenprofil, Bereiche und Besitzer](firma.md)\n- [Arbeitsregeln für Agenten](AGENTS.md)\n\n## Bereiche\n\n'
  bereiche | while IFS='|' read -r name ordner besitzer zweck; do
    printf -- '- **%s** (`%s`, Besitzer %s): %s\n' "$name" "$ordner" "$besitzer" "$zweck"
    for d in $(find "$ordner" -name '*.md' 2>/dev/null | sort); do printf '  '; zeile "$d"; done
  done
  printf '\n## Steuerung\n\n'; for d in steuerung/*.md; do zeile "$d"; done
  printf '\n## Skills\n\n'
  for d in skills/*/SKILL.md; do
    n=$(basename "$(dirname "$d")"); e=$(ls "evals/$n" 2>/dev/null | grep -c '\.md$' || true)
    printf -- '- [%s](%s) — %s Prüffälle: %s\n' "$n" "$d" "$(feld "$d" description | cut -c1-140)…" "$e"
  done
  printf '\n## Weitere\n\n- [Quellen: Karpathy](references/karpathy-llm-wiki.md), [OKF](references/open-knowledge-format.md)\n'
  printf -- '- [Rohquellen](raw/index.md)\n- [Unbestätigte Entwürfe](proposals/index.md)\n- [Korrekturen](lernschleife/korrekturen.md)\n'
  [ -f evals/ergebnisse.md ] && printf -- '- [Eval-Ergebnisse](evals/ergebnisse.md)\n'
  for d in $(ls logbuch/*.md 2>/dev/null | sort -r | head -n 3); do printf -- '- [Logbuch %s](%s)\n' "$(basename "$d" .md)" "$d"; done
  printf '\nÄnderungshistorie: [log.md](log.md)\n'
} > index.md.neu
mv index.md.neu index.md
echo "index.md erzeugt"
