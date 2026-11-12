#!/usr/bin/env bash
set -euo pipefail

# Legt das LLM-Wiki aus vorlagen/llm-wiki/ im persistenten Home des Open-Terminal-Containers an
# (/home/user/llm-wiki), ersetzt die Platzhalter {{…}} aus einer Firmen-Datei, macht das Wiki zum Git-Repository,
# verlinkt die Skills für Codex (~/.agents/skills) und setzt den Container so neu auf, dass Agenten dort starten.
# Vorhandene Dateien werden nie überschrieben; nur fehlende kommen dazu. index.md wird neu erzeugt.
#
#   scripts/llm-wiki-einrichten.sh <Compose-env-Datei> [Firmen-Datei, Vorlage: vorlagen/llm-wiki.firma.env.example]
if [[ $# -lt 1 || $# -gt 2 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei> [Firmen-Datei]" >&2
  exit 2
fi
cd "$(dirname "$0")/.."
firma=${2:-vorlagen/llm-wiki.firma.env.example}
[[ -f "$firma" ]] || { echo "Firmen-Datei fehlt: $firma" >&2; exit 2; }
compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)
# WIKI_CONTAINER=<Name> richtet stattdessen in einem anderen Container ein (zum Testen an einem frischen Ziel)
im_container() { if [[ -n "${WIKI_CONTAINER:-}" ]]; then docker exec -i "$@" "$WIKI_CONTAINER" "${befehl[@]}"; else "${compose[@]}" exec -T "$@" open-terminal "${befehl[@]}"; fi; }

# Platzhalter auf einer Kopie ersetzen (awk mit ENVIRON, damit Sonderzeichen in Werten sicher sind)
set -a; . "$firma"; set +a
export HEUTE=${HEUTE:-$(date +%Y-%m-%d)}
for v in FIRMA_NAME FIRMA_KURZ BESITZER_STANDARD CODEX_MODELL CRM CRM_ZUGANG; do
  [[ -n "${!v:-}" ]] || { echo "$v fehlt in $firma" >&2; exit 2; }
done
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
cp -R vorlagen/llm-wiki "$tmp/llm-wiki"
find "$tmp/llm-wiki" -type f -name '*.md' | while read -r datei; do
  awk 'BEGIN{split("HEUTE FIRMA_NAME FIRMA_KURZ BESITZER_STANDARD CODEX_MODELL CRM CRM_ZUGANG",n," ")
             for(i in n){w=ENVIRON[n[i]]; gsub(/&/,"\\\\&",w); r[n[i]]=w}}
       {for(k in r) gsub("\\{\\{" k "\\}\\}", r[k]); print}' "$datei" > "$datei.neu" && mv "$datei.neu" "$datei"
done

befehl=(sh -c 'umask 077; tar -C "$HOME" --skip-old-files -xf -')
COPYFILE_DISABLE=1 tar --no-xattrs -C "$tmp" -cf - llm-wiki | im_container  # ohne macOS-Begleitdateien (._*)
befehl=(sh -s)
im_container -e GIT_NAME="Firmenagent" -e GIT_MAIL="$BESITZER_STANDARD" <<'CONTAINER_SCRIPT'
set -eu
root=$HOME/llm-wiki
cd "$root"
chmod 700 "$root" werkzeuge/*.sh
werkzeuge/wiki-index.sh >/dev/null
mkdir -p "$HOME/.agents/skills"
for skill in "$root"/skills/*/; do
  skill=$(basename "$skill")
  [ -e "$HOME/.agents/skills/$skill" ] || ln -s "$root/skills/$skill" "$HOME/.agents/skills/$skill"
done
if [ ! -d .git ]; then
  git init -q -b main
  git config user.name "$GIT_NAME"; git config user.email "$GIT_MAIL"
  git add -A && git commit -q -m "Wiki aus Vorlage angelegt"
  echo "git: Repository angelegt"
elif [ -n "$(git status --porcelain)" ]; then
  echo "git: Arbeitsbaum hat Änderungen (neue Vorlagendateien oder Index); bitte prüfen und committen"
fi
werkzeuge/wiki-pruefen.sh | tail -n 1
printf 'wiki_ready=%s\n' "$root"
CONTAINER_SCRIPT

[[ -z "${WIKI_CONTAINER:-}" ]] || exit 0
container_id=$("${compose[@]}" ps -q open-terminal)
current_workdir=$(docker inspect "$container_id" --format '{{.Config.WorkingDir}}' 2>/dev/null || true)
if [[ "$current_workdir" != /home/user/llm-wiki ]]; then
  "${compose[@]}" up -d --no-deps --force-recreate open-terminal
fi
