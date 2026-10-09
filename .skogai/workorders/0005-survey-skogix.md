---
id: 0005-survey-skogix
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/skogix
---

# Goal

Write a survey of the skogai2 repo **skogix** (local clone: `/home/skogix/skogix`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/skogix`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/skogix ...` for history and status.
- **Do not modify `/home/skogix/skogix` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

### 1. Purpose and status

`/home/skogix/skogix` is skogix's (the human's) own personal/narrative
scratch repo: markdown notes about his workflow, communication style, and
reflections on his own agent setup, plus a nested skills repo. It is not an
application — there is no code, no toolchain, no build. It reads as a
seed/early-stage repo that's actively being reorganized: 3 commits total, the
most recent from today (`f17777a`, 2026-10-09 09:18), the previous from
earlier today (`0d319a4`), and one from a week prior (`a21d03f`, 2026-10-02).
The two most recent commits are pure reshuffling (moving files into `docs/`,
adding a nested repo) rather than new content. `docs/TODO.md` has 4 open
checkbox items, none checked off — consistent with "freshly started, not yet
worked through."

### 2. Layout

Top level: `docs/`, `story/`, `WIP/`, `git-diff-communication/`, `old-skills/`
(nested git repo), plus an untracked `.skogai/` (see §3/§7). No `README`,
`CLAUDE.md`, or `AGENTS.md` anywhere in the main repo (only inside
`old-skills/`, a separate nested repo — see below). No `.claude/` directory.

- `docs/SKOGAI.md` — a `type: router` doc with `<routes>` pointing to
  `user.md` and `definitions.md`.
- `docs/SKOGIX.md` — a `type: router` doc ("the users own routing file like
  `{CLAUDE,AGENTS}.md` for `SKOGAI.md`") pointing to `TODO.md` and two
  external paths, `@~/dash-skogai` and `@~/skogai/¡` (this last target looks
  corrupted/typo'd — see §8).
- `docs/user.md` / `docs/introduction.md` — skogix's self-introduction to
  Claude (communication style, lowercase-significant naming convention,
  functional-programming preference).
- `story/` duplicates most of `docs/`'s content almost verbatim (including a
  full copy of `WIP/`) and adds five `skogix-story-N.md` narrative/fiction
  files not present in `docs/`.
- `WIP/` — two files (`context-engineering.md`, `progressive-disclosure.md`),
  also duplicated under `story/WIP/`.
- `git-diff-communication/` — three prompt files plus two captured
  diff-output files (`git-diff`, `git-diff-cached`); looks like saved
  examples/scratch for a "how to communicate git diffs to an agent"
  exercise, not live tooling.
- `old-skills/` — tracked as a git submodule link (mode `160000`, see §5) but
  with **no `.gitmodules` entry**, so git itself warns
  "no submodule mapping found in .gitmodules for path 'old-skills'"
  (`git submodule status` exit code 128). On disk it's a full, independently
  cloned repo (`github.com/skogai/skills.git`) with its own `README.md`,
  `AGENTS.md`, `CLAUDE.md` (under `scripts/`), `bin/`, `commands/`, `rules/`,
  `scripts/`, and ~40 `skills/` subdirectories (agent-development,
  bm-checkpoint, coordinator, hook-development, memory-ingest, etc.).
  Despite the local directory name "old-skills", this nested repo is not old
  or abandoned — its newest commit (`44d03e5 cleanup`) is from today
  (2026-10-09 09:15), same morning as the parent repo's last commit.

### 3. Agent conventions

The only routing/`@`-include convention in the main repo is the
`SKOGAI.md`/`SKOGIX.md` router pair described in §2, using the same `<routes>`
/ `<router>` + `@path` pattern used elsewhere in skogai2 (and the same OKF
`type: router` frontmatter field used by this skogai repo's own knowledge
base). There is no top-level `CLAUDE.md`/`AGENTS.md`, no `.claude/` settings,
hooks, or plugin config, and no OKF `.skogai/knowledge/` bundle in the main
repo (contrast with the `.skogai/knowledge/` structure in *this* skogai
worktree). An agent landing in this repo cold has no top-level entry point
telling it to read `docs/SKOGAI.md` — it would have to notice it by
convention/filename alone.

The nested `old-skills/` repo is a different story: it has its own
`AGENTS.md`/`CLAUDE.md` (under `scripts/`), a large `skills/` library, and
`rules/` (e.g. `rules/decisions-not-relitigated.md`, `rules/act-dont-ask`
per its commit log) — i.e. a real, maintained agent-skills repository, just
checked in here as an unregistered gitlink rather than referenced.

No Claude Code `settings.json`, hooks config, or plugin manifests found
anywhere under either repo.

### 4. Toolchain

None. No `mise.toml`, `argc` config, `package.json`, `Cargo.toml`,
`pyproject.toml`, `Makefile`, or `.github/` CI workflow anywhere in the main
repo or in `old-skills/`. Content is 100% markdown (plus two raw `git diff`
text captures). Build/test/lint: **none**.

### 5. Git state

Main repo (`/home/skogix/skogix`):
- Branch `master`, tracking `origin/master`
  (`https://github.com/skogai2/skogix.git`), 0 ahead / 0 behind.
- No other local or remote branches (`git branch -a` shows only
  `master`/`origin/HEAD`/`origin/master`).
- `git status`: clean except for one **untracked** `.skogai/` directory (see
  §7 — this appears to be a side effect of this very survey session's
  tooling, not pre-existing repo content).
- No worktrees other than the main checkout (`git worktree list`).
- 3 commits total: `a21d03f` "skogix" (2026-10-02, initial content dump),
  `0d319a4` "docs" (2026-10-09, pure file move into `docs/`), `f17777a`
  "Move decisions into .skogai knowledge directory" (2026-10-09, adds
  `git-diff-communication/` and the `old-skills` gitlink — but, despite the
  message, adds **no** `.skogai/knowledge/decisions/` files; see §8).

Nested repo (`old-skills/`, `https://github.com/skogai/skills.git`):
- Branch `master`, tracking `origin/master`, 0 ahead / 0 behind, clean.
- 10-commit visible history including merged PRs (#1, #2), unrelated to the
  parent repo's history.

### 6. Relationships

Explicit references to other skogai2/`~` paths are sparse and mostly
narrative, not functional:
- `docs/SKOGIX.md:10` — `@~/dash-skogai` ("a workspace shared between all
  agents... meta-tasks... git, dotfiles, global settings, permissions").
- `docs/SKOGIX.md:11` — `@~/skogai/¡` described as "the dot-folder for the
  dot-skogai project" — the path itself looks malformed (see §8).
- `docs/a-portrait-in-nine-chapters.md` / `story/a-portrait-in-nine-chapters.md`
  — prose describing skogix's other projects (a `cli` repo, a `marketplace`
  repo with `marketplace.json`, dotfiles/Ansible setup) in the third person,
  as reflective character study rather than live documentation or links.
- No references found to `skogai-cli`, `skogai-docs`, `skogai-fleet`,
  `skogai-git-workflow`, `skogai-routing`, `okn`, or `open-knowledge-plugin`
  by name anywhere in the main repo's markdown.

Live install / symlink check: `gita`'s repo list
(`~/.config/gita/repos.csv`) tracks `/home/skogix/skogix` under the group
name `skogix`, confirming `TOOLS.md`'s description of gita usage — this is
the only live "installation" found. No symlinks from `~/.config`, `~/.claude`,
or `~/.claude/plugins/*` point into `/home/skogix/skogix` or
`/home/skogix/skogix/old-skills`, and neither directory appears in
`~/.claude/plugins/marketplaces` or `installed_plugins.json`. Not installed
or symlinked anywhere live beyond the gita listing.

### 7. Orchestration readiness

Mostly yes, with caveats:

- **Content is just markdown** — low risk of path/build breakage from
  working in a `wt` worktree copy.
- **The `old-skills` gitlink is a problem.** Because it's a submodule-mode
  tree entry (`160000`) with no `.gitmodules`, a plain `git clone` or `wt`
  worktree checkout of `/home/skogix/skogix` will materialize an **empty**
  `old-skills/` directory (git has no instructions to populate it) rather
  than the populated nested repo seen on disk here. A worker in a fresh
  worktree would not see `old-skills/`'s actual content unless it's told to
  clone `https://github.com/skogai/skills.git` there manually, or unless
  `.gitmodules` is added first. A workorder touching `old-skills/` must say
  this explicitly.
- **Hook-tap side effect.** During this survey, running ordinary Bash/Read
  tool calls with cwd set to `/home/skogix/skogix` caused an untracked
  `.skogai/logs/hook-tap/log.jsonl` to be created and grow (66+ lines,
  observed during this session) — apparently a machine-wide Claude Code hook
  that logs tool activity into `<cwd>/.skogai/logs/`, independent of which
  repo is open. This is **not** something this survey did deliberately (the
  workorder forbids modifying the repo), but it means *any* agent — including
  a future `wt`-worktree worker — that merely runs shell commands with cwd
  inside this repo will leave behind untracked files there too. A workorder
  for this repo should tell the worker to expect/ignore this (and skogai's
  own `.gitignore` or the pre-merge hook should probably exclude
  `.skogai/logs/`).
- No secrets, no absolute-path hardcoding, and no live-installed config found
  that a worktree copy would break (§6).
- No build/test/lint to run, so `wt`'s normal "does it still build" safety
  net doesn't apply here — a pre-merge hook would have nothing to check
  except markdown validity/links.

What a workorder for this repo should tell the worker:
1. `old-skills/` is a dangling gitlink with no `.gitmodules` — don't assume
   it's populated or touch it without first deciding whether to add a proper
   submodule entry, vendor it, or drop the gitlink.
2. `docs/` and `story/` are near-duplicates — clarify which is canonical
   before editing either, to avoid drifting them further apart.
3. Expect an untracked `.skogai/logs/` to appear from hook activity; it is
   not part of the content to review or commit.

### 8. Open questions for skogix

- `old-skills` was added as a bare gitlink with no `.gitmodules` entry
  (commit `f17777a`). Was this intentional (e.g. a `git submodule add` that
  didn't finish) or a mistake? As-is, nobody else cloning this repo gets its
  contents.
- Commit `f17777a`'s message says it adds "decision records under
  `.skogai/knowledge/decisions/`... Replace the root `DECISIONS.md` with a
  router to `.skogai/knowledge/DECISIONS.md`" — but no such paths exist
  anywhere in the repo (tracked or on disk), and there's no `DECISIONS.md`
  at all. The message doesn't match the actual diff for that commit.
- `docs/SKOGIX.md:11`'s route target `@~/skogai/¡` contains what looks like a
  stray/corrupted character where a path was presumably intended (maybe
  `.skogai` or similar) — unknown what the correct target is.
- `docs/` vs `story/`: nearly every file in `docs/` is duplicated under
  `story/`, plus `story/` has five extra narrative `skogix-story-N.md` files
  and its own copy of `WIP/`. Unclear which directory is meant to be kept,
  or whether `story/` is a separate, deliberately-forked narrative project
  that happens to share source files.
- The directory name "old-skills" for the nested repo is misleading — its
  own history shows continuous activity through today, not an archived/old
  project. Unknown why it was named that locally.
