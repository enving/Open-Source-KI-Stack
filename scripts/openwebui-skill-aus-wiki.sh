#!/usr/bin/env bash
set -euo pipefail

# Überträgt einen Skill aus dem LLM-Wiki (Quelle: /home/user/llm-wiki/skills/<Name>/SKILL.md im Open-Terminal-Container)
# als Open-WebUI-Skill. Das Wiki bleibt die einzige Pflegestelle; der Open-WebUI-Skill ist eine Kopie mit Herkunftsvermerk
# und wird bei jedem Lauf überschrieben. Lesbar für alle angemeldeten Nutzer. Optional an ein Modell gebunden.
#
#   scripts/openwebui-skill-aus-wiki.sh <Compose-env-Datei> <Skill-Name> [Modell-ID]
if [[ $# -lt 2 || $# -gt 3 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei> <Skill-Name> [Modell-ID]" >&2
  exit 2
fi
[[ "$2" =~ ^[a-z0-9-]+$ ]] || { echo "Skill-Name nur aus a-z, 0-9 und -" >&2; exit 2; }
compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)

SKILL_INHALT=$("${compose[@]}" exec -T open-terminal cat "/home/user/llm-wiki/skills/$2/SKILL.md") \
  || { echo "Skill $2 im Wiki nicht gefunden" >&2; exit 1; }
export SKILL_INHALT SKILL_NAME="$2" MODELL_ID="${3:-}"

"${compose[@]}" exec -T -e SKILL_INHALT -e SKILL_NAME -e MODELL_ID -w /app/backend openwebui python3 - <<'PY'
import asyncio, os, re
from open_webui.models.skills import Skills, SkillForm
from open_webui.models.models import Models, ModelForm
from open_webui.models.users import Users

inhalt, sid, modell = os.environ['SKILL_INHALT'], os.environ['SKILL_NAME'], os.environ['MODELL_ID']
m = re.match(r'^---\n(.*?)\n---\n', inhalt, re.S)
if not m:
    raise SystemExit('SKILL.md ohne Frontmatter')
kopf = dict(re.findall(r'^(\w+):\s*(.*)$', m.group(1), re.M))
if kopf.get('name') != sid or not kopf.get('description'):
    raise SystemExit('Frontmatter braucht name (= Skill-Name) und description')
vermerk = (f'\n> Kopie aus dem LLM-Wiki (`skills/{sid}/SKILL.md`), erzeugt von `scripts/openwebui-skill-aus-wiki.sh`. '
           'Änderungen im Wiki vornehmen und das Skript erneut laufen lassen.\n')
text = inhalt[:m.end()] + vermerk + inhalt[m.end():]
titel = kopf.get('title') or sid
grants = [{'principal_type': 'user', 'principal_id': '*', 'permission': 'read'}]

async def main():
    admin = next(u for u in (await Users.get_users())['users'] if u.role == 'admin')
    alt = await Skills.get_skill_by_id(sid)
    if alt is None:
        await Skills.insert_new_skill(admin.id, SkillForm(id=sid, name=titel, description=kopf['description'],
                                      content=text, access_grants=grants, commit_message='aus LLM-Wiki'))
        print(f'Skill {sid} angelegt')
    else:
        await Skills.update_skill_by_id(sid, {'name': titel, 'description': kopf['description'],
                                              'files': [{'path': 'SKILL.md', 'content': text}],
                                              'expected_version_id': alt.version_id,
                                              'commit_message': 'aus LLM-Wiki'}, user_id=admin.id)
        print(f'Skill {sid} aktualisiert')
    if modell:
        mod = await Models.get_model_by_id(modell)
        if mod is None:
            raise SystemExit(f'Modell {modell} nicht gefunden')
        meta = mod.meta.model_dump()
        ids = meta.get('skillIds') or []
        if sid not in ids:
            meta['skillIds'] = ids + [sid]
            form = ModelForm(**{**mod.model_dump(), 'meta': meta, 'access_grants': None})  # Freigaben unverändert
            await Models.update_model_by_id(modell, form)
            print(f'An Modell {modell} gebunden')
        else:
            print(f'Modell {modell} hat den Skill bereits')

asyncio.run(main())
PY
