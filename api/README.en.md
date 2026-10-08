# Investlytic web API

[Version française](README.md) · [Back to the MCP connector](../README.en.md)

The Investlytic API gives your tools the Investlytic score of a stock (out of 5 criteria) with an explanation of each criterion, trending stocks and the best dividend stocks. Answers are JSON, in French or English, and always state the date of the data.

It is available on the **Developer** (EUR 29 excl. VAT per month) and **Business** (EUR 290 excl. VAT per month) plans, with a 14-day trial. **Enterprise** on quote. [See pricing](https://investlytic.co/tarifs) · [Online documentation](https://investlytic.co/api-developpeurs) (French).

## Get a key

After subscribing, open Settings → API & AI and create a key. It starts with `ilv_` and is shown only once. You can revoke it and create another at any time.

Send it in the header, which is the recommended method:

```
Authorization: Bearer ilv_votre_cle
```

Fallback: if your tool cannot send a header, append `?key=ilv_votre_cle` to the address. Be aware that a key placed in the address is recorded in server logs (yours, proxies) and in browser history. Prefer the header, and never publish your key in a web page.

## The 5 endpoints

All start with `https://investlytic.co/api/v1` and answer to `GET`. Add `lang=en` to get texts in English.

| Endpoint | What it returns | Parameters |
|---|---|---|
| `/recherche?q=lvmh` | Matching symbols (`resultats`) | `q` (required), `limite` (1 to 50) |
| `/action/MC.PA` | The score of a stock and the detail of its 5 criteria | `direct=1` (live analysis), `lang=en` |
| `/tendance` | Trending stocks (`resultats`) | `marche` (fr, us, de…), `note_min`, `limite` |
| `/dividendes` | Best dividend stocks (`resultats`) | `marche`, `rendement_min`, `rendement_max`, `limite` |
| `/usage` | Your usage this month (not counted) | none |

Symbol search is free (not counted) but a key is required; it returns at most 50 results. `/tendance` and `/dividendes` return up to 50 rows on the Developer plan and up to 200 on the Business plan.

Example answer from `/api/v1/action/MC.PA` (the field names stay in French; texts follow `lang`):

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

`premier_passage_4_sur_5` / `premier_passage_5_sur_5`: date the stock first reached 4/5 (or 5/5), `null` if never reached.

`/usage` returns `plan`, `mois`, `inclus`, `utilises`, `reste`, `depassement`, `direct_aujourdhui` and `direct_plafond_jour`.

## Examples

Each example reads the key from the `INVESTLYTIC_KEY` environment variable, searches a symbol, then prints the score, the date and the verdict of the 5 criteria.

```bash
export INVESTLYTIC_KEY=ilv_votre_cle
python3 exemples/python.py lvmh      # standard library only
node exemples/javascript.js lvmh     # Node 18+, server side
bash exemples/curl.sh lvmh
```

- [exemples/python.py](exemples/python.py)
- [exemples/javascript.js](exemples/javascript.js)
- [exemples/curl.sh](exemples/curl.sh)

Never put the key in code sent to the browser.

## Errors

On error, the answer holds a readable message and the HTTP code: `{ "erreur": "Clé invalide ou révoquée.", "code": 401 }`

| Code | Meaning |
|---|---|
| 400 | Missing parameter or misspelled symbol (examples: `MC.PA`, `AAPL`). |
| 401 | Key missing, invalid or revoked. |
| 402 | Payment pending: subscription suspended until your card is updated. |
| 403 | Your plan does not include the API. |
| 404 | Symbol not in the Investlytic database: check it with `/recherche`. Not billed. |
| 429 | More than 10 calls per second, or daily live-analysis cap reached (come back tomorrow, or call without `direct=1`). |
| 503 | Service temporarily unavailable: retry in a moment. Not billed. |

## Quotas and billing

| | Developer | Business |
|---|---|---|
| Subscription | EUR 29 excl. VAT / month | EUR 290 excl. VAT / month |
| Calls included each month | 3,000 | 50,000 |
| Beyond | €0.01 per call, billed per started block of 100 calls (€1) | €0.01 per call, billed per started block of 100 calls (€1) |
| Live analysis | EUR 0.10 (max 200 per day) | EUR 0.10 (max 2,000 per day) |
| Lists (trending, dividends) | up to 50 rows | up to 200 rows |
| Symbol search | free (not counted, key required), 50 results | free (not counted, key required), 50 results |
| Widget | with the Investlytic logo | white label |
| Support | — | by e-mail |

Every successful call is counted; `/usage` and symbol search are not. Calls beyond the included amount and live analyses are added to your monthly invoice.

## Data freshness

By default the API returns the score from the latest Investlytic update, always dated by `donnees_du`, with `"donnees": "stockees"`. With `?direct=1` on `/action/…`, the score is recomputed with today's data (`"donnees": "direct"`): this is the live analysis, billed EUR 0.10. If it fails, you get the stored score, counted as an ordinary call.

## Widget for your website

To display a stock's score on a web page without writing code: one line to paste, free for everyone, with the Investlytic logo. [Create your widget](https://investlytic.co/afficher-investlytic).

```html
<script src="https://investlytic.co/encart.js" data-symbole="MC.PA"></script>
```

| Attribute | Purpose |
|---|---|
| `data-symbole` | The stock symbol (required). |
| `data-lang` | `fr` (default) or `en`. |
| `data-theme` | `sombre` for a dark background; without it the widget is light. |
| `data-cle` | Business-plan widget key: removes the logo (white label). |

Limits to know:

- Your site's styles can alter the widget's appearance: very general CSS rules (links, headings, images) apply to it. Check the preview on your page.
- If your site has a Content Security Policy (CSP), allow `https://investlytic.co` in `script-src` and `connect-src`, plus inline styles (`style-src 'unsafe-inline'`), otherwise the widget will not display.
- The widget key only removes the logo. It is visible in your page's source and is not an access control: the score stays public.

## From your AI assistant

To query Investlytic from Claude, ChatGPT or Cursor, use the [MCP connector](../README.en.md).

## Disclaimer

Factual information, not investment advice. If you republish this data, cite the source (Investlytic) and the date of the data, and keep this notice for your users.

Investlytic is published by VRAIVEX SAS, Paris · contact@investlytic.co
