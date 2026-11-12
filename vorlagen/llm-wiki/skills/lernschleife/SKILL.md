---
name: lernschleife
description: Wenn eine Person ein Ergebnis korrigiert oder sagt „so nicht“, die Korrektur einordnen (einmalig oder Regel), zählen und eine Regel nur mit Prüffall und Ja eines Menschen übernehmen. Das System lernt über Dateien, nicht über den Chat.
type: Skill
title: Lernschleife – aus Korrekturen Regeln machen
tags: [lernschleife, korrektur, evals, git]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# Lernschleife

Der Agent lernt nichts dazu. Besser werden die Dateien, die er liest. Eine Korrektur, die nur im Chat passiert, ist im nächsten Chat weg.

## Zwei Grundsätze

- Im Zweifel ist eine Korrektur einmalig.
- Nichts ändert sich still. Jede neue Regel braucht ein Ja von einem Menschen und einen Prüffall.

## Ablauf (Workspace-Modell im Chat)

1. Erkennen: Die Person ändert ein Ergebnis, lehnt es ab oder sagt, wie es richtig wäre.
2. Einordnen und der Person in einem Satz zeigen: einmalig (nur dieser Fall) oder Regel (wäre beim nächsten Mal wieder nötig). Kurz begründen.
3. Zählen, immer, auch bei einmalig: Codex ruft `werkzeuge/korrektur-zaehlen.sh <skill-oder-bereich> <muster-kennung> einmalig|regel` auf. Die Muster-Kennung ist ein kurzes, wiederverwendbares Stichwort (`termin-fehlt`, `zu-foermlich`). Keine Inhalte, keine Namen.
4. Bei Regel mit `ask_user` vorschlagen:
   - wo sie hingehört (Skill, Wiki-Datei, `steuerung/systemanweisung-workspace.md`),
   - wie sie lautet (ein bis zwei Sätze),
   - der Prüffall, an dem sie getestet wird (Bitte, erwartetes Verhalten).
   Optionen: „Regel übernehmen“ / „Nur einmalig“.
5. Bei Ja: Codex legt Zweig `vorschlag/<datum>-<muster-kennung>` an, ändert die Datei, legt den Prüffall unter `evals/<skill>/` an, committet und gibt den Diff zurück. Du zeigst den Diff.
6. Übernahme in `main`: nur nach Ja des Besitzers des Bereichs (`firma.md`). Ist das die Person im Chat, reicht ihr Ja. Sonst fragt Codex den Besitzer per `rueckfrage`.
7. Nach der Übernahme lässt Codex `werkzeuge/eval-laufen.sh <skill>` laufen. Fällt ein Prüffall durch, wird nicht übernommen.

## Ablauf (Codex)

- Arbeite nur auf dem Zweig. `main` änderst du nur mit `git merge --ff-only` nach bestätigtem Ja.
- `werkzeuge/wiki-pruefen.sh` muss ohne Fehler laufen, bevor du den Diff zurückgibst.

## Wöchentlich

`werkzeuge/os-check.sh` zählt die Korrekturen. Erst ab drei gleichen Mustern schlägt es eine Regel vor, höchstens drei pro Woche.
