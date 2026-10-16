---
name: openknowledge-insights-are-memory
description: openknowledge's insights/ drafts are local memory living inside the knowledge bundle, untriaged; plus loose ends from the openknowledge setup.
created: 2026-10-11
stale_after: 2026-10-25
---

`.skogai/knowledge/insights/` gets auto-generated draft pages from the
openknowledge session-end observer. By decision 0007 that is local memory
(needs triage, has a best-before), but it sits inside the knowledge bundle.
State on 2026-10-11: `2026-10-09-…aa80d90f96c8.md` committed,
`2026-10-10-…2b36e05b97da.md` untracked, neither triaged.

Options:
- point the insights path at `.skogai/memory/insights/` (`integration.toml`
  records the path; untested whether openknowledge honours a change);
- keep it in the bundle and define `insights/` as memory that lives there.

Orchestrator leans to the first. Undecided.

Loose ends from the same setup (`wip/knowledge-definitions.md`):
- `~/.config/openknowledge/registry.json` still connects `/tmp/foobar`
  (key `knowledge`, write access).
- openknowledge 0.13.0 writes the observer under `Stop` (every turn), not
  session end. Upstream bug; we report or fork, never push upstream. Untested
  whether `setup repair` reverts skogai's hand fix.

On expiry: becomes a decision or a workorder.
