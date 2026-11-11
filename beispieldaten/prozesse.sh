#!/bin/bash
# Baut die BPMN-Beispielprozesse für Tidewell (erfunden) mit dem bpmn-cli.
# Aufruf: prozesse.sh <wurzel der beispieldaten>   → <wurzel>/unternehmen/prozesse/ und <wurzel>/team/prozesse/
# Konvention: Bahn "Mensch" = userTask (Mensch macht und entscheidet), Bahn "Firmen-Agent" = serviceTask (Agent macht).
# Wo der Agent beraten soll statt zu handeln, steht das in `doc` des Schritts. Quelle der Regeln: kobench-Beispielfirma.
set -euo pipefail
WURZEL="${1:?Wurzel der Beispieldaten fehlt}"
mkdir -p "$WURZEL"; WURZEL=$(cd "$WURZEL" && pwd)   # absolut, weil das Skript in Unterordner wechselt
b() { out=$("$@" 2>&1) || { echo "$out" >&2; exit 1; }; }   # nur Fehler zeigen

bahnen() {  # $1=Datei $2=Pool-Name $3=Mensch-Bahn
  b bpmn add "$1" participant "$2" --id pool
  b bpmn add "$1" lane "$3" --in pool --id lane_mensch
  b bpmn add "$1" lane "Firmen-Agent" --in pool --id lane_agent
}

# ---- 1. Erstattung (Unternehmen, Finance) ----
mkdir -p "$WURZEL/unternehmen/prozesse"; cd "$WURZEL/unternehmen/prozesse"
f=erstattung.bpmn; rm -f $f
b bpmn new $f "Erstattung"
bahnen $f "Erstattung (Finance)" "Mensch (Finance)"
b bpmn add $f start "Erstattungswunsch eingegangen" --id start --in pool --lane lane_agent
b bpmn add $f serviceTask "Frist und Betrag prüfen" --after start --id pruefen --lane lane_agent \
  doc="Richtlinie: 30 Tage ab erster Rechnung volle Erstattung, danach anteilig nur bei Jahrespaketen."
b bpmn add $f xor "Fall klar?" --after pruefen --id klar --lane lane_agent
b bpmn add $f userTask "Sonderfall beraten und entscheiden" --after klar --id sonderfall --lane lane_mensch --flow-name "nein" \
  doc="Der Agent berät: legt Fakten und Richtlinie vor und sagt, ob Richtlinie oder Ablauf geändert werden sollten. Entscheiden tut der Mensch."
b bpmn add $f end "Fall übergeben" --after sonderfall --id ende_sonder --lane lane_mensch
b bpmn add $f xor "Betrag über 10.000 USD?" --after klar --id betrag --lane lane_agent --flow-name "ja"
b bpmn add $f userTask "Freigabe Finance-Leitung" --after betrag --id freigabe --lane lane_mensch --flow-name "ja" \
  doc="Erstattungen über 10.000 USD braucht die Freigabe der Finance-Leitung (Refund policy)."
b bpmn add $f userTask "Zweite Unterschrift CEO" --after freigabe --id ceo --lane lane_mensch
b bpmn add $f serviceTask "Erstattung buchen und Kunden informieren" --after ceo --id buchen --lane lane_agent
b bpmn add $f end "Erstattung erledigt" --after buchen --id ende --lane lane_agent
b bpmn add $f xor --flow flow_ceoToBuchen --id zusammen --lane lane_agent
b bpmn connect $f betrag zusammen name="nein"
b bpmn layout $f
b bpmn validate $f >/dev/null

for g in *.bpmn; do b bpmn render "$g" -o "${g%.bpmn}.png"; done

# ---- 2. Störung (Team Technik) ----
mkdir -p "$WURZEL/team/prozesse"; cd "$WURZEL/team/prozesse"
f=stoerung.bpmn; rm -f $f
b bpmn new $f "Störung"
bahnen $f "Störung (Technik)" "Mensch (On-Call)"
b bpmn add $f start "Störung gemeldet" --id start --in pool --lane lane_agent
b bpmn add $f serviceTask "Schweregrad einordnen" --after start --id einordnen --lane lane_agent \
  doc="Sev1: Ausfall für Kunden. Sev2: eingeschränkter Dienst. Sev3: alles andere. Bei Unsicherheit berät der Agent und der Mensch entscheidet."
b bpmn add $f xor "Schweregrad?" --after einordnen --id grad --lane lane_agent
b bpmn add $f userTask "On-Call alarmieren und beheben" --after grad --id sev1 --lane lane_mensch --flow-name "Sev1"
b bpmn add $f serviceTask "Statusseite aktualisieren (Entwurf)" --after sev1 --id status --lane lane_agent \
  doc="Statusseite innerhalb von 15 Minuten."
b bpmn add $f userTask "Statusseite freigeben" --after status --id status_frei --lane lane_mensch
b bpmn add $f serviceTask "Post-Mortem entwerfen" --after status_frei --id pm --lane lane_agent doc="Fällig innerhalb von 5 Arbeitstagen."
b bpmn add $f userTask "Post-Mortem prüfen" --after pm --id pm_pruefen --lane lane_mensch
b bpmn add $f end "Störung abgeschlossen" --after pm_pruefen --id ende --lane lane_agent
b bpmn add $f userTask "Innerhalb eines Arbeitstags beheben" --after grad --id sev2 --lane lane_mensch --flow-name "Sev2"
b bpmn add $f serviceTask "In Backlog eintragen" --after grad --id sev3 --lane lane_agent --flow-name "Sev3"
b bpmn add $f xor --flow flow_pruefenToEnde --id zusammen --lane lane_agent
b bpmn connect $f sev2 zusammen
b bpmn connect $f sev3 zusammen
b bpmn layout $f
b bpmn validate $f >/dev/null

# ---- Bilder zum Ansehen ----
for g in *.bpmn; do b bpmn render "$g" -o "${g%.bpmn}.png"; done
echo "fertig: $(ls "$WURZEL"/unternehmen/prozesse "$WURZEL"/team/prozesse | tr '\n' ' ')"
