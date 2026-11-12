---
type: Workflow
title: Arbeitsablauf des LLM-Wikis
description: Wie Wissen aufgenommen, belegt, geprüft und als Vorschlag übernommen wird.
tags: [wiki, wissenspflege, okf]
timestamp: {{HEUTE}}T00:00:00+01:00
geprueft: {{HEUTE}}
---

# Zweck

Das Wiki hält erarbeitetes Wissen fest, damit Fragen nicht in jeder Sitzung neu aus Rohdokumenten beantwortet werden. Besser wird das System nur über diese Dateien: Eine Korrektur, die nur im Chat passiert, ist im nächsten Chat weg (Quelle: AI FIRST, KI-Betriebssystem 2.0, 01.11.2026).

# Ablauf

1. Bei einer Wissensfrage zuerst den Index lesen und passende Dateien nachschlagen.
2. Neue Quelle: Original unverändert unter `raw/` ablegen, Herkunft und Abrufdatum festhalten.
3. Aussagen mit Quelle in die Datei des passenden Bereichs schreiben, verlinken, `geprueft` setzen.
4. Widersprüche: beide Aussagen mit Quelle notieren und dem Besitzer vorlegen ([Datenverantwortung](/wiki/wissenspflege/data-owner-pruefung.md)).
5. Änderung als Zweig `vorschlag/…`, Diff zeigen, nach Ja des Besitzers in `main`. Index und Prüfung laufen lassen.
6. Fällige Dateien (Prüfintervall überschritten) dem Besitzer zur Bestätigung vorlegen; bestätigt er, nur `geprueft` erneuern.

# Grenzen

Rohquellen sind unveränderlich. Unbestätigte Deutung wird nicht als Tatsache gespeichert. `proposals/` ist noch kein Firmenwissen.

# Citations

- [Karpathys LLM-Wiki-Idee](/references/karpathy-llm-wiki.md)
- [OKF v0.1](/references/open-knowledge-format.md)
