---
type: AIInventory
title: KI-Inventar und Rollenprüfung
description: Welche KI-Systeme die Firma einsetzt, wozu, in welcher Rolle nach der KI-Verordnung und mit welcher Risikoklasse. Vor dem ersten Einsatz und bei jeder Zweckänderung prüfen.
tags: [steuerung, governance, ki-verordnung, iso-42001]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# KI-Inventar

Vorbefüllt aus der Vorlage des Open-Source-KI-Stacks. **Die Einordnung trifft die Firma**; die Einträge unten sind Vorschläge, keine Rechtsberatung. Herleitung der Rollen: kobetriebssystem, `docs/architektur/anbieterrolle-und-pflichtenabdeckung-2026-11-09.md`; Vorlage für ausführliche Prüfungen: kobetriebssystem, `ki-inventar/`.

| System | Zweck | Name, unter dem es läuft | Rolle der Firma | Risikoklasse | Anhang-III-Zweck? | Verantwortlich | Stand |
|---|---|---|---|---|---|---|---|
| Workspace-Modell in Open WebUI | Chat, Entwürfe, Recherche, Koordination | {{FIRMA_NAME}} | Anbieter und Betreiber (selbst zusammengestellt, Eigengebrauch) | gering, solange kein Anhang-III-Zweck | nein (zu prüfen) | {{FIRMEN_ADMIN}} | Vorschlag |
| Firmenagent (Codex im Terminal-Container) | Dateien und Wiki pflegen, Rückfragen an Personen | {{FIRMA_NAME}} | Anbieter und Betreiber | gering, solange kein Anhang-III-Zweck | nein (zu prüfen) | {{FIRMEN_ADMIN}} | Vorschlag |

## Was der Stack zu den Pflichten beiträgt

- **Hinweis, dass man mit einer KI spricht:** Der Firmenagent stellt sich in jeder Direktnachricht als solcher vor (Skill `onboarding`).
- **KI-Kompetenz:** Onboarding erklärt Nutzung, Ampel und Korrektur; offen bleibt eine Schulung je Rolle.
- **Klare Grenzen:** ein Firmenagent, Werkzeuge mit den Rechten der Person, Ampel in der Systemanweisung, Sandbox im Container.
- **Nachvollziehbarkeit:** Logbuch je Skill-Lauf, Wiki unter Git, Prüffälle mit Ergebnissen, wöchentlicher OS-Check.
- **Verbesserung mit Freigabe:** Lernschleife nur mit Ja eines Menschen und Prüffall.

## Wann neu prüfen

Neuer Agent oder neues Modell, neuer Zweck, neue Werkzeuge mit Zugriff auf Personendaten, Bewerbungen, Leistungsbewertung, Kreditwürdigkeit oder Versicherungstarife (Anhang III). Dann vor dem Einsatz die Geschäftsführung fragen.
