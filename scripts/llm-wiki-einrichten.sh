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
mkdir -p "$root/raw" "$root/wiki" "$root/references" "$root/proposals"
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

Änderungshistorie: [log.md](log.md)
EOF

write_if_missing "$root/log.md" <<'EOF'
## 2026-11-12

- **Creation**: Grundstruktur nach Karpathys LLM-Wiki-Muster angelegt: unveränderte Quellen, agentengepflegte Wiki-Konzepte, Schema, Index und Änderungslog.
- **Creation**: OKF v0.1 als Frontmatter-Vertrag für alle Konzepte festgelegt.
- **Creation**: Widerspruchsprüfung mit fachlicher Datenverantwortung und einwilligungsgebundene Vorschläge dokumentiert.
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
timestamp: 2026-11-12T08:00:00+01:00
---

# Wann anwenden

Wenn Codex in freigegebenen Quellen oder im Wiki zwei nicht vereinbare Aussagen findet und die Quellen allein nicht klären, welche fachlich gilt.

# Ablauf

1. Den Themenbereich und beide Aussagen mit ihren Fundstellen benennen.
2. Beleg, Schlussfolgerung und Unsicherheit trennen. Keine der Aussagen ohne Beleg als richtig markieren.
3. Eine fachliche Datenverantwortung nur dann direkt fragen, wenn OpenWebUI dafür einen privaten, auf diese Person begrenzten Zielkanal bereitstellt. Namen nicht aus einer Vermutung ableiten.
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

chmod 700 "$root"
printf 'wiki_ready=%s\n' "$root"
CONTAINER_SCRIPT

container_id=$("${compose[@]}" ps -q open-terminal)
current_workdir=$(docker inspect "$container_id" --format '{{.Config.WorkingDir}}' 2>/dev/null || true)
if [[ "$current_workdir" != /home/user/llm-wiki ]]; then
  "${compose[@]}" up -d --no-deps --force-recreate open-terminal
fi
