# Betrieb des erweiterten Stacks: Erfahrungen

Verallgemeinerter Stand aus einer Testinstallation auf einem Mac (Apple Silicon, Docker über eine Linux-VM). Keine Zugangsdaten, keine Hostnamen, keine Adressen aus dem Testaufbau. Beispiele sind allgemein gehalten.

## 1. Umgebungsdatei prüfen, bevor Dienste starten

Die Datei mit Geheimnissen (`--env-file`) wird von Compose zeilenweise gelesen. Jede Zeile muss `SCHLÜSSEL=WERT` sein, Kommentare beginnen mit `#`. Zeilen mit Freitext oder Leerzeichen im Schlüssel brechen den gesamten Start ab, ohne dass ein Dienst teilweise läuft.

Prüfen, ohne Werte auszugeben:

```bash
docker compose --env-file <datei> -f docker-compose.erweitert.yml config -q && echo "ok"
```

Eine Vorlage liegt als `.env.example`. Die echte Datei gehört nicht ins Repo und sollte Modus 600 haben.

## 2. Firecrawl braucht mehr Speicher als der Standard

Die API von Firecrawl wird vom Kernel mit Exit 137 beendet, wenn das Speicherlimit zu klein ist oder zu viele Worker laufen. Der Container startet dann in einer Neustartschleife.

Mit 8 Workern und 3 GB Limit trat das in der Testinstallation auf. Stabil lief es mit einem Worker und 5 GB. Die Docker-VM braucht dafür mindestens 8 GB, besser 10 GB. Die Werte sind als Vorschlag in einem offenen PR dokumentiert; vor einem Merge prüfen, ob sie zur eigenen Hardware passen.

## 3. Open WebUI aktualisieren

Vor jedem Versionssprung:

1. Datenvolumen sichern (`tar` aus einem Hilfscontainer, Datei außerhalb des Repos, Modus 700 für das Verzeichnis).
2. Neues Image mit Tag ziehen und den Digest ermitteln.
3. Den Digest in der Compose-Datei eintragen (wird so auf Digest festgelegt, nicht auf einen beweglichen Tag).
4. Nur den Dienst neu erstellen: `up -d --no-deps openwebui`.
5. Prüfen: Health-Status, Anzahl der Konten und Modelle.

Schema-Migrationen lassen sich nicht zurückdrehen. Die Sicherung ist dann der einzige Weg zurück.

## 4. Open Terminal auf einem Mac betreiben

Open Terminal läuft auch nativ auf macOS (über `uvx open-terminal run`), nicht nur im Container. Der Mac wird dann als Umgebung an OpenWebUI angehängt.

Empfehlungen aus dem Test:
- Nur an eine Tailnet-Adresse binden, nicht an alle Schnittstellen.
- Einen API-Schlüssel setzen; ohne Schlüssel muss die Antwort 401 sein. Den Schlüssel als Datei mit Modus 600 ablegen.
- Den Dienst unter einem eigenen, nicht administrativen macOS-Benutzer starten. Der Dienst läuft sonst mit allen Rechten des Hauptbenutzers, und ein Modell mit Terminalzugriff kann alles lesen und ändern, was dieser Benutzer darf.
- Den Home-Ordner des Hauptbenutzers auf 700 setzen, damit der zweite Benutzer ihn nicht lesen kann. Neue macOS-Benutzer landen sonst in der Gruppe `staff`, die Leserechte auf den Home-Ordner hat.
- Die Umgebung des Dienstes bereinigen: Der Prozess übernimmt sonst den PATH des Startbenutzers. Dadurch sieht der Benutzer Programme, die für ihn nicht gedacht sind, etwa Agenten-CLIs mit Login des Hauptbenutzers. Der Start mit `env -i` und einem eigenen PATH verhindert das.
- Bildschirmaufnahme und Bedienungshilfen sind pro Programm und pro Benutzer zu erteilen. Sie lassen sich nicht über ein Skript setzen.

## 5. Homebrew ohne Administratorrechte

Homebrew lässt sich im Home-Ordner eines Benutzers installieren, ohne `sudo`. Dafür das Git-Repository unter `~/homebrew/Homebrew` klonen und `brew` nach `~/homebrew/bin` verlinken. Die Xcode-Command-Line-Tools sind systemweit und reichen aus.

Einschränkungen:
- Vorgebaute Pakete (Bottles) gibt es für das Standard-Präfix `/opt/homebrew`. Andere Pakete werden dann aus dem Quellcode gebaut, das dauert deutlich länger.
- Der Plattenbedarf ist eigenständig; vor größeren Installationen den freien Platz prüfen.

## 6. Upstream-Stand (Open WebUI, Stand 10.11.2026)

Aus Tests sind Fragen an das öffentliche Open-WebUI-Repo entstanden. Vorher suchen, ob es schon ein Issue gibt:

- #34067 (Automations mit Open Terminal): geschlossen als Duplikat. Die Begründung des Maintainers: Eine Automation braucht einen Benutzer, dem der Chat gehört. Diskussion dazu: #29527.
- #34068 (Open Terminal als Modell-Schalter): geschlossen. Die Terminal-Auswahl am Ende der Modell-Bearbeitung leistet das bereits.
- #29016 (Standard-Terminal eines Modells wird in Channels nicht angewendet): offen. Das ist für Team-Channels der relevante Fehler.
- #34073 (Channel-Bots dauerhaft aktiv halten, Open Terminal als Bot-Werkzeug): offen.
- #34075 (Agent-Modelle erscheinen, obwohl die CLI für den Benutzer nicht eingeloggt ist): offen.
- #34076 (Übersicht ausstehender Tool-Freigaben über alle Chats): offen.
- #34077 (Ordner pro Channel für Mitglieder und Bots): offen.

## 7. Offene Punkte

- Entscheidung, ob Open Terminal für mehrere Benutzer freigegeben wird und unter welchem Benutzerkonto.
- Umgang mit der Sprache der Oberfläche: Bei einem unvollständigen Sprachpaket erscheinen Übersetzungsschlüssel statt Text. Abhilfe ist die Oberflächensprache Englisch, bis ein vollständiges Paket da ist.
- Merge der Änderungen für Firecrawl-Speicher und n8n.
