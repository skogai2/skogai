---
name: no-chained-commands
description: never chain unrelated shell commands in one Bash call; use Read/Grep and one command per call
metadata:
  node_type: memory
  stale_after: 2027-04-29
  type: feedback
  originSessionId: 44ce83a1-023e-4ac3-b91b-2818363cef1a
  modified: 2026-10-29T09:42:33.382Z
---

Don't bundle unrelated commands (`cat ...; ls ...; grep ...`) into one Bash call. Use Read/Grep for reading, one command per Bash call, chain only true dependencies.

**Why:** chained calls defeat narrow permission rules (`Bash(grep:*)` can't match), so skogix is pushed toward allow-all; it makes reviewing what ran useless.

**How to apply:** parallel independent tool calls instead of `;`-chains. Related: [[trust-existing-systems]].
