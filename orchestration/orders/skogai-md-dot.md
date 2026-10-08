---
id: skogai-md-dot
repo: projects/dot-skogai
branch: add-skogai-md
base: master
status: pr-open
pane: wW:p1
worktree: /home/skogix/.herdr/worktrees/dot-skogai/add-skogai-md
pr: https://github.com/skogai2/dot-skogai/pull/1
---

## Task

This repo doesn't have a `SKOGAI.md` yet, and it's currently very early —
there's no README, just a `plugins/` directory. Add a `SKOGAI.md` at the
repo root that's honest about that: a short note on what this repo is
*for* (the skogai monorepo's own `SKOGAI.md` describes `dot-skogai` as "the
`.skogai` convention, the bootstrap folder for any project" — but check
whether that's still accurate from what's actually in this worktree rather
than assuming it), and that there isn't much here yet beyond `plugins/`.

Don't invent structure or roadmap that doesn't exist. If `plugins/` has
anything self-explanatory (a README, a single obvious plugin), mention it
briefly; otherwise just note it's there.

Two existing examples elsewhere in the skogai monorepo show acceptable
style — one is a pure router (`projects/config/SKOGAI.md`: frontmatter +
a list of `@file` routes), the other is prose-plus-routes
(`projects/skogai-fleet/SKOGAI.md`: short summary paragraph then a routes
list). You don't have access to those files from inside this worktree
(sibling repo), so don't try to read them — just write in a similar
spirit, scaled down: this one should probably be 3-6 lines given there's
almost nothing here yet.

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It accurately reflects that the repo is early/minimal — no fabricated
  detail about contents that don't exist.
- It's short.

## Out of scope

- Don't add a README, don't flesh out plugins/, don't build out the
  convention this repo is meant to eventually hold.
- Don't touch anything outside this repo.
