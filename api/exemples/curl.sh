#!/usr/bin/env bash
# Exemple API Investlytic : recherche d'un symbole, puis note de l'action.
# Usage : INVESTLYTIC_KEY=ilv_votre_cle ./curl.sh lvmh      (nécessite curl et python3 ou jq)
set -euo pipefail
BASE="https://investlytic.co/api/v1"
: "${INVESTLYTIC_KEY:?Définissez la variable INVESTLYTIC_KEY (votre clé ilv_...).}"
Q="${1:-lvmh}"

appel() {  # appel <url> [options curl...] ; affiche le JSON, ou l'erreur et sort en échec
  local url="$1"; shift
  local out code
  out=$(curl -sS -w '\n%{http_code}' -H "Authorization: Bearer ${INVESTLYTIC_KEY}" "$@" "$url")
  code=${out##*$'\n'}; out=${out%$'\n'*}
  if [ "$code" != "200" ]; then echo "Erreur ${code} : ${out}" >&2; exit 1; fi
  printf '%s' "$out"
}

RECH=$(appel "${BASE}/recherche" -G --data-urlencode "q=${Q}" --data-urlencode "limite=5")
SYMBOLE=$(printf '%s' "$RECH" | python3 -c 'import json,sys; r=json.load(sys.stdin)["resultats"]; print(r[0]["symbole"] if r else "")')
[ -n "$SYMBOLE" ] || { echo "Aucun symbole pour « ${Q} »." >&2; exit 1; }

appel "${BASE}/action/${SYMBOLE}" | python3 -c '
import json, sys
f = json.load(sys.stdin)
print("%s (%s) : %s/%s" % (f["nom"], f["symbole"], f["note"], f["sur"]))
print("Données du", f["donnees_du"], "(" + f["donnees"] + ")")
for c in f["criteres"]:
    print(("  OK  " if c["verdict"] else "  NON ") + c["libelle"])
print(f["avertissement"])'
