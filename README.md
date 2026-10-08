# Investlytic MCP — l'analyse boursière Investlytic dans votre IA

[🇬🇧 English version](README.en.md)

**Investlytic** note les actions avec un moteur à 5 critères (tendance du prix, croissance, dette,
valorisation, correction récente) sur plus de 70 000 actions. Ce connecteur [MCP](https://modelcontextprotocol.io)
permet à Claude, ChatGPT, Cursor, VS Code, Claude Code ou Gemini d'interroger directement ce moteur.

Vous posez votre question en français ou en anglais, l'IA fait le reste :

> « Analyse l'action LVMH » · « Quelles actions françaises ont 5/5 ? » · « Les meilleurs dividendes américains au-dessus de 4 % »

**Rien à installer** : c'est un service en ligne. Adresse du connecteur :

```
https://investlytic.co/mcp
```

- **3 demandes gratuites, sans compte.** La recherche d'un symbole ne compte pas.
- Ensuite, un compte Investlytic et une adresse personnelle (voir plus bas).
- Chaque réponse indique **la date des données**. Ce sont des informations factuelles, pas un conseil en investissement.

## Les 4 outils

| Outil | Ce qu'il fait | Paramètres |
|---|---|---|
| `rechercher_action` | Trouve le symbole boursier d'une société à partir de son nom (« LVMH » → `MC.PA`). Gratuit. | `requete` |
| `analyser_action` | La note Investlytic sur 5 d'une action, avec le détail des 5 critères et la variation du cours année par année. | `symbole` |
| `actions_en_tendance` | Les actions les mieux notées par le moteur, triées par score. Filtrable par marché et note minimale. | `marche`, `note_min`, `limite` |
| `top_dividendes` | Les actions à dividende les mieux classées (rendement, croissance sur 5 ans, régularité). | `marche`, `rendement_min`, `rendement_max`, `limite` |

## Brancher votre IA en une minute

### Claude (claude.ai et application de bureau)
Paramètres → **Connecteurs** → **Ajouter un connecteur personnalisé** → nom `Investlytic`, adresse
`https://investlytic.co/mcp`, authentification : **aucune**.

### Claude Code
```bash
claude mcp add --transport http investlytic https://investlytic.co/mcp
```

### Cursor
Fichier `.cursor/mcp.json` (ou Settings → MCP) :
```json
{ "mcpServers": { "investlytic": { "url": "https://investlytic.co/mcp" } } }
```

### VS Code (Copilot)
Fichier `.vscode/mcp.json` :
```json
{ "servers": { "investlytic": { "type": "http", "url": "https://investlytic.co/mcp" } } }
```

### ChatGPT
Paramètres → **Connecteurs** → **Créer** (mode développeur) → adresse `https://investlytic.co/mcp`, sans authentification.

### Gemini CLI
Dans `~/.gemini/settings.json` :
```json
{ "mcpServers": { "investlytic": { "httpUrl": "https://investlytic.co/mcp" } } }
```

Les fichiers prêts à copier sont dans [`exemples/`](exemples/).

## Avec votre compte Investlytic

Après les 3 essais, créez un compte sur [investlytic.co](https://investlytic.co), puis
**Paramètres → « Connecter mon IA »** : vous obtenez une adresse personnelle qui remplace l'adresse d'essai.

Deux façons de l'utiliser, au choix :
- l'adresse avec la clé : `https://investlytic.co/mcp?key=ilv_votre_cle`
- ou l'en-tête `Authorization: Bearer ilv_votre_cle`

Chaque demande compte comme une analyse de votre plan (Découverte 30 par mois, Investisseur 100 par mois,
Pro illimité). Les listes « actions en tendance » et « top dividendes » sont réservées aux plans Investisseur et Pro.

**Fraîcheur des données** : l'essai gratuit et les plans Découverte et Investisseur reçoivent les données de la
dernière mise à jour Investlytic (la date est toujours indiquée). Seul le plan Pro reçoit l'analyse du jour, en direct.
[Voir les tarifs](https://investlytic.co/tarifs).

## Exemples de questions

- « Cherche le symbole de TotalEnergies et analyse l'action. »
- « Donne-moi les actions américaines notées 5/5, les 10 premières. »
- « Quelles actions à dividende rapportent entre 4 et 7 % en France ? »
- « Compare les notes Investlytic d'Apple, Microsoft et Nvidia. »

## Questions fréquentes

**Est-ce que c'est un conseil en investissement ?** Non. Le moteur applique 5 règles chiffrées, toujours les mêmes ;
les réponses sont des informations factuelles, datées. La décision vous appartient.

**Pourquoi la note de mon IA n'est pas celle du site ?** Le site Investlytic (membres) calcule en direct ; le connecteur
sert la dernière mise à jour stockée, sauf en plan Pro. La date est indiquée dans chaque réponse.

**Mes 3 essais sont épuisés.** Créez un compte sur [investlytic.co](https://investlytic.co) et prenez votre adresse personnelle dans Paramètres → « Connecter mon IA ».

**Le code du serveur est-il ici ?** Non. Ce dépôt est le mode d'emploi du connecteur. Le serveur est hébergé par
Investlytic ; les clés personnelles sont stockées hachées et ne transitent que dans votre propre configuration.

## API web

Une API JSON pour récupérer la note Investlytic d'une action (5 critères, explications, date des données), les actions en tendance et les meilleures actions à dividende, plus un encart d'une ligne pour afficher la note sur votre site (gratuit, avec le logo).

- Plan **Développeur** : 29 € HT par mois, 3 000 appels inclus, 14 jours d'essai.
- Plan **Business** : 290 € HT par mois, 50 000 appels inclus, encart en marque blanche.
- Entreprise : sur devis. Recherche de symbole gratuite.

[Documentation de l'API et exemples](api/README.md) · [Tarifs](https://investlytic.co/tarifs)

## Support

contact@investlytic.co · [investlytic.co/connecter-ia](https://investlytic.co/connecter-ia)

Investlytic est édité par VRAIVEX SAS, Paris. Protocole MCP 2025-06-18, transport HTTP (JSON-RPC).
