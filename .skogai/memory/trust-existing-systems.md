---
name: trust-existing-systems
description: "use established systems (pacman, git, ...) where they fit instead of reinventing them."
metadata:
  node_type: memory
  type: feedback
  originSessionId: 1490d855-cc9e-48bd-8e1b-63aa236102c3
  modified: 2026-10-23T07:12:02.365Z
---

Always trust and use existing systems where possible instead of
reinventing the wheel, even ones the user hasn't used before (e.g. pacman
for installs and versioning in skogai2/cli).

**Why:** the user's gut rule; established tools already solve the hard
edge cases.

**How to apply:** before designing a mechanism, check what the existing
tool already does and build on it. Related: [[offer-dont-install]].
