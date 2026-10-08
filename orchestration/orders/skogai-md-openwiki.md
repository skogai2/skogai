---
id: skogai-md-openwiki
repo: projects/openwiki
branch: add-skogai-md
base: main
status: pr-open
pane: w12:p1
worktree: /home/skogix/.herdr/worktrees/openwiki/add-skogai-md
pr: https://github.com/skogai/openwiki/pull/1
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

This is a fork (`skogai/openwiki`, upstream project "OpenWiki — a living
wiki for your code, your agents, and you"; it already has its own
`AGENTS.md` and `CLAUDE.md`). Don't duplicate or replace those — route to
them. `SKOGAI.md` is a skogai monorepo convention layered on top: short
context for an agent arriving via the skogai orchestrator, not a rewrite
of the project's own docs.

Two existing examples elsewhere in the skogai monorepo show acceptable
style — one is a pure router (`projects/config/SKOGAI.md`: frontmatter +
a list of `@file` routes), the other is prose-plus-routes
(`projects/skogai-fleet/SKOGAI.md`: short summary paragraph then a routes
list). You don't have access to those files from inside this worktree
(sibling repo), so don't try to read them — just write in a similar
spirit: short, scannable, a starting point not a manual.

Cover, in whatever structure fits:
- What this project is in 1-2 sentences, and that it's a fork vendored
  into the skogai monorepo.
- A route to AGENTS.md/CLAUDE.md/DEVELOPMENT.md for actual contribution
  rules — don't restate them.
- Anything skogai-specific about why this fork is here / how skogai uses
  it, if you can determine it from the repo itself; if you can't, say the
  skogai-specific angle is undocumented rather than inventing one. (Note:
  there's an `openwiki` MCP server/skill elsewhere in the skogai monorepo
  that currently fails to connect — if you find anything in this repo
  that would explain that, mention it briefly, but don't go digging
  outside this repo to chase it down.)

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It doesn't restate what AGENTS.md/CLAUDE.md already say — it routes to
  them.
- It's short — a few short paragraphs or a routes list, not a full
  README rewrite.

## Out of scope

- Don't modify AGENTS.md, CLAUDE.md, README.md, or any other existing
  file.
- Don't touch anything outside this repo.
