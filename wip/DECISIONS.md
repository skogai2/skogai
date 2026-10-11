# Decisions — summary

Draft summary, 2026-10-11. The recorded decisions live in
[.skogai/knowledge/decisions/](../.skogai/knowledge/decisions/index.md).
All seven are `type: Decision`, `status: stable`.

## Recorded

### 0001 — Adopt Open Knowledge Format

skogai's structured knowledge is an OKF v0.2 bundle at `.skogai/knowledge`,
with the maintenance rules `project`, `writing`, `decisions`, `agents` and
`changelog` enabled. The earlier hand-rolled drafts (`knowledge/DECISIONS.md`,
`.skogai/proposals/`) were deleted rather than migrated, because OKF's
`index.md` and `type`/`status` conventions already answer what they tried to
invent. New decisions are OKF concepts in `decisions/`.
Source: [0001-adopt-okf.md](../.skogai/knowledge/decisions/0001-adopt-okf.md)

### 0002 — Orchestration model

The main session orchestrates (writes, dispatches, checks and lands
workorders); each worker implements exactly one workorder. wt owns the
worktree lifecycle (`wo/<NNNN-slug>` branches, `wt merge` with pre-merge
hooks). herdr owns panes and agents: one `workers` workspace, one tab per
workorder, agents named `wo-<NNNN>`. A workorder is a committed file with
`status: open|done|blocked`, and the worker appends a `## Report`. Landing
is automatic once `done`, because skogai is experimental. The default
worker kind is `claude`, with codex planned.
Source: [0002-orchestration-model.md](../.skogai/knowledge/decisions/0002-orchestration-model.md)

### 0003 — Repo roles

gita tracks every repo skogai manages (groups `home`, `src`, `forks`,
`parked`). New clones go in `~/.local/src/`, and fixed-home repos stay where
they are. skogai is the orchestrator. Agent home repos (`claude`, `dot`, …)
become implementers later, and get no workorders until then. `skogai-fleet`
is parked, `skogai-docs` is superseded by `marketplace`, and `skogix` is
personal. Five repos are left untracked for skogix to sort out. The global
hooks and dotfiles installers stay dormant. This replaced the old
`projects/` submodules after the 0002–0014 surveys.
Source: [0003-repo-roles.md](../.skogai/knowledge/decisions/0003-repo-roles.md)

### 0004 — Knowledge lifecycle

Landed workorders, reports included, are the immutable raw layer. Knowledge
pages are the synthesized layer: they cite workorders in `sources` and carry
`stale_after` (30 days by default) when they derive from a point-in-time
survey. A stale page is a signal to re-survey, not to delete. Outdated
pages get `status: deprecated` instead of being deleted. There is no archive
folder, because OKF status plus git already do that job.
Source: [0004-knowledge-lifecycle.md](../.skogai/knowledge/decisions/0004-knowledge-lifecycle.md)

### 0005 — dash- and dot-skogai

Each repo's remote origin is the only source of truth, and every local
checkout (`/skogai` and `~/.skogai` included) is disposable. The goal is a
machine rebuilt from `archinstall` on every iteration. `/skogai`
(dash-skogai) plus skogcli replaced `~/.skogai` (dot-skogai) as the shared
layer. dot-skogai is kept and will be used once an installer exists. Only
the vision is fixed: full agent access to `/skogai`, and PRs approved by
agents with a skogix veto.
Source: [0005-dash-and-dot-skogai.md](../.skogai/knowledge/decisions/0005-dash-and-dot-skogai.md)

### 0006 — Push on land

A change counts only once it reaches origin. `wo land` pushes both the
target repo's default branch and skogai `master`, but only to origins owned
by `skogai2` or `Skogix` (`PUSH_OWNERS` in `bin/wo`). It never pushes to fork
upstreams, and it refuses to land when the local branch is behind origin or
has diverged from it. This setup is interim, until agents have their own
accounts and agent-approved PRs replace direct pushes.
Source: [0006-push-on-land.md](../.skogai/knowledge/decisions/0006-push-on-land.md)

### 0007 — Knowledge and memory

Two axes form a 2×2: scope (global/local) and lifespan (knowledge lasts,
memory expires). Writing memory is always allowed, but memory must be
maintained: local memory has a `stale_after`, and on expiry it becomes
knowledge, state, an action, or is forgotten. Global memory is append-only
events read through a per-reader marker. Promotion goes upward through
repetition (memory → pattern → principle). Types are an open set. Rules are
skogfences (structural enforcement), not knowledge. `/skogai` holds global
state and dot-skogai the implementing tools. One shared vocabulary is
defined once in `/skogai`.
Source: [0007-knowledge-and-memory.md](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md)

## Mentioned but not recorded

Choices that are settled, proposed or still open, and that have no decision
file yet.

- **dash-skogai = definition, dot-skogai = instance; every `.skogai` is a
  dot-skogai; one layout.** Settled in the 0020 interview. The report notes
  that it makes the wording of 0005 and 0007 outdated: they use
  "dot-skogai" for `~/.skogai` only, and 0007 splits "global state" from
  "tools". A follow-up decision was suggested but never written.
  [workorders/0020](../.skogai/workorders/0020-interview-skogai-glossary-and-layout.md)
- **"router" is the term; the meanings of bin/scripts/config/state.**
  Settled in the 0020 interview, and recorded only as dash-skogai glossary
  pages (`status: draft`), not as a decision.
  [workorders/0020](../.skogai/workorders/0020-interview-skogai-glossary-and-layout.md)
- **No staged principle moves to `/skogai` until "principle" is defined.**
  skogix's call in the 0020 interview.
  [workorders/0020](../.skogai/workorders/0020-interview-skogai-glossary-and-layout.md)
- **Definitions name concepts, never mechanisms.** A candidate principle,
  held as memory and used as the rule in the ground-up order.
  [memory/concepts-not-mechanisms.md](../.skogai/memory/concepts-not-mechanisms.md),
  [wip/ground-up-order.md](ground-up-order.md)
- **Offer, don't install: a `.skogai` owns only its own tree.** A candidate
  principle, held as memory.
  [memory/offer-dont-install.md](../.skogai/memory/offer-dont-install.md)
- **Where openknowledge `insights/` live** (move to `.skogai/memory/insights/`,
  or define them as memory inside the bundle). Undecided; the orchestrator
  leans to moving them.
  [memory/openknowledge-insights-are-memory.md](../.skogai/memory/openknowledge-insights-are-memory.md)
- **The order of definitions (steps 0–7: definition vs implementation, type,
  router, knowledge/memory, trigger, tool, workorder, layout).** A draft
  that must be agreed before any definitions are written; not agreed yet.
  [wip/ground-up-order.md](ground-up-order.md)
- **The name of "workorder" vs "action" vs "raw layer".** Deferred to skogix.
  [wip/ground-up-order.md](ground-up-order.md),
  [workorders/0020](../.skogai/workorders/0020-interview-skogai-glossary-and-layout.md)
- **The observe hook runs on `SessionEnd`, not `Stop`.** A hand fix (commit
  `368db74`) that departs from openknowledge's managed output. It is not
  recorded as a decision.
  [wip/knowledge-definitions.md](knowledge-definitions.md)
- **Workers run in `auto` permission mode.** `bin/wo` passes
  `--permission-mode auto` and TOOLS.md says the same. Decision 0002 still
  says `acceptEdits` with pre-allowed `git` and `openknowledge`. The change
  was never recorded. [TOOLS.md](../TOOLS.md)
- **Memory-maintenance routine** (for example a periodic triage workorder).
  Decision 0007 says one is needed; it is not designed.
  [0007](../.skogai/knowledge/decisions/0007-knowledge-and-memory.md)
- **Global git hooks in `claude`: revert the global scope or keep it
  machine-wide.** The survey asked for "a final decision". Decision 0003
  only says the hooks stay dormant.
  [workorders/0002](../.skogai/workorders/0002-survey-claude.md)
- **`config` repo diverged from origin; a merge/rebase decision is needed.**
  [workorders/0003](../.skogai/workorders/0003-survey-config.md)
- **Misnamed reference.** Survey 0003 cites "decision `0001-fix-dead-routes`",
  but that is workorder 0001, not a decision.
  [workorders/0003](../.skogai/workorders/0003-survey-config.md)
- **Phantom decision records in `skogix`.** Commit `f17777a` claims to add
  `.skogai/knowledge/decisions/`, but no such files exist.
  [workorders/0005](../.skogai/workorders/0005-survey-skogix.md)
