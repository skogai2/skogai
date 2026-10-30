---
name: track-then-trim
description: "Dotfiles coverage - when unsure if something is config, track it and trim noise fast; agents start read-only and add authority as needed."
metadata:
  node_type: memory
  type: feedback
  originSessionId: a6b4e01f-999b-4154-bf89-96900c059543
  modified: 2026-10-30T06:17:54.625Z
---

When sorting untracked config (in `~/.config` or elsewhere in `~`) and it's unclear whether an entry is
real config: track it, then trim the noise right away. Claude should see the noise within minutes and
skogix within the hour; if not, something else is broken anyway. Config outside `~/.config` is tracked
in place too, by the same path rules (decided 2026-10-30).

Agents working on this start from "read files in the repo" and get whatever extra authority the task
actually needs, added step by step, not up front.

**Why:** skogix prefers a fast feedback loop over cautious leave-and-ask. Secrets don't change this
calculation: anything that touched git or an agent is already treated as burned and rotated
([[secrets-burned-on-contact]]).

**How to apply:** default verdict "track", follow with `mise dot exclude/untrack` for noise in the same
session. Use mise's own commands ([[dotfiles-via-mise-tools]]).
