# Installationsregister

Die **eine** Stelle, an der steht, welche Werkzeuge außerhalb der Docker-Images für diesen Stack installiert werden, in welcher
Version und womit. Wer den Stack auf einer anderen Maschine aufbauen will, findet hier den Weg; wer etwas installiert, trägt es
hier ein (Regel in [../AGENTS.md](../AGENTS.md)). Container-Images stehen nicht hier, sie sind per Digest in den
Compose-Dateien festgelegt.

Status: **Skript** = im Repo, Version fest, auf frischem Ziel ausgeführt. **Lücke** = bisher von Hand gemacht, es gibt noch kein
Skript im Repo; der Eintrag hält fest, was fehlt.

| Werkzeug | Version | Wofür | Wie installiert | Status |
|---|---|---|---|---|
| bpmn-cli ([Miragon/bpmn-cli](https://github.com/Miragon/bpmn-cli), MIT) | 0.10.0 (fest; vor 1.0 können Nebenversionen Befehle ändern) | Prozesse für Menschen und Firmen-Agenten modellieren, prüfen, zeichnen | [`beispieldaten/installieren-bpmn.sh`](../beispieldaten/installieren-bpmn.sh), ohne Administratorrechte nach `~/.local` | Skript, geprüft 11.11.2026: frisches Präfix, danach Prozess angelegt und `valid`; die Beispielprozesse (`beispieldaten/prozesse.sh`) liefen mit derselben Version |
| Node.js | 24 oder neuer | Voraussetzung von bpmn-cli | Systemweit (z. B. Homebrew); das Skript prüft die Version und bricht sonst ab | Voraussetzung, nicht vom Repo installiert |
| Open Terminal (nativ auf macOS) | nicht festgehalten | Mac als Umgebung für OpenWebUI, unter eigenem Benutzer | `uvx open-terminal run`, Hinweise in [erweiterter-stack-betrieb.md](erweiterter-stack-betrieb.md) §4 | Lücke: kein Startskript, keine feste Version im Repo |
| uv | nicht festgehalten | Start von Open Terminal (`uvx`), Python-Umgebungen | Von Hand beim zweiten Benutzer | Lücke: kein Skript |
| Homebrew im Home-Ordner | nicht festgehalten | Pakete ohne Administratorrechte | Beschrieben in [erweiterter-stack-betrieb.md](erweiterter-stack-betrieb.md) §5 | Lücke: kein Skript |

## Eintragen

Neue Zeile oder geänderte Version im **selben Commit** wie das Skript. Pflichtangaben: Werkzeug mit Quelle und Lizenz, feste
Version, Zweck, Skript oder Abschnitt, Status mit Datum der letzten Prüfung. Alles Weitere gehört in den Abschnitt zum
Werkzeug, nicht in eine zweite Tabelle.
