---
id: 0015-knowledge-repos-section
status: done
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

## Report

Created `.skogai/knowledge/repos/index.md` plus 14 `type: Repository`
pages (`skogai`, `claude`, `config`, `dot`, `skogix`, `marketplace`,
`dash-skogai`, `skogai-cli`, `skogai-docs`, `skogai-fleet`,
`skogai-git-workflow`, `skogai-routing`, `okn`, `open-knowledge-plugin`),
linked from `.skogai/knowledge/index.md`, with a `log.md` entry.

Each page follows the required frontmatter (`type`, `title`,
`description`, `tags`, `generated.by: "claude-code/claude-sonnet-5"`,
`stale_after: 2026-11-10T00:00:00Z`, `sources`), and a `# Role` / `#
Location` / `# State` / `# Workorder notes` / `# Open issues` body with
markdown footnotes keyed to `sources[].id`. `sources` link each survey
workorder as an absolute GitHub URL and decision 0003 as an internal
bundle-relative link (`/decisions/0003-repo-roles.md`); `skogai`'s own
page (no survey exists) cites decisions 0002–0004 instead. Role sections
follow decision 0003 wherever it overrides the survey. Pages are 49–59
lines each (index.md excluded, no frontmatter, matching
`decisions/index.md`'s convention).

Applied skogix's 2026-10-10 answers and dropped the questions they
resolve: `open-knowledge-plugin`'s CI-broken finding is noted resolved
(workflows folder renamed) and its "vendored in the monorepo" wording is
noted as tracked by workorder 0017; `skogai-fleet` is marked parked, not
a competing design to act on; `claude`/`dot` are marked future
implementers, not dispatch targets yet, with a note that their
`AGENTS.md` git/attribution conventions still conflict with skogai's
should that change; `skogai-docs` is `status: deprecated`, superseded by
`marketplace`; the global-git-hooks-dormant and
`.skogai/logs`/`.skogai/worktrees`-gitignored items are reflected as
resolved/non-issues across the affected pages (config, claude, dot,
skogix, and others that had flagged hook-tap noise); `skogix` repo notes
`old-skills` is a personal test repo, not a workorder target; `okn`'s
`okf2` naming is noted as tracked by workorder 0016.

`openknowledge validate .skogai/knowledge` passes (24 markdown files, 20
concepts, 3 indexes, 1 log — all checks OK).

Nothing left open from this workorder's own scope. Cross-repo items
raised in the pages' own "Open issues" sections (e.g. config's
master/origin divergence, skogai-fleet's half-deleted hook-tap plugin)
are for skogix/the orchestrator to resolve later, not blockers here.
