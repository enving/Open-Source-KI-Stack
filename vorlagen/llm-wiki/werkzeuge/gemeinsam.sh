# Gemeinsame Hilfen für die Wiki-Werkzeuge. Wird mit `. werkzeuge/gemeinsam.sh` aus dem Wiki-Stamm geladen.
WIKI=$(cd "$(dirname "$0")/.." && pwd)
cd "$WIKI"
# Wert eines Frontmatter-Schlüssels: feld <datei> <schlüssel>
feld() { awk -v k="$2" 'NR==1&&$0!="---"{exit} NR>1&&$0=="---"{exit} NR>1{i=index($0,":"); if(substr($0,1,i-1)==k){v=substr($0,i+1); sub(/^ +/,"",v); gsub(/^"|"$/,"",v); print v; exit}}' "$1"; }
# Bereiche aus firma.md: Zeilen „Name|Ordner|Besitzer|Zweck“
bereiche() { awk -F'|' '/^## Bereiche/{f=1;next} /^## /{f=0} f&&/^\| *[^-| ][^|]*\| *wiki\//{for(i=2;i<=5;i++){gsub(/^ +| +$/,"",$i)}; print $2"|"$3"|"$4"|"$5}' firma.md; }
besitzer_von() { bereiche | awk -F'|' -v d="$1" 'index(d,$2"/")==1{print $3; exit}'; }
heute() { date +%Y-%m-%d; }
