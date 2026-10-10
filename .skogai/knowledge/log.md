# Bundle Update Log

## 2026-10-10

* **Knowledge and memory**: Recorded [decisions/0007-knowledge-and-memory.md](decisions/0007-knowledge-and-memory.md) (2×2 of scope × lifespan, maintained memory, skogfences, `/skogai` global state); added [principles/](principles/index.md) with [write, commit, push](principles/write-commit-push.md).
* **Push on land**: Recorded [decisions/0006-push-on-land.md](decisions/0006-push-on-land.md) (`wo land` pushes to owned origins only; unpushed work hasn't happened).
* **dash/dot-skogai**: Recorded [decisions/0005-dash-and-dot-skogai.md](decisions/0005-dash-and-dot-skogai.md)
  (origin is the only source of truth; local checkouts are disposable; dispatch to whichever repo a change belongs in; dot-skogai stays and will be used).
  Rewrote [repos/dash-skogai.md](repos/dash-skogai.md) and added [repos/dot-skogai.md](repos/dot-skogai.md)
  from the workorder 0019 interview; both are human-verified by skogix.

* **Repos section**: Added [repos/index.md](repos/index.md) and one
  `type: Repository` page per skogai2 repo, synthesized from survey
  workorders 0002–0014 and [decisions/0003-repo-roles.md](decisions/0003-repo-roles.md).
  `skogai-docs` is `status: deprecated` (superseded by `marketplace`);
  `skogai-fleet` is described as parked.

* **Repos**: Recorded [decisions/0003-repo-roles.md](decisions/0003-repo-roles.md) (gita in `~/.local/src` replaces `projects/` submodules; repo roles, parked and superseded repos).
* **Lifecycle**: Recorded [decisions/0004-knowledge-lifecycle.md](decisions/0004-knowledge-lifecycle.md) (workorders are the raw archive; pages cite them with `sources` and `stale_after`; deprecate, don't delete).

## 2026-10-09

* **Orchestration**: Recorded [decisions/0002-orchestration-model.md](decisions/0002-orchestration-model.md):
  workorders in `.skogai/workorders/`, wt owns worktrees, herdr owns worker agents, `bin/wo` drives it.

* **Initialization**: Created the Open Knowledge bundle scaffold.
* **Rules**: Seeded lightweight starter agent rules in [AGENTS.md](AGENTS.md).
* **Reference**: Stored a local pinned OKF spec copy in [SPEC.md](SPEC.md).
* **Setup complete**: Enabled `decisions`, `agents`, `changelog` rules alongside
  `project`/`writing`; recorded [decisions/0001-adopt-okf.md](decisions/0001-adopt-okf.md)
  documenting the switch away from the old `.skogai/proposals/` drafts; removed
  `SETUP.MD`; activated the project-scoped skill and knowledge-gap observation.
