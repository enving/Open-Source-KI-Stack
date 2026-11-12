---
type: Firmenprofil
title: Firmenprofil und Bereiche
description: Name, Bereiche des Wikis mit Besitzern und Prüfintervall. Einzige Stelle für diese Angaben; Werkzeuge und Agenten lesen sie von hier.
tags: [firma, bereiche, besitzer]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
pruefintervall_tage: 90
---

# {{FIRMA_NAME}}

{{FIRMA_KURZ}}

## Bereiche

Jeder Bereich ist ein Ordner unter `wiki/`. Der Besitzer entscheidet, was dort gilt; schreiben tut nur der Agent, nach Ja des Besitzers. Besitzer ist das Open-WebUI-Konto (E-Mail), damit der Agent ihn mit `rueckfrage` erreicht.

| Bereich | Ordner | Besitzer | Zweck |
|---|---|---|---|
| Firma | wiki/firma | {{BESITZER_STANDARD}} | Angebot, Positionierung, Stimme, Grundsätze |
| Vertrieb | wiki/vertrieb | {{BESITZER_STANDARD}} | Ablauf von Anfrage bis Auftrag, Vorlagen, Einwände |
| Projekte | wiki/projekte | {{BESITZER_STANDARD}} | Ablauf von Kick-off bis Abschluss, Checklisten |
| Wissenspflege | wiki/wissenspflege | {{BESITZER_STANDARD}} | Wie dieses Wiki gepflegt wird |

Neue Bereiche: Zeile ergänzen, Ordner anlegen, `werkzeuge/wiki-index.sh` laufen lassen.

## Personen

Wer welche Rolle hat. Rollen statt Privatangaben; die E-Mail ist das Open-WebUI-Konto. Bei Anmeldung über Microsoft Entra ID tritt an die Stelle der E-Mail später eine Gruppe (`gruppe:<Name>`), die Entra ID zuweist; siehe Betriebsdoku des Stacks. Administratives (Installationen, Rechte, neue Konten) meldet der Agent per `rueckfrage` an den Firmen-Admin.

| Rolle | Konto |
|---|---|
| Geschäftsführung, OS-Betreuung | {{BESITZER_STANDARD}} |
| Firmen-Admin (Installationen, Rechte, Konten) | {{FIRMEN_ADMIN}} |
