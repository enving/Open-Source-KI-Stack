#!/usr/bin/env bash
set -euo pipefail

# Überträgt die Systemanweisung aus dem LLM-Wiki (Quelle: /home/user/llm-wiki/steuerung/systemanweisung-workspace.md
# im Open-Terminal-Container) in ein Open-WebUI-Modell (params.system). Das Wiki bleibt die einzige Pflegestelle;
# Änderungen in Open WebUI werden beim nächsten Lauf überschrieben. Die vorige Fassung bleibt in der Modellhistorie.
#
#   scripts/openwebui-systemanweisung-aus-wiki.sh <Compose-env-Datei> <Modell-ID>
if [[ $# -ne 2 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei> <Modell-ID>" >&2
  exit 2
fi
compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)

QUELLE=steuerung/systemanweisung-workspace.md
ANWEISUNG=$("${compose[@]}" exec -T open-terminal cat "/home/user/llm-wiki/$QUELLE") \
  || { echo "$QUELLE im Wiki nicht gefunden" >&2; exit 1; }
export ANWEISUNG QUELLE MODELL_ID="$2"

"${compose[@]}" exec -T -e ANWEISUNG -e QUELLE -e MODELL_ID -w /app/backend openwebui python3 - <<'PY'
import asyncio, os, re
from open_webui.models.models import Models, ModelForm

inhalt, quelle, modell = os.environ['ANWEISUNG'], os.environ['QUELLE'], os.environ['MODELL_ID']
m = re.match(r'^---\n.*?\n---\n', inhalt, re.S)
if not m:
    raise SystemExit('Systemanweisung ohne Frontmatter')
text = inhalt[m.end():].strip() + f'\n\n(Quelle: LLM-Wiki `{quelle}`. Änderungen dort, nicht hier.)\n'

async def main():
    mod = await Models.get_model_by_id(modell)
    if mod is None:
        raise SystemExit(f'Modell {modell} nicht gefunden')
    params = mod.params.model_dump()
    if params.get('system') == text:
        print('Systemanweisung unverändert')
        return
    params['system'] = text
    form = ModelForm(**{**mod.model_dump(), 'params': params, 'access_grants': None,  # Freigaben unverändert
                        'commit_message': 'Systemanweisung aus LLM-Wiki'})
    await Models.update_model_by_id(modell, form)
    print(f'Systemanweisung in {modell} gesetzt ({len(text)} Zeichen)')

asyncio.run(main())
PY
