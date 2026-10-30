---
name: secrets-burned-on-contact
description: "Any secret that touched git or may have been read by an AI agent is burned, and skogix has already rotated it."
metadata:
  node_type: memory
  type: user
  originSessionId: a6b4e01f-999b-4154-bf89-96900c059543
  modified: 2026-10-30T06:17:54.646Z
---

skogix treats every secret that has touched git, or may have been read by an AI agent, as burned, and
rotates it right away. Old secrets found in history (e.g. `~/.cloudflared/token` in mise dot history,
2026-10-19) are already rotated. The only open question is whether to rewrite history, and that's
skogix's call.

**How to apply:** when a secret turns up in history, don't push for rotation. Note it and ask only about
the history rewrite. Related: [[track-then-trim]].
