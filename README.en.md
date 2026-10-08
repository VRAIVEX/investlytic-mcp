# Investlytic MCP — Investlytic stock analysis inside your AI

[🇫🇷 Version française](README.md)

**Investlytic** scores stocks with a 5-criteria engine (price trend, growth, debt, valuation, recent pullback) on more
than 70,000 listed companies. This [MCP](https://modelcontextprotocol.io) connector lets Claude, ChatGPT, Cursor,
VS Code, Claude Code or Gemini query the engine directly.

> "Analyse LVMH" · "Which French stocks score 5/5?" · "Best US dividend stocks above 4%"

**Nothing to install** — it is a hosted service. Connector address:

```
https://investlytic.co/mcp
```

- **3 free requests, no account.** Symbol search is free and does not count.
- Then an Investlytic account and a personal address (see below).
- Every answer states **the date of the data**. This is factual information, not investment advice.

## The 4 tools

| Tool | What it does | Parameters |
|---|---|---|
| `rechercher_action` | Finds a company's ticker from its name ("LVMH" → `MC.PA`). Free. | `requete` |
| `analyser_action` | Investlytic score out of 5 for a stock, with the detail of each criterion and year-by-year price change. | `symbole` |
| `actions_en_tendance` | Best-rated stocks by the engine, sorted by score. Filter by market and minimum score. | `marche`, `note_min`, `limite` |
| `top_dividendes` | Best-ranked dividend stocks (yield, 5-year dividend growth, regularity). | `marche`, `rendement_min`, `rendement_max`, `limite` |

Tool names are in French; your AI understands them in any language.

## Connect your AI in one minute

**Claude (claude.ai / desktop)** — Settings → Connectors → Add custom connector → name `Investlytic`,
URL `https://investlytic.co/mcp`, authentication: none.

**Claude Code**
```bash
claude mcp add --transport http investlytic https://investlytic.co/mcp
```

**Cursor** — `.cursor/mcp.json`:
```json
{ "mcpServers": { "investlytic": { "url": "https://investlytic.co/mcp" } } }
```

**VS Code (Copilot)** — `.vscode/mcp.json`:
```json
{ "servers": { "investlytic": { "type": "http", "url": "https://investlytic.co/mcp" } } }
```

**ChatGPT** — Settings → Connectors → Create (developer mode) → URL `https://investlytic.co/mcp`, no authentication.

**Gemini CLI** — `~/.gemini/settings.json`:
```json
{ "mcpServers": { "investlytic": { "httpUrl": "https://investlytic.co/mcp" } } }
```

Ready-to-copy files are in [`exemples/`](exemples/).

## With your Investlytic account

After the 3 free requests, create an account on [investlytic.co](https://investlytic.co), then
**Settings → "Connect my AI"** to get a personal address that replaces the trial one:
`https://investlytic.co/mcp?key=ilv_your_key`, or the header `Authorization: Bearer ilv_your_key`.

Each request counts as one analysis of your plan (Discovery 30/month, Investor 100/month, Pro unlimited).
The "trending stocks" and "top dividends" lists require the Investor or Pro plan.

**Data freshness**: the free trial, Discovery and Investor plans receive the latest stored Investlytic update
(the date is always given). Only the Pro plan gets same-day, live analysis. [Pricing](https://investlytic.co/tarifs).

## Is the server code here?

No. This repository is the connector's user guide. The server is hosted by Investlytic; personal keys are stored
hashed and only travel in your own configuration.

## Support

contact@investlytic.co · [investlytic.co/connecter-ia](https://investlytic.co/connecter-ia)

Published by VRAIVEX SAS, Paris. MCP protocol 2025-06-18, HTTP transport (JSON-RPC).
