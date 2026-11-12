---
type: Reference
title: Open Knowledge Format v0.1
description: Offenes Markdown-Bündelformat mit YAML-Frontmatter für agentenlesbares Wissen.
resource: https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md
tags: [okf, markdown, metadata]
timestamp: {{HEUTE}}T00:00:00+01:00
---

# Zusammenfassung

OKF bündelt hierarchisch strukturierte Markdown-Konzepte. Jedes Konzeptdokument benötigt YAML-Frontmatter mit nichtleerem `type`. `index.md` und `log.md` sind reservierte Dateinamen.

# Anwendung in diesem Wiki

- Konzepte verwenden `type`, `title`, `description`, `tags` und ISO-8601-`timestamp`.
- `index.md` bietet progressive Navigation, `log.md` hält Änderungen chronologisch fest.
- Querverweise verwenden bevorzugt bundle-absolute Markdown-Links.

# Citations

- [Google Cloud, Open Knowledge Format specification](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md), abgerufen 2026-11-12.
