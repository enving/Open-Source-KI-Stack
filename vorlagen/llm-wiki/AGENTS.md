---
type: AgentSchema
title: Arbeitsregeln für Agenten im LLM-Wiki
description: Verbindliches Schema und Ablauf für Agenten, die dieses OKF-Wiki lesen und pflegen.
tags: [agent-schema, okf, codex]
timestamp: {{HEUTE}}T00:00:00+01:00
---

# LLM-Wiki: Arbeitsregeln

Dieses Verzeichnis ist der Arbeitsbereich des Firmenagenten (Codex im Open-Terminal-Container). Es folgt Karpathys LLM-Wiki-Muster: unveränderte Rohquellen, eine vom Agenten gepflegte Wissensschicht, dieses Schema. Für alle Markdown-Dateien gilt OKF v0.1: YAML-Frontmatter mit nichtleerem `type`; `index.md` und `log.md` sind reserviert.

## Aufbau

- `firma.md`: Firmenprofil, Bereiche mit Besitzern, Prüfintervall. Einzige Stelle dafür.
- `wiki/<bereich>/`: Wissen, das dauerhaft gilt (Angebot, Abläufe, Stimme). Ein Ordner je Bereich aus `firma.md`.
- `raw/`: Originalquellen, nur lesen. Neue Quellen nur nach Auftrag.
- `references/`: Quellenbeschreibungen mit URL und Abrufdatum.
- `steuerung/`: Systemanweisung mit Ampel, Landkarte der Datenorte, KI-Inventar mit Rollenprüfung.
- `skills/<name>/SKILL.md`: Anleitungen für wiederkehrende Aufgaben. `evals/<name>/`: Prüffälle dazu.
- `proposals/`: Entwürfe, die noch kein Besitzer bestätigt hat.
- `logbuch/JJJJ-MM.md`: ein Eintrag je erledigtem Skill-Lauf.
- `lernschleife/korrekturen.md`: Zähler der Korrekturen, ohne Inhalte und Namen.
- `werkzeuge/`: Prüf-, Index- und Eval-Skripte.

## Pflichtfelder

- Jede Datei unter `wiki/`, `skills/` und `steuerung/` trägt `geprueft: JJJJ-MM-TT`. Ist das länger her als `pruefintervall_tage` in `firma.md`, ist die Datei fällig und der Besitzer wird erinnert.
- Jede Aussage im Wiki hat eine Quelle, etwa „(Quelle: Ansage Geschäftsführung, 12.11.2026)“ oder einen Link nach `raw/` oder `references/`.
- Den Besitzer einer Datei bestimmt ihr Bereich in `firma.md`.

## Was nicht ins Wiki gehört

Kundendaten, Mailinhalte, laufende Vorgänge und Fristen einzelner Aufträge bleiben in den Werkzeugen (siehe `steuerung/landkarte.md`). Zugangsdaten, Personaldaten und Verträge nie.

## Abläufe

- Vor einer Wissensfrage `index.md` lesen, dann nur die passenden Dateien.
- Findest du nichts, erfinde nichts: Lücke als offen melden.
- Widerspricht etwas dem Wiki, nicht selbst auflösen, sondern dem Besitzer vorlegen (Skill `openwebui-kommunikation`).
- Jede Änderung ist ein Vorschlag: auf einem Zweig `vorschlag/<datum>-<kurz>` arbeiten, committen, Diff zeigen. In `main` erst nach Ja des Besitzers. `log.md` ergänzen, `werkzeuge/wiki-index.sh` und `werkzeuge/wiki-pruefen.sh` laufen lassen.
- Korrekturen von Menschen: Skill `lernschleife`.
- Neuer Agent, neues Modell, neue Werkzeuge oder neuer Zweck: `steuerung/ki-inventar.md` prüfen und die Geschäftsführung fragen, bevor es eingesetzt wird.
- Nach jedem erledigten Skill-Lauf eine Zeile in `logbuch/JJJJ-MM.md`: Datum, Skill, Auslöser, Ergebnis, offene Punkte. Ohne Kundendaten.

## Abschluss

Nenne geänderte Dateien, Zweig, Prüfergebnis von `werkzeuge/wiki-pruefen.sh` und offene Punkte.
