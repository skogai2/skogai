---
name: swap-internals-keep-interface
description: "when replacing how something works, keep the user's command and interface; never delete it"
metadata:
  node_type: memory
  type: feedback
  originSessionId: c4a358c4-f706-487e-aa84-85c427deeaf9
  modified: 2026-10-23T21:58:06.390Z
---

When the user asks to swap what a tool uses underneath (e.g. "use mise
instead"), keep their command, its interface and its tests, and replace
only the body. "The end result is the same" means the same commands
still work, not permission to delete them.

**Why:** in skogai2/cli (2026-10-23) I deleted `bin/config`, the argc
interface they had spent hours on, and left a package with no commands.
Then the restored version failed on their real machine and passed in the
too-clean tests.

**How to apply:** before calling something done, run it against the
user's real setup (read-only commands), not just isolated tests. Say
plainly what can be installed and run. Related: [[trust-existing-systems]].
