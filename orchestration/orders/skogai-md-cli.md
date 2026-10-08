---
id: skogai-md-cli
repo: projects/skogai-cli
branch: add-skogai-md
base: master
status: done
pane: wP:p1
worktree: /home/skogix/.herdr/worktrees/skogai-cli/add-skogai-md
pr: https://github.com/skogai2/skogai-cli/pull/1
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

Base it on what's actually in the repo (README, docs/, src/ layout, tests),
not on assumptions. Two existing examples elsewhere in the skogai
monorepo show the range of acceptable style — one is a pure router
(`projects/config/SKOGAI.md`, frontmatter + a list of `@file` routes), the
other is prose-plus-routes (`projects/skogai-fleet/SKOGAI.md`, a short
summary paragraph then a routes list). You don't have access to those files
from inside this worktree (they're in a sibling repo), so don't try to read
them — just write in a similar spirit: short, scannable, and useful as a
starting point, not a full manual.

Cover, in whatever structure fits:
- What this project is and does, in 1-3 sentences.
- Where the real documentation lives (e.g. docs/ENV.md, docs/DECISIONS.md,
  docs/CONFIG.md) — link to it with routes rather than duplicating it.
- Anything a cold-starting agent would otherwise have to discover by
  reading code: key commands, how the pieces fit together, anything
  currently in-flux or intentionally left undecided.

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It reflects the actual current state of the repo (verify commands/paths
  you mention actually exist), not boilerplate.
- It's short — a few short paragraphs or a routes list, not a full README
  rewrite.

## Out of scope

- Don't modify README.md, docs/, or any other existing file.
- Don't touch anything outside this repo.
