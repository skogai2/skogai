# Orchestration — plan

Status: draft, 2026-10-14. The first pieces exist in `projects/claude-code`.
Open work is tracked in [TODO.md](TODO.md).

## Goal

skogai is the orchestration layer. The main session discusses things with
skogix and decides. It uses tools and other agents to do the bulk of the
work: implementing, researching, reading and summarizing.

## Scope of this folder

`projects/orchestration/` holds only what has been discussed and is
active. `wip/` is temporary and still being tested. Something moves from
`wip/` into here only after we discuss it and adopt it.

## Big picture

`projects/claude-code` is the collection of Claude Code setups, and also
the test bed for orchestration. The orchestrator is the agent that does
what we have been doing by hand: it spawns other setups.

| Orchestration idea | What it is in `projects/claude-code` |
|---|---|
| Worker kind or role | A setup, e.g. `commit-msg`, later `reviewer` or `implementer` |
| Handoff contract v0 | `bin/agent`: prompt in on stdin, one message out on stdout |
| Proof that a worker is good | Its cases and evals. A setup is tested before it is relied on |
| The orchestrator | A setup too (`orchestration`). Its main tool is "run setup X with this prompt" |
| `TOOLS.md` | Mostly the list of setups: what each one is for and when to use it |

Example from 2026-10-14: instead of the orchestrator reading a worker's
diff and writing the commit message, it should spawn a `reviewer` setup and
the existing `commit-msg` setup, then read only their replies. Its context
stays on the discussion.

This also addresses the "tools went unused" problem. The orchestrator has
few tools, spawning setups is the main one, and each setup is improved on
its own through its evals.

## The handoff contract (v0)

```
input:  a prompt (plain text)
output: a message back (plain text)
```

`bin/agent` already does this for one-shot workers. Workorder files,
worktrees and merging come later and build on it.

## Lessons

- **Tools we had went unused.** That made most of the earlier work useless
  in the end. Every tool we rely on is documented in `TOOLS.md`, and if a
  tool isn't documented, we don't count on it.
- **First herdr handoff (2026-10-14).** A `claude` worker in a herdr pane
  made the `append-system-prompt.md` change in `projects/claude-code`. It
  worked, but with `acceptEdits` it still stopped for approval on every
  shell command.
- **Harness gaps found by that worker.** `TOOLS` defaults to none, so the
  orchestration setup has no `Agent` tool. The sandbox doesn't contain
  `TOOLS.md` or the repo.

## Open questions

- Which parts of `wip/dot-dash-skogai` decisions 0002 (orchestration model)
  and 0003 (repo roles) still hold? 0002's workorders and herdr/`wt`
  workers look like the long-running worker kind.
- Does the orchestrator keep the `Agent` tool (in-session subagents) next
  to spawning setups, or only spawn setups?
