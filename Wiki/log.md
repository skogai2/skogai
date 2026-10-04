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
