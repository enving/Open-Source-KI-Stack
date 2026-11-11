# Hinweise für Agenten in diesem Repo

Dieses Repo ist **öffentlich** und soll einen übertragbaren, wiederholbaren Stack liefern: Wer es klont, kommt mit den
Skripten und der Doku zum gleichen Ergebnis, ohne dass jemand von Hand etwas wusste. Alles Folgende dient diesem Ziel.

## 1. Nichts Privates ins Repo

Keine Zugangsdaten, Schlüssel, Kunden- oder Personennamen, Benutzernamen, Hostnamen, Adressen oder lokale Pfade aus einer
Testmaschine. Beispiele allgemein halten. Zugangsdaten gehören in die lokale `.env`. Vor jedem Commit die eigenen Dateien
danach durchsuchen. Übergabe- und Logbuchdateien (`UEBERGABE.md`, `LOGBUCH.md`) sind lokal und nicht im Repo.

## 2. Jede Installation gehört ins Repo: Skript plus Register

Was nur auf einer Maschine von Hand installiert wurde, ist für andere nicht vorhanden. Deshalb gilt bei **jeder** Installation
oder Versionsänderung eines Werkzeugs außerhalb der Docker-Images:

1. **Skript im Repo**, das die Installation ausführt (Beispiel: `beispieldaten/installieren-bpmn.sh`). Version **fest**
   eingetragen, nicht „latest“. Ohne Administratorrechte, wenn möglich. Ziel als Argument, keine festen Pfade oder Benutzer.
   Voraussetzungen prüfen und bei Fehlen mit klarer Meldung abbrechen.
2. **Eintrag im Installationsregister** [`docs/installationen.md`](docs/installationen.md), im selben Commit: Werkzeug mit
   Quelle und Lizenz, Version, Zweck, Skript, Status mit Prüfdatum. Das Register ist die einzige Stelle für diese Angaben;
   keine zweite Tabelle in README oder anderen Dateien, dort nur verlinken.
3. **Prüfen, bevor es als fertig gilt**: Skript auf einem frischen Ziel laufen lassen und das Ergebnis benutzen (nicht nur
   `--version`). Erst dann „Skript, geprüft <Datum>“ eintragen.
4. **Von Hand Gemachtes nicht verschweigen**: Wurde etwas ohne Skript installiert, kommt es trotzdem ins Register, mit Status
   „Lücke“. Das Skript folgt, sobald jemand daran arbeitet.

Container-Images werden nicht ins Register geschrieben, sondern per Digest in den Compose-Dateien festgelegt. Wer ein Image
ändert, prüft Health und Datenbestand und hält das in `docs/erweiterter-stack-betrieb.md` fest.

## 3. Daten bleiben draußen, Bauskripte kommen herein

Beispiel- und Testdaten liegen nicht im Repo. Das Repo enthält das Skript, das sie aus öffentlichen Quellen wiederherstellt
(`beispieldaten/`), samt Quellen und Lizenzen. Alles Ausprobierende bleibt **optionales Setup** mit einem Einstiegspunkt
(`beispieldaten/einrichten.sh`); der Stack selbst darf davon nicht abhängen. Gleiche Eingabe soll dieselbe Ausgabe ergeben (fester Seed).

## 4. Doku

Allgemeingültige Erfahrungen stehen in `docs/erweiterter-stack-betrieb.md`, verallgemeinert und ohne Bezug zur Testmaschine.
Vor neuen Regeln oder Tabellen nach der zuständigen vorhandenen Stelle suchen und dort ergänzen.
