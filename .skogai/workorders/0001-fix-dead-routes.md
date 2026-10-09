---
id: 0001-fix-dead-routes
status: done
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

## Report

Checked every route in the six in-scope router files:

- `SKOGAI.md`
  - `@./TOOLS.md` → `TOOLS.md` exists — ok
  - `./SKOGAI.md` → self-reference to `SKOGAI.md`, which exists — ok
- `AGENTS.md`
  - `@SKOGAI.md` → `SKOGAI.md` exists — ok
  - `@.skogai/SKOGAI.md` → `.skogai/SKOGAI.md` exists — ok
- `.skogai/SKOGAI.md`
  - `@ROUTES.md` → `.skogai/ROUTES.md` exists — ok
  - `./foo/bar/dot-skogai-only/example.md` → `.skogai/foo/bar/dot-skogai-only/example.md` does not exist, and no `*example*` file exists anywhere under `.skogai/` to redirect it to — **removed** (it was a placeholder route, not a typo of a real file)
- `.skogai/ROUTES.md`
  - `@knowledge/index.md` → `.skogai/knowledge/index.md` exists — ok
- `.skogai/AGENTS.md`
  - `@SKOGAI.md` → `.skogai/SKOGAI.md` exists — ok
- `.skogai/CLAUDE.md`
  - `@SKOGAI.md` → `.skogai/SKOGAI.md` exists — ok

One dead route found and removed; everything else checked out. No other content in these files was changed. Committed as `6e62965`.

Nothing left open.
