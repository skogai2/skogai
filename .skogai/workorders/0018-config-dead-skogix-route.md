---
id: 0018-config-dead-skogix-route
status: done
created: 2026-10-10T00:00:00Z
repo: config
---

# Goal

Make every route in the config repo's router files point at a file that exists.

# Scope

- Router files only: `AGENTS.md` and `SKOGAI.md` in the config worktree.
- Out of scope: topic docs (`atuin.md` and the others), `.skogai/`, `plugins/`, `.gitignore`, and the divergence from origin.

# Done when

- [ ] The dead `@SKOGIX.md` route in `SKOGAI.md` is removed, or fixed if a file it obviously meant exists in this repo.
- [ ] The report lists every route you checked, with ok, fixed or removed for each.
- [ ] The commit touches only router files.

# Context

- Survey: workorder 0003, section 8, first bullet.
- This repo's main checkout is the live `~/.config/skogai`. Work only in your worktree.

## Report

Checked both router files in the config worktree:

- `AGENTS.md` → `@SKOGAI.md` — ok (file exists).
- `SKOGAI.md` → `@atuin.md` — ok (file exists).
- `SKOGAI.md` → `@mappings.md` — ok (file exists).
- `SKOGAI.md` → `@containers.md` — ok (file exists).
- `SKOGAI.md` → `@SKOGIX.md` — removed. No such file exists in the
  worktree, and `git log --all -- SKOGIX.md` / a full-history search for
  any file ever added with "skogix" in its name turned up nothing, so
  there's no renamed file it could have obviously meant to point at
  instead (the existing `SKOGIX.md` text — "the users general layout,
  preferences, quirks and way to navigate a keyboard centric workspace" —
  reads close to what `window-manager.md` and `SKOGAI.md` itself already
  cover, but neither is an obvious 1:1 rename, and both are out of this
  workorder's scope anyway).

Commit `30b1447` on this branch touches only `SKOGAI.md` (one line
removed). Nothing left open.
