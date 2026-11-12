---
type: Reference
title: Karpathys LLM-Wiki-Idee
description: Idee für ein persistent gepflegtes, verlinktes Markdown-Wiki zwischen Originalquellen und späteren LLM-Antworten.
resource: https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f
tags: [llm-wiki, markdown, wissenspflege]
timestamp: {{HEUTE}}T00:00:00+01:00
---

# Zusammenfassung

Die Idee unterscheidet sich von reinem RAG: Ein Agent liest neue Quellen, pflegt daraus ein dauerhaftes, verlinktes Wiki und hält Zusammenfassungen, Querverweise und erkennbare Widersprüche aktuell.

# Struktur und Betrieb

- Originalquellen bleiben unverändert und sind die Belegbasis.
- Ein Agent pflegt eine Markdown-Wissensschicht.
- Ein Schema (zum Beispiel `AGENTS.md`) beschreibt Struktur und Abläufe.
- Aufnahme, Fragen und regelmäßige Konsistenzprüfung sind wiederkehrende Arbeitsweisen.
- `index.md` ist der thematische Einstieg; `log.md` hält den chronologischen Verlauf.

Dieses Wiki übernimmt diese Struktur und verwendet OKF-Frontmatter für portable Konzeptmetadaten.

# Citations

- Original: [Andrej Karpathy, llm-wiki gist](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f), erstellt 2026-04-04; abgerufen 2026-11-12.
