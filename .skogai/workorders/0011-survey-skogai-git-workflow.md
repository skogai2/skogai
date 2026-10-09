---
id: 0011-survey-skogai-git-workflow
status: done
created: 2026-10-09T21:50:18Z
add_dir: /home/skogix/.local/src/skogai-git-workflow
---

# Goal

Write a survey of the skogai2 repo **skogai-git-workflow** (local clone: `/home/skogix/.local/src/skogai-git-workflow`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/skogai-git-workflow`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/skogai-git-workflow ...` for history and status.
- **Do not modify `/home/skogix/.local/src/skogai-git-workflow` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Read-only survey of `/home/skogix/.local/src/skogai-git-workflow`. Nothing in that clone was modified — only `Read`/`Glob`/`Grep` and non-mutating `git` commands (`status`, `log`, `branch -vv`, `remote -v`, `worktree list`, `ls-remote`) were used there.

### 1. Purpose and status

The repo is a **design doc / seed, not yet implemented**. `README.md` proposes a "turn-based editing protocol" where `git diff`/`git add -p` staging stand in for an agent conversation's proposal/consensus state, and sketches a `skogai-turn` CLI (`status`, `pass`, `commit`, `reset`) as an "MVP proposal" (README.md:48-55). No such CLI exists anywhere in the repo — it's a textual proposal only.

Evidence it's a fresh skeleton, not abandoned or active: a single commit `8985716` ("init", 2026-10-09 01:33:43, Emil Skogsund) that added exactly `README.md` and `bin/claude-simple-prompt` (`git show --stat HEAD`); no later commits, no branches besides `master`, no TODOs/empty dirs because there are effectively only these two files.

### 2. Layout

Entire tracked tree:
- `README.md` — the protocol write-up and MVP proposal described above.
- `bin/claude-simple-prompt` — a 3-line bash script invoking `claude -p` with `--no-session-persistence --model=haiku --tools='' --safe-mode --setting-sources=user --system-prompt=''`, commented as "example of how claude could be called without anthropic-bloat." It has no apparent connection to the turn-protocol idea in the README.

No `SKOGAI.md`, `CLAUDE.md`, `AGENTS.md`, `.claude/`, or tracked `.skogai/` exists. (An *untracked* `.skogai/logs/hook-tap/log.jsonl` is present — see §6/§7, it's a side effect of a global hook, not repo content.)

### 3. Agent conventions

None. No routing files, `@`-includes, skills, hooks, Claude settings, plugins, or knowledge bundles (no OKF `.okf/` or `.skogai/knowledge/`) in the repo itself. An agent landing here has only `README.md` to orient from.

### 4. Toolchain

No language manifest of any kind (no `package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, etc.), no `mise.toml`/`.mise.toml`, no `argc.yaml`. Build/test/lint: **none**. CI: **none** (no `.github/` directory, no other CI config found anywhere in the tree).

### 5. Git state

- Default/only branch: `master`, tracking `origin/master`, up to date (`git status`, `git branch -vv`).
- One commit total: `8985716` "init".
- One remote: `origin` → `https://github.com/skogai2/skogai-git-workflow.git` (fetch+push).
- `git ls-remote origin` shows only `refs/heads/master` at the same SHA — no other remote branches.
- No submodules (`.gitmodules` absent), no other local worktrees for this repo (`git worktree list` shows only the one checkout).
- No uncommitted tracked changes. One **untracked** directory, `.skogai/logs/hook-tap/log.jsonl` (127 lines, timestamps 2026-10-09T21:54:04–21:54:42Z) — this is a session-log side effect of a global Claude Code hook (`~/.claude/settings.json` references `hook-tap`) that fires and writes to `<cwd>/.skogai/logs/...` whenever a Claude session runs with this directory as its cwd. It is not part of the repo's own design and was not created by this survey (timestamps predate this session).
- Recent commit themes: n/a beyond the single "init" commit.

### 6. Relationships

No tracked file mentions any other skogai2 repo (skogai, claude, config, dot, skogix, marketplace, dash-skogai, skogai-cli, skogai-docs, skogai-fleet, skogai-routing, okn, open-knowledge-plugin) or any path under `~`. Searched `~/.config`, `~/.claude`, `~/.local/bin`, `~/skogai` for symlinks resolving into `skogai-git-workflow`: none found. `bin/claude-simple-prompt` isn't referenced or installed anywhere live — the only hits for its name outside the repo are this survey session's own transcripts. The repo is **not** installed, symlinked, or wired into any live config.

### 7. Orchestration readiness

Yes, this repo looks safe to hand to a worker in a `wt` worktree — it's about as low-risk as a repo gets: two files, no absolute paths, no live-installed config, no symlinks, no secrets. The one thing worth flagging in the workorder:

- A global Claude Code hook writes `<cwd>/.skogai/logs/hook-tap/log.jsonl` whenever a session runs here (see §5). A worker should **not** `git add`/commit that directory; it's hook noise, not repo content. (The repo has no `.gitignore`, so it will show as untracked in `git status` every time.)
- There is nothing to build, test, or lint, so a workorder can't ask for "tests pass" as a done-condition — verification will have to be by inspection/manual review.
- Because `skogai-turn` doesn't exist yet, any workorder to "implement the turn protocol" is greenfield work, not a bug fix/extension — it should say so explicitly and probably point at the MVP section of the README (README.md:48-89) as the spec.

### 8. Open questions for skogix

- `bin/claude-simple-prompt` has no apparent relationship to the turn-protocol README — is it meant to become part of the eventual implementation (e.g. the harness that drives `skogai-turn` turns), or is it just parked here incidentally and belongs elsewhere?
- The README's "MVP proposal" fully specifies a `skogai-turn` CLI, but nothing implements it yet. Is this repo meant to actually build that CLI, or is it intentionally just the design doc for now (i.e. should a workorder build it, or just further refine the doc)?
- The README has two inline attributed asides — `[@skogix:"i should explain/we should focus on..."]` (README.md:15) and `[skogix:"obviously insanely simple concepts..."]` (README.md:46) — that read like transcript quotes left in a shipped doc. Intentional voice/citation style, or draft residue to clean up before anyone builds on this?
- No `SKOGAI.md`/`AGENTS.md`/`CLAUDE.md` exists, unlike the convention seen in the main `skogai` repo. Is one expected here eventually, or is this repo deliberately agent-doc-free until it has actual code to orient around?

Nothing left open from this workorder's own scope — survey is complete, no fixes were made (none were in scope).
