# Beispieldaten (alles erfunden)

Grundstock zum Ausprobieren eines KI-Betriebssystems. **Nichts davon ist echt.** Gebaut mit `bauen.py` und `prozesse.sh` aus dem
Repo Open-Source-KI-Stack (Ordner `beispieldaten/`); gleiche Eingabe ergibt dieselben Dateien (Seed 42).

## Aufbau: zwei Ebenen

```
unternehmen/   was die ganze Firma sieht
  tidewell/      Wiki-Seiten und Dateien mit Kreis "alle"
  sinabis/       mails/ (Rundmails, Systemmails), kalender/ (große Termine ab 6 Teilnehmenden)
  prozesse/      erstattung.bpmn (+ .png)
team/          was ein Team intern und mit Kunden hat
  tidewell/      vertrieb/ technik/ finance/ (CRM, Slack, Tickets, Wiki, Verträge je Rechtekreis)
  sinabis/       mails-intern/ (Person zu Person, intern), mails-kunden/ (mit Externen), kalender/ (kleine Termine)
  prozesse/      stoerung.bpmn (+ .png)
pruefung/      Fragen mit Musterantworten (Tidewell, am Korpus belegt)
rechte-tidewell.yaml   wer welchen Kreis sieht
manifest.json          jede Datei mit Herkunft
```

Warum so: Ein Agent soll lernen, dass nicht alles für alle ist. `unternehmen/` ist offen für alle, `team/` gehört dem Team.
Bei Tidewell folgt die Aufteilung den Rechtekreisen (`alle` → Unternehmen, `vertrieb`/`technik`/`finance` → Team). Bei Sinabis
folgt sie der Art der Nachricht: automatische und Rundmails gehen ans Unternehmen, Mails zwischen Personen ans Team.

## Zwei Firmen

- **Tidewell Software** (kobench, MIT): CRM-Konten, Slack-Kanäle, Jira-Tickets, Wiki-Seiten, SharePoint-Dateien, englisch.
  Passende Fragen: `pruefung/tidewell-fragen.yaml`, Rechte: `rechte-tidewell.yaml`.
- **Sinabis Green Energy** (nur vorhanden, wenn beim Bauen angegeben; sonst fehlen die Ordner `sinabis/`) (Hugging Face `sinabis-group/sinabis-10m-synthetic-emails`, CC-BY-4.0): E-Mails (`.eml`, Kopf
  `X-Synthetic-Data`) und Kalendereinträge (`.ics`), englisch. Keine Verknüpfung zu Tidewell, keine Musterantworten; dient als
  realistisches Rauschen und für eigene Fragen.

Die beiden Firmen haben nichts miteinander zu tun. Verknüpfungen zwischen ihnen wären erfunden.

## Gleichzeitiges Arbeiten

Dieser Ordner ist ein Git-Repo. Wie mehrere Personen und Agenten sich nicht überschreiben: `ARBEITSWEISE.md`.

## Prozesse (BPMN)

`prozesse/*.bpmn` öffnet jedes BPMN-Werkzeug (Camunda Modeler, bpmn.io). Mit dem Befehl `bpmn` lesen und ändern: `bpmn show <datei>`,
`bpmn validate <datei>`, `bpmn render <datei> -o bild.png`. Konvention: Bahn **Mensch** (Aufgabe „userTask“) gegen Bahn
**Firmen-Agent** (Aufgabe „serviceTask“). Der Agent erledigt nicht alles: Wo ein Mensch entscheidet oder die Regel geändert
werden sollte, steht ein Menschen-Schritt, und der Agent berät dort (siehe `doc` am Schritt).
