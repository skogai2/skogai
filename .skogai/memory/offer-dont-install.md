---
name: offer-dont-install
description: skogai offers things opt-in and never takes over another tool's files; candidate principle.
created: 2026-10-11
stale_after: 2026-11-11
---

skogix, 2026-10-11: assume everything anyone else builds is the worst thing
imaginable. So skogai never takes over another tool's files ("rm -rf
.claude/ and copy our stuff there"). It offers instead: ".skogai/skills/foo
is a skill you can use; here is how you would symlink it, copy it, or
whatever else you need."

Example: openknowledge writes into `.openknowledge/`, `.claude/settings.json`,
`.claude/skills/` and `~/.config/openknowledge/`. What a `.skogai` owns is
only its own tree. Everything outside it is something we point at, never
something we own.

On expiry: promote to a principle once principle is defined, or forget.
