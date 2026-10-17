---
name: always-commit
description: "commit finished changes without asking; don't end a turn with uncommitted work of mine."
metadata:
  node_type: memory
  created: 2026-10-17
  stale_after: 2026-11-17
  originSessionId: 84aa1ff9-c213-4775-a230-886489667f9a
  modified: 2026-10-17T13:13:35.241Z
---

skogix, 2026-10-17, after I asked "want me to commit both repos?":
"always commit".

**Why:** asking is a wasted round-trip; uncommitted work gets swept into
someone's WIP commit with no message.

**How to apply:** commit my own changes as soon as a step is done, in
every repo I touched, with a real message. Stage only my files, not
hook output (`.skogai/journal.md`) or others' edits. Pushing is still
separate.

On expiry: promote to a rule once rule is defined, or forget.
