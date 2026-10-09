---
id: 0012-survey-skogai-routing
status: done
created: 2026-10-09T21:50:18Z
add_dir: /home/skogix/.local/src/skogai-routing
---

# Goal

Write a survey of the skogai2 repo **skogai-routing** (local clone: `/home/skogix/.local/src/skogai-routing`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/skogai-routing`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/skogai-routing ...` for history and status.
- **Do not modify `/home/skogix/.local/src/skogai-routing` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

skogai-routing defines a convention for "routing files" (all-caps `.md`
files like `SKOGAI.md`/`CLAUDE.md`/`AGENTS.md`) that own other files and
act as choice-portals an agent walks to find context, plus a Claude Code
skill that teaches an agent the vocabulary needed to navigate the wider
skogai filesystem layout (`/skogai`, `.skogai`, "skogfences").

It is a seed/skeleton, not yet active tooling. Evidence:
- Single commit, `9820d74 init` (`git log`), already in sync with
  `origin/master`, nothing uncommitted.
- `SKOGAI-ROUTING-INTENTIONS.md:3` calls itself "a starting point to
  correct, not a finished position," and line 19 says "the first version
  proves only the routing step. Everything else waits."
- The glossary (`SKOGAI-ROUTING-GLOSSARY.md:11`) points to a narrative
  source `docs/concepts/definitions.md` that does not exist in the repo —
  the only directories present are `skills/`.
- No code, no tests, no validator exists yet for the convention it
  defines — it is prose plus one Claude skill.

### 2. Layout

Everything lives under the repo root, flat:
- `SKOGAI-ROUTING-GLOSSARY.md` — term definitions (`ownership`,
  `routing-file`, `leaf`, `root`, `ownership-(relationship)`).
- `SKOGAI-ROUTING-INTENTIONS.md` — design-rationale narrative, explicitly
  provisional.
- `skills/skogai-routing/SKILL.md` — the Claude Code skill entry point
  (frontmatter `name: skogai-routing`, `description: use this to *always*
  ... when exploring the skogai ecosystem`), routes to three reference
  docs.
- `skills/skogai-routing/AGENTS.md` — a one-line router (`<routes>` →
  `@SKILL.md`).
- `skills/skogai-routing/references/dash-skogai.md`,
  `dot-skogai.md`, `skogfences.md` — explain `/skogai` and `.skogai`
  naming/ownership conventions and the "skogfences" philosophy
  (agents get their own home dirs instead of being sandboxed).
- `skills/skogai-routing/plugins/hook-tap/log.jsonl` — a *committed*
  4-line tool-call log fragment from a prior session (see §8).

There is **no** README, no top-level `SKOGAI.md`, no `CLAUDE.md`, no
`.claude/`, and no `.skogai/` directory committed in the repo (one
appeared transiently under `.skogai/logs/hook-tap/` purely as a side
effect of this survey's own tool calls — see §8 — and was removed before
finishing). Despite the repo being *about* routing files, it has no
routing file of its own at its root.

### 3. Agent conventions

Orientation path for an agent dropped into this repo: there's no
root-level entry point, so the only way in is `skills/skogai-routing/SKILL.md`
or `skills/skogai-routing/AGENTS.md` directly. From there:
- `AGENTS.md` → `@SKILL.md` (one hop).
- `SKILL.md` → three `@./references/*.md` includes (dash-skogai,
  dot-skogai, skogfences), each a flat reference doc, no further routing.
- Several files carry `permalink:` frontmatter (`skogai-routing/glossary`,
  `skogai-routing/agents`, `skogai-routing/skill`), but the three
  reference docs' permalinks are all prefixed `dot-skogai/...` instead of
  `skogai-routing/...` (e.g. `dot-skogai/skills/skogai-routing/references/dash-skogai`
  in `dash-skogai.md:4`) — looks like they were copied from a `dot-skogai`
  repo and not re-pointed.

No `.claude/settings.json`, no hooks config, no plugin manifest, and no
OKF/knowledge bundle exist in this repo. The only "plugin" artifact is the
static log file under `skills/skogai-routing/plugins/hook-tap/`, which
looks like output *from* a hook-tap plugin rather than a plugin
definition — there's no plugin code here.

### 4. Toolchain

No languages beyond Markdown/YAML frontmatter and one `.jsonl` log file.
No package manager, no `mise.toml`/`.mise.toml`, no `argc` recipes, no
build/test/lint commands — **none**. No `.github/` or other CI config
found anywhere in the tree.

### 5. Git state

- Default/only branch: `master`, currently checked out, tracking
  `origin/master` and up to date (`git status`: "nothing to commit,
  working tree clean").
- No other local or remote branches besides `origin/HEAD`/`origin/master`
  (`git branch -a`).
- No submodules (`.gitmodules` absent), no worktrees other than the
  single checkout.
- Remote: `origin` → `https://github.com/skogai2/skogai-routing.git`
  (fetch and push).
- `git log @{u}..` is empty — nothing unpushed.
- Full history is one commit: `9820d74 init`, author Emil Skogsund,
  2026-10-09, adding all 8 current files at once.

### 6. Relationships

- Conceptually about two other paths, both explained but not referenced
  as live repos: `/skogai` ("dash-skogai", a shared, setgid multi-user
  directory for both human and agent system users — `dash-skogai.md:19`)
  and `~/.skogai` ("dot-skogai", described as both a config dir and a
  bootstrap submodule for new projects — `dot-skogai.md:13-15`).
- No mentions of skogai-cli, skogai-docs, skogai-fleet,
  skogai-git-workflow, okn, open-knowledge-plugin, or marketplace
  anywhere in this repo's tracked files.
- Not installed or symlinked anywhere live as far as this survey could
  check: no symlink under `~/.config` or `~/.claude` points at
  `/home/skogix/.local/src/skogai-routing`. However, the machine has
  several *other*, separate copies/clones of the same skill content
  found by filesystem search, outside this repo and outside this
  survey's scope to inspect further: `/home/skogix/old-dot-skogai/skills/skogai-routing`,
  `/mnt/sda1/skogix/dot-skogai/skills/skogai-routing`,
  `/mnt/sda1/claude-container-example/dot-skogai/skills/skogai-routing`,
  and `/mnt/sda1/20260927-red-alert-skogix/.agents/skills/skogai-routing`.
  This is consistent with §3's mismatched `dot-skogai/...` permalinks —
  the skill appears to have originated in (or been duplicated across) a
  `dot-skogai` tree before landing here. The committed
  `plugins/hook-tap/log.jsonl` also contains a stale reference to
  `cd /home/skogix/skogai/projects/skogai-routing` (a path `TOOLS.md`
  says "no longer exist[s] in this repo" as a submodule), confirming this
  repo used to live as a submodule under `skogai/projects/`.

### 7. Orchestration readiness

Mostly yes, with one concrete hazard observed directly during this
survey: this machine has a global Claude Code hook/plugin ("hook-tap")
that, on every tool call, appends the full tool input/output (and other
session-transcript data) to `<cwd>/.skogai/logs/hook-tap/log.jsonl`. Just
by running `git`/`ls` commands with this repo as the shell's `cwd`, this
survey caused that file to be silently created as **untracked** content
inside `/home/skogix/.local/src/skogai-routing/.skogai/` — not via any
Edit/Write tool call, so it would not have been obviously visible as a
modification. It was deleted again (plain `rm`/`rmdir`, no git operations)
to leave the clone clean, per the workorder's no-modification rule. A
worker agent operating in a `wt` worktree of this repo (or any repo) will
hit the same thing unless the hook is disabled for the worktree, scoped
to not fire outside intended directories, or its output path is
`.gitignore`d — otherwise every worker session leaves stray
transcript-bearing files behind that an orchestrator reviewing `git
status`/diffs before `wo land` could easily miss since they're untracked,
not staged.

Beyond that: no absolute paths were found hardcoded in tracked content
(the two `~` paths discussed are explanatory prose, not config), no
secrets, no live symlinks into `~/.config` or `~/.claude` that a worktree
copy would break, and no build/test tooling to wire up. A `wt` worktree
of this repo should be safe to create and work in. A workorder here would
mainly need to tell the worker: (a) there is no root routing file yet —
if asked to add one, decide whether it supersedes
`skills/skogai-routing/AGENTS.md` as the entry point; (b) the three
reference docs' `dot-skogai/...` permalinks are likely wrong and should
probably read `skogai-routing/...`; (c) `docs/concepts/definitions.md`
referenced from the glossary does not exist — either create it or fix
the reference; (d) the hook-tap log hazard above, if the orchestrator
wants worker worktrees kept artifact-free.

### 8. Open questions for skogix

- The permalink prefix mismatch (`dot-skogai/...` inside a repo named
  `skogai-routing`) in `dash-skogai.md`, `dot-skogai.md` and
  `skogfences.md` — intentional (shared namespace) or copy-paste leftover
  that should be `skogai-routing/...`?
- `SKOGAI-ROUTING-GLOSSARY.md:11` cites `docs/concepts/definitions.md` as
  the "full narrative source" — should this repo gain a `docs/concepts/`
  tree, or was that written for a different (home) repo and needs
  updating?
- This repo defines the *theory* of routing files but has no root routing
  file of its own and is not yet linked into the real repos that would
  use the convention (per `TOOLS.md`/`AGENTS.md` in the main skogai
  worktree, which use `@`-routes but don't reference skogai-routing at
  all). Is wiring skogai-routing's convention into the main skogai repo's
  own routing files an intended next step?
- The committed `skills/skogai-routing/plugins/hook-tap/log.jsonl` is a
  leftover debug artifact from a prior session (references a
  `demo-origin` herdr agent and the old `skogai/projects/skogai-routing`
  submodule path) — was it meant to be committed, or should it be
  removed upstream? (Not something this read-only survey could fix.)
- The global hook-tap logger's practice of writing full tool
  input/output into whatever directory is `cwd` (§7) seems worth a
  decision independent of this repo — should it write to a fixed log
  location instead of per-cwd `.skogai/logs/`, to avoid polluting every
  repo a session happens to visit?
