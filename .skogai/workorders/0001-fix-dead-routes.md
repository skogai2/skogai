---
id: 0001-fix-dead-routes
status: open
created: 2026-10-09T00:00:00Z
---

# Goal

Every route in skogai's router files points at a file that exists. This is also the first test of the `bin/wo` pipeline.

# Scope

- Router files only: `SKOGAI.md`, `AGENTS.md`, `.skogai/SKOGAI.md`, `.skogai/ROUTES.md`, `.skogai/AGENTS.md`, `.skogai/CLAUDE.md`.
- Routes are lines like `- @path` or `- ./path` inside `<routes>` blocks or route lists. `@` paths resolve relative to the file that contains them.
- Out of scope: `TOOLS.md`, `.skogai/knowledge/`, `~/.claude/CLAUDE.md`, and anything outside this repo.

# Done when

- [ ] Each dead route is removed, or fixed to point at the file it obviously meant.
- [ ] The report lists every route you checked, with ok, fixed or removed for each.
- [ ] No other content in these files changed.

# Context

- Known suspect: `.skogai/SKOGAI.md` has an example route, `./foo/bar/dot-skogai-only/example.md`, that does not exist.
