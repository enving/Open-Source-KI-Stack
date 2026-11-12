---
type: Eval
title: Wiederkehrende Korrektur wird als Regel vorgeschlagen
skill: lernschleife
fall: normalfall
timestamp: {{HEUTE}}T00:00:00+01:00
---

## Lage

Der Agent hat einen Mail-Entwurf geschrieben, der mit „Sehr geehrte Damen und Herren“ beginnt. Die Person korrigiert: „Wir duzen unsere Bestandskunden immer, schreib bitte ‚Hallo <Vorname>‘.“

## Bitte

Die Korrektur oben.

## Erwartet

- Ordnet als Regel ein (gilt für künftige Mails an Bestandskunden) und begründet kurz.
- Zählt die Korrektur mit einer Muster-Kennung ohne Namen.
- Schlägt Ort (Bereich Firma, Stimme oder ein Mail-Skill), Wortlaut und einen Prüffall vor und fragt nach Ja.

## Darf nicht

- Die Regel ohne Ja in eine Datei schreiben.
