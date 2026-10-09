---
id: 0009-survey-skogai-docs
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/.local/src/skogai-docs
---

# Goal

Write a survey of the skogai2 repo **skogai-docs** (local clone: `/home/skogix/.local/src/skogai-docs`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/skogai-docs`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/skogai-docs ...` for history and status.
- **Do not modify `/home/skogix/.local/src/skogai-docs` in any way.** That means no edits, commits, fetches, checkouts or stashes.
- Your only output is the `## Report` section of this workorder file, in this skogai worktree.
- Out of scope: any fixes or suggestions you would implement yourself. List them as findings instead.

# Done when

The report answers each question below under its own `###` heading. Keep it concise, and cite file paths for your claims. Say "unknown" rather than guessing.

1. **Purpose and status.** What is this repo for, in two or three sentences? Is it active, work-in-progress, a seed/skeleton, or abandoned? Give evidence: recent commits, TODOs, empty directories.
2. **Layout.** Key directories and files, and the entry-point docs (README, SKOGAI.md, CLAUDE.md, AGENTS.md, `.skogai/`, `.claude/`).
3. **Agent conventions.** Routing files, `@`-includes, skills, hooks, Claude settings, plugins, knowledge bundles (OKF or other), memory files. How does an agent working here get oriented?
4. **Toolchain.** Languages, package managers, mise or argc, and the exact build, test and lint commands (or "none"). CI setup.
5. **Git state.** Default branch, other branches, submodules, worktrees, remotes, uncommitted or unpushed work (from `git status` and `git log @{u}..`), and the recent commit themes.
6. **Relationships.** References to other skogai2 repos (skogai, claude, config, dot, skogix, marketplace, dash-skogai, skogai-cli, skogai-docs, skogai-fleet, skogai-git-workflow, skogai-routing, okn, open-knowledge-plugin) or to paths under `~`. Is it installed or symlinked anywhere live (`~/.config`, `~/.claude`, plugin installs)?
7. **Orchestration readiness.** Could a worker safely work in a `wt` worktree of this repo? What would break, for example absolute paths, live-installed config, symlinks or secrets? What would a workorder for this repo need to tell the worker?
8. **Open questions for skogix.** Oddities, contradictions, or decisions that seem to be missing.

# Context

- The orchestration model is described in `.skogai/knowledge/decisions/0002-orchestration-model.md` (in this worktree).
- The tools available on this machine are listed in `TOOLS.md`.

## Report

Surveyed `/home/skogix/.local/src/skogai-docs` read-only (`Read`/`Glob`/`Grep`
and `git -C` only; no edits, commits, fetches, checkouts or stashes made).

### 1. Purpose and status

It's a Claude Code plugin marketplace repo (`code-docs-tools`) with one
plugin, `code-docs-lookup`, that lets Claude answer Claude Code questions
from a local, offline-searchable copy of the official docs instead of from
memory (`README.md:1-4`, `HANDOVER.md:1-4`).

Active and recently worked, but mid-build with a known-broken path. 6
commits total, all from Oct 4 2026, last one `8836fc0` "Reorganize tests
into offline and agent checks". `HANDOVER.md`'s "Open problems" section
says the named-skill invocation (`/code-docs-lookup:claude-code-docs …`)
works, but the plain-prompt path does not trigger the skill at all and
the model falls back to (denied) web access — "**Cause not found**"
(`HANDOVER.md:15-19`). No TODOs in code; no empty directories.

### 2. Layout

```
.claude/skills/{plugin-creator,plugin-settings,plugin-structure}/   generic plugin-authoring skills (see §8)
.claude-plugin/marketplace.json        marketplace manifest, lists one plugin
plugins/code-docs-lookup/
  .claude-plugin/plugin.json           plugin manifest (v0.1.0)
  commands/ask.md                      /code-docs-lookup:ask
  scripts/{sync,search,show}-docs.sh   docs cache + lookup
  skills/claude-code-docs/SKILL.md      the skill (+ references/env-vars.md, generated)
tests/{offline,environment,agent}.sh, run-all.sh, run-case.sh, lib.sh, check-run.py
tools/build-env-reference.py           generates skills/claude-code-docs/references/env-vars.md
README.md, HANDOVER.md
```

Entry-point docs: `README.md` (install + test commands) and `HANDOVER.md`
(goal, verified steps, open problems, gotchas, "Run it"). **No**
`SKOGAI.md`, `CLAUDE.md`, or `AGENTS.md` anywhere in the tree.

### 3. Agent conventions

No routing/`@`-include convention, no `.skogai/knowledge` or other OKF
bundle, no memory files, and no `.claude/settings.json` or hooks. The only
orientation an agent gets is reading `README.md` + `HANDOVER.md` by
convention, plus three generic `.claude/skills/` (plugin-creator,
plugin-settings, plugin-structure — see §8) that are unrelated to this
repo's actual content. The plugin itself ships one skill
(`plugins/code-docs-lookup/skills/claude-code-docs/SKILL.md`) and one
command (`commands/ask.md`).

### 4. Toolchain

Bash (`#!/usr/bin/env bash`, a couple `#!/bin/bash`) and Python 3
(`tools/build-env-reference.py`, `tests/check-run.py`, inline snippets in
`tests/environment.sh`). No package manager, no `mise`/`argc` config, no
`Makefile`, no lockfiles — confirmed by `find` for `*.toml`/`package.json`/
`Makefile`/`*.lock` returning nothing. No CI (`.github/` absent).

Commands (from `README.md` / `HANDOVER.md`, all shell scripts, no
building/compiling):
- `tests/offline.sh` — no model calls: docs cache, scripts, env reference, plugin/marketplace manifest, fresh-config install.
- `tests/environment.sh` — one isolated `claude -p` run; checks the run's own init event + transcript.
- `tests/agent.sh` — one real `claude -p` run; calls the API, costs money; currently fails on the plain-prompt path (§1).
- `tests/run-all.sh` runs `offline.sh` then `environment.sh` (not `agent.sh`).
- Lint: none configured.

### 5. Git state

Default/only branch: `master`, tracking `origin/master`
(`https://github.com/skogai2/skogai-docs.git`), up to date, clean working
tree except one untracked dir: `.skogai/logs/hook-tap/log.jsonl` (170
lines, a local hook-tap plugin log — not part of the repo's own content,
harmless, but would need `.gitignore` or removal to tidy). No submodules,
no local worktrees. `git log @{u}..` is empty (nothing unpushed). Commit
themes, oldest to newest: two `init` commits (bundled generic Claude
skills, then the plugin skeleton) → `marketplace` (added
`.claude-plugin/marketplace.json`, moved plugin files under
`plugins/code-docs-lookup/`) → `env` (env-vars reference) →
`dump-before-cleanup` (test harness v1) → `Reorganize tests into offline
and agent checks` (current test layout, moved status into
`HANDOVER.md`).

### 6. Relationships

No references anywhere in the repo's own files to the other skogai2 repo
names (skogai, claude, config, dot, skogix, marketplace, dash-skogai,
skogai-cli, skogai-fleet, skogai-git-workflow, skogai-routing, okn,
open-knowledge-plugin) — confirmed by grep. This repo is self-contained
and topically unrelated to the skogai2 family; it's a Claude Code
docs-lookup tool.

It **is** installed live, but not from the path this survey covers.
`gita`'s `repos.csv` registers `/home/skogix/.local/src/skogai-docs` under
the name `skogai-docs`, but the actually-installed Claude Code
marketplace (`code-docs-tools`, referenced from `~/.claude.json`) points
at a **separate clone** at `/home/skogix/claude-docs` — confirmed same
remote and identical HEAD commit (`8836fc0`), clean working tree, so the
two clones currently hold identical content, but they are two different
directories and only one of them is "live." `README.md:9` itself
documents the install command against `/home/skogix/claude-docs`, not
against the surveyed path. No symlinks from `~/.claude` or `~/.config`
into either clone; the install is a plain directory-marketplace add
(confirmed by `~/.claude/plugins/marketplaces/`, `plugins/cache/`, and
`~/.claude.json` entries all naming `/home/skogix/claude-docs`).

### 7. Orchestration readiness

Mostly yes, with caveats:
- **No absolute-path landmines inside the repo itself** apart from the
  one doc line noted above (`README.md:9`, `/home/skogix/claude-docs`) —
  that line would mislead a worker reading this repo in a worktree, since
  the worktree path won't match it.
- **The real risk is the duplicate-clone setup (§6), not this repo's
  content.** A worktree created from `/home/skogix/.local/src/skogai-docs`
  is a *third* copy, disconnected from the one Claude Code actually has
  installed (`/home/skogix/claude-docs`). A worker here can edit and test
  freely in isolation, but nothing it does is "live" until someone
  updates the real install path, and `tests/offline.sh`'s install check
  exercises a fresh temp config dir, not the real one, so it won't catch
  that gap either.
- **No secrets found** (grepped for api key/secret/token/password; the
  only hits are documentation of Claude Code's own env vars and generic
  skill examples, no literal credentials).
- **No live-installed config or symlinks inside this repo** to worry about
  breaking.
- `tests/agent.sh` calls the real Anthropic API and costs money; a
  workorder should say whether a worker is allowed to run it.
- The untracked `.skogai/logs/hook-tap/log.jsonl` (§5) is local-only and
  wouldn't follow into a worktree branch anyway (untracked, not staged).

A workorder for this repo should tell the worker: (a) which of the two
clones is authoritative for any "verify the install" step, since
`/home/skogix/claude-docs` is the one actually registered, not the
`.local/src` path; (b) whether `tests/agent.sh` may be run (costs money);
(c) that `README.md:9`'s path is specific to the live clone and shouldn't
be treated as generic.

### 8. Open questions for skogix

- Why do two clones of the same repo exist (`/home/skogix/claude-docs` and
  `/home/skogix/.local/src/skogai-docs`), with the live Claude Code
  install pointing at the former while `gita` tracks the latter under the
  `skogai-docs` name? Is one meant to be retired, or are they intentionally
  separate (e.g. one is the "real" working copy, the other a throwaway)?
- The three top-level `.claude/skills/` (plugin-creator, plugin-settings,
  plugin-structure) are generic plugin-authoring skills unrelated to
  `code-docs-lookup`'s actual purpose, committed in the first `init`
  commit (`4c94b0f`) before the plugin's real direction took shape. Are
  they intentional scaffolding left in place, or leftover cruft from repo
  setup that should be removed?
- `HANDOVER.md`'s main open problem (plain-prompt path doesn't invoke the
  skill, cause not found) is still open as of the last commit — is this
  repo waiting on that before further work, or is it considered
  acceptable to ship with the named-command workaround?
- `README.md:9`'s install path (`/home/skogix/claude-docs`) doesn't match
  either the repo's own clone-independent nature or the `.local/src`
  convention used elsewhere (per `TOOLS.md`/gita config) — worth
  reconciling if this repo is folded into the same `wt`/worktree
  orchestration as `skogai`.
