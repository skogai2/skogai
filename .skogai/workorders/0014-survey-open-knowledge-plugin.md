---
id: 0014-survey-open-knowledge-plugin
status: done
created: 2026-10-09T21:50:18Z
add_dir: /home/skogix/.local/src/open-knowledge-plugin
---

# Goal

Write a survey of the skogai2 repo **open-knowledge-plugin** (local clone: `/home/skogix/.local/src/open-knowledge-plugin`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/open-knowledge-plugin`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/open-knowledge-plugin ...` for history and status.
- **Do not modify `/home/skogix/.local/src/open-knowledge-plugin` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey of `/home/skogix/.local/src/open-knowledge-plugin` (read-only; nothing in that repo was modified). Current state: `main` at `c16141c`.

### 1. Purpose and status

It's a fork (`okf-skills`, upstream `scaccogatto/okf-skills`) that is the Claude Code-native toolchain for the **Open Knowledge Format (OKF)**: agent skills, two subagents, a Stop hook, an MCP server and a GitHub Action to author/validate/visualize/backfill OKF knowledge bundles (markdown + YAML frontmatter). See `README.md:1-45` and `SKOGAI.md`.

It is **active, not a skeleton** — the most recent commits are dated today (2026-10-09), `CHANGELOG.md` and `.okf/log.md` show steady, deliberate feature work (benchmark suites, backfill map/reduce routing, v0.2 migration), and it has its own test suite (`tests/`, `benchmark/*/tests/`) wired into CI. It also **documents itself** in its own format (`.okf/index.md`), which is unusual and a good sign of maturity.

However, the HEAD commit (`c16141c`, "rename marketplace, drop plugin.json") **deleted `.claude-plugin/plugin.json`** but `.github/workflows/ci.yml` still runs `jq empty .claude-plugin/plugin.json .claude-plugin/marketplace.json .mcp.json` — CI on `main` is almost certainly broken right now (see §5).

### 2. Layout

- `README.md` — primary entry point (install channels, usage, architecture).
- `SKOGAI.md` — skogai-specific routing stub (routes to README, CHANGELOG, `.okf/index.md`); explicitly notes there is **no** AGENTS.md/CLAUDE.md/CONTRIBUTING in this repo.
- `.okf/` — the repo's own OKF bundle: `index.md` (hub), `log.md`, `components/`, `decisions/`, `reference/` (vendored OKF v0.2 spec), `skills/`.
- `skills/{okf,validate,visualize,backfill}/` — each a `SKILL.md` + `scripts/`.
- `agents/{bundle-weaver,event-analyzer}.md` — the two backfill subagents.
- `servers/okf_mcp.py` — read-only MCP server.
- `hooks/{hooks.json,okf-stop-check.sh}` — a dormant opt-in Stop hook.
- `.claude-plugin/marketplace.json` — marketplace manifest (plugin.json was just deleted, see above).
- `.mcp.json` — registers the `bundle` MCP server via `${CLAUDE_PLUGIN_ROOT}`.
- `benchmark/{trust,gate,map-tier}/` — benchmark harnesses with their own tests.
- `examples/sample-bundle/`, `templates/CLAUDE-okf.md` (opt-in snippet for a consuming project's CLAUDE.md), `docs/` (generated GitHub Pages demos), `tests/`, `.github/workflows/{ci,release}.yml`, `action.yml`, `Makefile`.

### 3. Agent conventions

- No AGENTS.md/CLAUDE.md router — `README.md` + `SKOGAI.md` are the orientation docs, and the repo's architecture/decisions live in `.okf/` (self-hosted OKF bundle), not prose.
- Ships as a Claude Code **plugin** (`.claude-plugin/marketplace.json`), as installable **skills** via skills.sh (`skills/<name>/SKILL.md`, path-resolved through `${CLAUDE_SKILL_DIR}` so the same scripts work whether installed as plugin or skill), as a **GitHub Action**, and as a standalone **MCP server**.
- Two subagents (`agents/bundle-weaver.md`, `agents/event-analyzer.md`) live outside `skills/` by design — backfill only works from a full plugin install, not the skills.sh path (`README.md` "One repo serves both layouts" paragraph).
- One dormant **Stop hook** (`hooks/hooks.json` → `hooks/okf-stop-check.sh`), opt-in per consuming-repo via `upkeep: enforced` in that repo's `.okf/index.md` frontmatter (`.okf/decisions/dormant-hooks.md`).
- `templates/CLAUDE-okf.md` is the adoption snippet a *consuming* project pastes into its own CLAUDE.md for soft-mode (non-enforced) upkeep — this repo's own `.okf/index.md` sets `upkeep: enforced` on itself instead.
- This plugin is **already active in the current Claude Code session** I'm running in (the deferred tools `mcp__plugin_open-knowledge-plugin_bundle__*` and the `open-knowledge-plugin:{okf,validate,visualize,backfill,bundle-weaver,event-analyzer}` skills/agents all come from it) — see §6/§7.

### 4. Toolchain

- Python, dependency-managed via `uv` (no `pyproject.toml`/`requirements.txt` found at top level; scripts are run directly with `uv run`). README also accepts plain `python3` + `pyyaml` as a fallback.
- **Build**: `make docs` (regenerates the two GitHub Pages demo graphs via `skills/visualize/scripts/okf_visualize.py`; pinned in the Makefile because the invocation used to drift, per the comment at `Makefile:1-4`).
- **Test**: `make test` runs 5 top-level `tests/test_okf_*.py` files plus 4 benchmark test files via `uv run`, no separate test framework/runner config.
- **Lint**: none found.
- **Validate** (domain-specific, not code lint): `make validate` runs the OKF conformance checker against `examples/sample-bundle` and the repo's own `.okf`, both `--strict`.
- **CI**: `.github/workflows/ci.yml` runs the same test files plus manifest checks, cp1252-encoding and non-conformant-bundle regression tests. `.github/workflows/release.yml` exists but wasn't inspected in depth. As noted in §1, the manifest-check step references a file (`.claude-plugin/plugin.json`) deleted in HEAD — CI is very likely currently red on `main`.

### 5. Git state

- Default/current branch: `main`, up to date with `origin/main` (`git log @{u}..` is empty — nothing unpushed).
- Remotes: `origin` → `github.com/skogai2/open-knowledge-plugin.git` (fetch+push), `upstream` → `github.com/scaccogatto/okf-skills.git` (fetch+push) — it's a tracked fork.
- Other branches: `origin/add-skogai-md` (remote-only, not checked out locally); `upstream/main`.
- No submodules. `git worktree list` shows only the one checkout (itself) — no worktrees currently exist for this repo.
- Working tree is clean except one **untracked** path: `.skogai/logs/hook-tap/log.jsonl` (gitignored via the repo's own `.worktrees/`/`.claude/` ignores? — actually not covered by `.gitignore`, just untracked). This is the global `hook-tap` Claude Code plugin (enabled in `~/.claude/settings.json`, `"hook-tap@skogai-marketplace": true`) writing its session log relative to cwd into *every* repo a session runs in — confirmed the same artifact appears under `~/skogix/.skogai/logs/hook-tap`, `~/dot/.skogai/logs/hook-tap`, `~/claude/.skogai/logs/hook-tap`. Not part of this plugin's own design; a side effect of the machine's global hook config.
- Recent commit themes (last 10): a marketplace/plugin.json rename+cleanup, a SKOGAI.md routing addition, a 0.10.0 release (log.md semantics, Stop hook widened), a README rewrite, a spec resync + ISO-datetime handling (0.9.6), several backfill map-phase fixes/releases (0.9.4–0.9.5), a haiku-based backfill analyzer with a decided-by-benchmark default, and a capped-diff emitter. Overall: active feature/release work concentrated on the backfill subsystem and v0.2 spec conformance, plus repo-hygiene cleanup today.

### 6. Relationships

- No code-level references to other skogai2 repos (`skogai`, `claude`, `config`, `dot`, `skogix`, `marketplace`, `dash-skogai`, `skogai-cli`, `skogai-docs`, `skogai-fleet`, `skogai-git-workflow`, `skogai-routing`, `okn`) were found anywhere in tracked files (checked via grep for each name and for `~`-rooted paths) — the only self-reference is in its own `SKOGAI.md`, which calls itself `skogai2/okf` "vendored here as `ofk-claude`" and says it "lives in the monorepo under a different name." That claim doesn't match what's on disk: this is a **standalone git repo** with its own remotes (`origin` = `skogai2/open-knowledge-plugin`), not a path inside the `skogai` monorepo or a submodule of it — see §8.
- **It is installed and live** in this machine's Claude Code config, and not merely as a passive clone:
  - `~/.claude/plugins/known_marketplaces.json` has an entry `open-knowledge-plugin-marketplace` whose source is `{"source": "directory", "path": "/home/skogix/.local/src/open-knowledge-plugin"}` — i.e. Claude Code treats this exact working directory as a live marketplace source.
  - `~/.claude/plugins/installed_plugins.json` shows `open-knowledge-plugin@open-knowledge-plugin-marketplace` installed at user scope, pinned to `gitCommitSha: c16141c0cc5297b8c6a37a5c22fe1c6afd2ba49b` (current HEAD), cached under `~/.claude/plugins/cache/open-knowledge-plugin-marketplace/open-knowledge-plugin/c16141c0cc52`.
  - There is a *second*, separate marketplace entry also named by the plugin, sourced from `github.com/skogai2/open-knowledge-plugin.git` with its own `installLocation` under `~/.claude/plugins/marketplaces/open-knowledge-plugin-marketplace` (a full clone, currently also at `c16141c`) — so two independent marketplace registrations resolve to the same plugin today, one by local directory, one by git URL.
  - Concretely: the skills/agents/MCP tools this very survey session has access to (`open-knowledge-plugin:okf`, `:validate`, `:visualize`, `:backfill`, `:bundle-weaver`, `:event-analyzer`, and `mcp__plugin_open-knowledge-plugin_bundle__*`) are this plugin, loaded from this repo.
- No symlinks found under `~/.config` or `~/.claude` pointing at this repo.

### 7. Orchestration readiness

A worker **could** work in a `wt` worktree of this repo for ordinary code changes (no absolute `/home/skogix` paths are hardcoded anywhere in tracked files; scripts resolve via `${CLAUDE_PLUGIN_ROOT}`/`${CLAUDE_SKILL_DIR}`; no secrets found). But a workorder for this repo needs to warn the worker about:

- **This repo is itself a live Claude Code plugin install, not just a passive clone.** Edits in a worktree don't affect the installed/cached copy (`~/.claude/plugins/cache/.../c16141c0cc52`) until something re-syncs it, but the *directory-source* marketplace entry points straight at `/home/skogix/.local/src/open-knowledge-plugin` — so if `wt` lands a merge into that exact path (rather than a worktree copy), the orchestrator/user's own live plugin tools (including the ones this survey used) change underneath them. A workorder should say explicitly whether landing is expected to immediately affect the live install, and the user may want to reload/restart Claude Code after any merge here.
- **CI is currently broken on `main`** (`.claude-plugin/plugin.json` referenced by `ci.yml` but deleted in HEAD) — a worker shouldn't assume a green baseline; this should likely be its own workorder/fix before other work lands.
- **The untracked `.skogai/logs/hook-tap/log.jsonl`** will keep reappearing (it's written by a global hook, not by this repo) and isn't something a worker should try to clean up or gitignore as part of unrelated work; flag it rather than "fixing" it unless that's the task.
- No worktrees or submodules exist yet for this repo, so `wt` would be creating the first one — straightforward, but confirm the `wt`/worktrunk config the user wants for this *separate* repo (it's not nested under the `skogai` monorepo's own `.skogai/worktrees/`, since it's a different git root entirely).
- Dual `upstream`/`origin` remotes: a worker should push/PR against `origin` (`skogai2/open-knowledge-plugin`) only; `upstream` (`scaccogatto/okf-skills`) is the read-only fork source and should not be touched without explicit instruction.

### 8. Open questions for skogix

- `SKOGAI.md` calls this "vendored" into "the monorepo under a different name" (`ofk-claude`), but it's actually a standalone repo at `~/.local/src/open-knowledge-plugin` with its own `origin`/`upstream` remotes — not a path or submodule inside the `skogai` monorepo. Is `SKOGAI.md` stale, or is "the monorepo" referring to something broader (the skogai2 GitHub org as a whole) than the `skogai` git repo this workorder lives in? Worth reconciling, since it's the one place the vendoring rationale is (supposedly) recorded, and it currently raises more questions than it answers.
- Two marketplace registrations (`directory` source at the local path, and `github` source cloned separately) both resolve to the same plugin name today. Is that intentional (e.g. local path for dev iteration, git source as the "real" install for others), or leftover from setup and worth pruning to one?
- `.claude-plugin/plugin.json` was deleted in the HEAD commit on the premise that `marketplace.json` alone is enough, but `ci.yml` wasn't updated to match — was that an oversight, or is there a pending follow-up commit not yet made? This should be fixed or confirmed before anyone relies on CI here.
- The repo's own `.okf/decisions/` records real architectural decisions (dual distribution, dormant hooks, v0.2 migration, etc.) in far more depth than skogai's own `.skogai/knowledge/decisions/`. Given skogai is adopting OKF for its own knowledge (`.skogai/knowledge/`, decision 0001), is there an intent to eventually point skogai's own workorders/decisions at this toolchain's `/okf:*` skills instead of hand-written markdown, or are the two meant to stay separate?

No fixes were made and none are proposed for implementation here, per scope — the above are findings only.
