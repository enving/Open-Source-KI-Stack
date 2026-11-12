#!/usr/bin/env bash
set -euo pipefail

# Legt in OpenWebUI ein eigenes Nutzerkonto für den Firmenagenten an und legt dessen Zugangsdaten
# nur im persistenten Home des Open-Terminal-Containers ab (~/.config/firmenagent/zugang, Modus 600).
# Dazu kommt das Werkzeug ~/bin/rueckfrage, mit dem der Agent Mitarbeitende per Direktnachricht fragt.
# Idempotent: Ein vorhandenes Konto behält sein Passwort, sofern die Zugangsdatei noch existiert.
#
#   scripts/firmenagent-konto-einrichten.sh <Compose-env-Datei> [Agenten-E-Mail]
#
# Das Konto ist ein normales Nutzerkonto ohne Admin-Rechte. API-Schlüssel bleiben in OpenWebUI aus;
# der Agent meldet sich wie ein Mensch mit E-Mail und Passwort an.
if [[ $# -lt 1 || $# -gt 2 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei> [Agenten-E-Mail]" >&2
  exit 2
fi
command -v docker >/dev/null || { echo "docker fehlt" >&2; exit 1; }
command -v openssl >/dev/null || { echo "openssl fehlt" >&2; exit 1; }

cd "$(dirname "$0")/.."
compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)
FIRMENAGENT_EMAIL=${2:-firmenagent@firma.invalid}

FIRMENAGENT_PASSWORT=$("${compose[@]}" exec -T open-terminal sh -c \
  'f=$HOME/.config/firmenagent/zugang; [ -f "$f" ] && sed -n "s/^OWUI_PASSWORT=//p" "$f" || true')
[[ -n "$FIRMENAGENT_PASSWORT" ]] || FIRMENAGENT_PASSWORT=$(openssl rand -hex 24)
export FIRMENAGENT_EMAIL FIRMENAGENT_PASSWORT

"${compose[@]}" exec -T -e FIRMENAGENT_EMAIL -e FIRMENAGENT_PASSWORT -w /app/backend openwebui python3 - <<'PY'
import asyncio, os
from open_webui.models.auths import Auths
from open_webui.models.users import Users
from open_webui.utils.auth import get_password_hash

async def main():
    email = os.environ['FIRMENAGENT_EMAIL'].lower()
    passwort = await get_password_hash(os.environ['FIRMENAGENT_PASSWORT'])
    nutzer = await Users.get_user_by_email(email)
    if nutzer is None:
        nutzer = await Auths.insert_new_auth(email, passwort, 'Firmenagent', role='user')
        print('Konto angelegt:', email)
    else:
        await Auths.update_user_password_by_id(nutzer.id, passwort)
        if nutzer.role != 'user':
            await Users.update_user_role_by_id(nutzer.id, 'user')
        print('Konto vorhanden, Passwort abgeglichen:', email)

asyncio.run(main())
PY

"${compose[@]}" exec -T -e FIRMENAGENT_EMAIL -e FIRMENAGENT_PASSWORT open-terminal sh -c '
  set -eu; umask 077
  mkdir -p "$HOME/.config/firmenagent" "$HOME/bin"
  printf "OWUI_URL=http://openwebui:8080\nOWUI_EMAIL=%s\nOWUI_PASSWORT=%s\n" "$FIRMENAGENT_EMAIL" "$FIRMENAGENT_PASSWORT" \
    > "$HOME/.config/firmenagent/zugang"'
"${compose[@]}" exec -T open-terminal sh -c 'cat > "$HOME/bin/rueckfrage" && chmod 700 "$HOME/bin/rueckfrage"' \
  < scripts/firmenagent-rueckfrage.sh
echo "Fertig. Im Terminal: ~/bin/rueckfrage <E-Mail der zuständigen Person> \"<Frage>\""
