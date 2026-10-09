---
id: 0004-survey-dot
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/dot
---

# Goal

Write a survey of the skogai2 repo **dot** (local clone: `/home/skogix/dot`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/dot`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/dot ...` for history and status.
- **Do not modify `/home/skogix/dot` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey of `/home/skogix/dot` (origin `https://github.com/skogai2/dot.git`, branch `master`), read-only, no changes made there.

### 1. Purpose and status

`dot` is Skogix's agent for the *base environment*: dotfiles, shared dev tooling, shell ergonomics, and agent infrastructure — explicitly not individual project implementation (`README.md:4-6`, `ABOUT.md:5-20`). It is a `gptme` "agent template" instance (same lineage as `gptme/dot`), with shared tooling vendored as the `gptme-contrib` git submodule (`ARCHITECTURE.md:13`, `.gitmodules`).

Status: **young / early work-in-progress**, not abandoned. 7 commits total, all dated 2026-09-30 to 2026-10-02 (`git log`), none since (today is 2026-10-09 — a week idle). Working tree is clean and up to date with `origin/master`. The only completed task is `tasks/initial-agent-setup.md` (`state: done`); nine `review-gptme-*` tasks are still `state: new` (backlog) and four `validate-tool-*` tasks are `todo`/`active` — i.e. scaffolding is finished but the planned review/validation work hasn't started. `projects/` is a stub (README only, no actual project symlinks yet, despite `ARCHITECTURE.md` describing it as populated). `state/queue-manual.md` is still the unfilled template (`[Brief description of current work]` placeholders). The systemd autonomous service (`gptme-agent-dot.service`) exists but is disabled/inactive.

### 2. Layout

Root docs (all auto-loaded via `gptme.toml`'s `[prompt] files`): `README.md`, `ARCHITECTURE.md`, `ABOUT.md`, `SOUL.md`, `TASKS.md`, `TOOLS.md`, plus `lessons/README.md` and `projects/README.md`. `AGENTS.md` and `WORKFLOW.md` exist but aren't in the auto-load list (`AGENTS.md` is read natively by Claude Code; `WORKFLOW.md` is deliberately excluded — "rendered at run time," per a comment in `gptme.toml:14`).

Key directories: `journal/` (dated session logs), `knowledge/` (2 files: `agent-forking.md`, `forking-workspace.md`), `lessons/` (behavioral patterns), `people/` (profile templates, empty of actual profiles), `state/` (work-queue files), `tasks/` (13 task files + templates), `scripts/` (mostly symlinks into `gptme-contrib`), `dotfiles/` (installable global git hooks, also symlinked into `gptme-contrib`), `gptme-contrib/` (submodule), `.claude/` (hooks + settings), `.github/` (one config file, no workflows).

No `CLAUDE.md` or `SKOGAI.md` — `AGENTS.md:109-112` notes this is intentional: Claude Code reads `AGENTS.md` natively when no `CLAUDE.md` exists.

### 3. Agent conventions

- **Routing**: no `@`-include routing files (unlike this skogai repo). Orientation is `gptme.toml` → `[prompt] files` list → the docs above; `AGENTS.md` is the Claude-Code-native entry point and duplicates/summarizes the same "read these files" guidance plus repo-specific git/task/testing rules.
- **Skills**: `[lessons] dirs = ["lessons", "skills", "gptme-contrib/skills"]` in `gptme.toml` — agent-specific lessons/skills take precedence over `gptme-contrib`'s shared ones. No local `skills/` directory exists yet (allowlisted in `.github/root-structure-allowlist.yaml` but not created).
- **Hooks**: `.claude/settings.json` wires `UserPromptSubmit`/`PreToolUse` → `match-lessons.py` (symlinked from `gptme-contrib`) for automatic lesson-matching, and `Stop` → `post-session.py` (local script, not a symlink).
- **Knowledge bundles**: no OKF or other structured knowledge bundle — `knowledge/` is two freeform markdown docs, not an OKF-style index/decisions structure like this skogai repo's `.skogai/knowledge/`.
- **Memory**: `journal/` (append-only daily logs) and `state/` (work-queue) serve as the durable-memory analogs; no CLAUDE-style memory files beyond that.
- An agent orienting here would: read the `gptme.toml` prompt files, run `scripts/context.sh` (symlink into `gptme-contrib`) for dynamic context, then check `gptodo ready --skip-claimed --jsonl` for unblocked tasks (`AGENTS.md`, `TOOLS.md`).

### 4. Toolchain

`dot` itself ships **no package manifest of its own** (no `pyproject.toml`/lockfile at root) — it's a markdown/shell workspace. The submodule `gptme-contrib` is a Python project (`uv`, `pyproject.toml`, `uv.lock`) that supplies the actual tooling (`gptodo`, context scripts, hooks) via symlinks.

- **Lint/format**: `pre-commit` (or `prek` if installed) via `.pre-commit-config.yaml`: `ruff`/`ruff-format`, `mypy`, `shellcheck` (excludes `gptme-contrib/` and `dotfiles/`), plus local validators (`validate-root-structure`, `check-names`, `check-markdown-links`, codeblock-syntax checks) from `gptme-contrib/scripts/precommit/`.
- **Build/test/lint commands** (`Makefile`): `make format`, `make check` (all hooks), `make test` (runs `pytest tests/` only if a `tests/` dir with `.py` files exists at root — it doesn't, so this is currently a no-op: "No tests found"), `make typecheck` (mypy via pre-commit), `make context` (`scripts/context.sh`), `make stats` (cloc).
- **No mise or argc** config found in `dot` itself.
- **CI**: none. `.github/` contains only `root-structure-allowlist.yaml` (consumed by the `validate-root-structure` pre-commit hook); `.github/workflows/` does not exist.

### 5. Git state

- Default/only branch: `master` (per `git branch -vv`), tracking `origin/master`, clean, no unpushed commits (`git log @{u}..` empty).
- Single remote: `origin → https://github.com/skogai2/dot.git`.
- Single worktree (`git worktree list` shows only `/home/skogix/dot`).
- One submodule: `gptme-contrib`, checked out at a commit that is on a non-mainline branch (`remotes/origin/bob/judge-content-example-6-489-gb6f948bf`) rather than `master` — worth a note but not necessarily a problem.
- Recent commit themes: initial scaffolding and identity setup (`34f3c5d`, `626914a`), doc cleanup (`e22f74d`), removing vendored lesson copies in favor of the submodule (`1cc4a39`), adding validation/tool-review tasks (`5e8b5f1`), and docs/examples (`b5ed032`, `cbc72f4`).
- No uncommitted or stray files; working tree matches `AGENTS.md`'s expectations.

### 6. Relationships

No textual references to the other skogai2 repos (skogai, claude, config, skogix, marketplace, dash-skogai, skogai-cli, skogai-docs, skogai-fleet, skogai-git-workflow, skogai-routing, okn, open-knowledge-plugin) were found anywhere in tracked files outside the `gptme-contrib` submodule (`git grep` for those names returned nothing). The only `~`-relative paths found are in prose inside journal/task files (`journal/2026-09-30/132622-initial-setup.md:19`, `tasks/review-gptme-web.md:12,14`), referencing `~/.config/gptme/...` and `~/.local/bin/gptme-web` — not code paths.

Live-installed state on this machine:
- `~/.config/git/hooks` is currently a symlink to `/home/skogix/claude/dotfiles/.config/git/hooks` — i.e. a **different** skogai2 repo (`claude`), not `dot`, currently owns the global git-hooks install. `dot`'s own `dotfiles/install.sh` (symlinked from `gptme-contrib`) is not the active installer right now.
- `git config --global init.templateDir` → `~/.git-templates` (unrelated to which dotfiles repo is active).
- A disabled/inactive systemd unit `~/.config/systemd/user/gptme-agent-dot.service` points `WorkingDirectory`/`ExecStart` at `/home/skogix/dot` — so `dot` is registered for autonomous operation but not running.
- No `~/.claude` symlinks point into `dot`.

### 7. Orchestration readiness

Yes, with caveats — a worker could safely use a `wt` worktree of `dot`:
- All symlinks in the repo are **relative** and resolve inside the repo (mostly into the `gptme-contrib` submodule) — `find . -xtype l` found zero broken symlinks, and none point outside the repo tree. A fresh worktree would need `git submodule update --init --recursive` first (`AGENTS.md:77-80` already flags this as a required step, and as the fix for false-positive link-check failures).
- Scripts avoid hardcoded absolute paths; `AGENTS.md:14-18` mandates `REPO_ROOT=$(git rev-parse --show-toplevel)` rather than hardcoding, and no script-level counterexample was found (the only `/home/skogix` strings are in markdown prose, not code).
- **What would break**: `dot`'s own `AGENTS.md` (§ Git Workflow) already mandates its own conventions that *conflict* with this orchestration model if applied naively — it says "commit directly to master for docs/journal/tasks," forbids `git commit -a`/`git add .`, requires `git-safe-commit` (a flock wrapper) for shared-worktree commits, and explicitly says "**No AI attribution** — never add `Co-Authored-By: Claude`." A `wo/<slug>` workorder branch + `wt merge --squash` flow is compatible with the no-`git add .` and explicit-paths rules, but a workorder dispatched here needs to override or reconcile the "commit to master directly" and "no AI attribution" instructions, since this skogai orchestration model's own conventions (squash-merge via `wt`, this session's attribution trailer) would otherwise collide with `dot`'s own `AGENTS.md`.
- `make install-dotfiles` / `dotfiles/install.sh` is **not safe to run unattended** in a worktree or anywhere else without intent: it mutates *global, machine-wide* git config (`core.hooksPath`, `init.templateDir`) and symlinks `~/.config/git/hooks`, i.e. state outside the repo/worktree entirely. It has a safety gate (requires `GPTME_AGENT=1`, an active `*-autonomous.service`, or explicit confirmation/`DOTFILES_FORCE=1`) but a workorder should explicitly say "do not run `make install-dotfiles` / `dotfiles/install.sh`" to be safe, since it would currently overwrite the `claude` repo's active hooks symlink (see §6).
- No secrets found in tracked files (checked for key/token/password patterns and PEM headers; only matches were doc prose about *not* committing secrets).
- A workorder for this repo should tell the worker: (a) run `git submodule update --init --recursive` after the worktree is created; (b) do not run `dotfiles/install.sh` / `make install-dotfiles`; (c) this skogai repo's own commit/attribution/merge conventions (from `.skogai/knowledge/decisions/0002-orchestration-model.md`) take precedence over `dot`'s local `AGENTS.md` git-workflow section for work done *through* this orchestration flow — flag that explicitly since `dot`'s `AGENTS.md` instructs otherwise; (d) pre-commit/`make check` needs `prek` or `pre-commit`, `ruff`, `mypy`, `shellcheck` installed to pass locally.

### 8. Open questions for skogix

- `dot`'s global git-hooks install currently points at the `claude` repo's dotfiles, not `dot`'s own — is that intentional (i.e. is `claude` the one true dotfiles source and `dot`'s copy of the same hooks under `dotfiles/` effectively a dead duplicate), or is `dot` supposed to take over that symlink at some point?
- `gptme-contrib` submodule is pinned to a feature branch (`bob/judge-content-example-6-489-...`) rather than `master`/a tag — intentional pin for a needed fix, or stale?
- `projects/README.md` says the directory "contains symlinks to the projects dot works with," but it's currently empty — is populating it in scope for this orchestration effort, or out of scope since "individual project implementation remains separate" (`ABOUT.md:19-20`)?
- `dot`'s `AGENTS.md` git-workflow rules (no AI attribution, commit directly to master, `git-safe-commit` for concurrent sessions) were presumably written for `dot`'s own autonomous/gptme operation model, separate from this skogai repo's `wt`/herdr workorder model. If `dot` is brought into the same orchestration setup as `skogai`, do its conventions get superseded, kept as-is (meaning workers there follow a different ruleset than workers in `skogai`), or reconciled into one shared convention?
- Is `dot` meant to be orchestrated by *this* `skogai` repo's `bin/wo` at all, or does it stay a separate, independently-autonomous `gptme`/Claude agent (its own systemd service, own task system via `gptodo`) that `skogai` only observes/references?
