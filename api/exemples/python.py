#!/usr/bin/env python3
"""Exemple API Investlytic : recherche d'un symbole, puis note de l'action.

Usage : INVESTLYTIC_KEY=ilv_votre_cle python3 python.py lvmh
Bibliothèque standard uniquement.
"""
import json
import os
import sys
import urllib.error
import urllib.parse
import urllib.request

BASE = "https://investlytic.co/api/v1"
CLE = os.environ.get("INVESTLYTIC_KEY", "")


def appel(chemin, params=None):
    url = BASE + chemin
    if params:
        url += "?" + urllib.parse.urlencode(params)
    req = urllib.request.Request(url, headers={"Authorization": "Bearer " + CLE})
    try:
        with urllib.request.urlopen(req, timeout=30) as r:
            return json.load(r)
    except urllib.error.HTTPError as e:
        try:
            msg = json.load(e).get("erreur", "")
        except ValueError:
            msg = ""
        sys.exit("Erreur %d : %s" % (e.code, msg))


if not CLE:
    sys.exit("Définissez la variable INVESTLYTIC_KEY (votre clé ilv_...).")

requete = sys.argv[1] if len(sys.argv) > 1 else "lvmh"
trouves = appel("/recherche", {"q": requete, "limite": 5})["resultats"]
if not trouves:
    sys.exit("Aucun symbole pour « %s »." % requete)

symbole = trouves[0]["symbole"]
fiche = appel("/action/" + urllib.parse.quote(symbole))
print("%s (%s) : %s/%s" % (fiche["nom"], fiche["symbole"], fiche["note"], fiche["sur"]))
print("Données du", fiche["donnees_du"], "(" + fiche["donnees"] + ")")
for c in fiche["criteres"]:
    print(("  OK  " if c["verdict"] else "  NON ") + c["libelle"])
print(fiche["avertissement"])
