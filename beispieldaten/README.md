# Beispieldaten und BPMN-Werkzeug

Ein wiederholbarer Grundstock **erfundener** Daten, um ein KI-Betriebssystem in einer abgeschotteten Umgebung auszuprobieren
(zum Beispiel dem eigenen macOS-Benutzer, den Open Terminal bedient, siehe `../docs/erweiterter-stack-betrieb.md`). Dazu der
BPMN-Befehl `bpmn`, damit Prozesse für Menschen und Firmen-Agenten modelliert werden können.

Die Daten liegen **nicht** im Repo. Das Repo hält nur das, was sie wieder herstellt. Installierte Werkzeuge (hier `bpmn`) stehen im
[Installationsregister](../docs/installationen.md).

| Datei | Zweck |
|---|---|
| `bauen.py` | Baut die Daten aus zwei öffentlichen Quellen, getrennt in `unternehmen/` und `team/` (nur Standardbibliothek) |
| `prozesse.sh` | Baut zwei BPMN-Beispielprozesse (Erstattung, Störung) mit dem `bpmn`-Befehl |
| `git-einrichten.sh` | Macht aus den gebauten Daten ein Git-Repo (Standard) und legt `ARBEITSWEISE.md` dazu |
| `installieren-bpmn.sh` | Installiert den `bpmn`-Befehl in fester Version ohne Administratorrechte |
| `ausgabe-README.md`, `ausgabe-ARBEITSWEISE.md` | Werden in die gebauten Daten kopiert (`README.md`, `ARBEITSWEISE.md`); beschreiben dort Aufbau und gleichzeitiges Arbeiten |

## Quellen und Lizenzen

- **Tidewell Software**: Beispielfirma aus [enving/kobench](https://github.com/enving/kobench), `daten/beispiel` (MIT).
- **Sinabis Green Energy**: synthetische E-Mails und Kalendereinträge, Hugging Face
  [`sinabis-group/sinabis-10m-synthetic-emails`](https://huggingface.co/datasets/sinabis-group/sinabis-10m-synthetic-emails)
  (CC-BY-4.0, Namensnennung nötig). Das Skript erwartet einen schon entpackten Ausschnitt: einen Ordner mit `.eml`, eine
  `manifest.json` mit der Liste `dateien[].datei` und einen Ordner mit `.ics`.

Nicht verwendet wird alles, was echte oder fremde Firmeninhalte enthalten kann (zum Beispiel Simulator-Abzüge).

## Ablauf

```bash
# 1. bpmn-Befehl (Node.js 24 oder neuer; unter dem Benutzer, der ihn nutzen soll)
./installieren-bpmn.sh                       # danach: export PATH="$HOME/.local/bin:$PATH"

# 2. Daten bauen (Ordner muss leer oder neu sein)
python3 -I bauen.py --kobench <kobench> --mails <ordner-eml> --mails-manifest <manifest.json> \
                    --ics <ordner-ics> --ziel <ziel>

# 3. Prozesse dazubauen
./prozesse.sh <ziel>

# 4. Git-Repo anlegen (erst jetzt, damit der erste Commit alles enthält)
./git-einrichten.sh <ziel>
```

Standardumfang (änderbar über Optionen): 150 Rundmails und Systemmails sowie 20 große Termine im Unternehmen; 150 interne
Mails, 100 Kundenmails und 40 kleine Termine im Team; 42 Tidewell-Dokumente verteilt nach Rechtekreis; rund 8 MB.

Läuft das Ziel unter einem anderen Benutzer (der die Quellen nicht lesen darf), baut man in einem neutralen Ordner wie `/tmp`
und kopiert das Ergebnis dem Zielbenutzer ins Home. Prüfen: `bpmn validate <ziel>/unternehmen/prozesse/erstattung.bpmn`.

## BPMN: Mensch und Agent

Der Befehl `bpmn` ([Miragon/bpmn-cli](https://github.com/Miragon/bpmn-cli), MIT) lässt einen Agenten Prozesse benennen statt XML
zu schreiben, prüft sie (`validate`) und zeichnet sie (`render`). Die Dateien öffnen sich in jedem BPMN-Werkzeug.

Konvention in den Beispielen: zwei Bahnen, **Mensch** (`userTask`) und **Firmen-Agent** (`serviceTask`). Nicht alles soll der
Agent können. Wo ein Mensch entscheidet oder eine Regel zur Änderung ansteht, steht ein Menschen-Schritt; der Agent berät dort,
entschieden wird vom Menschen. Ob daraus später ein Adapter im KI-Betriebssystem wird, ist offen; hier ist es nur das
Werkzeug und zwei Beispiele.

## Mehrere gleichzeitig: Git und die Grenze

Die Daten sind ein Git-Repo, damit mehrere Personen und Agenten gleichzeitig arbeiten können. Jede Aufgabe bekommt einen eigenen
Worktree auf eigenem Zweig; zusammengeführt wird erst nach Freigabe. Ändern zwei dieselbe Stelle, stoppt Git mit einem sichtbaren
Konflikt statt still zu überschreiben. Der Ablauf steht in `ARBEITSWEISE.md` im Ergebnis. Geprüft (11.11.2026): zwei Zweige ändern
dieselbe Zeile, der erste lässt sich zusammenführen, der zweite endet im Konflikt.

Was Git nicht löst: inhaltlich widersprüchliche, aber sauber mergebare Änderungen, und Rechte pro Bereich. Dafür bleiben Freigabe
durch einen Menschen und der Zugriff auf den Ordner.

**AionUi** ([iOfficeAI/AionUi](https://github.com/iOfficeAI/AionUi), Apache-2.0) löst das nach unserer Prüfung nicht (Einschätzung
Sonnet 5.5, 11.11.2026). Die README trennt den Kontext je Konversation, aber im Team-Modus teilen sich alle Agenten denselben Ordner
(`readme.md`, Zeilen 188 und 195: „all agents share the same folder“, „all agents read/write the same folder“). Das WebUI kennt
laut Wiki nur das Konto `admin`; Worktrees pro Agent, Sperren oder einen Merge-Schritt fanden wir nicht (Stichwortsuche, nicht
ausgeführt). Offene Fehler zu gleichzeitigem Betrieb: #4359 („database is locked“), #3832 (verlorene Nachrichten). Das
Rust-Backend wurde nicht geprüft.
