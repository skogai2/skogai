---
id: 0016-okn-skogai-md-naming
status: done
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

## Report

Verified remotes with `git remote -v` in the okn worktree: `origin` =
`https://github.com/skogai2/okn.git`, `upstream` =
`https://github.com/openknowledge-sh/openknowledge.git`.

Rewrote `SKOGAI.md`:
- Frontmatter now has `project: okn`, `origin: skogai2/okn`,
  `upstream: openknowledge-sh/openknowledge` (previously `project: ofk-tools`,
  `upstream: Open Knowledge (skogai2/okf2)`).
- Body now states this repo is `skogai2/okn`, a fork of
  `openknowledge-sh/openknowledge`, naming both remotes explicitly. Removed
  all references to `okf2`, `ofk-tools`, and "the skogai monorepo" as this
  repo's identity.
- Removed the closing paragraph claiming the monorepo/naming rationale is
  undocumented, since this edit documents the naming.

Committed on branch `wo/0016-okn-skogai-md-naming` in the okn worktree
(commit 6f558b2), touching only `SKOGAI.md`.

Nothing left open.
