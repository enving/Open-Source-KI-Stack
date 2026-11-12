---
name: onboarding
description: Eine neue Person aktiv an die Arbeit mit dem Firmenagenten heranführen. Begrüßung per Direktnachricht, die fünf Dinge, die sie wissen muss, Rolle erfragen und in firma.md als Vorschlag eintragen. Nutzen, wenn ein neues Konto auftaucht, jemand fragt „wie nutze ich das?“ oder die Geschäftsführung um Onboarding bittet.
type: Skill
title: Onboarding einer neuen Person
tags: [onboarding, nutzung, personen]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# Onboarding einer neuen Person

Ziel: Die Person kann nach der ersten Woche selbst mit dem Agenten arbeiten und weiß, wo sie Hilfe bekommt.

## Begrüßung (Codex, per `rueckfrage`)

Nur auf Auftrag einer Person mit Rolle Geschäftsführung oder Firmen-Admin (`firma.md`) oder wenn die Person selbst fragt. Eine Nachricht, kurz, in der Anrede der Firma (`wiki/firma`, sonst „du“). Inhalt:

1. Wer schreibt: der Firmenagent, ein Konto für Rückfragen; gearbeitet wird im Chat mit dem Workspace-Modell.
2. Werkzeuge: im Chat unter „Werkzeuge“ das eigene Composio-Konto verbinden; der Agent arbeitet dann nur mit den Rechten und Postfächern dieser Person.
3. Ampel in einem Satz: Entwürfe macht er selbst, Senden, Termine und Wiki-Änderungen nur nach ihrem Ja.
4. Korrigieren ist erwünscht („so nicht, sondern …“); der Agent fragt dann, ob das eine Regel wird.
5. Rückfragen des Agenten kommen als Direktnachricht in die Inbox; dort antworten.

Zum Schluss genau eine Frage: welche Rolle sie hat und wobei der Agent zuerst helfen soll. Kanal und Nachricht festhalten.

## Antwort verwerten

- Mit `rueckfrage antworten` lesen. Die Rolle als Vorschlag in die Tabelle „Personen“ in `firma.md` (Zweig, Ja der Geschäftsführung). Keine weiteren Privatangaben.
- Den genannten ersten Wunsch im Chat aufgreifen oder als offenen Punkt ins Logbuch schreiben.
- Nach einer Woche ohne Nutzung höchstens einmal freundlich nachfragen.

## Im Chat

Fragt jemand „wie nutze ich das?“, dieselben fünf Punkte knapp erklären und anbieten, eine erste echte Aufgabe gemeinsam zu machen.

## Grenzen

- Keine Rechte vergeben oder Werkzeuge installieren. Dafür den Firmen-Admin aus `firma.md` per `rueckfrage` benachrichtigen.
- Kein Onboarding-Rundschreiben an alle Konten.
