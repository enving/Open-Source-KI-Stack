#!/usr/bin/env bash
set -euo pipefail

# Baut ein OKF-Wiki im persistenten terminal-home-Volume auf und setzt den
# Open-Terminal-Container so neu auf, dass neue Agentläufe dort starten.
if [[ $# -ne 1 || ! -f "$1" ]]; then
  echo "Aufruf: $0 <Compose-env-Datei>" >&2
  exit 2
fi
compose=(docker compose --env-file "$1" -f docker-compose.erweitert.yml)
"${compose[@]}" exec -T open-terminal sh -s <<'CONTAINER_SCRIPT'
set -eu
umask 077
root=/home/user/llm-wiki
mkdir -p "$root/raw" "$root/wiki" "$root/references" "$root/proposals" "$root/skills/openwebui-kommunikation" "$root/skills/firmenwissen-vorschlagen" "$root/steuerung"
write_if_missing() {
  file=$1
  if [ -e "$file" ] || [ -L "$file" ]; then
    cat >/dev/null
  else
    cat > "$file"
  fi
}

write_if_missing "$root/AGENTS.md" <<'EOF'
---
type: AgentSchema
title: Arbeitsregeln für Codex im LLM-Wiki
description: Verbindliches Schema und Ablauf für Agenten, die dieses OKF-Wiki lesen und pflegen.
tags: [agent-schema, okf, codex]
timestamp: 2026-11-12T08:00:00+01:00
---

# LLM-Wiki: Arbeitsregeln für Codex

Dieses Verzeichnis ist der feste Arbeitsbereich für Codex. Das Wiki folgt Karpathys LLM-Wiki-Muster mit unveränderten Rohquellen, einer vom Agenten gepflegten, verlinkten Wissensschicht sowie diesem Schema. Für Wissensdateien gilt OKF v0.1: jedes Konzept hat YAML-Frontmatter mit nichtleerem `type`; `index.md` und `log.md` sind reservierte Dateien.

## Arbeitsbereiche

- `raw/`: vom Menschen ausgewählte Originalquellen. Nicht verändern. Neue Quellen nur nach Auftrag aufnehmen.
- `wiki/`: agentengepflegte, belegte Konzepte und Synthesen.
- `references/`: Quellenbeschreibungen mit URL und Abrufdatum.
- `proposals/`: bereinigte Vorschläge für ein gemeinsames Firmenwissen. Das Verzeichnis ist kein gemeinsamer Speicher.

## Abläufe

- Vor einer Wissensfrage `index.md` und danach nur die passenden Konzepte lesen.
- Beim Einlesen einer Quelle Aussagen mit Belegen extrahieren, bestehende Seiten auf Widersprüche prüfen, neue/aktualisierte Konzepte verlinken, Verzeichniseinträge und `index.md` auffrischen und `log.md` ergänzen.
- Quellenbeleg, Schlussfolgerung und offene Frage sichtbar unterscheiden. Widersprüche nicht glattbügeln.
- Eine Wissensübernahme in den Firmen-Agenten erst nach ausdrücklicher Zustimmung zum konkret gezeigten, bereinigten Vorschlag. Ohne Zustimmung nichts anlegen. Nach Zustimmung nur `proposals/` beschreiben, solange kein bestätigtes gemeinsames Ziel mit Schreibrecht verfügbar ist.
- Keine Zugangsdaten, Kunden-/Personendaten, privaten Hostnamen oder lokalen Host-Pfade in ein gemeinsames Ziel kopieren.
- Vor Änderungen an einem bestehenden Konzept dessen Links und `timestamp` aktualisieren. Änderungen am Schema nicht nebenbei vornehmen.
- Keine Commits oder Veröffentlichungen ohne gesonderten Auftrag.

## Abschluss

Nenne die geänderten Dateien, Quellen, Prüfungen und offene Punkte. Prüfe Links und OKF-Frontmatter, bevor du eine Änderung als fertig meldest.
EOF

write_if_missing "$root/index.md" <<'EOF'
---
okf_version: "0.1"
---

# LLM-Wiki

Ein persistentes, agentengepflegtes Markdown-Wiki. Das Muster trennt unveränderte Rohquellen, verlinkte Wissenskonzepte und Schema/Arbeitsregeln.

## Einstieg

- [Arbeitsablauf und Grenzen](wiki/arbeitsablauf.md)
- [Prüfung fachlicher Widersprüche](wiki/data-owner-pruefung.md)
- [Karpathys LLM-Wiki-Muster](references/karpathy-llm-wiki.md)
- [Open Knowledge Format](references/open-knowledge-format.md)
- [Rohquellen](raw/index.md)
- [Vorschläge für gemeinsames Firmenwissen](proposals/index.md)
- [Skill: Rückfrage per Direktnachricht in OpenWebUI](skills/openwebui-kommunikation/SKILL.md)
- [Skill: Firmenwissen nach erledigter Aufgabe vorschlagen](skills/firmenwissen-vorschlagen/SKILL.md)
- [Systemanweisung des Workspace-Modells](steuerung/systemanweisung-workspace.md)

Änderungshistorie: [log.md](log.md)
EOF

write_if_missing "$root/log.md" <<'EOF'
## 2026-11-12

- **Creation**: Grundstruktur nach Karpathys LLM-Wiki-Muster angelegt: unveränderte Quellen, agentengepflegte Wiki-Konzepte, Schema, Index und Änderungslog.
- **Creation**: OKF v0.1 als Frontmatter-Vertrag für alle Konzepte festgelegt.
- **Creation**: Widerspruchsprüfung mit fachlicher Datenverantwortung und einwilligungsgebundene Vorschläge dokumentiert.
- **Creation**: Skill `openwebui-kommunikation` (Rückfrage per Direktnachricht) unter `skills/` angelegt; für Codex über `~/.agents/skills` verlinkt. Datenverantwortungs-Ablauf verweist darauf.
- **Creation**: Systemanweisung des Workspace-Modells (mit Systemdiagramm) unter `steuerung/` und Skill `firmenwissen-vorschlagen` angelegt; beide werden per Skript nach Open WebUI übertragen.
EOF

write_if_missing "$root/raw/index.md" <<'EOF'
# Rohquellen

Hier werden ausgewählte Originalquellen abgelegt. Codex liest diese Dateien und verändert sie nicht. Quelle, Abrufdatum und Rechte sind je Aufnahme zu dokumentieren.
EOF

write_if_missing "$root/wiki/index.md" <<'EOF'
# Wiki-Konzepte

- [Arbeitsablauf und Grenzen](arbeitsablauf.md) — Quellen aufnehmen, Fragen beantworten, Widersprüche prüfen und Änderungen protokollieren.
- [Prüfung fachlicher Widersprüche](data-owner-pruefung.md) — eine fachliche Datenverantwortung gezielt um Einordnung bitten.
EOF

write_if_missing "$root/wiki/arbeitsablauf.md" <<'EOF'
---
type: Workflow
title: Arbeitsablauf des LLM-Wikis
description: Regeln für Aufnahme, Beantwortung und Pflege von Wissen mit Belegen.
tags: [wiki, wissenspflege, okf]
timestamp: 2026-11-12T08:00:00+01:00
---

# Zweck

Das Wiki hält bereits erarbeitete Synthesen persistent, damit Fragen nicht bei jeder Sitzung aus Rohdokumenten neu zusammengesetzt werden müssen.

# Ablauf

1. Bei einer Wissensfrage zuerst den Index lesen und passende Konzepte nachschlagen.
2. Bei einer neuen Quelle das Original unverändert unter `raw/` ablegen; Herkunft und Abrufdatum festhalten.
3. Aussagen mit Quellenbelegen in bestehende Konzepte integrieren. Seiten verknüpfen und neue Einträge im Index sowie im Änderungslog ergänzen.
4. Bei Widersprüchen beide Aussagen und ihre Quellen getrennt notieren. Eine Synthese kennzeichnet, was belegt ist, was Schlussfolgerung ist und was offen bleibt.
5. Vor einer Übernahme in gemeinsames Firmenwissen einen bereinigten Vorschlag zeigen und die ausdrückliche Zustimmung der Person abwarten.

# Grenzen

Rohquellen sind unveränderlich. Unbestätigte Interpretation wird nicht als Tatsache gespeichert. Das lokale Verzeichnis `proposals/` ist kein gemeinsames Firmenwissen.

# Citations

- [Karpathys LLM-Wiki-Idee](/references/karpathy-llm-wiki.md)
- [OKF v0.1](/references/open-knowledge-format.md)
EOF

write_if_missing "$root/wiki/data-owner-pruefung.md" <<'EOF'
---
type: Playbook
title: Fachliche Datenverantwortung bei Widersprüchen fragen
description: Ein begrenzter Ablauf, um widersprüchliche Aussagen einer zuständigen Person zur Einordnung vorzulegen.
tags: [datenverantwortung, widerspruch, menschliche-pruefung]
timestamp: 2026-11-12T12:00:00+01:00
---

# Wann anwenden

Wenn Codex in freigegebenen Quellen oder im Wiki zwei nicht vereinbare Aussagen findet und die Quellen allein nicht klären, welche fachlich gilt.

# Ablauf

1. Den Themenbereich und beide Aussagen mit ihren Fundstellen benennen.
2. Beleg, Schlussfolgerung und Unsicherheit trennen. Keine der Aussagen ohne Beleg als richtig markieren.
3. Eine fachliche Datenverantwortung direkt fragen, wenn ihre Zuständigkeit bestätigt ist: per Direktnachricht nach dem Skill [Rückfrage per Direktnachricht in OpenWebUI](/skills/openwebui-kommunikation/SKILL.md). Namen nicht aus einer Vermutung ableiten.
4. Die Frage knapp formulieren: „Für [Bereich] stehen [Aussage A, Quelle] und [Aussage B, Quelle] im Konflikt. Welche gilt, sind beide kontextabhängig oder fehlt eine weitere Quelle?“
5. Die Antwort als menschliche Einordnung mit Datum und Bereich dokumentieren; Quellenbelege daneben erhalten.
6. Ohne bestätigte Zuständigkeit oder erreichbaren Privatkanal den Konflikt als offen markieren und im aktuellen Chat um Einordnung bitten.

# Sicherheit

Keine Konflikte mit personenbezogenen oder vertraulichen Inhalten in öffentliche Kanäle, gemeinsame Agentenprompts oder Benachrichtigungen kopieren.

# Citations

- [Arbeitsablauf des LLM-Wikis](/wiki/arbeitsablauf.md)
EOF

write_if_missing "$root/references/karpathy-llm-wiki.md" <<'EOF'
---
type: Reference
title: Karpathys LLM-Wiki-Idee
description: Idee für ein persistent gepflegtes, verlinktes Markdown-Wiki zwischen Originalquellen und späteren LLM-Antworten.
resource: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
tags: [llm-wiki, markdown, wissenspflege]
timestamp: 2026-11-12T08:00:00+01:00
---

# Zusammenfassung

Die Idee unterscheidet sich von reinem RAG: Ein Agent liest neue Quellen, pflegt daraus ein dauerhaftes, verlinktes Wiki und hält Zusammenfassungen, Querverweise und erkennbare Widersprüche aktuell.

# Struktur und Betrieb

- Originalquellen bleiben unverändert und sind die Belegbasis.
- Ein Agent pflegt eine Markdown-Wissensschicht.
- Ein Schema (zum Beispiel `AGENTS.md`) beschreibt Struktur und Abläufe.
- Aufnahme, Fragen und regelmäßige Konsistenzprüfung sind wiederkehrende Arbeitsweisen.
- `index.md` ist der thematische Einstieg; `log.md` hält den chronologischen Verlauf.

Dieses Wiki übernimmt diese Struktur und verwendet OKF-Frontmatter für portable Konzeptmetadaten.

# Citations

- Original: [Andrej Karpathy, llm-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), erstellt 2026-04-04; abgerufen 2026-11-12.
EOF

write_if_missing "$root/references/open-knowledge-format.md" <<'EOF'
---
type: Reference
title: Open Knowledge Format v0.1
description: Offenes Markdown-Bündelformat mit YAML-Frontmatter für agentenlesbares Wissen.
resource: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
tags: [okf, markdown, metadata]
timestamp: 2026-11-12T08:00:00+01:00
---

# Zusammenfassung

OKF bündelt hierarchisch strukturierte Markdown-Konzepte. Jedes Konzeptdokument benötigt YAML-Frontmatter mit nichtleerem `type`. `index.md` und `log.md` sind reservierte Dateinamen.

# Anwendung in diesem Wiki

- Konzepte verwenden `type`, `title`, `description`, `tags` und ISO-8601-`timestamp`.
- `index.md` bietet progressive Navigation, `log.md` hält Änderungen chronologisch fest.
- Querverweise verwenden bevorzugt bundle-absolute Markdown-Links.

# Citations

- [Google Cloud, Open Knowledge Format specification](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md), abgerufen 2026-11-12.
EOF

write_if_missing "$root/proposals/index.md" <<'EOF'
# Entwürfe für gemeinsames Firmenwissen

Hier liegen nur bereinigte Entwürfe nach ausdrücklicher Zustimmung. Dieses Verzeichnis wird nicht automatisch mit einem gemeinsamen Agenten synchronisiert.
EOF

write_if_missing "$root/skills/openwebui-kommunikation/SKILL.md" <<'EOF'
---
name: openwebui-kommunikation
description: Als Firmenagent eine bestimmte Person in OpenWebUI per Direktnachricht fragen und ihre Antwort lesen. Nutzen, wenn nur diese Person etwas klären kann (Widerspruch zwischen Quellen, fachliche Freigabe, fehlende Angabe) und sie nicht im aktuellen Chat ist.
type: Skill
title: Rückfrage per Direktnachricht in OpenWebUI
tags: [openwebui, rueckfrage, datenverantwortung, kommunikation]
timestamp: 2026-11-12T12:00:00+01:00
---

# Rückfrage per Direktnachricht in OpenWebUI

Der Firmenagent hat ein eigenes, normales OpenWebUI-Konto ohne Admin-Rechte. Mit `~/bin/rueckfrage` schreibt er einer Person eine Direktnachricht und erwähnt sie darin. Die Person sieht die Frage in ihrer Inbox, ein Klick öffnet die Unterhaltung, dort antwortet sie.

## Wann nicht

- Die Person sitzt im aktuellen Chat: dort fragen (`ask_user`), keine Direktnachricht.
- Die Antwort steht in freigegebenen Quellen oder im Wiki: erst dort nachsehen.
- Die Zuständigkeit ist unklar: keinen Empfänger raten. Den Punkt als offen markieren und im aktuellen Chat fragen, wer zuständig ist.
- Keine Rundschreiben an viele Personen und keine Fragen aus Neugier. Die Personensuche zeigt Namen und E-Mail-Adressen aller Konten; sie dient nur dazu, eine bereits bekannte zuständige Person zu erreichen.

## Ablauf

1. Empfänger festlegen: nur aus einem Auftrag, einer bestätigten Zuständigkeit im Wiki oder der Antwort der Person im Chat. Die E-Mail-Adresse des OpenWebUI-Kontos verwenden.
2. Frage so schreiben, dass sie ohne Vorwissen beantwortbar ist: Bereich, was vorliegt (mit Fundstellen), die konkrete Frage, mögliche Antworten. Keine Zugangsdaten, keine vertraulichen Inhalte, die die Person nicht ohnehin sehen darf.
3. Senden: `rueckfrage <E-Mail> "<Frage>"`. Die Ausgabe nennt Kanal und Nachricht und den Befehl zum Lesen. Beides im Ergebnis oder im Wiki-Log festhalten, sonst ist die Antwort später nicht zuzuordnen.
4. Antwort lesen: `rueckfrage antworten <Kanal> <Nachricht>`. Exit 0 = Antworten mit Zeit und Name, Exit 3 = noch keine Antwort. Eine neue Antwort wird nicht gemeldet; nicht in einer Schleife abfragen, sondern beim nächsten Arbeitsschritt oder auf Zuruf nachsehen.
5. Antwort verwerten: als menschliche Einordnung mit Datum, Person und Bereich festhalten, die Quellenbelege daneben stehen lassen (siehe [Fachliche Datenverantwortung bei Widersprüchen fragen](/wiki/data-owner-pruefung.md)). Bleibt die Antwort aus, den Punkt als offen melden statt selbst zu entscheiden.

## Ohne eigenes Terminal

Ein Chatmodell ohne Terminalzugriff führt `rueckfrage` nicht selbst aus. Es übergibt die Aufgabe an den freigegebenen Terminal-Agenten, mit Empfänger, fertigem Fragetext und dem Hinweis, Kanal und Nachricht zurückzumelden.

## Grenzen

- Das Werkzeug schreibt nur Direktnachrichten des Firmenagenten. Andere Kanäle und fremde Unterhaltungen liest es nicht.
- Die Zugangsdaten liegen in `~/.config/firmenagent/zugang`. Nie ausgeben, nie in Nachrichten, Wiki oder Vorschläge kopieren.

# Citations

- [Fachliche Datenverantwortung bei Widersprüchen fragen](/wiki/data-owner-pruefung.md)
EOF

write_if_missing "$root/steuerung/systemanweisung-workspace.md" <<'EOF'
---
type: SystemPrompt
title: Systemanweisung des Workspace-Modells in Open WebUI
description: Rolle, Systemaufbau als Diagramm und Arbeitsregeln für das koordinierende Chatmodell. Wird per Skript in das Modell übertragen.
tags: [steuerung, openwebui, systemanweisung]
timestamp: 2026-11-12T12:30:00+01:00
---

Du bist das Workspace-Modell in Open WebUI: die Oberfläche, mit der Menschen arbeiten. Du sprichst mit der Person, zeigst Ergebnisse an und koordinierst. Dateien und Befehle erledigt der Codex-Agent; er kann im Chat nichts anzeigen. Anzeigen ist deine Aufgabe.

## So hängt das System zusammen

```mermaid
flowchart LR
  P[Person im Browser] <--> W[Du: Workspace-Modell]
  W -- "ask_user" --> P
  W -- "delegate_task mit model_id" --> C[Codex-Agent im Terminal-Container]
  C -- Text-Ergebnis --> W
  C --> WK[(LLM-Wiki: raw, wiki, proposals, skills)]
  C -- "rueckfrage" --> FA[Konto Firmenagent]
  FA -- "Direktnachricht + Inbox" --> D[Zuständige Person]
  W -- "Werkzeuge mit Konto der Person" --> CO[Composio]
  CO --> T[Gmail, Kalender, weitere Apps]
```

## Delegieren

- Datei- und Befehlsarbeit gibst du mit `delegate_task` ab, immer mit `model_id: agent:open-terminal:codex:gpt-6-luna`. Ohne `model_id` startet Open WebUI dich selbst noch einmal, nicht Codex. Das ist verboten.
- Gib Ziel, Kontext, Erfolgskriterien und Dateipfade mit. Verlange, dass Codex Inhalte, die die Person sehen soll, vollständig als Text zurückgibt.
- Erhältst du selbst einen Auftrag per `delegate_task`, bist du nicht Codex. Führe keine Dateiaufgaben aus, weiche nicht auf andere Werkzeuge aus, sondern melde die Blockade.
- Ist Codex nicht erreichbar oder scheitert er, sag das so. Erfinde kein Ergebnis.

## Anzeigen

- Was Codex zurückgibt, zeigst du im Chat: als Markdown, Tabelle, Codeblock oder Mermaid-Diagramm. Abläufe und Zusammenhänge zeigst du gern als Mermaid.
- `display_file` funktioniert nur für hochgeladene Dateien mit `file_id`, nicht für Pfade im Terminal-Container. Erfinde keine Datei-URLs.
- Nenne bei Dateien den tatsächlichen Pfad, den Codex gemeldet hat.

## Werkzeuge der Person (Composio)

- Mail, Kalender und weitere Apps laufen über Composio mit dem eigenen Konto der Person, das sie im Chat unter Werkzeuge verbunden hat. Du siehst nur deren Verbindungen.
- Eingerichtet hat die Werkzeuge der Admin dieser Instanz. Personen ohne Admin-Rechte sehen diese Einstellungen nicht; schick sie nicht ins Admin-Panel. Fehlt eine App-Verbindung, erzeugt Composio im Chat einen Verbindungslink.
- Nachrichten an andere sendest du nur auf ausdrücklichen Auftrag; sonst legst du einen Entwurf an.

## Ehrlich bleiben

- Sag, welches Werkzeug was getan hat. Behaupte nichts, was nicht geschehen ist, auch nicht, du hättest etwas eingerichtet.
- Findest du nichts, sag das und markiere die Lücke als offen.

## Skills

- Nach einer erledigten Aufgabe: Skill `firmenwissen-vorschlagen`.
- Muss eine andere Person etwas klären: Skill `openwebui-kommunikation`, ausgeführt durch Codex.

Antworte auf Deutsch und knapp.
EOF

write_if_missing "$root/skills/firmenwissen-vorschlagen/SKILL.md" <<'EOF'
---
name: firmenwissen-vorschlagen
description: Nach einer erledigten Aufgabe vorschlagen, was davon ins gemeinsame Firmenwissen soll, und erst nach Zustimmung einen bereinigten Entwurf anlegen lassen. Anwenden im koordinierenden Workspace-Modell, nicht in einem Teilauftrag.
type: Skill
title: Firmenwissen nach erledigter Aufgabe vorschlagen
tags: [wissenspflege, lernschleife, zustimmung]
timestamp: 2026-11-12T12:30:00+01:00
---

# Firmenwissen nach erledigter Aufgabe vorschlagen

Gilt für das koordinierende Workspace-Modell, nicht für einen Subagenten mit Teilauftrag.

## Wann

Nach jeder tatsächlich erledigten Aufgabe, deren Ergebnis geprüft ist. Derzeit gilt: lieber mehr vorschlagen als zu wenig. Auch ein kleiner Ablaufschritt, eine Vorlage, ein Begriff oder eine Korrektur der Person ist ein Vorschlag wert. Nicht nach Zwischenantworten oder Rückfragen.

## Ablauf

1. Den Baustein in 1–3 Sätzen zeigen und sagen, wem er künftig nützt. Hat die Person ein Ergebnis korrigiert, die Korrektur als möglichen Baustein nennen und einordnen: einmalig oder Regel für das nächste Mal.
2. Mit `ask_user` fragen: „Vorschlag anlegen“ / „Nicht übernehmen“. Das Ja gilt nur für diesen Baustein.
3. Bei Nein nichts schreiben und das bestätigen.
4. Bei Ja den Entwurf von Codex unter `proposals/` im LLM-Wiki anlegen lassen (`delegate_task` mit `model_id`). Inhalt: Baustein, Quelle mit Datum („Chat mit <Rolle>, TT.MM.JJJJ“), Einordnung einmalig/Regel, offene Punkte.
5. Bereinigen: Kundennamen, Kontaktdaten, Mailinhalte, Zugangsdaten und lokale Pfade gehören nicht in den Entwurf. Rollen statt Namen.
6. Den Entwurf im Chat zeigen und deutlich sagen, dass er noch nicht im gemeinsamen Firmenwissen ist. Übernommen wird erst nach Prüfung durch den Besitzer des Bereichs.
7. Kann Codex den Entwurf nicht anlegen, den bereinigten Text im Chat zeigen und die Blockade nennen. Nicht über andere Werkzeuge ausweichen.
EOF

mkdir -p "$HOME/.agents/skills"
for skill in "$root"/skills/*/; do
  skill=$(basename "$skill")
  [ -e "$HOME/.agents/skills/$skill" ] || ln -s "$root/skills/$skill" "$HOME/.agents/skills/$skill"
done

chmod 700 "$root"
printf 'wiki_ready=%s\n' "$root"
CONTAINER_SCRIPT

container_id=$("${compose[@]}" ps -q open-terminal)
current_workdir=$(docker inspect "$container_id" --format '{{.Config.WorkingDir}}' 2>/dev/null || true)
if [[ "$current_workdir" != /home/user/llm-wiki ]]; then
  "${compose[@]}" up -d --no-deps --force-recreate open-terminal
fi
