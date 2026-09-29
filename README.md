# 4D Results API & MCP Server — 4dlivetoday

Official 4D lottery results for **Malaysia, Singapore and Cambodia**, as a free JSON API and a remote **MCP server** that AI assistants (Claude, ChatGPT, Cursor and others) can query directly.

- **MCP server:** `https://4dlivetoday.com/mcp` (Streamable HTTP, no sign-in)
- **REST API:** `https://4dlivetoday.com/api/v1/` (JSON, no key)
- **Docs page:** https://4dlivetoday.com/en/developers
- **Data licence:** [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) — free to use, including commercially, with attribution

Results are compiled from each operator's **own official website** and cross-checked where a second source exists. This service publishes results and draw history only. It does not sell tickets or accept bets, and it offers no number recommendations, "hot" numbers or forecasts.

---

## Contents

- [What's covered](#whats-covered)
- [Use it from an AI assistant (MCP)](#use-it-from-an-ai-assistant-mcp)
- [MCP tools](#mcp-tools)
- [REST API](#rest-api)
- [Response format](#response-format)
- [Errors](#errors)
- [Fair use and caching](#fair-use-and-caching)
- [Attribution](#attribution)
- [Data quality](#data-quality)
- [Licence](#licence)

---

## What's covered

| Operator id | Name | Region |
|---|---|---|
| `magnum` | Magnum 4D | Malaysia |
| `damacai` | Da Ma Cai 1+3D | Malaysia |
| `toto` | Sports Toto 4D | Malaysia |
| `sabah88` | Sabah 88 4D | East Malaysia |
| `stc` | Sandakan STC 4D | East Malaysia |
| `cashsweep` | Sarawak Cash Sweep | East Malaysia |
| `sg` | Singapore 4D (Singapore Pools) | Singapore |
| `gd` | Grand Dragon 4D (GD Lotto) | Cambodia |
| `perdana` | Perdana 4D (evening; the afternoon draw appears as `perdana3pm`) | Cambodia |
| `9lotto` | 9 Lotto 4D | Cambodia |

Every 4D draw has 23 numbers: 1st, 2nd and 3rd prize, 10 special (starter) and 10 consolation.

**Other official games** (`game` ids):

| Game id | Name |
|---|---|
| `magnum_life` | Magnum Life (8 numbers + 2 bonus) |
| `magnum_jackpot`, `magnum_gold` | Magnum 4D Jackpot / Jackpot Gold amounts |
| `damacai_3p3d` | Da Ma Cai 3+3D (6-digit 1st–3rd, starter, consolation) |
| `damacai_jackpot` | Da Ma Cai 1+3D Jackpot and 3D Jackpot amounts |
| `toto_5d`, `toto_6d` | Toto 5D, Toto 6D |
| `toto_star`, `toto_power`, `toto_supreme` | Star Toto 6/50, Power Toto 6/55, Supreme Toto 6/58 |
| `toto_jackpot` | Sports Toto 4D Jackpot amounts |
| `sg_toto` | Singapore Toto (6 numbers + additional number, Group 1 prize) |

History: 4D results go back decades (Magnum from 1985). Magnum and Da Ma Cai other games cover the last 12 months and grow daily; Sports Toto games and Singapore Toto are kept from late September 2026 onward.

Draw days and times: see https://4dlivetoday.com/en/schedule (or the `get_draw_schedule` tool).

---

## Use it from an AI assistant (MCP)

The server speaks Streamable HTTP at:

```
https://4dlivetoday.com/mcp
```

No API key and no OAuth.

### Claude (claude.ai and Claude Desktop, via connectors)

Settings → Connectors → **Add custom connector** → paste `https://4dlivetoday.com/mcp`.

### Claude Desktop (config file, via mcp-remote)

`claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "4dlivetoday": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://4dlivetoday.com/mcp"]
    }
  }
}
```

### Claude Code

```bash
claude mcp add --transport http 4dlivetoday https://4dlivetoday.com/mcp
```

### Cursor

`~/.cursor/mcp.json` (or `.cursor/mcp.json` in a project):

```json
{
  "mcpServers": {
    "4dlivetoday": { "url": "https://4dlivetoday.com/mcp" }
  }
}
```

### VS Code

`.vscode/mcp.json`:

```json
{
  "servers": {
    "4dlivetoday": { "type": "http", "url": "https://4dlivetoday.com/mcp" }
  }
}
```

### Try it

Ask your assistant things like:

- "What were last night's Magnum 4D results?"
- "Show me every operator's 4D results for 27 September 2026."
- "Has 1063 ever won a prize? When?"
- "What's the latest Supreme Toto 6/58 result and jackpot?"
- "When is the next Singapore 4D draw?"

Ready-made config files are in [`examples/mcp`](examples/mcp).

---

## MCP tools

| Tool | Input | What it returns |
|---|---|---|
| `get_latest_results` | — | The newest draw for every operator |
| `get_results_by_date` | `date` (YYYY-MM-DD, Malaysia time) | Every operator's draw on that date |
| `get_operator_results` | `operator`, `limit` (1–30, default 10) | That operator's most recent draws |
| `lookup_number` | `number` (4 digits, e.g. `"0650"`) | Every draw in which the number won, with prize tier, newest first, plus a total count |
| `get_other_game_results` | `game`, `limit` (1–30, default 10) | Recent results of one of the other games listed above |
| `get_draw_schedule` | — | Upcoming draw dates (regular and special) and which operators draw |

Every tool result includes a short text summary plus the full structured data, and each result carries a `url` to the matching page on 4dlivetoday.com so the assistant can link to it.

---

## REST API

Base URL: `https://4dlivetoday.com/api/v1`

| Method & path | Description |
|---|---|
| `GET /api/v1` | Index: endpoints and envelope fields |
| `GET /api/v1/latest` | Newest draw for every operator |
| `GET /api/v1/results/{date}` | All operators on a date (`YYYY-MM-DD`, Malaysia time) |
| `GET /api/v1/operators/{operator}?limit=10` | Recent draws of one operator (`limit` 1–30) |
| `GET /api/v1/numbers/{number}` | Every winning appearance of a 4-digit number |
| `GET /api/v1/games/{game}?limit=10` | Recent results of another official game |
| `GET /api/v1/schedule` | Upcoming draw dates |
| `GET /api/v1/openapi.json` | OpenAPI 3.1 description |

### Examples

```bash
curl https://4dlivetoday.com/api/v1/latest
curl https://4dlivetoday.com/api/v1/results/2026-09-27
curl "https://4dlivetoday.com/api/v1/operators/magnum?limit=5"
curl https://4dlivetoday.com/api/v1/numbers/1063
curl "https://4dlivetoday.com/api/v1/games/sg_toto?limit=3"
curl https://4dlivetoday.com/api/v1/schedule
```

More in [`examples/`](examples): [curl](examples/curl.sh), [Python](examples/python/latest.py), [Node.js](examples/node/latest.mjs).

CORS is open (`Access-Control-Allow-Origin: *`), so you can call it from a browser.

---

## Response format

Every successful response has the same envelope (`url` is the matching human-readable page on 4dlivetoday.com):

```json
{
  "data": { "results": [ ] },
  "source": "4dlivetoday.com",
  "license": "CC BY 4.0",
  "license_url": "https://creativecommons.org/licenses/by/4.0/",
  "attribution": "Results from 4dlivetoday.com (https://4dlivetoday.com), compiled from each operator's official site.",
  "url": "https://4dlivetoday.com/en/results/2026-09-27",
  "generated_at": "2026-09-30T12:00:00.000Z"
}
```

What `data` holds per endpoint:

| Endpoint | `data` |
|---|---|
| `/latest` | `{ results: [draw, …] }` — newest draw of each operator |
| `/results/{date}` | `{ date, results: [draw, …] }` (empty `results` plus a `note` on a day with no draws) |
| `/operators/{operator}` | `{ operator, operator_name, results: [draw, …] }` |
| `/numbers/{number}` | `{ number, count, results: [{ operator, operator_name, date, draw_no, tier, url }, …] }` — `tier` is `1st`, `2nd`, `3rd`, `special` or `consolation` |
| `/games/{game}` | `{ game, game_name, operator, results: [game result, …] }` |
| `/schedule` | `{ schedule: [{ date, kind, operators: [{ id, name }, …] }, …] }` — `kind` is `regular` or `special` |

A 4D draw (real, trimmed):

```json
{
  "operator": "magnum",
  "operator_name": "Magnum 4D",
  "date": "2026-09-27",
  "draw_no": "428/26",
  "first": "1063",
  "second": "2421",
  "third": "5815",
  "special": ["6814", "7902", "… 10 numbers"],
  "consolation": ["1091", "8204", "… 10 numbers"],
  "status": "checked",
  "url": "https://4dlivetoday.com/en/results/2026-09-27"
}
```

Numbers are always strings, so leading zeros are kept (`"0650"`, never `650`).

`status` tells you how far a result has been verified:

| status | Meaning |
|---|---|
| `checked` | Official result confirmed by an independent second source |
| `verifying` | Published, second-source check still running (usually minutes after the draw) |
| `single_source` | Only one official source exists for this operator |
| `history` | Imported from the archive |

A game result (real, trimmed):

```json
{
  "game": "sg_toto",
  "game_name": "Singapore Toto",
  "operator": "sg",
  "date": "2026-09-28",
  "draw_no": "4221",
  "numbers": ["14", "22", "25", "27", "34", "37"],
  "bonus": ["18"],
  "jackpots": { "Group 1 prize": "S$ 1,298,326" },
  "url": "https://4dlivetoday.com/en/sg-toto"
}
```

Money amounts are strings exactly as the operator published them, with currency (`"RM 12,749,753.62"`, `"S$ 1,298,326"`). `draw_no` can be empty for operators that don't publish a readable draw number.

---

## Errors

```json
{ "error": { "code": "invalid_date", "message": "date must be a real calendar date in YYYY-MM-DD format" } }
```

| HTTP | code | When |
|---|---|---|
| 400 | `invalid_date`, `invalid_operator`, `invalid_number`, `invalid_game`, `invalid_limit` | Bad input |
| 429 | — | Too many MCP requests from one address; wait for `Retry-After` |
| 503 | `upstream_unavailable` | Results store temporarily unreachable; retry shortly |

A date with no draws (for example a regular Monday for the weekly operators) is **not** an error: it returns `200` with an empty list.

In MCP, the same problems come back as a tool result with `isError: true` and the same message.

---

## Fair use and caching

- No key and no sign-up. Responses are cached for about 60 seconds; results change only around draw times, so please cache on your side too.
- Unknown query parameters are dropped with a redirect to the canonical URL.
- The MCP endpoint accepts one request per call (no JSON-RPC batches).
- Draw nights (roughly 18:30–21:30 Malaysia time on draw days) are when results change; polling more often than once a minute gains nothing.
- Abusive traffic may be rate-limited without notice.

---

## Attribution

The data is licensed **CC BY 4.0**. If you show or republish it, credit:

> Results from [4dlivetoday.com](https://4dlivetoday.com), compiled from each operator's official site.

A link back is appreciated and is how this stays free.

---

## Data quality

- Every result comes from the operator's own official site. Where a second independent source exists, the result is cross-checked and its `status` becomes `checked`.
- Always treat the operator's own announcement as final. If you find a result that differs from the operator's official site, please [open an issue](../../issues) with the date, operator and the operator's page.

---

## Licence

- **Data** returned by the API and MCP server: [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/). See [DATA-LICENSE.md](DATA-LICENSE.md).
- **Code and documentation** in this repository: [MIT](LICENSE).

4dlivetoday is an independent results site. It is not affiliated with any operator named above; operator names are used only to identify their results. For readers aged 21 and over, where the law allows.
