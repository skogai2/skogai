---
name: probe-method-lessons
description: "what the vv-harness sessions (2026-10-29/30) taught about protocol probes, spec gates and parallel agents; the harness itself was removed 2026-10-31."
metadata:
  node_type: memory
  stale_after: 2027-01-31
  type: feedback
  modified: 2026-10-31
---

The harness files are gone; the full record is `git show 593de0b:.harness/context_summary.md`.

**Probes** (`bin/probe`, `tests/probes/*.jsonl`):
- a probe = question + expected regex + ground-truth source; asked of `claude -p --safe-mode --tools ''` from an empty dir with only protocol/*.md as context. `--safe-mode` blocks CLAUDE.md leakage.
- commit probes before the section they test; a criterion is met on two consecutive passing runs (haiku is not deterministic). a single failing probe is noise until it repeats (~10% spurious UNKNOWN at 25 KB of protocol).
- regexes match meaning, not formatting; exact names must be expected literally (haiku wrote "skogix2" for skogai2).
- one fact per `###` heading; facts buried in another entry's answer get missed.
- `claude -p` waits 3s on non-TTY stdin; pass `</dev/null`.

**Gates and agents:**
- a spec gate proves a spec is testable, not worth building. ask "what changes in the world if this works" first; that question is what caught the rejected check framework.
- one Sonnet `claude` per feature in herdr workspaces, brief file + disjoint files + lead commits, gave near-zero rework.
- verify agent claims against what was seen in-session: atuin does not record `!`-prefixed commands, so history alone can mislead.

Related: [[subagent-briefs-are-mine]], [[understand-before-fixing]].
