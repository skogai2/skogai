---
id: skogai-md-okfclaude
repo: projects/ofk-claude
branch: add-skogai-md
base: main
status: done
pane: wY:p1
worktree: /home/skogix/.herdr/worktrees/ofk-claude/add-skogai-md
pr: https://github.com/skogai2/okf/pull/1
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

This is a fork (`skogai2/okf`, upstream project "okf: the Open Knowledge
Format toolkit for Claude Code" — agents/hooks/servers/skills for
authoring, validating and visualizing OKF knowledge bundles). Check
whether it has its own AGENTS.md/CLAUDE.md or CONTRIBUTING doc; if so,
route to it rather than duplicating it. `SKOGAI.md` is a skogai monorepo
convention layered on top — short context for an agent arriving via the
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
  into the skogai monorepo under a different name (ofk-claude ==
  skogai2/okf).
- A route to whatever real docs exist (README, CHANGELOG, any
  AGENTS/CLAUDE/CONTRIBUTING file) instead of restating them.
- Anything skogai-specific about why this fork is here, if you can
  determine it from the repo itself; if you can't, say the skogai-specific
  angle is undocumented rather than inventing one.

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It doesn't restate what existing docs already say — it routes to them.
- It's short — a few short paragraphs or a routes list, not a full
  README rewrite.

## Out of scope

- Don't modify README.md, CHANGELOG.md, or any other existing file.
- Don't touch anything outside this repo.
