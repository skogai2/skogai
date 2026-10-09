---
id: 0015-knowledge-repos-section
status: open
created: 2026-10-10T00:00:00Z
---

# Goal

Add a `repos/` section to the knowledge bundle with one OKF concept page per skogai2 repo. The pages are synthesized from the survey reports and from skogix's decisions, so an orchestrator can learn a repo's role, state and workorder caveats without reading a 150-line report.

# Scope

- Create `.skogai/knowledge/repos/index.md` and one page per repo: `skogai`, `claude`, `config`, `dot`, `skogix`, `marketplace`, `dash-skogai`, `skogai-cli`, `skogai-docs`, `skogai-fleet`, `skogai-git-workflow`, `skogai-routing`, `okn`, `open-knowledge-plugin`.
- Link `repos/index.md` from `.skogai/knowledge/index.md`, and add a `log.md` entry.
- Out of scope: editing decisions, workorders, or anything outside `.skogai/knowledge/`.

# Done when

- [ ] Each page has `type: Repository`, `title`, a one-line `description`, `tags`, `generated` (`by` = you, as `claude-code/<model>`), `stale_after: 2026-11-10T00:00:00Z`, and `sources`. In `sources`, link the survey workorder as an absolute GitHub URL (`https://github.com/skogai2/skogai/blob/master/.skogai/workorders/<file>`). Decision 0003 is an internal link.
- [ ] The body of each page has these short sections:
  - **Role:** taken from decision 0003, which overrides the survey wherever they differ.
  - **Location:** local path, remote, and gita group.
  - **State:** status and the evidence for it.
  - **Workorder notes:** what a worker in this repo must be told.
  - **Open issues:** use only the issues that are still open after skogix's answers below.
- [ ] `skogai-docs` has `status: deprecated` and says `marketplace` superseded it. `skogai-fleet` is described as parked.
- [ ] `skogai` gets a page too. Derive it from `TOOLS.md`, decisions 0002–0004 and `bin/wo`. It has no survey, so its `sources` are the decisions.
- [ ] Each page is under about 60 lines. Do not copy reports into the pages; cite them.
- [ ] `openknowledge validate .skogai/knowledge` passes.

# Context

skogix answered the survey questions on 2026-10-10. Apply these answers, and drop the questions they resolve:

- open-knowledge-plugin: skogix renamed the CI workflows folder, so the broken-CI finding is resolved. Its `SKOGAI.md` "monorepo/vendored" wording dates from when it was a submodule of skogai (workorder 0017 fixes it).
- skogai-fleet: an old project that is parked and may be reworked later. It is not a competing orchestration design to act on now.
- claude (and the other agent homes): these will become implementer agents that skogai orchestrates to, once skogai is closer to its original state. Do not dispatch workorders there yet.
- skogai-docs / `~/claude-docs`: "clone the Claude Code docs to disk", which has moved to marketplace.
- The global git hooks / dotfiles installers stay dormant and ignored. Workers must not run them.
- `.skogai/logs/` and `.skogai/worktrees/` are now in the global gitignore, so the hook-tap noise is resolved.
- skogix: skogix's personal dump repo. `old-skills` is a big old test repo of skills, rules and scripts.
- okn: the repo is `skogai2/okn`. The `okf2` name in its `SKOGAI.md` is stale (workorder 0016 fixes it).

Read these before you start:

- `.skogai/knowledge/decisions/0003-repo-roles.md` (roles)
- `.skogai/knowledge/decisions/0004-knowledge-lifecycle.md` (sources, stale_after, deprecation)
- the `## Report` sections of `.skogai/workorders/0002`–`0014`
- `.skogai/knowledge/SPEC.md` §5 (frontmatter)
