---
id: 0010-survey-skogai-fleet
status: done
created: 2026-10-09T21:50:18Z
add_dir: /home/skogix/.local/src/skogai-fleet
---

# Goal

Write a survey of the skogai2 repo **skogai-fleet** (local clone: `/home/skogix/.local/src/skogai-fleet`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/skogai-fleet`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/skogai-fleet ...` for history and status.
- **Do not modify `/home/skogix/.local/src/skogai-fleet` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey performed read-only against `/home/skogix/.local/src/skogai-fleet`
(git, Read, Glob, Grep only; no writes, commits, fetches, or checkouts).

### 1. Purpose and status

skogai-fleet is a rewrite of an older "nelson" Claude Code skill/plugin: a
multi-agent orchestration workflow dressed in a Royal Navy squadron
metaphor (Admiral, Captains, crew roles, Royal Marines), built as a
`SKILL.md` (~43KB) plus persona docs and reference material
(`SKOGAI.md`, `PERSONAS.md`, `personas-index.md`, `references/**`).

It is **active work-in-progress, not abandoned** — most recent commits are
from 2026-10-04 through 2026-10-07 (`git log`, `0a065b8` "Bump hook-tap
version to 0.2.0"). But the orchestration skill itself is a **skeleton**:
`SKILL.md` contains 26 `TODO(script:...)` placeholders (e.g.
`TODO(script:nelson-data) init`, `TODO(script:nelson-phase) advance`) for
helper scripts that are explicitly "not built yet." No `.state/` directory
exists anywhere in the repo, meaning the workflow has never actually been
run to completion. A second, separate concern — a `hook-tap` learning
plugin for Claude Code hooks — was added, versioned, and then its files
were deleted from the working tree (uncommitted), see §5.

### 2. Layout

```
skogai-fleet/
  SKOGAI.md            front door — routes to SKILL.md, PERSONAS.md, personas-index.md
  AGENTS.md            router, just `@SKOGAI.md` (permalink: skogai-fleet/agents)
  SKILL.md             the "nelson" orchestration skill (8-step workflow)
  PERSONAS.md          full character profiles for every crew role
  personas-index.md    condensed persona table for planning-phase loading
  references/          admiralty-templates/, damage-control/, standing-orders/,
                        plus crew-roles.md, model-selection.md, tool-mapping.md,
                        workflow-doctrine.md, the-estimate.md, goal-alignment.md,
                        structured-data.md, squadron-composition.md,
                        royal-marines.md, commendations.md, action-stations.md
  .old-references/      superseded drafts (chat.md, nelson-example.md,
                        skogai/experiments/{fleet-memory,personas}/...)
  .claude/skills/       plugin-creator, plugin-settings, plugin-structure —
                        generic Codex/Claude plugin-authoring skills, not
                        skogai2-specific (boilerplate, references
                        `~/.agents/plugins/marketplace.json`)
  .skogai/logs/hook-tap/log.jsonl   untracked, actively written (see §5)
```

No `README`, no `CLAUDE.md`, no `LICENSE`, no `.gitignore` at the repo
root (none found via `find . -maxdepth 1`).

### 3. Agent conventions

- `AGENTS.md` and `SKOGAI.md` form a two-file router: `AGENTS.md` has
  `permalink: skogai-fleet/agents`, `type: router`, and a `<routes>` block
  pointing to `@SKOGAI.md`, matching the `@`-include convention used
  elsewhere in the skogai2 fleet.
- `SKILL.md` frontmatter declares `name: nelson`, a `description`, an
  `argument-hint`, and `paths: [".state/**"]` — this is a genuine Claude
  Code skill, loaded as `/nelson` or by description match.
- The skill's own internal convention is "sailing orders → estimate →
  battle plan → form squadron → permission to sail → quarterdeck rhythm →
  action stations → stand down," backed by `references/admiralty-templates/*`
  for each artifact type and `references/standing-orders/*` for 17 named
  failure/edge-case situations (`becalmed-fleet`, `split-keel`, etc.) and
  `references/damage-control/*` for recovery procedures.
- `.claude/skills/` holds three unrelated, generic plugin-authoring skills
  (plugin-creator, plugin-settings, plugin-structure) — scaffolding
  imported from elsewhere, not written for skogai-fleet's own domain.
- No OKF or other knowledge bundle exists in this repo (no `.okf/`, no
  `knowledge/` dir). No memory files beyond the routers above.
- An agent arriving cold should read `AGENTS.md` → `SKOGAI.md` →
  `SKILL.md`, then pull `references/*` and `PERSONAS.md` on demand as the
  skill itself instructs ("load during planning," "do not load during
  quarterdeck/action-stations," etc.).

### 4. Toolchain

**None.** No `package.json`, no `*.toml` (no `mise.toml`, no `Cargo.toml`),
no lockfiles, no argc manifest anywhere in the repo (`find` for these came
back empty). No CI config (no `.github/`, no CI YAML outside a generic
`openai.yaml` agent-config example inside the imported plugin-creator
skill, which is unrelated). Build/test/lint commands: **none exist** —
the repo is pure markdown/skill content plus one small deleted TypeScript
hook plugin (see §5). The `hook-tap` plugin (when it existed) had its own
`.gitignore` and an "engine-generated tsconfig" per commit `c417edb`, but
those files are gone from the working tree now.

### 5. Git state

- Default/only branch: `master`, tracking `origin/master`
  (`https://github.com/skogai2/skogai-fleet.git`), up to date
  (`git log @{u}..` empty — nothing unpushed).
- No other local or remote branches, no submodules (`.gitmodules` absent),
  no registered worktrees besides the primary checkout
  (`git worktree list` shows one entry).
- **Uncommitted working-tree changes** at survey time: `.claude-plugin/marketplace.json`
  and the entire `plugins/hook-tap/` directory (plugin.json, `.gitignore`,
  `LEARNINGS.md`, `README.md`, `hooks/hooks.json`, `hooks/register.ts`)
  are deleted on disk but still present in `HEAD` — i.e. someone removed
  these files from the working copy without committing or `git rm`-ing
  them. `git status` shows them as unstaged deletions.
  - `git show HEAD:.claude-plugin/marketplace.json` confirms this repo
    was registered as a Claude Code plugin marketplace named
    `skogai-fleet`, with one plugin, `hook-tap` ("Shows the current hook
    stage in the status line and appends each event's input to
    `log.jsonl`, for learning how hooks fire").
- **Untracked**: `.skogai/logs/hook-tap/log.jsonl` (111 lines at survey
  time) — see §7, this is being written *live*, including by this very
  survey session.
- Recent commit themes (last 12): initial dump/experiments → markdown
  reorg → basic README → rename old-references → "skogix; a quick
  entrypoint" → basic-plugin-skills → add hook-tap plugin + marketplace
  manifest → stop tracking engine-generated tsconfig → update hook-tap log
  path → bump hook-tap version. Reads as: nelson-skill content came first,
  then a short, separate side-project (learning Claude Code hooks via
  hook-tap) was layered on top and has now been partially torn out
  in-place.

### 6. Relationships

No references found (`grep -rniE` across `*.md`/`*.json`/`*.toml`, outside
`.old-references/`) to the other named skogai2 repos (skogai, claude,
config, dot, skogix, marketplace, dash-skogai, skogai-cli, skogai-docs,
skogai-git-workflow, skogai-routing, okn, open-knowledge-plugin), and no
hardcoded `~/skogai`, `~/.config`, or `~/.claude` paths inside the repo's
own content — the only hits are generic plugin-authoring boilerplate
inside `.claude/skills/plugin-creator/**` referring to
`~/.agents/plugins/marketplace.json` (a Codex convention, not skogai2's).

**It is live-installed**, however, outside the repo:
`~/.claude/plugins/cache/skogai-fleet/hook-tap` and
`~/.claude/plugins/cache/skogai-marketplace/hook-tap` both exist, and
`hook-tap` is registered in `~/.claude/settings.json`. The log file at
`.skogai/logs/hook-tap/log.jsonl` (§5) contains an entry stamped with
*this survey session's own session ID*, confirming the globally-cached
hook-tap plugin is currently firing against whichever directory is the
active Claude Code `cwd` — it wrote into skogai-fleet's own working tree
during this very survey, purely as a side effect of this agent's `cwd`
being set there, not from any action this report took.

### 7. Orchestration readiness

Mostly yes, with two real hazards:

- **Hazard 1 — stray untracked artifacts from a global plugin.** Because
  `hook-tap` is cached/registered globally (not per-repo), any worker
  given this repo as its `cwd` will have `.skogai/logs/hook-tap/log.jsonl`
  silently appended to on every hook event, regardless of workorder
  content. A `wt` worktree would inherit this (new worktree, but the
  global plugin cache and `~/.claude/settings.json` registration are
  outside the worktree and still apply). A workorder should tell the
  worker to **ignore/not commit** `.skogai/logs/**`, or the orchestrator
  should add a `.gitignore` entry before dispatching real work.
- **Hazard 2 — dangling deleted-but-uncommitted plugin.** `plugins/hook-tap/`
  and `.claude-plugin/marketplace.json` are deleted on disk but still in
  `HEAD`. A worker that runs `git status`/`git diff` will see this as
  "pre-existing dirty state," not something it caused — a workorder
  touching this repo must say so explicitly, or a worker may reasonably
  (but wrongly) try to "clean up" by committing an unrelated deletion.
  skogix should decide: commit the deletion (confirming hook-tap is being
  retired) or restore the files (if the deletion was accidental) before
  any other work lands here.
- No absolute paths, no symlinks, and no secrets were found anywhere in
  the repo (`find -type l` returned nothing; no `.env`/credential-shaped
  files seen). The repo content itself (SKILL.md, PERSONAS.md,
  references/) is pure markdown and portable — safe to edit in a
  worktree.
- No toolchain (§4) means no build/test/lint step to wire into a
  `pre-merge` hook today; a workorder here is docs/content work, not code
  — the openknowledge `pre-merge` hook used in *this* repo's `.config/wt.toml`
  does not apply since there is no OKF bundle in skogai-fleet.
- A workorder for this repo should state: (a) treat `.skogai/logs/**` as
  noise, not a change to act on; (b) the `hook-tap`/`marketplace.json`
  deletion is pre-existing and out of scope unless the workorder is
  specifically about retiring hook-tap; (c) the actual task is almost
  certainly replacing the `TODO(script:...)` placeholders in `SKILL.md`
  with real scripts, or otherwise completing the nelson-skill rewrite.

### 8. Open questions for skogix

- Is `hook-tap` being retired (finish the deletion, commit it, maybe drop
  the marketplace registration from `~/.claude/settings.json` too), or was
  the deletion accidental and should the files come back? Right now the
  repo is in a half-removed state that nothing will resolve on its own.
  (Unknown — repo gives no commit message or note explaining the
  deletion; it is simply unstaged.)
- Is `skogai-fleet` meant to become the next plugin dispatched into a
  `wt`/`herdr` workflow (per decision 0002), i.e. should "finish nelson's
  TODO scripts" become its own workorder dispatched into this repo? The
  repo's own content (SKILL.md's 8-step workflow) is itself a competing
  orchestration design to the one in `.skogai/knowledge/decisions/0002-orchestration-model.md`
  — worth deciding whether nelson is meant to run *inside* the
  `wo`/`herdr`/`wt` model, replace it, or stay a separate, unrelated
  experiment.
- No README/CLAUDE.md at the repo root — is that intentional (SKOGAI.md
  is meant to be the sole entry point), or a gap versus the other skogai2
  repos' conventions?
- `.old-references/skogai/experiments/` duplicates `personas-index.md`
  and parts of `PERSONAS.md` under an older path — unknown whether this
  is deliberately kept for history or should be pruned.
