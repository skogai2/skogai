---
id: 0016-okn-skogai-md-naming
status: open
created: 2026-10-10T00:00:00Z
repo: okn
---

# Goal

Make okn's `SKOGAI.md` describe the repo as it is now: it is `skogai2/okn`, forked from `openknowledge-sh/openknowledge`.

# Scope

- Edit only `SKOGAI.md` in the okn worktree.
- Out of scope: all other files, the product `Wiki/`, and running `pnpm test` or any other build or test.

# Done when

- [ ] `SKOGAI.md` no longer refers to `okf2`, `ofk-tools`, or "the monorepo" as this repo's identity. It names `origin` = `skogai2/okn` and `upstream` = `openknowledge-sh/openknowledge`. Check both with `git remote -v`.
- [ ] Any remark that the naming is undocumented is removed, because this change documents it.
- [ ] The commit touches only `SKOGAI.md`.

# Context

- Survey: workorder 0013, section 8, first bullet.
- skogix confirmed that the repo is `skogai2/okn`.
