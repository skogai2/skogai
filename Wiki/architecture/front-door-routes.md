---
type: Reference
title: Front-Door Routes
description: The routes in SKOGAI.md, what each route owns, and where its source is.
tags: [skogai, routes, reference]
---

# Front-Door Routes

These routes are listed in `SKOGAI.md` at the repo root. Each route points to a
home outside this repo. This page only summarizes the route. For the content,
follow the route. Source: `SKOGAI.md`.

| Route | Home | Owns |
| --- | --- | --- |
| TOOLS.md | `./TOOLS.md` | The tools on this machine (herdr, wt, gh, gptodo, gptme-coordination, ...) and how skogai uses them. |
| skogai | this repo | The front-door index itself (`SKOGAI.md` routes to itself). |

## Notes

* This table was rewritten on 2026-10-09 to match the current `SKOGAI.md`,
  which now lists only these two routes. The previous table (`dot-skogai`,
  `dash-skogai`, `skogix`, `claude`, `dot`, `config`) is history, not current
  behavior; see `log.md` for when it changed.
* The `~/` paths a route may point to are outside this repo. Verify that a
  path exists before you rely on it. The wiki does not copy their content.
