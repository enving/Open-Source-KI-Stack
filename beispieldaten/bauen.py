#!/usr/bin/env python3
"""Baut einen Grundstock erfundener Beispieldaten, getrennt in "unternehmen" und "team".

Nur Standardbibliothek. Die Daten selbst liegen NICHT im Repo; dieses Skript baut sie aus zwei öffentlichen Quellen:

  1. kobench, Beispielfirma Tidewell (MIT): github.com/enving/kobench, Ordner daten/beispiel
  2. Sinabis Green Energy (CC-BY-4.0, Hugging Face sinabis-group/sinabis-10m-synthetic-emails):
     frei erfundene Mails (.eml) und Kalendereinträge (.ics). Jede Mail trägt den Kopf X-Synthetic-Data.

Aufruf (alle Pfade sind Argumente, nichts ist fest verdrahtet):

    python3 -I bauen.py --kobench <kobench-ordner> --ziel <ausgabeordner> \
                        [--mails <ordner-mit-eml> --mails-manifest <manifest.json> --ics <ordner-mit-ics>]

Ohne die drei Sinabis-Angaben entsteht nur der Tidewell-Teil (kleiner Einstieg ohne große Downloads).

Die Auswahl ist deterministisch (Seed 42): gleiche Eingabe, gleiche Ausgabe. Die Aufteilung steht in README.md.
"""
import argparse
import email
import fnmatch
import hashlib
import json
import random
import re
import shutil
import sys
from email import policy
from email.utils import getaddresses
from pathlib import Path

INTERN = ("sinabis-green.com", "sinabis-foundation.org")
SEED = 42


# ---------- Tidewell (Rechtekreise aus kobench/daten/beispiel/rechte.yaml) ----------

def lies_rechte(pfad):
    """Minimaler Leser für das flache Format von rechte.yaml (kein PyYAML nötig)."""
    regeln, nutzer, abschnitt = [], {}, None
    for zeile in Path(pfad).read_text(encoding="utf-8").splitlines():
        if not zeile.strip() or zeile.lstrip().startswith("#"):
            continue
        if not zeile.startswith(" "):
            abschnitt = zeile.rstrip(":").strip()
            continue
        if abschnitt == "quellen":
            m = re.search(r'muster:\s*"([^"]+)"\s*,\s*kreise:\s*\[([^\]]*)\]', zeile)
            if m:
                regeln.append((m.group(1), [k.strip() for k in m.group(2).split(",") if k.strip()]))
        elif abschnitt == "nutzer":
            name, _, rest = zeile.strip().partition(":")
            nutzer[name] = [k.strip() for k in rest.strip().strip("[]").split(",") if k.strip()]
    return regeln, nutzer


def kreise_von(doc_id, regeln):
    gefunden = ["alle"]
    for muster, kreise in regeln:  # die letzte passende Regel gilt
        if fnmatch.fnmatch(doc_id, muster):
            gefunden = kreise
    return gefunden


def schreibe(pfad, text):
    pfad.parent.mkdir(parents=True, exist_ok=True)
    pfad.write_text(text, encoding="utf-8")


def tidewell(kobench, ziel, manifest):
    quelle = Path(kobench) / "daten" / "beispiel"
    regeln, _ = lies_rechte(quelle / "rechte.yaml")
    n = {"unternehmen": 0, "team": 0}
    for zeile in (quelle / "dokumente.jsonl").read_text(encoding="utf-8").splitlines():
        d = json.loads(zeile)
        kreise = kreise_von(d["id"], regeln)
        if "alle" in kreise:
            bereich, ordner = "unternehmen", ziel / "unternehmen" / "tidewell"
        else:
            bereich, ordner = "team", ziel / "team" / "tidewell" / kreise[0]
        name = d["id"].replace(":", "_") + ".md"
        kopf = (f"---\nid: {d['id']}\nsystem: {d['system']}\ntitel: {json.dumps(d['titel'], ensure_ascii=False)}\n"
                f"datum: {d.get('datum') or ''}\nkreise: [{', '.join(kreise)}]\nfirma: Tidewell Software (erfunden)\n---\n\n")
        schreibe(ordner / name, kopf + d["text"].rstrip() + "\n")
        manifest.append({"bereich": bereich, "datei": str((ordner / name).relative_to(ziel)), "quelle": "kobench:" + d["id"]})
        n[bereich] += 1
    # Rechte und Prüffragen mitliefern (Musterantworten sind am Korpus belegt)
    shutil.copy(quelle / "rechte.yaml", ziel / "rechte-tidewell.yaml")
    (ziel / "pruefung").mkdir(exist_ok=True)
    shutil.copy(quelle / "fragen.yaml", ziel / "pruefung" / "tidewell-fragen.yaml")
    shutil.copy(quelle / "firma.yaml", ziel / "pruefung" / "tidewell-firma.yaml")
    return n


# ---------- Sinabis ----------

def adressen(m, *felder):
    return [a.lower() for _, a in getaddresses([str(m[f] or "") for f in felder]) if a]


def einordnen(roh):
    """Gibt (gruppe, absender) zurück: 'unternehmen' | 'team-intern' | 'team-extern'."""
    m = email.message_from_bytes(roh, policy=policy.default)
    von = adressen(m, "From")
    an = adressen(m, "To", "Cc")
    if not von:
        return None
    absender = von[0]
    lokal, _, domain = absender.partition("@")
    # Interne Personen heißen vorname.nachname; interne Systeme servicedesk, people-portal, ... Externe zählen nie als System.
    system = absender.endswith(INTERN) and "." not in lokal
    alle = von + an
    if system or len(an) >= 6:
        return "unternehmen"
    if all(a.endswith(INTERN) for a in alle):
        return "team-intern"
    return "team-extern"


def sinabis_mails(mails, manifest_pfad, ziel, anzahl, manifest):
    eintraege = json.loads(Path(manifest_pfad).read_text())["dateien"]
    gruppen = {"unternehmen": [], "team-intern": [], "team-extern": []}
    for e in sorted(eintraege, key=lambda e: e["datei"]):
        pfad = Path(mails) / e["datei"]
        if not pfad.exists():
            continue
        g = einordnen(pfad.read_bytes())
        if g:
            gruppen[g].append(e["datei"])
    ziele = {"unternehmen": ziel / "unternehmen" / "sinabis" / "mails",
             "team-intern": ziel / "team" / "sinabis" / "mails-intern",
             "team-extern": ziel / "team" / "sinabis" / "mails-kunden"}
    rng = random.Random(SEED)
    zaehler = {}
    for g, liste in gruppen.items():
        wahl = sorted(rng.sample(liste, min(anzahl[g], len(liste))))
        for datei in wahl:
            roh = (Path(mails) / datei).read_bytes()
            (ziele[g]).mkdir(parents=True, exist_ok=True)
            (ziele[g] / datei).write_bytes(roh)
            manifest.append({"bereich": g.split("-")[0], "datei": str((ziele[g] / datei).relative_to(ziel)),
                             "quelle": "sinabis-mail:" + datei, "sha256": hashlib.sha256(roh).hexdigest()[:16]})
        zaehler[g] = (len(wahl), len(liste))
    return zaehler


def sinabis_ics(ics, ziel, anzahl_unternehmen, anzahl_team, manifest):
    gross, klein = [], []
    for p in sorted(Path(ics).glob("*.ics")):
        text = p.read_text(encoding="utf-8", errors="replace")
        (gross if len(re.findall(r"^ATTENDEE", text, re.M)) >= 6 else klein).append(p)
    rng = random.Random(SEED)
    zaehler = {}
    for gruppe, liste, n, ordner in (("unternehmen", gross, anzahl_unternehmen, ziel / "unternehmen" / "sinabis" / "kalender"),
                                     ("team", klein, anzahl_team, ziel / "team" / "sinabis" / "kalender")):
        wahl = sorted(rng.sample(liste, min(n, len(liste))))
        ordner.mkdir(parents=True, exist_ok=True)
        for p in wahl:
            shutil.copy(p, ordner / p.name)
            manifest.append({"bereich": gruppe, "datei": str((ordner / p.name).relative_to(ziel)), "quelle": "sinabis-ics:" + p.name})
        zaehler[gruppe] = (len(wahl), len(liste))
    return zaehler


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--kobench", required=True, help="Ordner des kobench-Repos")
    ap.add_argument("--mails", help="Ordner mit den .eml-Dateien (Sinabis); ohne --mails, --mails-manifest und --ics nur Tidewell")
    ap.add_argument("--mails-manifest", help="manifest.json des Mail-Ausschnitts (Liste 'dateien' mit 'datei')")
    ap.add_argument("--ics", help="Ordner mit .ics-Dateien (Sinabis)")
    ap.add_argument("--ziel", required=True, help="Ausgabeordner (wird neu angelegt; ein vorhandener wird nicht überschrieben)")
    ap.add_argument("--mails-unternehmen", type=int, default=150)
    ap.add_argument("--mails-team-intern", type=int, default=150)
    ap.add_argument("--mails-team-kunden", type=int, default=100)
    ap.add_argument("--ics-unternehmen", type=int, default=20)
    ap.add_argument("--ics-team", type=int, default=40)
    a = ap.parse_args()
    sinabis = [a.mails, a.mails_manifest, a.ics]
    if any(sinabis) and not all(sinabis):
        sys.exit("Sinabis braucht alle drei Angaben: --mails, --mails-manifest und --ics (oder keine).")

    ziel = Path(a.ziel)
    if ziel.exists() and any(ziel.iterdir()):
        sys.exit(f"Abbruch: {ziel} ist nicht leer. Anderen Ordner wählen oder den alten bewusst entfernen.")
    ziel.mkdir(parents=True, exist_ok=True)
    manifest = []
    t = tidewell(a.kobench, ziel, manifest)
    mails = ics = "übersprungen (keine Sinabis-Quelle angegeben)"
    if all(sinabis):
        mails = sinabis_mails(a.mails, a.mails_manifest, ziel,
                              {"unternehmen": a.mails_unternehmen, "team-intern": a.mails_team_intern, "team-extern": a.mails_team_kunden}, manifest)
        ics = sinabis_ics(a.ics, ziel, a.ics_unternehmen, a.ics_team, manifest)
    manifest.sort(key=lambda e: e["datei"])
    schreibe(ziel / "manifest.json", json.dumps({"seed": SEED, "dateien": manifest}, indent=1, ensure_ascii=False) + "\n")
    vorlage = Path(__file__).with_name("ausgabe-README.md")
    if vorlage.exists():
        shutil.copy(vorlage, ziel / "README.md")
    print(f"Tidewell: {t}")
    print(f"Sinabis-Mails (ausgewählt, verfügbar): {mails}")
    print(f"Sinabis-Kalender (ausgewählt, verfügbar): {ics}")
    print(f"Dateien insgesamt: {len(manifest)}  →  {ziel}")


if __name__ == "__main__":
    main()
