# Bundle Update Log

## 2026-10-10

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
