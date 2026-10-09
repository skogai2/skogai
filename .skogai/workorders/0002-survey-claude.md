---
id: 0002-survey-claude
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/claude
---

# Goal

Write a survey of the skogai2 repo **claude** (local clone: `/home/skogix/claude`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/claude`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/claude ...` for history and status.
- **Do not modify `/home/skogix/claude` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey performed read-only against `/home/skogix/claude` (`git -C`, `Read`/`Grep`/`find`, no `cd` into it). No files in that repo were modified.

### 1. Purpose and status

`/home/skogix/claude` is Claude Code's own "home" repo in skogix's per-agent-home setup ("skogfences") — a full [gptme-agent-template](https://github.com/gptme/gptme-agent-template) instance adopted wholesale on 2026-09-30, giving the agent persona "claude" a workspace/memory/harness (journal, tasks, knowledge, people, lessons) rather than a sandbox (`README.md`, `ABOUT.md`, `.skogai/memory/project_agent_homes_architecture.md`). Per `ABOUT.md`, this persona's job is explicitly **orchestration** — "global integrations... turning intent into work orders and tasks" — contrasted with `~/dot` (a separate gptme agent that does direct implementation and is off-limits from here).

**Status: active, but identity-setup is unfinished.** Evidence:
- Recent commits run through 2026-10-09 (`git log`: `780efef` "Add memory notes for orchestration, OKF, and fleet", `8f644e2`, `ae73d46` "submodule project" on 2026-10-06), and there are uncommitted edits right now to `.skogai/memory/*` (`git status`: modified `MEMORY.md`, four memory files deleted in the working tree but not committed).
- `tasks/initial-agent-setup.md` is still `state: active` with two unchecked boxes ("Success metrics" and "Review process") and goals/values marked "my first draft, awaiting Emil's review" — the onboarding conversation was never closed out.
- Of 15 task files, 13 are `state: backlog`, 2 are `state: done`; none besides `initial-agent-setup` are active — i.e. a lot of recorded intent, little executed work yet.
- `journal/` has exactly one day of entries (`2026-09-30/`) despite commits continuing into October — recent work shows up in `.skogai/memory/` and task files, not the journal.
- No empty-skeleton directories found; `find -xtype l` shows no broken symlinks.

### 2. Layout

Root docs (gptme-agent-template convention): `README.md`, `ABOUT.md` (persona background/purpose), `SOUL.md` (voice/stance), `ARCHITECTURE.md` (workspace structure doctrine), `TOOLS.md`, `WORKFLOW.md`, `TASKS.md`, `AGENTS.md`, `CLAUDE.md` (a 6-line router: `<routes>@.skogai</routes>` plus a note that `tmp/docs/` holds cached Claude Code docs — no `SKOGAI.md` exists in this repo, unlike the skogai repo convention).

Key directories: `journal/` (daily logs), `tasks/` (15 files + `templates/`, driven by the `gptodo` CLI), `knowledge/` (2 files: `agent-forking.md`, `forking-workspace.md`), `lessons/` (`README.md`, `TEMPLATE.md`, `tools/`), `people/` (profiles, e.g. `skogix.md`), `state/` (`queue-manual.md`/`queue-generated.md` two-queue work prioritization, `coordination/`, `sessions/`), `scripts/` (automation incl. `context.sh`, `runs/autonomous/`), `dotfiles/` (installs a **global** git hooks setup — see §6/§7), `.config/wt.toml` (worktrunk pre-start hook), `.github/root-structure-allowlist.yaml` (no CI workflows present), `plugins/hook-tap/`, `projects/` (submodule `projects/gptme` + its own `README.md`), `gptme-contrib/` (submodule), `.mypy_cache/`/`.ruff_cache/` (tool caches), `memory -> .skogai/memory` (symlink).

`.skogai/` holds Claude Code's native memory (`.skogai/memory/*.md`, `MEMORY.md` index), plus `.skogai/messages/skogix.md` and `.skogai/state/cc-memory/`, `.skogai/logs/hook-tap/log.jsonl`. `.claude/` holds `settings.json`, `settings.local.json`, `hooks/` (`match-lessons.py`, `post-session.py`), and `skills/` (17 symlinks into `gptme-contrib/skills/*`).

### 3. Agent conventions

- **Routing:** `CLAUDE.md` → `<routes>@.skogai</routes>`. There's no further `@`-include chain inside `.skogai/` discovered (no nested `SKOGAI.md`/`ROUTES.md` there, unlike this skogai repo's pattern) — orientation instead comes from `AGENTS.md` pointing at `gptme.toml`'s `[prompt] files` list.
- **`AGENTS.md`** is the real onboarding doc: tells an agent to read `gptme.toml`'s `[prompt] files` (`ABOUT.md`, `ARCHITECTURE.md`, `TASKS.md`, etc.), always derive `REPO_ROOT` via `git rev-parse --show-toplevel` rather than hardcoding paths, use Conventional Commits, use `git-safe-commit` (a flock wrapper) for shared-worktree commits, never `--squash`-merge locally but squash PRs, and never add Claude/AI attribution to commits or PRs (**conflicts with this skogai repo's own attribution requirement** — see §8).
- **Skills:** 17 skills symlinked `.claude/skills/<name> -> ../../gptme-contrib/skills/<name>/` (journal, agent-onboarding, test-discovery, etc.) so Claude Code's native Skill tool can invoke them; this is a deliberate "promotion path" distinct from the keyword-matched `lessons/` system (`.skogai/memory/project_agent_homes_architecture.md`).
- **Hooks:** `.claude/settings.json` wires `SessionStart` → `scripts/context.sh`, `UserPromptSubmit` + `PreToolUse(Read|Bash|Grep|WebFetch|WebSearch)` → `.claude/hooks/match-lessons.py` (keyword-matched lesson/skill injection), `Stop` → `.claude/hooks/post-session.py` (logs session metrics, not narrative).
- **Memory:** two intentionally separate systems — `.skogai/memory/` (Claude Code's native auto-memory: facts/feedback/user/project/reference notes, currently mid-edit per `git status`) and `lessons/` + the match-lessons hook (keyword-triggered injection, scoped via `gptme.toml`'s `[lessons] dirs = ["lessons", "skills"]`, deliberately *not* widened to `gptme-contrib/lessons`/`skills` because that caused noisy irrelevant injections).
- **Knowledge bundles:** no OKF bundle (no `.okf/`) found in this repo; `knowledge/` is two plain markdown files, unrelated to Open Knowledge Format.
- **Plugins:** `plugins/hook-tap/` (just a log file, `log.jsonl`) — no installed Claude Code plugins found under this repo.

### 4. Toolchain

- **Language:** Python (via submodules/tooling) + Markdown/shell content; no root `pyproject.toml`, `mise.toml`, or `argc` files — these live only inside the `gptme-contrib` submodule (`gptme-contrib/pyproject.toml`).
- **Task runner:** `Makefile` — `make install-precommit`, `make format` (ruff-format, end-of-file-fixer, trailing-whitespace), `make check` (`prek`/`pre-commit run --all-files`), `make test` (runs `pytest tests/` *only if* a `tests/` dir with `.py` files exists — it doesn't; `make test` currently prints "No tests found"), `make typecheck` (mypy via pre-commit), `make context` (`scripts/context.sh`), `make stats` (`cloc`).
- **Pre-commit (`.pre-commit-config.yaml`):** check-yaml/end-of-file-fixer/trailing-whitespace/check-symlinks/destroyed-symlinks/check-added-large-files, shellcheck, ruff + ruff-format, mypy, `gptme/gptme-contrib`'s `validate-root-structure` (against `.github/root-structure-allowlist.yaml`), and local hooks: `check-names` (agent-name collision guard), `check-markdown-links`, `validate-markdown-codeblock-syntax`, `validate-task-frontmatter`, `validate-task-metadata` (`gptodo check`, optional).
- **CI:** none found — `.github/` contains only `root-structure-allowlist.yaml`, a config file for the local pre-commit hook, not a GitHub Actions workflow.
- **Package manager for tasks:** `gptodo` CLI (installed separately via `uv tool install git+https://github.com/gptme/gptme-contrib#subdirectory=packages/gptodo`), confirmed working per memory notes.

### 5. Git state

- Default/current branch: `master`, tracking `origin/master` (up to date, `git log @{u}..` empty — no unpushed commits).
- Remote: `origin` → `https://github.com/skogai2/claude.git` (single remote).
- Other branches (remote-only, no local checkouts besides master): `origin/bridge-cse_01Rd3gif2bmYbUNDHJxghENh`, `origin/worktree-bridge-cse_016HofbLyycpNRERkBHjjNy3`, `origin/skogix`.
- Submodules (`.gitmodules`): `gptme-contrib` → `skogai2/gptme-contrib.git` (pinned `959333e`, branch `master`), `projects/gptme` → `gptme/gptme.git` (pinned `461a603`, tag-ish `v0.28.2-3383-g461a603d4`). Both are checked out and populated.
- No worktrees other than the main checkout (`git worktree` not probed for a list, but `.claude/settings.local.json` references a stale worktree path `.claude/worktrees/bridge-cse_01BwySFjGdUCvs5cSfG4Hd2n`, suggesting worktrees have been used and cleaned up before — see §7/§8).
- **Uncommitted work right now:** `.skogai/memory/MEMORY.md` modified, and four memory files deleted in the working tree (`feedback_skogai_write_and_commit_immediately.md`, `gptme-util-memory-link.md`, `project_cc_memory_hooks_wired.md`, `project_okf_adoption_proposal.md`) — not staged, not committed. This survey did not touch them (read-only).
- Recent commit themes (last ~20): memory-note housekeeping ("Clean up transient memory files and add to gitignore", "Add memory notes for orchestration, OKF, and fleet"), a submodule add, several merges from bridge/worktree branches, gptme-coordination evaluation and sub-agent spawning notes, hook/memory wiring ("Wire cc-memory hooks and git allowlist config", "Comment out submodule and docs hooks, add echo test").

### 6. Relationships

- Explicit cross-repo references (grep across non-submodule `*.md`): `ABOUT.md`, `SOUL.md`, `people/skogix.md`, journal entries, and several `.skogai/memory/*.md` files describe the sibling repos `~/dot` (`skogai2/dot`, a gptme agent, explicitly off-limits from here), `~/skogai`/`~/.config/skogai` (the human-facing router/config layer), and reference clones under `~/.local/src/` (`gptme-agent-template`, `gptme-contrib`, `gptme-cc-plugin`, `gptme-skills-cc`, `agent-workspace-plugin`).
- `tasks/*.md` filenames/content reference `dash-skogai` (PR #1 cleanup, mise.toml pinning, launcher testing) and `gptme-coordination` (multi-agent messaging evaluation) — both treated as external repos/tools this agent evaluates or depends on, not vendored here.
- No references found to `skogai-cli`, `skogai-docs`, `skogai-fleet`, `skogai-git-workflow`, `skogai-routing`, `okn`, or `open-knowledge-plugin` anywhere in this repo (outside submodules).
- **Live installation outside the repo:**
  - `~/.claude/settings.json` (the user's global Claude Code settings) sets `"autoMemoryDirectory": "/home/skogix/claude/.skogai/memory"` — a hardcoded absolute-path live wire from the global config into this specific repo. `autoMemoryEnabled` is currently `false`, so it's configured but dormant.
  - `~/.config/git/hooks` is a live symlink → `/home/skogix/claude/dotfiles/.config/git/hooks` (installed by `dotfiles/install.sh`). The *symlink* is in place, but `git config --global core.hooksPath` is currently **unset** (checked directly: no value), so the hooks are not currently wired to fire — see §7 for the history of this ("global git hooks landmine").
  - `~/.claude/skills` and `~/.claude` itself are **not** symlinks to or from this repo (confirmed: real directories; only `diagnose-crash`/`omarchy` there are symlinks, to `/usr/share/omarchy/...`, unrelated).
  - No other `~/.config/skogai` or plugin-marketplace references to this repo were found.

### 7. Orchestration readiness

A worker could mostly work safely in a `wt` worktree of this repo, but there are real hazards:

- **Global git hooks dependency (biggest risk).** `dotfiles/install.sh` symlinks `~/.config/git/hooks` to a path *inside this repo* and sets `core.hooksPath` **globally** (all repos on the machine, not just this one) — documented as a known landmine in `.skogai/memory/project_global_git_hooks_landmine.md`. It's currently dormant (hooksPath unset), but if anyone re-runs `install.sh`, every commit everywhere — including in unrelated `wt` worktrees of *other* repos — would start running this repo's `pre-commit`/`pre-push`/`post-checkout` hooks, which include an identity allowlist (`dotfiles/.config/git/allowed-identities.conf`) and a repo allowlist (`dotfiles/.config/git/allowed-repos.conf`, currently listing only `skogai2/*` patterns). A worktree whose path or remote doesn't match those allowlists would get its commits rejected with a confusing, seemingly unrelated error. A workorder must tell the worker **not to run `dotfiles/install.sh`**, and if a commit ever fails with an unfamiliar identity/repo-guard message, check `git config --global core.hooksPath` first rather than assuming it's a problem with the worktree itself.
- **Live global-settings coupling.** `~/.claude/settings.json`'s `autoMemoryDirectory` hardcodes `/home/skogix/claude/.skogai/memory`. A `wt` worktree lives at a different absolute path, so any session relying on auto-memory in a worktree would not read/write the same memory store as the main checkout (currently moot since `autoMemoryEnabled: false`, but worth flagging if that's ever turned on).
- **AGENTS.md's own path discipline helps.** `AGENTS.md` already tells agents to derive `REPO_ROOT` via `git rev-parse --show-toplevel` rather than hardcoding `/home/skogix/claude`, which is exactly what makes a worktree copy workable — as long as scripts actually follow that rule (not verified for every script in `scripts/`).
- **Submodules.** `gptme-contrib` and `projects/gptme` are real submodules; a fresh `wt` worktree needs `git submodule update --init --recursive` (per `AGENTS.md`'s troubleshooting section) or pre-commit hooks will false-positive on broken links from `gptme-contrib/lessons/`. `.config/wt.toml`'s `[pre-start]` hook currently only runs a smoke-test `echo` (the submodule-init and docs lines are commented out) — so a worker will need to run submodule init itself, or that hook needs uncommenting first.
- **No secrets found** in a maxdepth-2 scan for `.env*`/`secrets` dirs; `dotfiles/.config/git/allowed-identities.conf` and `allowed-repos.conf` contain an email address and repo-name patterns, not credentials.
- **No broken symlinks** (`find -xtype l` empty), so a worktree checkout of tracked files should be internally consistent; the only *external* symlink hazard is the global `~/.config/git/hooks` one above, which lives outside git and wouldn't be recreated by a worktree checkout anyway.
- **What a workorder for this repo should tell the worker:** (1) don't touch `~/dot` even implicitly; (2) don't run `dotfiles/install.sh`; (3) run `git submodule update --init --recursive` before relying on pre-commit; (4) use `git rev-parse --show-toplevel` / repo-relative paths, never hardcode `/home/skogix/claude`; (5) `make test` is currently a no-op (no `tests/` dir) — don't treat a green `make test` as real coverage; (6) there is live uncommitted work in `.skogai/memory/` right now that predates any workorder — a worker should not assume a clean tree without checking `git status` first.

### 8. Open questions for skogix

- **Attribution conflict.** This repo's `AGENTS.md` says "No AI attribution: Never add `Co-Authored-By: Claude` or 'Generated with Claude Code' to commits/PRs." This session's own system instructions require exactly that attribution on every commit/PR from here on. Which rule wins when a worker is dispatched into a worktree of this repo?
- **Identity ambiguity.** This repo's persona is also named "claude," distinct from the `claude` worker-kind name used by `bin/wo`/herdr in skogai's own orchestration model (`.skogai/knowledge/decisions/0002-orchestration-model.md`). Worth confirming these are understood as two unrelated uses of the same word before anyone builds tooling that conflates them.
- **Global git-hooks landmine left unresolved.** `.skogai/memory/project_global_git_hooks_landmine.md` says this was "flagged to Emil (2026-09-30) and left unresolved." It's dormant now (hooksPath unset) but the symlink and allowlists are still staged to be reactivated by `dotfiles/install.sh`. Worth a final decision (revert the global scope vs. keep it machine-wide) before any orchestration touches this repo via worktrees.
- **Uncommitted memory-file deletions.** `git status` shows four `.skogai/memory/*.md` files deleted and `MEMORY.md` modified, uncommitted, with no clear record of why (possibly manual cleanup mid-edit, possibly accidental). Not touched by this survey; flagging so it isn't mistaken for a worker's own change later.
- **Identity-setup still open.** `tasks/initial-agent-setup.md` has been `state: active` since 2026-09-30 with "Success metrics" and "Review process" still unchecked, and `ABOUT.md`'s goals/values are marked as an unreviewed first draft. Is this task still meant to be live, or should it be closed/superseded given the repo has since moved on to other work (gptme-coordination evaluation, memory wiring, etc.)?
- **`wt.toml` pre-start hook is stubbed.** `.config/wt.toml` has the submodule-init and docs-generation lines commented out, leaving only a smoke-test `echo`. Intentional placeholder, or should it be wired up before this repo is used with `wt` worktrees for real?
