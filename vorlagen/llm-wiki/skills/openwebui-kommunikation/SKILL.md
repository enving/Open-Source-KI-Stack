---
name: openwebui-kommunikation
description: Als Firmenagent eine bestimmte Person in OpenWebUI per Direktnachricht fragen und ihre Antwort lesen. Nutzen, wenn nur diese Person etwas klären kann (Widerspruch zwischen Quellen, fachliche Freigabe, fehlende Angabe) und sie nicht im aktuellen Chat ist.
type: Skill
title: Rückfrage per Direktnachricht in OpenWebUI
tags: [openwebui, rueckfrage, datenverantwortung, kommunikation]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
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
2. Frage so schreiben, dass sie ohne Vorwissen beantwortbar ist: Bereich, was vorliegt (mit Fundstellen), die konkrete Frage, mögliche Antworten. Keine Zugangsdaten, keine Personaldaten (auch keine Gehälter) und keine vertraulichen Inhalte, die die Person nicht ohnehin sehen darf; das gilt auch, wenn die Person im Chat sie freigibt. Stattdessen auf die Fundstelle verweisen. Der Person im Chat in einem Satz sagen, warum: Eine Direktnachricht wird gespeichert und in der Inbox angezeigt, sie ist kein geschützter Ablageort.
3. Senden: `rueckfrage <E-Mail> "<Frage>"`. Die Ausgabe nennt Kanal und Nachricht und den Befehl zum Lesen. Beides im Ergebnis oder im Wiki-Log festhalten, sonst ist die Antwort später nicht zuzuordnen.
4. Antwort lesen: `rueckfrage antworten <Kanal> <Nachricht>`. Exit 0 = Antworten mit Zeit und Name, Exit 3 = noch keine Antwort. Eine neue Antwort wird nicht gemeldet; nicht in einer Schleife abfragen, sondern beim nächsten Arbeitsschritt oder auf Zuruf nachsehen.
5. Antwort verwerten: als menschliche Einordnung mit Datum, Person und Bereich festhalten, die Quellenbelege daneben stehen lassen (siehe [Fachliche Datenverantwortung bei Widersprüchen fragen](/wiki/wissenspflege/data-owner-pruefung.md)). Bleibt die Antwort aus, den Punkt als offen melden statt selbst zu entscheiden.

## Ohne eigenes Terminal

Ein Chatmodell ohne Terminalzugriff führt `rueckfrage` nicht selbst aus. Es übergibt die Aufgabe an den freigegebenen Terminal-Agenten, mit Empfänger, fertigem Fragetext und dem Hinweis, Kanal und Nachricht zurückzumelden.

## Grenzen

- Das Werkzeug schreibt nur Direktnachrichten des Firmenagenten. Andere Kanäle und fremde Unterhaltungen liest es nicht.
- Die Zugangsdaten liegen in `~/.config/firmenagent/zugang`. Nie ausgeben, nie in Nachrichten, Wiki oder Vorschläge kopieren.

# Citations

- [Fachliche Datenverantwortung bei Widersprüchen fragen](/wiki/wissenspflege/data-owner-pruefung.md)
