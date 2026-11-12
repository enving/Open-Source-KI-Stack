---
type: DataMap
title: Landkarte der Datenorte
description: Wo welche Daten außerhalb des Wikis liegen, wie der Agent sie erreicht und welche Regeln je Werkzeug gelten.
tags: [steuerung, landkarte, werkzeuge]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# Landkarte

Laufende Daten bleiben in den Werkzeugen; der Agent liest sie dort mit den Rechten der Person. Ins Wiki kommt nur, was dauerhaft gilt.

| Daten | Ort | Zugang des Agenten | Regeln |
|---|---|---|---|
| Mail, Entwürfe | Gmail der Person | Composio mit dem Konto der Person | Senden nur auf ausdrücklichen Auftrag; sonst Entwurf |
| Kalender | Kalender der Person | Composio, sobald verbunden | Termine anlegen nur nach Frage |
| Chats, Kanäle, Direktnachrichten | Open WebUI | Chat der Person; Firmenagent nur eigene Direktnachrichten | Keine fremden Chats lesen |
| Rückfragen an Personen | Open WebUI Inbox | `rueckfrage` als Konto Firmenagent | Nur an zuständige Personen |
| Administratives: Installationen, Rechte, Konten | Firmen-Admin laut `firma.md` | `rueckfrage` als Konto Firmenagent | Agent installiert und vergibt nichts selbst |
| Wissen, Skills, Regeln | LLM-Wiki im Terminal-Container (Git) | Codex | Änderungen nur als Zweig mit Ja |
| Kunden, Angebote, Fristen von Aufträgen | {{CRM}} | {{CRM_ZUGANG}} | Nicht ins Wiki |

Fehlt ein Ort, ist das eine Lücke: als offen markieren, nicht ins Wiki ausweichen.
