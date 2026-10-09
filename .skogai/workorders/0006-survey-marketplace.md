---
id: 0006-survey-marketplace
status: done
created: 2026-10-09T21:50:17Z
add_dir: /home/skogix/.local/src/marketplace
---

# Goal

Write a survey of the skogai2 repo **marketplace** (local clone: `/home/skogix/.local/src/marketplace`) so the orchestrator can plan how to work in it. This is a read-only survey.

# Scope

- Read anything under `/home/skogix/.local/src/marketplace`. Use the Read/Glob/Grep tools for files, and `git -C /home/skogix/.local/src/marketplace ...` for history and status.
- **Do not modify `/home/skogix/.local/src/marketplace` in any way.** That means no edits, commits, fetches, checkouts or stashes.
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

Survey done read-only via `Read`/`Glob`/`Grep` and `git -C /home/skogix/.local/src/marketplace ...`. No writes, commits, fetches, checkouts or stashes were made in the marketplace clone.

### 1. Purpose and status

`skogai2/marketplace` (origin `https://github.com/skogai2/marketplace.git`) is a Claude Code **plugin marketplace repo**: a `.claude-plugin/marketplace.json` catalog plus the plugin sources it points at, and a vendored copy of the official Claude Code docs for offline lookup.

It is **active and in-progress, not abandoned**. Evidence:

- `git log` (10 commits): `init` → `init` → `marketplace rename` → `cleanup` → `okp` → `remove plugin-creator` → `skogix` → `Log all plain hook events in hook-tap` → `Remove open-knowledge-plugin from marketplace` → `schema` → `Add open-knowledge-plugin as a submodule`. Commit messages are terse/experimental ("okp", "skogix", "schema"), typical of a seed repo still finding its shape.
- Working tree is clean, branch is up to date with `origin/master`, no unpushed commits (`git log @{u}..` empty).
- The plugin set has already been reworked at least once (`open-knowledge-plugin` was removed, then re-added as a git submodule two commits later), so the catalog is still settling.
- `plugins/openknowledge/` is a stray single-file skill directory (`openknowledge/SKILL.md`, the generic "Open Knowledge project" skill template) that isn't registered in `marketplace.json` at all — leftover/orphaned, not wired up.
- `plugins/code-docs-lookup/` is a complete, real plugin (manifest, commands, scripts, a skill) but likewise **not listed** in `.claude-plugin/marketplace.json`'s `plugins` array, so it currently isn't installable from this marketplace.

### 2. Layout

```
.claude-plugin/marketplace.json   the marketplace manifest (2 plugins listed)
.gitignore                        ignores the hook-tap log.jsonl files
.gitmodules                       one submodule: plugins/open-knowledge-plugin
docs/                             vendored copy of the official Claude Code docs (docs.claude.com),
                                   synced 2026-10-09T07:44:09Z per docs/synced-at.txt; ~150 files,
                                   mirrors the public docs tree 1:1 (agent-sdk/, plugins/, whats-new/)
plugins/
  hook-tap/                       real plugin: status-line + hooks.json/register.ts that logs every
                                   Claude Code hook event to .skogai/logs/hook-tap/log.jsonl
  code-docs-lookup/                real plugin: searches the docs/ copy via scripts + a skill;
                                   NOT in marketplace.json
  openknowledge/                  stray single SKILL.md, not a real plugin, not in marketplace.json
  open-knowledge-plugin/          git submodule (its own repo, see below), in marketplace.json
plugin-skills/                    two authoring-reference skills (plugin-settings, plugin-structure)
                                   for writing Claude Code plugins — not referenced from
                                   marketplace.json or any plugin; look like standalone reference
                                   material the author keeps alongside the marketplace
.skogai/logs/hook-tap/log.jsonl   hook-tap's own log, also written under docs/ and
                                   docs/plugins/ (git-ignored duplicates from running claude in
                                   those subdirectories)
```

No root `README`, `SKOGAI.md`, `CLAUDE.md`, or `AGENTS.md` exists anywhere in the repo (checked root and all plugin/plugin-skills subdirectories). The only "entry point" is `.claude-plugin/marketplace.json` itself and the per-plugin `README.md`/`LEARNINGS.md` (only `plugins/hook-tap/` has these).

### 3. Agent conventions

- No `@`-include routing files anywhere (no `SKOGAI.md`/`AGENTS.md` at all, so nothing to route through) — unlike the main skogai repo, an agent dropped into this repo has no routing/orientation doc to read first.
- No `.claude/settings.json`, no hooks configured in the repo itself (the hooks that exist are hook-tap's *plugin* hooks, which only fire once hook-tap is installed into a host session, not the marketplace repo's own hooks).
- Skills present: `plugin-skills/plugin-settings`, `plugin-skills/plugin-structure` (plugin-authoring reference skills, unregistered), `plugins/code-docs-lookup/skills/claude-code-docs` (registered, part of that plugin), and the various skills inside the `open-knowledge-plugin` submodule (`backfill`, `okf`, `validate`, `visualize`).
- Knowledge bundle: the `open-knowledge-plugin` submodule carries its own OKF bundle at `plugins/open-knowledge-plugin/.okf/` (components, decisions, reference, skills) — that's the submodule's own project knowledge, not knowledge about the marketplace repo itself. The marketplace repo has no `.okf/` or other knowledge bundle of its own.
- An agent orienting here today has nothing to start from except `marketplace.json` and directory names; there's no equivalent of this repo's `.skogai/knowledge/index.md`.

### 4. Toolchain

- No `package.json`, lockfile, `mise.toml`/`.tool-versions`, `argc.yaml`, or `Makefile` at the marketplace root. `find` turned up exactly one `Makefile`, inside the `open-knowledge-plugin` submodule (its own repo, out of scope here).
- `plugins/hook-tap/hooks/register.ts` is TypeScript written against the Claude Code mod API (`import type { Register } from 'claude-code'`) — run in-process by the Claude Code engine, not compiled/tested by a separate toolchain.
- `plugins/code-docs-lookup/scripts/*.sh` are plain bash (`search-docs.sh`, `show-doc.sh`, `sync-docs.sh` — the last presumably produced the `docs/` vendor copy, consistent with `docs/synced-at.txt`).
- Build/test/lint commands at the marketplace level: **none**. The closest thing is `claude plugin validate plugins/<name>`, mentioned in `plugins/hook-tap/README.md`, for validating an individual plugin's manifest/hooks.
- No CI config at the marketplace root (no `.github/`). The `open-knowledge-plugin` submodule has its own `.github/workflows/ci.yml` and `release.yml`, but that's that submodule's CI, not the marketplace's.

### 5. Git state

- Default/only branch: `master`, tracking `origin/master` (GitHub `skogai2/marketplace`), clean working tree, no ahead/behind commits.
- No other local or remote branches besides `origin/HEAD`/`origin/master`.
- One submodule: `plugins/open-knowledge-plugin` → `https://github.com/skogai2/open-knowledge-plugin.git`, checked out at `c16141c0` on `heads/main`, clean and up to date with its own `origin/main`.
- No `wt`/worktrunk worktrees of this repo exist on this machine (only the live marketplace-install clone discussed in §6, which is a plain `claude plugin` clone, not a `wt` worktree).
- Recent commit themes (oldest→newest): initial scaffold → rename to "marketplace" → cleanup → add open-knowledge-plugin (as a plain copy, "okp") → remove plugin-creator → "skogix" (unclear content, see open question) → hook-tap logging improvements → remove open-knowledge-plugin → add a `schema` commit → re-add open-knowledge-plugin as a proper git submodule. Net effect: the plugin list has been actively rearranged at least twice, most recently converting open-knowledge-plugin from a vendored copy into a submodule.

### 6. Relationships

- Direct reference to another skogai2 repo: `.gitmodules` → `plugins/open-knowledge-plugin` → `https://github.com/skogai2/open-knowledge-plugin.git`.
- No textual references found (`grep -r` across `.md`/`.json`/`.ts`/`.sh`) to `/home/skogix` or other absolute home paths inside the repo's own files — the docs vendor copy is pure upstream Claude Code documentation and doesn't mention skogai.
- No in-repo symlinks (`find -type l` empty).
- **It is live-installed**, separately from this clone: `~/.claude/plugins/known_marketplaces.json` registers `skogai-marketplace` as a `git` source pointing at the same GitHub URL, auto-updating, cloned independently to `~/.claude/plugins/marketplaces/skogai-marketplace` (plus a `..clone` staging copy). `~/.claude.json` shows two installed plugins from it in active use: `hook-tap@skogai-marketplace` and `open-knowledge-plugin@open-knowledge-plugin-marketplace` (the latter actually resolves through the separate `open-knowledge-plugin-marketplace`/`scaccogatto` marketplace entries, not through `skogai-marketplace` — the plugin is available from both). `~/.claude.json` also has a `projects` entry for `/home/skogix/.local/src/marketplace` itself (this clone, used directly as a Claude Code working directory) and a `skogai2/marketplace` repo-path mapping to the same clone.
- So there are at least three copies of this repo content relevant to a worker: (a) `/home/skogix/.local/src/marketplace` — the dev clone surveyed here; (b) `~/.claude/plugins/marketplaces/skogai-marketplace` — the live, auto-updating install Claude Code actually loads plugins from; (c) its `..clone` staging copy. None of these is a `wt` worktree.

### 7. Orchestration readiness

A `wt` worktree of **this clone** (`/home/skogix/.local/src/marketplace`) looks safe in principle:

- No absolute-path leakage, no symlinks, no secrets found in the repo content itself.
- `hook-tap`'s log path (`.skogai/logs/hook-tap/log.jsonl`) and its `docs/` /`docs/plugins/` duplicates are relative and git-ignored, so they wouldn't pollute a worktree's git state, just leave untracked log files if a worker happens to run Claude Code from inside this tree.
- The `open-knowledge-plugin` submodule needs `git submodule update --init` (or equivalent) in a fresh worktree/clone if a workorder needs its contents, since `wt`/`git worktree` doesn't auto-populate submodules.

What a workorder would need to tell the worker, and what could break:

- **This clone is not the live plugin install.** Editing `/home/skogix/.local/src/marketplace` (or a worktree of it) does not change what Claude Code actually loads — that comes from `~/.claude/plugins/marketplaces/skogai-marketplace`, which `autoUpdate: true` refreshes from `origin/master` on GitHub. A workorder must say explicitly that testing a plugin change requires pushing to `origin/master` (or pointing at a branch) and letting/forcing that marketplace to resync — editing the worktree alone proves nothing about runtime behavior.
- **`marketplace.json` is the single source of truth for what's installable.** Any workorder that adds/renames a plugin directory must also update `.claude-plugin/marketplace.json`, or the plugin won't appear (as currently happens with `code-docs-lookup` and the stray `openknowledge/` directory).
- **The submodule boundary.** A workorder touching `plugins/open-knowledge-plugin/` is really targeting a different repo (`skogai2/open-knowledge-plugin`) with its own CI/release process; it should go to that repo directly rather than be edited in place inside the marketplace worktree, unless the intent is specifically to bump the submodule pointer.
- No build/test/lint step exists to gate a merge here beyond `claude plugin validate <dir>` per plugin — a workorder for a plugin change should call that out as its done-when check.

### 8. Open questions for skogix

- Commit `3b03cc6 skogix` has an unclear/unlabeled message — worth knowing what it actually changed if it matters for history, though the tree is clean now.
- `code-docs-lookup` and the stray `openknowledge/` directory exist in the tree but aren't in `marketplace.json`. Is `code-docs-lookup` meant to be published (just missing a catalog entry), parked deliberately, or deprecated? Is `plugins/openknowledge/` meant to be deleted, or is something supposed to consume it?
- `plugin-skills/` (plugin-settings, plugin-structure) isn't referenced by any plugin or by `marketplace.json`. Is it meant to become its own plugin, stay as author-only reference material, or move elsewhere?
- There are two independent "open-knowledge-plugin" marketplace registrations on this machine (`open-knowledge-plugin-marketplace`/`scaccogatto`, pointed at the GitHub repo directly, and this marketplace's submodule-based entry) — both installable and both tracked as used in `~/.claude.json`. Is the intent to standardize on one path (submodule-through-marketplace) and retire the other, per [decision 0001](../.skogai/knowledge/decisions/0001-adopt-okf.md) territory?
- No decision doc or routing file exists for this repo the way `.skogai/knowledge/` exists for the main skogai repo — is one planned, or is `marketplace.json` + plugin READMEs considered sufficient documentation for it?
