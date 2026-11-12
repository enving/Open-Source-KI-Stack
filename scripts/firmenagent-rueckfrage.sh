#!/bin/sh
# Läuft im Open-Terminal-Container (eingespielt von firmenagent-konto-einrichten.sh als ~/bin/rueckfrage).
# Schickt als Firmenagent eine Direktnachricht an eine Person und erwähnt sie darin. OpenWebUI legt dafür
# eine Inbox-Benachrichtigung „channel.mentioned“ an; ein Klick öffnet die Unterhaltung, dort wird geantwortet.
#
#   rueckfrage <E-Mail> "<Frage>"                 Frage senden, gibt Kanal und Nachricht aus
#   rueckfrage antworten <Kanal> <Nachricht>      Antworten anderer nach dieser Frage ausgeben
#                                                 (Exit 3: noch keine Antwort)
set -eu
nutzung() { echo "Aufruf: rueckfrage <E-Mail> \"<Frage>\" | rueckfrage antworten <Kanal> <Nachricht>" >&2; exit 2; }
[ $# -ge 2 ] || nutzung
. "$HOME/.config/firmenagent/zugang"

json() { printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/\\t/g' | awk 'NR>1{printf "\\n"}{printf "%s",$0}'; }
feld() { sed -n "s/.*\"$1\": *\"\([^\"]*\)\".*/\1/p" | head -n 1; }

antwort=$(curl -fsS -H 'Content-Type: application/json' "$OWUI_URL/api/v1/auths/signin" \
  -d "{\"email\":\"$(json "$OWUI_EMAIL")\",\"password\":\"$(json "$OWUI_PASSWORT")\"}")
token=$(printf '%s' "$antwort" | feld token)
ich=$(printf '%s' "$antwort" | feld id)
[ -n "$token" ] || { echo "Anmeldung fehlgeschlagen" >&2; exit 1; }
auth="Authorization: Bearer $token"

if [ "$1" = antworten ]; then
  [ $# -eq 3 ] || nutzung
  command -v jq >/dev/null || { echo "jq fehlt im Container" >&2; exit 1; }
  kanal=$2 frage=$3
  # Antworten in der Unterhaltung nach der Frage und im Thread der Frage; eigene Nachrichten ausgelassen.
  oben=$(curl -fsS -H "$auth" "$OWUI_URL/api/v1/channels/$kanal/messages?skip=0&limit=100")
  faden=$(curl -fsS -H "$auth" "$OWUI_URL/api/v1/channels/$kanal/messages/$frage/thread?skip=0&limit=100" || echo '[]')
  ergebnis=$(jq -rn --argjson oben "$oben" --argjson faden "$faden" --arg frage "$frage" --arg ich "$ich" '
    ($oben | map(select(.id == $frage)) | first // error("Frage nicht in diesem Kanal gefunden")) as $f
    | [($oben[] | select(.parent_id == null and .created_at > $f.created_at)), ($faden[] | select(.id != $frage))]
    | map(select(.user_id != $ich)) | unique_by(.id) | sort_by(.created_at)
    | .[] | "\(.created_at / 1e9 | floor | strftime("%Y-%m-%d %H:%M UTC"))\t\(.user.name // .user_id)\t\(.content)"')
  [ -n "$ergebnis" ] || { echo "Noch keine Antwort" >&2; exit 3; }
  printf '%s\n' "$ergebnis"
  exit 0
fi

[ $# -eq 2 ] || nutzung
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
echo "Antworten lesen: rueckfrage antworten $kanal $nachricht"
