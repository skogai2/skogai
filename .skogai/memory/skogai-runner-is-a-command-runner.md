---
name: skogai-runner-is-a-command-runner
description: "skogai-runner (skogai 3.0) is named for command runners like argc/make; core is the focus, other modules are local on purpose."
metadata:
  node_type: memory
  created: 2026-10-26
  stale_after: 2026-11-26
  originSessionId: 5b3e07e9-52a0-42cc-9b27-1df8465e0d64
  modified: 2026-10-26T04:46:24.889Z
---

skogix, 2026-10-26: "runner" in skogai-runner means a command runner in
the sense of argc, make and the like, not agent io. skogai 3.0 is a big
rework that centres on the core module (finding, configuring, testing and
running modules) and the purpose behind it.

**Why:** runner, memory and type were moved to `.skogai/modules/` and then
removed from master (c4cfd39, 2026-10-26) on purpose, so core gets the
focus. Their last versions are in git history. This is not a regression.

**How to apply:** treat `modules/core` and `bin/skogai` as the product.
Don't flag the missing modules as broken, and don't describe the repo as
"typed agent io" first. HANDOVER.md is gone; `.skogai/TODO.md` (linked
from CLAUDE.md) is the working list.
Related: [[swap-internals-keep-interface]], [[trust-existing-systems]].

On expiry: fold into the repo's own docs once HANDOVER/README reflect it, or forget.
