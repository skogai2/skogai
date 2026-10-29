---
name: understand-before-fixing
description: "when skogix shows a tool or design, it's for understanding; never offer fixes. skogparse emits skogai-notation, not json."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5b1cec8d-6057-4df3-95ac-44c569789b32
  modified: 2026-10-28T20:45:40.495Z
---

When skogix demonstrates something (a tool's output, a design choice), the goal is my understanding, not a review. Don't list "bugs" or offer fixes; describe what it is, ask what I don't know.

Example: `skogparse` output looks like broken json (unescaped inner quotes, sorted keys) but it is skogai-notation, a different notation on purpose.

**Why:** told explicitly 2026-10-28, "there is nothing to fix except your understanding", after I kept proposing fixes for intended behavior (aichat chat hooks, skogparse).
**How to apply:** if something looks wrong, first assume intent and ask what the notation/design is; only suggest changes when asked. See [[read-vendored-docs-first]].
