---
name: concepts-not-mechanisms
description: Definitions name concepts (on change, session end), never the mechanism that implements them; candidate principle.
created: 2026-10-11
stale_after: 2026-11-11
---

skogix, 2026-10-11: "on change" is a concept, not a function to call.
Definitions never name or reference a mechanism (wt, a Claude Code hook
event, a TypeScript file watcher), because which implementation gets used
is unknown and irrelevant. "Not now. Not ever."

Applies to the glossary, the layout and type definitions in
`/skogai/knowledge/`. The current 0020 pages still name mechanisms in places
(`git`, `wt` in the layout's tool-slice note); clean up while redefining
from the ground up.

On expiry: promote to a principle once principle is defined, or forget.
