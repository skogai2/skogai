---
id: 0003-survey-config
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/.config/skogai
---

# Goal

Write a survey of the skogai2 repo **config** (local clone: `/home/skogix/.config/skogai`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.config/skogai`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.config/skogai ...` for history and status.
- **Do not modify `/home/skogix/.config/skogai` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey of `/home/skogix/.config/skogai` (remote: `https://github.com/skogai2/config.git`), performed read-only via `git -C`, `Read`, `Glob`/`find`, `grep`. No writes, commits, fetches or checkouts were made against that clone.

### 1. Purpose and status

It's a small, active, hand-maintained repo of **machine-configuration documentation and a handful of live runtime artifacts** for `skogix`'s workstation: shell/env management (`atuin.md`), keybinding conventions (`mappings.md`, `window-manager.md`), container runtime divergence from Omarchy defaults (`containers.md`), plus a coordination/logging layer (`.skogai/state`, `.skogai/logs`) and a local plugin (`plugins/hook-tap`). It is **work-in-progress but actively tended**, not a seed or abandoned skeleton: commits run through Oct 9 2026, `mappings.md` has two explicit `[@TODO:tmux]` / `[@TODO:nvim]` placeholders, and the docs describe themselves as "a living record... updated directly as the agreement changes" (`atuin.md:9`, `containers.md:2`). The branch has diverged from `origin/master` by one commit each way (local `14bcafb`, remote-only `4ca21fa` "Add herdr configuration and agent integration guide") — evidence of ongoing, slightly out-of-sync work rather than a frozen repo.

### 2. Layout

Top level (`/home/skogix/.config/skogai/`): `AGENTS.md`, `SKOGAI.md`, `atuin.md`, `mappings.md`, `window-manager.md`, `containers.md`, `.gitignore`, `plugins/`, `.skogai/`, `.claude/`, and a symlink `state -> .skogai/state`. No README anywhere.

- `AGENTS.md` and `SKOGAI.md` are both tiny routers (frontmatter `type: router`) using `<routes>` blocks with `@`-includes — `AGENTS.md` points only to `SKOGAI.md`, which fans out to `atuin.md`, `mappings.md`, `containers.md`, and a `@SKOGIX.md` that **does not exist in the repo** (dead reference — see Open Questions).
- `.skogai/` holds `state/coordination/coord.db` (SQLite, schema present, 77 KB), `logs/hook-tap/log.jsonl` (untracked, growing hook-tap session log — it recorded this very survey session live), and `worktrees/` (gitignored; contains one stray leftover directory, see §5/§7).
- `.claude/` holds only `settings.local.json`, granting `additionalDirectories` for `~/.config/hypr`, `~/.config/omarchy`, `~/.config/containers/systemd` — i.e. this Claude session's permission scope reaches outside the repo into other live config dirs. Not tracked by git (`.claude/` is gitignored).
- `plugins/hook-tap/` holds only `log.jsonl` (also gitignored) — the plugin's installed code isn't in this repo; this is just its log sink.
- No `.claude/skills/`, no `CLAUDE.md` in the repo itself.

### 3. Agent conventions

Orientation is purely `@`-include routing, same convention as the `skogai` repo: `AGENTS.md` → `SKOGAI.md` → topic files. There's no `.skogai/knowledge/` (no OKF bundle), no `ROUTES.md`, no skills directory, no hooks config checked into the repo (hook-tap's config/code lives elsewhere; only its log lands here). An agent landing here with no other context gets: four short markdown docs plus two runtime-state artifacts (a sqlite coordination DB and a hook log) that are present on disk but not part of the documented routing graph — nothing in `SKOGAI.md`/`AGENTS.md` explains `state/`, `plugins/hook-tap/`, or `.skogai/state/coordination/coord.db`.

### 4. Toolchain

None found. No `package.json`, `Makefile`, `*.toml` (other than worktrunk's internal `.git/wt/` state dir, which isn't a config file), no `mise`/`argc` manifest, no CI (`.github/` absent). This is a pure-markdown-plus-runtime-state repo; there is no build, test, or lint command — "none" for all three.

### 5. Git state

- Default/current branch: `master`. Remote branches: `origin/master` and a stale `origin/skogix-symlink-config-folders-to-this-repo` (already merged into master via PR #1, commit `958972e`).
- No submodules (`git submodule status` empty). `git worktree list` shows only the main checkout at `/home/skogix/.config/skogai` — no registered worktrees, despite `.skogai/worktrees/` containing a leftover, non-worktree directory tree (empty `plugins/hook-tap/` dirs under a dir named after the old symlink branch) — orphaned files from a past `wt` session, gitignored so they don't show as dirty.
- `git status`: working tree clean, but **diverged** from `origin/master` by 1 commit each (local `14bcafb`, remote `4ca21fa`) — needs a merge/rebase decision, not something this survey should resolve.
- Untracked-but-not-ignored: `.skogai/logs/` (the hook-tap log directory itself isn't in `.gitignore`, only `plugins/hook-tap/log.jsonl` and `.skogai/worktrees/` are — so `.skogai/logs/hook-tap/log.jsonl` shows as untracked, not ignored).
- Remote: single `origin` → `github.com/skogai2/config.git`, fetch+push.
- Recent commit themes: moving fish/env files out to other skogai2 repos (`dash-skogai`, `skogai-cli`) and consolidating env handling into Atuin, adding the coordination DB/state symlink, then independent docs additions (window-manager, atuin, containers).

### 6. Relationships

- Explicit moves-to-other-repo references in commit messages: `4435cae` "Remove link manifest and fish files", `ef91dd1` "Move fish/config.fish to dash-skogai", `9e0f006` "Move env docs to skogai-cli; globals to atuin" — i.e. this repo used to hold fish config and env docs that were deliberately relocated to `dash-skogai` and `skogai-cli`. No other skogai2 repo names (`skogai`, `skogai-docs`, `skogai-fleet`, `skogai-git-workflow`, `skogai-routing`, `okn`, `open-knowledge-plugin`, `marketplace`) appear in any tracked file's contents.
- `~`-rooted absolute paths appear only in `.claude/settings.local.json` (`additionalDirectories` listing `~/.config/hypr`, `~/.config/omarchy`, `~/.config/containers/systemd`) and in the untracked hook-tap log (recording this session's own `cwd`/`transcript_path`) — neither is in a tracked content file.
- **This repo's working copy *is* the live location**: `/home/skogix/.config/skogai` is a real directory (not a symlink) sitting directly under `~/.config`. I found no symlinks anywhere else under `~` (searched 3 levels deep) pointing into `/home/skogix/.config/skogai`; the only symlink involving this repo is internal (`state -> .skogai/state`). So nothing else on the machine depends on this exact path via a symlink, but the repo itself *is* currently doubling as "the live config dir" rather than a separate source that gets deployed/linked somewhere.

### 7. Orchestration readiness

Mostly yes, with caveats:
- **No secrets found** in tracked files (only markdown docs + the sqlite coordination DB, which is schema/state, not credentials, as far as a byte-level `file` check shows).
- **No absolute-path landmines** in tracked content — the only `~`-paths are in gitignored `.claude/settings.local.json` and the gitignored hook-tap log, neither of which would be copied into a fresh `wt` worktree by git (git only clones tracked files).
- **Live-installed-config risk**: because `/home/skogix/.config/skogai` *is* the live config directory (not deployed via symlink from elsewhere), a `wt` worktree is a separate checkout elsewhere on disk (per worktrunk convention, under `.skogai/worktrees/<branch>`) — editing there is safe and won't touch the live `~/.config/skogai` until merged. But a worker should **not** assume the live Atuin dotfiles sync, hook-tap plugin, or coordination DB are reproduced in the worktree — those are runtime state (`.claude/`, `plugins/*/log.jsonl`, `.skogai/state/`, `.skogai/worktrees/`) that's gitignored and won't exist in a fresh worktree.
- The stray orphaned directory under `.skogai/worktrees/` (empty `plugins/hook-tap/` tree) is cosmetic — gitignored, not tracked — but a workorder for this repo should tell the worker it may encounter it and that it's not something to clean up unless asked.
- A workorder for this repo should state: (a) the worktree is a separate checkout, not the live `~/.config/skogai`; (b) `.claude/`, `plugins/`, `.skogai/worktrees/`, and the `.skogai/logs/`/`state/` runtime artifacts are local-machine state, not deliverables to edit or commit; (c) the repo currently has no build/test/lint — don't invent one; (d) local master is diverged from `origin/master` by one commit each way, so don't assume a worktree branched from local master contains the remote's herdr-config commit.

### 8. Open questions for skogix

- `SKOGAI.md` routes to `@SKOGIX.md`, which doesn't exist anywhere in the repo — dead `@`-include, same category of issue as decision `0001-fix-dead-routes` in the `skogai` repo.
- Local `master` and `origin/master` have diverged (1 commit each way) — is this an intentional fork, or did a push get missed? Worth resolving before any `wt`-based work lands here.
- `.skogai/worktrees/skogix-symlink-config-folders-to-this-repo/` is an orphaned leftover from a merged branch of the same name — safe to delete, but flagging rather than removing it myself since cleanup is out of this survey's scope.
- Nothing in `SKOGAI.md`/`AGENTS.md` documents `state/`, `plugins/hook-tap/`, or the coordination DB's purpose/schema — worth a short reference doc (analogous to `atuin.md`) if those are meant to be load-bearing, or removal if they're abandoned experiments.
- `.gitignore` ignores `plugins/hook-tap/log.jsonl` and `.skogai/worktrees/` but not `.skogai/logs/` — looks like an oversight (the log ended up untracked-and-visible rather than cleanly ignored).
