#!/usr/bin/env bash
# Legt die gebauten Beispieldaten als Git-Repo an (Standard, damit mehrere Personen und Agenten gleichzeitig arbeiten
# können, ohne sich zu überschreiben). Aufruf: ./git-einrichten.sh <wurzel der beispieldaten>
# Idempotent: ein vorhandenes Repo bleibt unberührt. Es wird nichts gepusht.
set -euo pipefail
W="${1:?Wurzel der Beispieldaten fehlt}"; cd "$W"
[ -d .git ] && { echo "Schon ein Git-Repo: $(git log --oneline | wc -l | tr -d ' ') Commit(s)."; exit 0; }
cp "$(dirname "$0")/ausgabe-ARBEITSWEISE.md" ARBEITSWEISE.md
# Mails und Kalender unverändert lassen (keine Zeilenenden-Umwandlung); Bilder binär.
printf '%s\n' '*.eml -text' '*.ics -text' '*.png binary' > .gitattributes
printf '%s\n' '.arbeitsplaetze/' > .gitignore   # hier liegen die Arbeitsordner der Agenten (siehe ARBEITSWEISE.md)
git init -q -b main
git config user.name  "Beispieldaten"
git config user.email "beispieldaten@example.invalid"
git add -A
git commit -q -m "Grundstock Beispieldaten (erfunden): Unternehmen und Team"
echo "Git bereit: $(git rev-parse --short HEAD) auf main, $(git ls-files | wc -l | tr -d ' ') Dateien."
