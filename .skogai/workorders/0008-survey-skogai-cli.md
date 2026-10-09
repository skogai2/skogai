---
id: 0008-survey-skogai-cli
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/.local/src/skogai-cli
---

# Goal

Write a survey of the skogai2 repo **skogai-cli** (local clone: `/home/skogix/.local/src/skogai-cli`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/skogai-cli`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/skogai-cli ...` for history and status.
- **Do not modify `/home/skogix/.local/src/skogai-cli` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Read-only survey of `/home/skogix/.local/src/skogai-cli` (`git -C` and Read/Glob/Grep only; nothing in that clone was modified).

### 1. Purpose and status

The `skogai` CLI: "one place for skogai conventions" (stdlib-only Python,
no deps), starting with an `env` module and growing `config`/`links`/a
`.skogai` store synced from dash-skogai (`SKOGAI.md`).

Status: **mid-rework, currently not runnable, not active development in
the usual sense.** On 2026-10-08 the entire Python implementation was
deleted in one commit — `4f635d0 "Wipe Python implementation for a
from-scratch rework"` — which removed `src/`, `tests/`, `README.md`,
`pyproject.toml`, `examples/`, and every doc under `docs/` except two. The
commit message says the old implementation (argparse wrapping git/file
IO/JSON merging) is preserved on the `python-implementation` branch, and
master keeps only "routing files"; policy docs get re-derived as needed.
Since then (2026-10-09, same day as this survey) there have been two
research-notes commits (`06c4df6`, `541e65e`) comparing git-config vs.
JSON+jq as the config storage format for the rework — no code yet, just
docs. So: an active rework-in-progress, but right now the repo has **no
runnable CLI and no tests**.

### 2. Layout

Entire tracked tree at HEAD:
```
AGENTS.md
SKOGAI.md
docs/GIT-CONFIG-FORMAT.md
docs/JSON-JQ-MERGE.md
```
No `src/`, `tests/`, `README.md`, `.claude/`, `.github/`, or `pyproject.toml`
currently exist (all removed by `4f635d0`; still present on
`origin/python-implementation`). `AGENTS.md` and `SKOGAI.md` are the only
entry points. `SKOGAI.md` still links to `README.md`, `docs/ENV.md`,
`docs/ENV-HANDOVER.md`, `docs/GLOSSARY.md`, `docs/CONFIG.md`,
`docs/DECISIONS.md`, and `examples/demo.sh` — **all seven of these are
dead links**, since those files no longer exist on this branch. `TOOLS.md`
is cross-referenced in `docs/GIT-CONFIG-FORMAT.md`'s notes section but
there's no `TOOLS.md` in the repo itself (that's this repo's `TOOLS.md`,
not theirs). No `.skogai/` directory is tracked in git at all (see §5).

### 3. Agent conventions

`AGENTS.md` is a minimal router (`type: router` frontmatter, one `<routes>`
block pointing to `@SKOGAI.md`), matching the pattern used in this repo.
`SKOGAI.md` is the real index, a flat bullet list of doc links (no
`<routes>` block). No `.claude/` directory, no Claude settings, no
skills, no hooks, no plugin manifests, no OKF/knowledge bundle tracked in
git. An agent landing here cold gets oriented via `AGENTS.md` →
`SKOGAI.md`, but most of what `SKOGAI.md` points to is currently missing
(§2) — the router works, the destinations mostly don't.

### 4. Toolchain

Python 3.10+, stdlib only, no dependencies (per `SKOGAI.md`, confirmed by
the now-deleted `pyproject.toml` on `python-implementation`, which also
registered a `skogai` console-script entry point and `setuptools` build
backend). No mise config, no argc, no Makefile, no CI (no `.github/`
anywhere in history I checked). Build/test commands as currently
documented in `SKOGAI.md`: run via `PYTHONPATH=src python3 -m skogai env
check`; tests via `python3 -m unittest discover -s tests`. **Neither
command works on master right now** — `src/` and `tests/` don't exist
there (only on `origin/python-implementation`). No lint config found
(no ruff/flake8/mypy config on either branch I looked at).

### 5. Git state

- Default branch: `master`, up to date with `origin/master`, no
  unpushed commits (`git log @{u}..` empty).
- Remote: `origin` → `https://github.com/skogai2/skogai-cli.git`.
- Other branches: `origin/python-implementation` (full pre-wipe Python
  implementation, explicitly preserved by `4f635d0`) and
  `origin/add-skogai-md` (tip `b16d876`, already an ancestor of `master`
  — fully merged, just an old branch pointer, nothing pending).
- No submodules (no `.gitmodules`), no git worktrees other than the main
  checkout itself (`git worktree list` shows only
  `/home/skogix/.local/src/skogai-cli`).
- Uncommitted work: one untracked item, `.skogai/` (specifically
  `.skogai/logs/hook-tap/log.jsonl`, 86 lines as of this survey). This is
  **not a tracked config store** — there's no `.gitignore` on master
  (deleted by `4f635d0`) and no `.skogai/config.json` — it looks like a
  machine-local hook-tap log written by whatever agent tooling touches
  this directory (it was still growing while I ran commands against the
  repo during this survey). It's cruft/log output, not project state.
- Recent commit themes: 2026-10-07 was "beta" CLI functionality (config
  model, init/update/install, help-format, decisions log); 2026-10-08
  added routing docs then wiped the implementation same day; 2026-10-09
  is research notes for the rework (git-config format, JSON+jq merge,
  `includeIf` footgun) with no code yet.

### 6. Relationships

- No references to other skogai2 repos found in the current tracked
  files (`AGENTS.md`, `SKOGAI.md`, `docs/*.md`) other than the conceptual
  mention of "dash-skogai" as the source the `.skogai` store syncs from
  (`SKOGAI.md`) — no path or URL to it.
- Not symlinked or live-installed anywhere under `~/.config` or
  `~/.claude`. It **is** installed as a `uv tool`: `~/.local/bin/skogai`
  → `~/.local/share/uv/tools/skogai-cli/bin/skogai`, an **editable**
  install whose `.pth` file points at
  `/home/skogix/skogai/projects/skogai-cli/src` — a path `TOOLS.md` in
  this repo already flags as gone ("the `projects` group still lists the
  old `skogai/projects/*` submodules, which no longer exist"). I ran
  `~/.local/bin/skogai --help`: it fails with
  `ModuleNotFoundError: No module named 'skogai'`. **The only live,
  installed copy of this CLI on the machine is currently broken**,
  pointing at a path that predates both the submodule removal and the
  2026-10-08 wipe.
- Old Claude Code session-project directories under
  `~/.claude/projects/` reference a prior location,
  `-home-skogix-skogai-projects-skogai-cli`, and a prior herdr worktree,
  `-home-skogix--herdr-worktrees-skogai-cli-add-skogai-md` — consistent
  with `add-skogai-md` (§5) having already been developed and merged via
  an earlier herdr/worktree flow, before this repo moved to
  `/home/skogix/.local/src/skogai-cli`.

### 7. Orchestration readiness

A worker could run in a `wt` worktree of this repo safely as far as
isolation goes — no absolute paths inside the tracked files, no live
symlinks from `~/.config` or `~/.claude` into this clone, no secrets
found in tracked content. Concretely:

- **Nothing to break on the "live config" front** — confirmed in §6,
  this clone isn't the thing `~/.local/bin/skogai` resolves to, so
  editing it has no live blast radius on the current shell/session.
- **The stale `.skogai/hook-tap` log is noise, not state** — a workorder
  should tell the worker to ignore/not commit `.skogai/` unless it's
  deliberately building the config-store feature, since right now it's
  just an untracked log file with no corresponding `.gitignore`.
- **Big caveat: there's effectively nothing to build on yet.** `src/`,
  `tests/`, and most docs are gone (§2); a workorder dispatched into a
  worktree of this repo right now would need to either (a) explicitly
  scope itself to the research-notes/docs track `06c4df6`/`541e65e` are
  on, or (b) decide whether to resurrect code from
  `origin/python-implementation` as a starting point — the commit that
  wiped it says policy docs "get re-derived as the rework needs them,"
  not that the code should be ported back verbatim. A workorder should
  say explicitly which of these it wants, and should **not** assume
  `SKOGAI.md`'s doc links are real (§2) — several are dead.
- No CI, no pre-merge hooks of their own to interact with this repo's
  `wt`/`herdr` pipeline differently than any other repo.

### 8. Open questions for skogix

- Is `origin/python-implementation` meant to be cherry-picked from during
  the rework, or is it purely a historical reference never to be merged
  back? `4f635d0`'s message is ambiguous on this.
- `SKOGAI.md` on master still documents `config get`, `init`,
  `update`, `install`, and the five-layer config model as if they exist —
  should it be trimmed to match current (near-empty) reality until the
  rework produces something runnable, or left as the target spec?
- The broken `~/.local/bin/skogai` (uv editable install pointing at the
  dead `~/skogai/projects/skogai-cli/src` path) looks like leftover
  cruft from before the repo moved — is it meant to be reinstalled from
  `/home/skogix/.local/src/skogai-cli` once there's something to install,
  or removed/replaced with something else (e.g. `uv tool install -e
  /home/skogix/.local/src/skogai-cli`)?
- Should the untracked `.skogai/logs/hook-tap/log.jsonl` have a
  `.gitignore` entry (there is none on master at all right now), so a
  future `git add -A` in a worktree doesn't accidentally commit it?
