---
name: temporary-paths
description: .skogai/logs, .skogai/tmp and the like are temporary; drop anything in them nothing reads; default to opt-in.
created: 2026-10-17
stale_after: 2026-11-17
---

skogix, 2026-10-17, on where skogai-events' log goes after the rename:
"if not needed for anything then remove - but mostly we use paths which
should never be seen as other than temporary such as .skogai/logs
.skogai/tmp". And on event defaults: "when possible we go after clear
opt in solutions".

**Why:** a path under logs/ or tmp/ that something depends on long-term is
state hiding in a throwaway place; defaults that are on take over a repo
that never asked.

**How to apply:** don't preserve old logs or tmp files across renames or
migrations; delete what has no reader. Anything durable belongs in
config or state, not logs/tmp. Defaults ship off; a repo turns a thing on.
Related: [[offer-dont-install]].

On expiry: promote to a principle once principle is defined, or forget.
