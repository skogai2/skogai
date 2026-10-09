---
id: 0018-config-dead-skogix-route
status: open
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
