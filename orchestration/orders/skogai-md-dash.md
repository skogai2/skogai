---
id: skogai-md-dash
repo: projects/dash-skogai
branch: add-skogai-md
base: master
status: pr-open
pane: wT:p1
worktree: /home/skogix/.herdr/worktrees/dash-skogai/add-skogai-md
pr: https://github.com/skogai2/dash-skogai/pull/2
---

## Task

This repo doesn't have a `SKOGAI.md` yet. Add one at the repo root
(`SKOGAI.md`) that gives an agent landing here cold enough context to get
oriented without reading the whole tree first.

This is skogai's own infrastructure repo (`/skogai`: the shared multi-agent
workspace and source of truth), not a vendored fork — there's no
AGENTS.md/CLAUDE.md here to defer to, so `SKOGAI.md` should carry more of
the real summary itself. The README already documents the layout table
(admin/, bin/, tools/, gptme-contrib/, scripts/) — route to it rather than
duplicating the table, but do pull out what a cold-starting agent needs
most: what this repo *is for* (every repo installs shared config from it)
and the one or two things that would surprise someone (e.g. generated vs.
tracked directories, the gptme-contrib submodule pin).

Two existing examples elsewhere in the skogai monorepo show acceptable
style — one is a pure router (`projects/config/SKOGAI.md`: frontmatter +
a list of `@file` routes), the other is prose-plus-routes
(`projects/skogai-fleet/SKOGAI.md`: short summary paragraph then a routes
list). You don't have access to those files from inside this worktree
(sibling repo), so don't try to read them — just write in a similar
spirit: short, scannable, a starting point not a manual.

Cover, in whatever structure fits:
- What this repo is and why it exists, in 1-3 sentences.
- A route to README.md for the full layout table instead of repeating it.
- Anything in-flux or easy to get wrong (e.g. what's generated vs. hand
  edited, what requires sudo/ownership, the gptme-contrib pin) — pull
  this from the README and scripts/, don't guess.

## Acceptance

- `SKOGAI.md` exists at the repo root.
- It reflects the actual current state of the repo, not boilerplate.
- It's short — a few short paragraphs or a routes list, not a full
  README rewrite.

## Out of scope

- Don't modify README.md, admin/, scripts/, or any other existing file.
- Don't touch anything outside this repo.
