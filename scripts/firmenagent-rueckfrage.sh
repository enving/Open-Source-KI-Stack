#!/bin/sh
# Läuft im Open-Terminal-Container (eingespielt von firmenagent-konto-einrichten.sh als ~/bin/rueckfrage).
# Schickt als Firmenagent eine Direktnachricht an eine Person und erwähnt sie darin. OpenWebUI legt dafür
# eine Inbox-Benachrichtigung „channel.mentioned“ an; ein Klick öffnet die Unterhaltung, dort wird geantwortet.
#
#   rueckfrage <E-Mail> "<Frage>"
set -eu
[ $# -eq 2 ] || { echo "Aufruf: rueckfrage <E-Mail> \"<Frage>\"" >&2; exit 2; }
. "$HOME/.config/firmenagent/zugang"

json() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/\\t/g' | awk 'NR>1{printf "\\n"}{printf "%s",$0}'; }
feld() { sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | head -n 1; }

antwort=$(curl -fsS -H 'Content-Type: application/json' "$OWUI_URL/api/v1/auths/signin" \
  -d "{\"email\":\"$(json "$OWUI_EMAIL")\",\"password\":\"$(json "$OWUI_PASSWORT")\"}")
token=$(printf '%s' "$antwort" | feld token)
[ -n "$token" ] || { echo "Anmeldung fehlgeschlagen" >&2; exit 1; }
auth="Authorization: Bearer $token"

ziel=$(curl -fsS -G -H "$auth" "$OWUI_URL/api/v1/users/search" --data-urlencode "query=$1")
ziel_id=$(printf '%s' "$ziel" | tr '{' '\n' | grep -i "\"email\": *\"$1\"" | feld id)
ziel_name=$(printf '%s' "$ziel" | tr '{' '\n' | grep -i "\"email\": *\"$1\"" | feld name)
[ -n "$ziel_id" ] || { echo "Keine Person mit dieser E-Mail gefunden" >&2; exit 1; }

kanal=$(curl -fsS -H "$auth" -H 'Content-Type: application/json' "$OWUI_URL/api/v1/channels/create" \
  -d "{\"type\":\"dm\",\"name\":\"\",\"user_ids\":[\"$ziel_id\"]}" | feld id)
[ -n "$kanal" ] || { echo "Direktnachricht konnte nicht geöffnet werden" >&2; exit 1; }

inhalt="<@U:$ziel_id|$ziel_name> $2"
nachricht=$(curl -fsS -H "$auth" -H 'Content-Type: application/json' "$OWUI_URL/api/v1/channels/$kanal/messages/post" \
  -d "{\"content\":\"$(json "$inhalt")\"}" | feld id)
echo "Rückfrage gesendet: Kanal $kanal, Nachricht $nachricht"
