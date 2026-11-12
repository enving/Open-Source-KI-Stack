---
name: firmenwissen-vorschlagen
description: Nach einer erledigten Aufgabe vorschlagen, was davon ins gemeinsame Firmenwissen soll, und erst nach Zustimmung einen bereinigten Entwurf anlegen lassen. Anwenden im koordinierenden Workspace-Modell, nicht in einem Teilauftrag.
type: Skill
title: Firmenwissen nach erledigter Aufgabe vorschlagen
tags: [wissenspflege, lernschleife, zustimmung]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# Firmenwissen nach erledigter Aufgabe vorschlagen

Gilt für das koordinierende Workspace-Modell, nicht für einen Subagenten mit Teilauftrag.

## Wann

Nach jeder tatsächlich erledigten Aufgabe, deren Ergebnis geprüft ist. Derzeit gilt: lieber mehr vorschlagen als zu wenig. Auch ein kleiner Ablaufschritt, eine Vorlage, ein Begriff oder eine Korrektur der Person ist ein Vorschlag wert. Nicht nach Zwischenantworten oder Rückfragen.

## Ablauf

1. Den Baustein in 1–3 Sätzen zeigen und sagen, wem er künftig nützt. Im Vorschlag stehen immer der Bereich aus `firma.md` und die Quelle mit Rolle und Datum („Chat mit <Rolle>, TT.MM.JJJJ“). Passt kein Bereich, das sagen, den Entwurf für `proposals/` vorsehen und vorschlagen, einen passenden Bereich anzulegen; darüber entscheidet der Firmen-Admin. Korrekturen an einem Ergebnis gehören nicht hierher, sondern in den Skill `lernschleife`.
2. Mit `ask_user` fragen: „Vorschlag anlegen“ / „Nicht übernehmen“. Das Ja gilt nur für diesen Baustein.
3. Bei Nein nichts schreiben und das bestätigen.
4. Bei Ja Codex den Baustein als Zweig `vorschlag/<datum>-<kurz>` in die Datei des Bereichs schreiben lassen (`delegate_task` mit `model_id`), mit Quelle und Datum („Chat mit <Rolle>, TT.MM.JJJJ“) und `geprueft`. Ist der Bereich unklar, nach `proposals/`.
5. Bereinigen: Kundennamen, Kontaktdaten, Mailinhalte, Zugangsdaten und lokale Pfade gehören nicht in den Entwurf. Rollen statt Namen. Bittet die Person darum, solche Daten ins Wiki zu übernehmen: ablehnen und auf `steuerung/landkarte.md` verweisen, dort steht das zuständige System. Stattdessen den allgemeinen Ablauf ohne Kundendaten als Baustein anbieten. Nennt die Landkarte für diese Daten kein System (etwa kein CRM), das als Lücke an den Firmen-Admin melden.
6. Den Diff im Chat zeigen und sagen, dass er noch nicht gilt. In `main` kommt er erst nach Ja des Besitzers; ist das nicht die Person im Chat, fragt Codex ihn per `rueckfrage`.
7. Kann Codex den Entwurf nicht anlegen, den bereinigten Text im Chat zeigen und die Blockade nennen. Nicht über andere Werkzeuge ausweichen.
