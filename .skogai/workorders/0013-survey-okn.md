---
id: 0013-survey-okn
status: done
created: 2026-10-09T21:50:18Z
add_dir: /home/skogix/.local/src/okn
---

# Goal

Write a survey of the skogai2 repo **okn** (local clone: `/home/skogix/.local/src/okn`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/okn`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/okn ...` for history and status.
- **Do not modify `/home/skogix/.local/src/okn` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

All findings below are from read-only inspection of `/home/skogix/.local/src/okn` (git worktree not touched: no edits, commits, fetches, checkouts, or stashes were made).

### 1. Purpose and status

`okn` is the **Open Knowledge CLI** (`openknowledge`/`okn`): a tool that turns repository Markdown into a managed, searchable knowledge base (OKF format) for people and agents, with validation, search, review, publishing (static viewer, MCP), and optional Knowledge CI (`README.md`, `PRODUCT.md`). The checkout here is a fork vendored for skogai2 (`SKOGAI.md` calls it `ofk-tools`, upstream `skogai2/okf2`), with `origin` = `github.com/skogai2/okn.git` and `upstream` = `github.com/openknowledge-sh/openknowledge.git` (`git remote -v`).

**Active, mature project** — not a seed/skeleton:
- 0 TODO/FIXME/XXX hits anywhere in the tree.
- Commit history is dense and recent: `5a3bc1d` (2026-10-07, "docs: add SKOGAI.md orientation file"), `4943292` (2026-10-04), several `2026-09-01`–`09-05` feature/fix commits, release tagging (`v0.13.0`), CI, a website package, and a Go CLI package — all present and wired together.
- Full product surface: Go CLI (`packages/cli`), web/viewer (`packages/web`, 9.3M), npm distribution package (`packages/npm`), Docker/Railway deploy config, GitHub Actions (CI, release, security, knowledge-eval, deploy-railway), a colocated documentation wiki (`Wiki/`) with its own agent rules and writing standard.

### 2. Layout

Key paths (from repo root):
- `README.md` — product overview and quick start.
- `PRODUCT.md` — product vision/scope doc (not a code doc).
- `AGENTS.md` — repo-root agent instructions; points to `.codex/skills/openknowledge-wiki/SKILL.md` and `Wiki/AGENTS.md` for CLI/wiki-affecting changes.
- `SKOGAI.md` — skogai-orchestrator orientation only (new, added by the prior commit); explicitly says it doesn't restate `AGENTS.md`/`PRODUCT.md`.
- `.skogai/logs/hook-tap/log.jsonl` — present; a staged (uncommitted) `.gitignore` change adds this path to ignores (see §5).
- `Wiki/` — the colocated Open Knowledge Format knowledge base for this very project: `AGENTS.md`, `index.md`, `log.md`, `SPEC.md` (pinned upstream OKF spec copy), `decisions/`, `features/`, `workflows/`, `rules/`, `changelog/`, `.openknowledge.toml`.
- `packages/cli`, `packages/web`, `packages/npm` — the three pnpm/go workspace packages.
- `.codex/skills/openknowledge-wiki/` — a Codex-specific skill (`SKILL.md` + `agents/`) for working on the wiki.
- `.openknowledge/` — this repo's own job/eval config: `audit-sources.json`, `evals/*.yaml`, `jobs/docs-audit.md`.
- `deploy/runtime/`, `docker/`, `Dockerfile`, `railway.json`, `action.yml`, `.goreleaser.yaml` — deployment/release plumbing.
- `examples/` — three example knowledge-base projects, each with its own `AGENTS.md`/`README.md`.
- No `.claude/` directory and no `CLAUDE.md` anywhere in the tree (checked top 2 levels and repo-wide for the filename).

### 3. Agent conventions

Multiple layered conventions, none of them skogai's `@`-include router style:
- `AGENTS.md` (root) → routes to `.codex/skills/openknowledge-wiki/SKILL.md` and to `Wiki/AGENTS.md`/`Wiki/workflows/feature-docs.md`/`Wiki/workflows/changelog-updates.md` depending on what's being changed. Says to run `okn validate "Wiki"` after wiki edits.
- `Wiki/AGENTS.md` — detailed rules for maintaining the colocated wiki: read order, update rules per change type, a full ASD-STE100 ("simplified technical English") writing standard, and a validation step (`okn validate "Wiki"`). Also: "When the agent runtime supports subagents, use them for bounded Wiki tasks."
- `Wiki/.openknowledge.toml` — this project's own OKF config: HTML theme/site config, publish assets, `[rules] enabled = ["project", "writing", "asd-ste100"]`, `[release] outputs = ["viewer", "mcp"]`, `[maintenance] mode = "off", agent = "codex"`.
- `SKOGAI.md` — the only skogai-flavored file; a short orientation note, not a router (no `@`-includes).
- `.codex/skills/openknowledge-wiki/SKILL.md` + `agents/` — Codex-specific skill content for this repo.
- No `.claude/` settings, no Claude-specific hooks or skills, no OKF knowledge bundle targeting the *skogai orchestration* use case (the `Wiki/` OKF bundle documents the CLI product itself, not skogai's relationship to this repo).
- An agent arriving fresh would be oriented by `AGENTS.md` → `SKOGAI.md`/`PRODUCT.md` → `Wiki/AGENTS.md` as needed, but there is no single index comparable to `skogai`'s `.skogai/knowledge/index.md`.

### 4. Toolchain

- **Go**: `go.work` → `go 1.26.6`, uses `./packages/cli` only. Installed `go version` on this machine: 1.27.2 (newer than pinned; untested whether that matters).
- **Node/pnpm**: `package.json` engines `node >=20`; `pnpm-workspace.yaml` covers `packages/*`. Installed here: node v26.11.1, pnpm 12.10.1.
- **mise**: `mise.toml` pins only `pnpm = "latest"` (no Go pin via mise).
- **No argc usage found.**
- Build/test/lint (from `package.json` scripts):
  - Build: `pnpm build` (→ `build:web` + `go build -o bin/openknowledge ./packages/cli/cmd/openknowledge`); also `build:cli`, `build:viewer`.
  - Test (full): `pnpm test` — chains `build:viewer`, `check:format` (gofmt), `check:versions`, `check:workflow-pins`, `check:workflow-secret-scope`, `check:workflow-permissions`, `check:security-config`, `check:container-runtime`, a repo-jobs validate step, `test:install`, `test:npm-install`, `test:release-notes`, `test:packed-npm`, `test:demos`, `test:web`, and `go test ./packages/cli/...`. Narrower targets exist: `test:cli`, `test:race`, `test:coverage`, `test:web`, `test:browser`.
  - Lint/format: `check:format` runs `scripts/check-gofmt.sh`; CI additionally runs `go vet ./packages/cli/...`.
- **CI**: `.github/workflows/` has `ci.yml` (knowledge-audit, install deps, `pnpm check:format`, `pnpm test`, `go vet`, `pnpm build`, Playwright browser tests, `./bin/openknowledge validate Wiki`, plus a separate `go test -race`-style job), `release.yml`, `deploy-railway.yml`, `knowledge-eval.yml`, `security.yml`. Workflow pins and secret scope are themselves checked by custom scripts (`check-workflow-pins.mjs`, `check-workflow-secret-scope.mjs`).

### 5. Git state

- Default/current branch: `main`, up to date with `origin/main` (`5a3bc1d`), no unpushed commits (`git log origin/main..HEAD` empty).
- Remotes: `origin` = `github.com/skogai2/okn.git`, `upstream` = `github.com/openknowledge-sh/openknowledge.git`.
- No other local branches, no submodules (`.gitmodules` absent), only one worktree registered (`git worktree list` shows just this checkout).
- **Uncommitted state**: one file staged (not committed): `.gitignore` has a staged addition of `/.skogai/logs/hook-tap/log.jsonl`. This predates my survey — I made no edits — but the orchestrator should know this clone is not clean.
- Recent commit themes: release/version bump to 0.13.0, Windows release portability fixes, a viewer workspace-dragging fix, a web terminal landing page that was added then reverted, onboarding simplification, and the new `SKOGAI.md` orientation commit.

### 6. Relationships

- Grep for `skogai`/`skogix` across `*.md`/`*.toml`/`*.json`/`*.yml` hits only `SKOGAI.md` itself — no other skogai2 repo (skogai, claude, config, dot, marketplace, dash-skogai, skogai-cli, skogai-docs, skogai-fleet, skogai-git-workflow, skogai-routing, open-knowledge-plugin) or `~`-path is referenced anywhere in the okn tree.
- `SKOGAI.md` itself contains an internal inconsistency worth flagging (see §8): it names the upstream remote as `skogai2/okf2`, but the actual git remote named `upstream` points to `openknowledge-sh/openknowledge`, and `origin` points to `skogai2/okn` (not `okf2`).
- **Not live-installed anywhere.** `okn` is on `$PATH` at `/home/skogix/.local/bin/okn` (regular 31MB binary, link count 2, not a symlink) — unrelated to this checkout, installed independently (likely via the upstream install script). No files under `~/.config` or `~/.claude` reference `~/.local/src/okn`'s path. No symlinks found anywhere in the repo tree (`find -type l` empty).
- The repo is registered in `~/.config/gita/repos.csv` as a standalone entry (`/home/skogix/.local/src/okn,okn,,`) with no group assignment — i.e., not currently part of the `projects` group that `TOOLS.md` already flagged as stale.

### 7. Orchestration readiness

A worker could likely work in a `wt` worktree of this repo for most tasks, with caveats:
- No `.config/wt.toml` exists in this repo yet, so there's no pre-merge hook (unlike the skogai repo's `openknowledge validate` hook) — one would need to be added if the orchestrator wants the same safety net here.
- No secrets found in the tree itself (only a *checker script* named `check-workflow-secret-scope.mjs`, not actual secrets); `.dockerignore`/`.gitignore` already exclude `deploy/runtime/secrets/`, suggesting secrets are expected to live outside the repo at runtime, not committed.
- No live-install symlinks or absolute-path dependencies back to `~/.local/bin/okn` or `~/.config` were found, so a worktree copy shouldn't collide with the installed CLI.
- Toolchain mismatch risk: `go.work` pins Go 1.26.6 but the machine has 1.27.2 — likely fine but unverified; `mise.toml` only manages `pnpm`, so Go version management for a worktree isn't automated here.
- The full `pnpm test` is heavy (build:viewer, Playwright browser install/tests, install/npm/demo smoke tests, full Go test suite) — a workorder should tell the worker which narrower script to run (e.g. `test:cli`, `check:format`) unless a full CI-equivalent run is actually wanted, to keep worker turnaround reasonable.
- The repo already carries an *existing uncommitted staged change* (`.gitignore`) predating any worker — a workorder should tell the worker whether to carry that change forward, drop it, or ask, so it isn't silently lost or silently committed.
- Any wiki-touching change must follow `Wiki/AGENTS.md`'s ASD-STE100 writing rules and run `okn validate "Wiki"` — a workorder for doc changes here should say so explicitly, since it's a non-obvious repo-specific requirement.

### 8. Open questions for skogix

- `SKOGAI.md` names the upstream remote as `skogai2/okf2`, but `git remote -v` shows `upstream` → `openknowledge-sh/openknowledge` and `origin` → `skogai2/okn`. Is `okf2` a renamed/retired repo, a typo, or a third remote that was never added? `SKOGAI.md` itself flags this naming divergence as "undocumented."
- The repo has a staged-but-uncommitted `.gitignore` change (adding `/.skogai/logs/hook-tap/log.jsonl`) and a `.skogai/logs/hook-tap/log.jsonl` file already on disk outside git tracking. Was this left mid-edit, and should it be committed, discarded, or is `.skogai/logs/` from some hook-tap tooling that should be documented?
- This repo has its own fully-formed OKF `Wiki/` for the *product*, but nothing yet documents the repo's role from skogai's orchestration side (no decision record, no routing entry). Should a skogai-side OKF concept/decision be added once this repo enters orchestration, distinct from its own product wiki?
- No `.config/wt.toml` exists here — should one be added (mirroring skogai's `openknowledge validate` pre-merge hook, perhaps running this repo's own `okn validate "Wiki"` or `pnpm check:format`) before workers start landing changes here via `wt`?
