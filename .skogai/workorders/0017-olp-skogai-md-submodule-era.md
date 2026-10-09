---
id: 0017-olp-skogai-md-submodule-era
status: done
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

## Report

Edited `SKOGAI.md` in the open-knowledge-plugin worktree
(`/home/skogix/.local/src/open-knowledge-plugin/.skogai/worktrees/wo-0017-olp-skogai-md-submodule-era/SKOGAI.md`) and committed it there as `1d9f867` on branch `wo/0017-olp-skogai-md-submodule-era`, touching only that file.

- Verified remotes with `git remote -v`: `origin` = `https://github.com/skogai2/open-knowledge-plugin.git`, `upstream` = `https://github.com/scaccogatto/okf-skills.git`.
- Rewrote the body: it now opens by calling the repo "a standalone clone of **okf**", states it lives at `~/.local/src/open-knowledge-plugin` with `origin` = `skogai2/open-knowledge-plugin` and `upstream` = `scaccogatto/okf-skills`, and explicitly says it's "a separate repo with its own remotes, not a path or submodule inside `skogai`" — removing the old "vendored here"/"lives in the monorepo" wording.
- Kept the submodule history as one line: "It was once a submodule of the skogai monorepo under the name `ofk-claude`; that's now one line of history, not its current shape."
- Kept the one thing that's still true from the old text — that the skogai-specific reason this fork exists under a different name than upstream is undocumented in the repo itself — reworded away from "vendoring"/"monorepo" language.
- Left the frontmatter `routes:` list and the AGENTS.md/CLAUDE.md/CONTRIBUTING paragraph untouched.
- Did not touch CI, `.okf/`, or plugin files, per scope. The pre-existing modified-but-uncommitted `.skogai/logs/hook-tap/log.jsonl` in that worktree (a global hook's session log, unrelated to this task) was left alone and not committed.

Nothing left open; all three "Done when" items are satisfied.
