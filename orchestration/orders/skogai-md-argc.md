---
id: skogai-md-argc
repo: projects/argc-completions
branch: add-skogai-md
base: master
status: pr-open
pane: wR:p1
worktree: /home/skogix/.herdr/worktrees/argc-completions/add-skogai-md
pr: https://github.com/skogai/argc-completions/pull/6
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

This repo already has `AGENTS.md` and `CLAUDE.md` — those are the upstream
project's own agent docs (this is a fork of sigoden/argc-completions:
{bash,zsh,fish,powershell,nushell} completions for 1000+ commands, built
with `argc`). Don't duplicate or replace them. `SKOGAI.md` is a *skogai*
monorepo convention layered on top: a short routing/context file so an
agent that just landed here via the skogai orchestrator knows what this
fork is, how it fits into skogai, and where to go next (which is mostly
"read AGENTS.md/CLAUDE.md for the real rules").

Two existing examples elsewhere in the skogai monorepo show acceptable
style — one is a pure router (`projects/config/SKOGAI.md`: frontmatter +
a list of `@file` routes), the other is prose-plus-routes
(`projects/skogai-fleet/SKOGAI.md`: short summary paragraph then a routes
list). You don't have access to those files from inside this worktree
(sibling repo), so don't try to read them — just write in a similar
spirit: short, scannable, a starting point not a manual.

Cover, in whatever structure fits:
- What this project is in 1-2 sentences, and that it's a fork vendored
  into the skogai monorepo (not skogai's own code).
- A route to AGENTS.md/CLAUDE.md for actual contribution rules — don't
  restate them.
- Anything skogai-specific about why this fork is here / how skogai uses
  it, if you can determine it from docs/CONTRIBUTING.md/MANIFEST.md; if
  you can't determine it, say plainly that the skogai-specific angle is
  undocumented rather than inventing one.

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
