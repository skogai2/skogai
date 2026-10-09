---
id: 0017-olp-skogai-md-submodule-era
status: open
created: 2026-10-10T00:00:00Z
repo: open-knowledge-plugin
---

# Goal

Update open-knowledge-plugin's `SKOGAI.md` so it describes the repo as a standalone skogai2 repo. It should no longer describe the repo as "vendored into the monorepo".

# Scope

- Edit only `SKOGAI.md` in the open-knowledge-plugin worktree.
- Out of scope: everything else, including CI, `.okf/` and plugin files.

# Done when

- [ ] `SKOGAI.md` describes the repo as a standalone clone at `~/.local/src/open-knowledge-plugin`, with `origin` = `skogai2/open-knowledge-plugin` and `upstream` = `scaccogatto/okf-skills`. Check both with `git remote -v`.
- [ ] Anything that is still true about why skogai uses this fork is kept. The submodule history may stay as one line of history.
- [ ] The commit touches only `SKOGAI.md`.

# Context

- Survey: workorder 0014, section 8, first bullet.
- skogix: this wording dates from when the repo was a submodule of skogai.
- This clone is also the live directory-marketplace source for the plugin. Changing `SKOGAI.md` does not affect plugin behaviour.
