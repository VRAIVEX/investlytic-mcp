# API web Investlytic

[English version](README.en.md) · [Retour au connecteur MCP](../README.md)

L'API Investlytic donne à vos outils la note Investlytic d'une action (sur 5 critères) avec l'explication de chaque critère, les actions en tendance et les meilleures actions à dividende. Les réponses sont en JSON, en français ou en anglais, et indiquent toujours la date des données.

Elle est réservée aux plans **Développeur** (29 € HT par mois) et **Business** (290 € HT par mois), avec 14 jours d'essai. Offre **Entreprise** sur devis. [Voir les tarifs](https://investlytic.co/tarifs) · [Documentation en ligne](https://investlytic.co/api-developpeurs).

## Obtenir une clé

Après la souscription, ouvrez Paramètres → API & IA et créez une clé. Elle commence par `ilv_` et ne s'affiche qu'une fois. Vous pouvez la révoquer et en créer une autre à tout moment.

Envoyez-la dans l'en-tête, c'est la méthode recommandée :

```
Authorization: Bearer ilv_votre_cle
```

Solution de repli : si votre outil ne sait pas envoyer d'en-tête, ajoutez `?key=ilv_votre_cle` à l'adresse. Attention, une clé placée dans l'adresse est enregistrée dans les journaux des serveurs (le vôtre, les proxys) et dans l'historique du navigateur. Préférez l'en-tête et ne publiez jamais votre clé dans une page web.

## Les 5 adresses

Toutes commencent par `https://investlytic.co/api/v1` et répondent en `GET`. Ajoutez `lang=en` pour recevoir les textes en anglais.

| Adresse | Ce qu'elle renvoie | Paramètres |
|---|---|---|
| `/recherche?q=lvmh` | Les symboles qui correspondent (`resultats`) | `q` (obligatoire), `limite` (1 à 50) |
| `/action/MC.PA` | La note d'une action et le détail des 5 critères | `direct=1` (analyse en direct), `lang=en` |
| `/tendance` | Les actions en tendance (`resultats`) | `marche` (fr, us, de…), `note_min`, `limite` |
| `/dividendes` | Les meilleures actions à dividende (`resultats`) | `marche`, `rendement_min`, `rendement_max`, `limite` |
| `/usage` | Votre consommation du mois (non comptée) | aucun |

La recherche de symbole est gratuite (non décomptée) mais une clé est requise ; elle renvoie au plus 50 résultats. `/tendance` et `/dividendes` vont jusqu'à 50 lignes avec le plan Développeur et jusqu'à 200 avec le plan Business.

Exemple de réponse de `/api/v1/action/MC.PA` :

```json
{ "symbole": "MC.PA", "nom": "LVMH", "note": 4, "sur": 5,
  "donnees_du": "2026-10-06", "donnees": "stockees",
  "criteres": [ { "cle": "tendance", "libelle": "Tendance du prix", "verdict": true,
                  "explication": "Le cours monte sur la durée : le marché accompagne l'entreprise." }, … ],
  "variation_annuelle": { "2024": 12.3, "2025": -4.1 },
  "premier_passage_4_sur_5": "2025-03-14", "premier_passage_5_sur_5": null,
  "source": "Investlytic", "fiche": "https://investlytic.co/action-public?symbol=MC.PA",
  "avertissement": "Information factuelle, pas un conseil en investissement." }
```

`premier_passage_4_sur_5` / `premier_passage_5_sur_5` : date à laquelle l'action a atteint pour la première fois 4/5 (ou 5/5), `null` si jamais atteint.

`/usage` renvoie `plan`, `mois`, `inclus`, `utilises`, `reste`, `depassement`, `direct_aujourdhui` et `direct_plafond_jour`.

## Exemples

Chaque exemple lit la clé dans la variable d'environnement `INVESTLYTIC_KEY`, cherche un symbole, puis affiche la note, la date et le verdict des 5 critères.

```bash
export INVESTLYTIC_KEY=ilv_votre_cle
python3 exemples/python.py lvmh      # bibliothèque standard uniquement
node exemples/javascript.js lvmh     # Node 18+, côté serveur
bash exemples/curl.sh lvmh
```

- [exemples/python.py](exemples/python.py)
- [exemples/javascript.js](exemples/javascript.js)
- [exemples/curl.sh](exemples/curl.sh)

Ne mettez jamais la clé dans du code envoyé au navigateur.

## Erreurs

En cas d'erreur, la réponse contient un message lisible et le code HTTP : `{ "erreur": "Clé invalide ou révoquée.", "code": 401 }`

| Code | Signification |
|---|---|
| 400 | Paramètre manquant ou symbole mal écrit (exemples : `MC.PA`, `AAPL`). |
| 401 | Clé absente, invalide ou révoquée. |
| 402 | Paiement en attente : abonnement suspendu jusqu'à la mise à jour de votre carte. |
| 403 | Votre plan ne comprend pas l'API. |
| 404 | Symbole absent de la base Investlytic : vérifiez-le avec `/recherche`. Non facturé. |
| 429 | Plus de 10 appels par seconde, ou plafond quotidien d'analyses en direct atteint (revenez le lendemain, ou appelez sans `direct=1`). |
| 503 | Service momentanément indisponible : réessayez dans un instant. Non facturé. |

## Quotas et facturation

| | Développeur | Business |
|---|---|---|
| Abonnement | 29 € HT / mois | 290 € HT / mois |
| Appels inclus chaque mois | 3 000 | 50 000 |
| Au-delà | 0,01 € l'appel, facturé par tranche de 100 appels entamée (1 €) | 0,01 € l'appel, facturé par tranche de 100 appels entamée (1 €) |
| Analyse en direct | 0,10 € (200 par jour maxi) | 0,10 € (2 000 par jour maxi) |
| Listes (tendance, dividendes) | jusqu'à 50 lignes | jusqu'à 200 lignes |
| Recherche de symbole | gratuite (non décomptée, clé requise), 50 résultats | gratuite (non décomptée, clé requise), 50 résultats |
| Encart | avec le logo Investlytic | marque blanche |
| Support | — | par e-mail |

Chaque appel réussi est décompté ; `/usage` et la recherche ne le sont pas. Les appels au-delà du forfait et les analyses en direct sont ajoutés à votre facture du mois.

## Fraîcheur des données

Par défaut, l'API renvoie la note de la dernière mise à jour Investlytic, toujours datée par `donnees_du`, avec `"donnees": "stockees"`. Avec `?direct=1` sur `/action/…`, la note est recalculée avec les données du jour (`"donnees": "direct"`) : c'est l'analyse en direct, facturée 0,10 €. Si elle n'aboutit pas, vous recevez la note stockée, comptée comme un appel ordinaire.

## Encart pour votre site

Pour afficher la note d'une action sur une page web sans écrire de code : une ligne à coller, gratuite pour tout le monde, avec le logo Investlytic. [Créer votre encart](https://investlytic.co/afficher-investlytic).

```html
<script src="https://investlytic.co/encart.js" data-symbole="MC.PA"></script>
```

| Attribut | Rôle |
|---|---|
| `data-symbole` | Le symbole de l'action (obligatoire). |
| `data-lang` | `fr` (par défaut) ou `en`. |
| `data-theme` | `sombre` pour un fond foncé ; sans cet attribut, l'encart est clair. |
| `data-cle` | Clé d'encart du plan Business : retire le logo (marque blanche). |

Limites à connaître :

- Le style de votre site peut modifier l'apparence de l'encart : certaines règles CSS très générales (liens, titres, images) s'y appliquent. Vérifiez l'aperçu sur votre page.
- Si votre site a une politique de sécurité du contenu (CSP), autorisez `https://investlytic.co` dans `script-src` et `connect-src`, ainsi que les styles en ligne (`style-src 'unsafe-inline'`), sinon l'encart ne s'affiche pas.
- La clé d'encart sert seulement à retirer le logo. Elle est visible dans le code de votre page et n'est pas un contrôle d'accès : la note reste publique.

## Depuis votre assistant IA

Pour interroger Investlytic depuis Claude, ChatGPT ou Cursor, utilisez le [connecteur MCP](../README.md).

## Avertissement

Information factuelle, pas un conseil en investissement. Si vous republiez ces données, citez la source (Investlytic) et la date des données, et conservez cet avertissement auprès de vos utilisateurs.

Investlytic est édité par VRAIVEX SAS, Paris · contact@investlytic.co
