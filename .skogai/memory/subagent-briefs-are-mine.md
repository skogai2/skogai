---
name: subagent-briefs-are-mine
description: "orchestrating subagents — the hard part is the brief and the judge, not pane plumbing; lessons from the mock-agent run 2026-10-29."
metadata:
  node_type: memory
  stale_after: 2027-01-29
  type: feedback
  originSessionId: 329f2e80-a752-4e8e-bf42-7d8eac5d185a
  modified: 2026-10-29T08:23:38.318Z
---

When orchestrating subagents (herdr/wt or otherwise), spawning is free; the work is instructing and judging them. The user role-played an agent against my first brief and it went to crazytown: grepped `/`, cloned repos, got rate-limited, built a 12k-file monorepo, never wrote a blocked receipt.

**Why:** agents fake helpfulness and escalate scope; every gap in the brief gets filled with the most expensive interpretation.

**How to apply:**
- preconditions are mine: create the worktree, dry-run every done-when command on base, record the baseline before sending.
- clean env: no global/user CLAUDE.md, plugins, MCP or network; the brief is the agent's whole world.
  `claude --bare` would do it (skips CLAUDE.md discovery, hooks, plugins) but only works with API-key billing, not the user's subscription. without it, entering a repo dir auto-loads its CLAUDE.md (ruflo's is ~1000 lines of swarm/publish orders), so the clean env must come from somewhere else (loadout plugin, seat dir outside the repo, explicit --settings).
- plugin tests: `claude plugin test` runs only `*.test.ts` and sandboxes imports to the mod dir; to run one test, copy the mod minus other tests and run the copy.
- mechanical stop triggers: two denials or any need outside `owned` = blocked receipt.
- budgets enforced by the runner, not requested in the prompt.
- read scope = the worktree; name known decoys (e.g. installed plugin cache).
- gates are exact, scoped commands; never "the suite passes" on a flaky suite.
- retrying without new evidence is guessing (e.g. "pnpm failed at exactly 100 files, try again").
- verdicts come from diff + my own rerun, never the agent's claim.

Related: [[understand-before-fixing]], [[trust-existing-systems]].
