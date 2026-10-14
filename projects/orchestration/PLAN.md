# Orchestration — plan

Status: draft, 2026-10-14. Nothing is implemented yet.

## Goal

skogai is the orchestration layer. The main session discusses things with
skogix and decides. It uses tools and other agents to do the bulk of the
work: implementing, researching, reading and summarizing.

## Scope of this folder

`projects/orchestration/` holds only what has been discussed and is
active. `wip/` is temporary and still being tested. Something moves from
`wip/` into here only after we discuss it and adopt it.

## Lessons from earlier attempts

- **Tools we had went unused.** That made most of the earlier work useless
  in the end. So every tool we rely on must be documented here: what it is
  for, when to use it, and how to call it. If a tool isn't documented, we
  don't count on it.

## The handoff contract (v0)

The minimum we must get working before anything else:

```
input:  a prompt (plain text)
output: a message back (plain text)
```

One prompt goes in and one message comes back. The worker kind, workorder
files, worktrees and merging all come later and build on this.

## Plan

1. **Tool inventory.** Write `TOOLS.md` with one entry per tool: purpose,
   when to use it, how to invoke it, and a known-good example. Candidates
   from earlier work: `claude`, herdr, `wt` (worktrunk), `okn`
   (openknowledge), gita, mise, and the harness in `projects/claude-code`.
   Each one gets checked before it's listed.
2. **Handoff v0.** Get prompt → message working with one worker kind, and
   check it end to end.
3. **Orchestrator vs worker.** Write down what the orchestrator does itself
   (discuss, decide, review) and what it delegates (implement, research,
   read, summarize).
4. **Verification.** Decide how results get checked: review by the
   orchestrator, or evals in `projects/claude-code`.
5. **Real tasks.** Try the setup on one or two real tasks before writing
   more design docs.

## Open questions

- Which worker kind comes first for v0: an in-session subagent, `claude -p`,
  or a herdr pane?
- Which parts of `wip/dot-dash-skogai` decisions 0002 (orchestration model)
  and 0003 (repo roles) still hold?
- How do we make sure documented tools actually get used: a router file,
  `CLAUDE.md`, skills, or hooks?
