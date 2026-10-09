# Bundle Update Log

## 2026-10-04

* **Initialization**: Created the Open Knowledge bundle scaffold.
* **Rules**: Seeded lightweight starter agent rules in [AGENTS.md](AGENTS.md).
* **Handoff**: Seeded a temporary setup handoff, `SETUP.MD`. The file was removed after setup.
* **Reference**: Stored a local pinned OKF spec copy in [SPEC.md](SPEC.md).
* **Setup scope**: The wiki documents the `skogai` front-door repo at `/home/skogix/skogai`. It covers routes, the routing model, the `projects/` submodules, and the route-update workflow.
* **Rules enabled**: `project` and `writing` in `.openknowledge.toml`. Other rules are not enabled.
* **Structure**: Created `overview.md`, `architecture/`, `projects/`, and `workflows/`, each with an `index.md`. No `raw/` or `decisions/` folder yet, because no raw imports or decision records exist.
* **Agent instructions**: Rewrote `AGENTS.md` for this wiki's purpose, read/update/no-update boundaries, and validation. No skill or automation was created. Skill scope, harnesses, and observation are still open.
* **Source**: Facts come from `SKOGAI.md`, `AGENTS.md`, `.gitmodules`, and the two `projects/SKOGAI-ROUTING-*.md` notes at commit `f619f07`.
* **Handoff removed**: `SETUP.MD` was deleted after its decisions were written into the bundle.

* **User guide added**: `guides/openknowledge-guide.md` and `guides/index.md`. The guide explains the setup, `okn`, and the `ofk-tools` and `ofk-claude` projects.
* **Verified**: The installed `okn` is 0.13.0. It has no `check`, `review`, `publish`, or `upgrade` commands, which the `ofk-tools` README describes.
* **Index**: Linked the guide from `index.md`.
* **Guide updated**: Rebuilt `okn` now has `check`, `review`, `publish`, and `upgrade`. Updated the command section and the loop in the user guide. `okn version` still reports 0.13.0.
* **Guide expanded**: Added a connect section (official docs and CLI help agree on `--access` default `read`) and a full claims section with lifecycle, conflicts, freshness, and commands. The Wiki still has no claims.

## 2026-10-09

* **Skill repaired**: `.claude/skills/openknowledge/SKILL.md` and its `.agents/` and global (`~/.claude`, `~/.agents`) counterparts were deleted, then restored with `okn setup repair Wiki`. `opencode`'s global skill was left uninstalled; it has no project config on this machine yet.
* **`openwiki` disconnected**: the registry had a second, unrelated entry (`openwiki` → `projects/openwiki/openwiki`) left `MISSING` after `projects/` was removed. Disconnected with `okn disconnect openwiki`; no other reference to it existed in the repo.
* **Routing content caught up**: `projects/`, `.gitmodules`'s two submodule entries, and the routing design notes (`projects/SKOGAI-ROUTING-GLOSSARY.md`, `projects/SKOGAI-ROUTING-INTENTIONS.md`) were removed 2026-10-09 (commit `a99d6d2`), well before this wiki noticed. Updated to match current `SKOGAI.md` (now two routes: `TOOLS.md` and self) in `index.md`, `overview.md`, `architecture/front-door-routes.md`, `architecture/routing.md`, `projects/index.md`, and `projects/submodules.md` (marked `status: deprecated`, kept as history per [Submodules](projects/submodules.md)).
* **Observation**: still disabled. Left that way deliberately — turning it on wires `okn automation insights run`, which lets an agent make unattended edits and leave an uncommitted diff; that needs an explicit decision when there's a concrete insight workflow to run, not a default.
