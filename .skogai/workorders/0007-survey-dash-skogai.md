---
id: 0007-survey-dash-skogai
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/.local/src/dash-skogai
---

# Goal

Write a survey of the skogai2 repo **dash-skogai** (local clone: `/home/skogix/.local/src/dash-skogai`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/dash-skogai`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/dash-skogai ...` for history and status.
- **Do not modify `/home/skogix/.local/src/dash-skogai` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey of `/home/skogix/.local/src/dash-skogai` (read-only; nothing in that
checkout was modified). All claims below are from reading its files and
`git -C /home/skogix/.local/src/dash-skogai ...`.

### 1. Purpose and status

`dash-skogai` is the source repo for `/skogai`: a shared, multi-agent
filesystem workspace (not a code project in the usual sense). It provides
admin scripts to create a `skogai` group/agent users, a generator
(`scripts/gen-bin.py`) that produces portable `uv`-based launchers for
`gptme` and every `gptme-contrib` package, and Claude Code hook scripts that
glue a memory system and `herdr`/`wt` into that shared install
(`README.md`, `scripts/claude/hooks/*.sh`).

**Active, mid-churn.** All 16 commits are from 2026-10-02 through
2026-10-09 (today), with the tip commit (`ecd9d25`, today) deleting a shared
fish config and `config.defaults.json` that had been added only hours
earlier (`c767f28` → `ecd9d25`, same day) — i.e. the repo is still settling
on its own shape, not stable. No TODO/FIXME markers found. No empty
directories tracked in git; `gptme-contrib` is a submodule that is present
but **uninitialized** in this clone (`git submodule status` prints
`-959333e...`, the `-` meaning not checked out).

### 2. Layout

```
README.md              — the entry-point doc; layout table, bootstrap steps, permissions, gotchas
.gitmodules             — gptme-contrib submodule
mise.toml                — uv + python runtimes, puts bin/ on PATH
admin/*.sh               — create-agents, install-coordination, install-tools, setup-coordination, test-coordination
scripts/gen-bin.py        — generates bin/ launchers (pins live here)
scripts/claude/hooks/*.sh — Claude Code hook scripts (see below)
gptme-contrib/            — submodule, empty/uninitialized in this clone
.skogai/logs/hook-tap/log.jsonl — tracked log file (ironically also present; see open questions)
```

No `SKOGAI.md`, `CLAUDE.md`, `AGENTS.md`, or `.claude/` directory exist in
this repo. `README.md` is the only entry-point doc, and it says it is
referenced from `skogai-routing/references/dash-skogai.md` in another repo.
There is a `.skogai/` directory, but it holds only a hook-tap log file, not
routing/knowledge content like the orchestrator worktree has.

### 3. Agent conventions

No routing (`@`-includes), skills, OKF/knowledge bundle, or memory files
live in this repo itself. What it has instead is **hook scripts meant to be
installed into a Claude Code settings elsewhere**:

- `scripts/claude/hooks/cc-memory-prompt-submit.sh` / `cc-memory-stop.sh` —
  delegate to `gptme-cc-memory-*` launchers, pointed at
  `/home/skogix/claude/.skogai/memory/` (a different repo, "claude", not
  this one).
- `scripts/claude/hooks/herdr-agent-state.sh` — herdr's own
  SessionStart-reporting hook (header says "installed by herdr ... managed
  by herdr"), so it's generated/installed tooling, not hand-written here.
- `scripts/claude/hooks/worktree-create.sh` — delegates Claude Code's
  `WorktreeCreate` hook to `wt switch --create`, same pattern this
  orchestrator repo uses.

So an agent working *in* dash-skogai has no local routing to orient by; it
would read `README.md` cold. An agent working *elsewhere* that installs
these hooks needs to know they hardcode `/home/skogix/claude/.skogai`.

### 4. Toolchain

- Shell/Python/Bash only; no application language.
- Package/runtime manager: `mise` (`mise.toml`: `uv`, `python`, both
  `"latest"`, pinned only by whatever `mise` resolves at install time — not
  pinned to exact versions in this repo).
- `gptme`/`gptme-contrib` packages are installed via `uv tool run --from
  <git-spec>`, pinned by commit SHA in `scripts/gen-bin.py`
  (`CONTRIB_REF`, `GPTME_SPEC`), not by a lockfile.
- Build: `bash admin/install-tools.sh` (installs runtimes, regenerates
  `bin/`). Test: `sudo bash admin/test-coordination.sh` (a live
  cross-user smoke test against a real `/skogai` + real system users, not a
  unit test suite). Lint: none. No `Makefile`/`package.json`/`pyproject.toml`
  at the repo root.
- CI: none (no `.github/` directory).

### 5. Git state

- Default/only branch: `master`. Remote branches also present:
  `origin/add-skogai-md`, `origin/add-default-gitignore`,
  `origin/feat/portable-launchers` (all presumably merged or superseded —
  not checked out locally).
- Remote: `origin` → `https://github.com/skogai2/dash-skogai.git`.
- Submodule: `gptme-contrib` → `https://github.com/skogai2/gptme-contrib.git`,
  pinned at `959333e4...` in `.gitmodules`/index, **not initialized** in
  this clone.
- `git status`: clean, `master` up to date with `origin/master`.
  `git log @{u}..` and `git log origin/master..`: empty — no unpushed work
  in this clone.
- No worktrees of this repo exist under this checkout.
- Recent commit themes: bootstrap/permissions scripts → portable
  `uv`-based launchers replacing per-package venvs → shared fish config and
  a `config.defaults.json` convention → both removed same day → gitignore
  and hook refactors. Reads as active exploration of "what belongs in the
  shared workspace," not a finished design.

### 6. Relationships

- Hook scripts hardcode `/home/skogix/claude/.skogai/memory` —
  i.e. a sibling skogai2 repo named **`claude`** — as the memory store
  (`scripts/claude/hooks/cc-memory-prompt-submit.sh`,
  `cc-memory-stop.sh`).
- `README.md` references **`skogai-routing`**
  (`skogai-routing/references/dash-skogai.md`) as the doc that points *into*
  this repo.
- `admin/install-coordination.sh` defaults its source path to
  `$HOME/claude/gptme-contrib/packages/gptme-coordination` — another
  pointer at the `claude` repo.
- No references found to `skogai-cli`, `skogai-docs`, `skogai-fleet`,
  `skogai-git-workflow`, `okn`, `open-knowledge-plugin`, `config`, `dot`,
  `skogix`, or `marketplace` as repo names inside this repo's tracked files.
- **Live install vs. this clone are two separate checkouts, not a
  symlink.** `/skogai` on this machine is its own git clone of the same
  `dash-skogai` remote (same `origin` URL, same `HEAD` commit `ecd9d25` at
  survey time), with its submodule initialized and `bin/`, `tools/`,
  `coordination/` actually populated (`gptme-contrib/`, `coordination/`
  with a live `coord.db`, `scripts/claude/hooks` not present in `/skogai`
  itself — those are installed into Claude Code's own settings elsewhere).
  `/skogai` currently has **staged, uncommitted changes** to `.gitignore`
  and `mise.toml` (seen via `git -C /skogai status` and `diff`, read-only —
  not touched). So the deployed `/skogai` has already drifted from what's
  committed in either checkout.

### 7. Orchestration readiness

A `wt` worktree of **this clone** (`~/.local/src/dash-skogai`) would be
mostly safe for a worker to edit in isolation — the tracked files
(`README.md`, `admin/*.sh`, `scripts/*`, `.gitmodules`, `.gitignore`,
`mise.toml`) are ordinary text/scripts with no secrets found. But several
things would break or mislead a worker who doesn't know the context:

- **This repo is not the live system.** `/skogai` is the thing that
  actually runs (real system users, a real coordination DB, generated
  `bin/`). Editing the clone's scripts does nothing until someone re-runs
  `admin/install-tools.sh` against `/skogai`, and `/skogai` can drift
  independently (it already has uncommitted changes right now). A workorder
  must say explicitly that changes here don't take effect until deployed,
  and must not assume `/skogai` and the clone are in sync.
- **Several admin scripts require `sudo`** and create/modify real system
  users and group membership (`admin/create-agents.sh`,
  `admin/setup-coordination.sh`, `admin/test-coordination.sh`). A worker
  should never run these against the live system; testing them, if needed,
  wants a container/VM, not this machine.
- **Hardcoded absolute paths** outside the repo:
  `/home/skogix/claude/.skogai/memory` (hook scripts) and
  `$HOME/claude/gptme-contrib/...` (`admin/install-coordination.sh`) assume
  a specific layout under the operator's home directory that won't exist
  in an arbitrary worktree checkout path.
- **The `gptme-contrib` submodule is uninitialized** in the surveyed clone;
  a worker touching it needs `git submodule update --init` first (as
  `admin/install-tools.sh` already does).
- No secrets were found in the tracked tree, but `coordination/`, `bin/`,
  and `tools/` are gitignored live-state directories (real at `/skogai`) —
  a workorder should be clear that those are out of scope / not part of
  the source repo.

### 8. Open questions for skogix

- Is `/home/skogix/.local/src/dash-skogai` meant to stay a passive
  reference clone, or should it become the thing `wt` worktrees branch
  from for this repo? Right now `/skogai` (the live install) and this
  clone are two independent `git` checkouts of the same remote with no
  automatic sync, which seems fragile for an orchestration setup.
  Note: `/skogai` currently has uncommitted staged changes
  (`.gitignore`, `mise.toml`) that aren't reflected anywhere else.
- The fish-config / `config.defaults.json` feature was added and then fully
  removed within the same day (`c767f28`…`ecd9d25`). Is that a closed
  experiment, or is there still a plan for a "config defaults" convention
  that should be captured in `.skogai/knowledge/decisions/` instead of
  being dropped silently?
- `scripts/claude/hooks/*.sh` assume a specific operator home layout
  (`/home/skogix/claude/.skogai/memory`). If other agents (e.g. non-`skogix`
  system users created by `admin/create-agents.sh`) are meant to run
  Claude Code with these hooks, the hardcoded `/home/skogix` path looks
  like it would need to be parameterized.
- No CI, lint, or automated test exists beyond the manual
  `admin/test-coordination.sh` smoke test (which itself needs `sudo` and
  real multi-user state) — is that intentional for a machine-bootstrap repo,
  or is there an appetite for something lighter-weight a worker could run
  unattended?
