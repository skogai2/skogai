---
id: skogai-md-okftools
repo: projects/ofk-tools
branch: add-skogai-md
base: main
status: pr-open
pane: w0:p1
worktree: /home/skogix/.herdr/worktrees/ofk-tools/add-skogai-md
pr: https://github.com/skogai2/okf2/pull/1
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

This is a fork (`skogai2/okf2`, upstream project "Open Knowledge" —
a CLI that turns repository Markdown into managed, searchable knowledge;
see its own `AGENTS.md` for contribution rules). Don't duplicate or
replace `AGENTS.md` — route to it. `SKOGAI.md` is a skogai monorepo
convention layered on top: short context for an agent arriving via the
skogai orchestrator, not a rewrite of the project's own docs.

Two existing examples elsewhere in the skogai monorepo show acceptable
style — one is a pure router (`projects/config/SKOGAI.md`: frontmatter +
a list of `@file` routes), the other is prose-plus-routes
(`projects/skogai-fleet/SKOGAI.md`: short summary paragraph then a routes
list). You don't have access to those files from inside this worktree
(sibling repo), so don't try to read them — just write in a similar
spirit: short, scannable, a starting point not a manual.

Cover, in whatever structure fits:
- What this project is in 1-2 sentences, and that it's a fork vendored
  into the skogai monorepo under a different name (ofk-tools ==
  skogai2/okf2).
- A route to `AGENTS.md` and `PRODUCT.md` for the real rules/vision
  instead of restating them.
- Anything skogai-specific about why this fork is here, if you can
  determine it from the repo itself; if you can't, say the skogai-specific
  angle is undocumented rather than inventing one.

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It doesn't restate what AGENTS.md/PRODUCT.md already say — it routes to
  them.
- It's short — a few short paragraphs or a routes list, not a full
  README rewrite.

## Out of scope

- Don't modify AGENTS.md, README.md, PRODUCT.md, or any other existing
  file.
- Don't touch anything outside this repo.
