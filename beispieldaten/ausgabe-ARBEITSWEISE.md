# Arbeitsweise: mehrere gleichzeitig, ohne sich zu überschreiben

Dieser Ordner ist ein Git-Repo. `main` ist der gültige Stand. **Niemand arbeitet direkt auf `main`.**
Jede Person und jeder Agent bekommt je Aufgabe einen eigenen Arbeitsordner (Git-Worktree) auf einem eigenen Zweig:

```bash
git worktree add .arbeitsplaetze/<name>-<aufgabe> -b agent/<name>/<aufgabe>
cd .arbeitsplaetze/<name>-<aufgabe>      # hier ändern, hier committen
```

So sieht ein Agent nur seinen Stand; zwei Agenten können dieselbe Datei ändern, ohne dass einer den anderen still überschreibt.

## Zusammenführen

1. Der Zweig wird gegen `main` geprüft: `git diff main...HEAD`. Ein Mensch (oder ein Firmen-Agent als Prüfer, dann gegengelesen
   von einem Menschen) gibt frei.
2. Zusammenführen auf `main` macht nur die freigebende Stelle: `git merge --no-ff agent/<name>/<aufgabe>`.
3. Weicht `main` inzwischen ab, holt der Zweig es nach: `git rebase main` (oder `git merge main`).

## Konflikte

Ändern zwei Zweige dieselbe Stelle, stoppt Git beim Zusammenführen mit einem Konflikt. Das ist gewollt: Es passiert sichtbar statt
still. Der Agent löst Konflikte **nicht allein**: Er legt beide Fassungen vor und sagt, was sich unterscheidet; ein Mensch
entscheidet. Nie `--force`, nie Konflikte mit „ours/theirs“ pauschal überfahren.

Konflikte vermeiden: eine Aufgabe, ein Bereich. Kurze Zweige, früh zusammenführen. Dateien, die Menschen und Agenten gleichzeitig
brauchen, lieber klein und getrennt halten (eine Datei je Vorgang) als eine lange Sammeldatei.

## Grenze

Git trennt Dateistände, es schützt nicht vor **inhaltlich** widersprüchlichen Änderungen, die sich sauber zusammenführen lassen
(zwei Agenten schreiben verschiedene Zeilen, die zusammen nicht stimmen). Dafür bleibt die Freigabe durch einen Menschen.
Rechte (wer `unternehmen/` oder `team/` ändern darf) regelt Git nicht; dafür der Zugriff auf den Ordner.
