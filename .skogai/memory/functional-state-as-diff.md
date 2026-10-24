---
name: functional-state-as-diff
description: "user is a functional programmer; sees state as a diff applied on a base, every key has a default."
metadata:
  node_type: memory
  type: user
  originSessionId: 1490d855-cc9e-48bd-8e1b-63aa236102c3
  modified: 2026-10-23T06:12:50.319Z
---

The user is a functional programmer at heart. They think of state like a
git diff that gets applied on top of a base, not as mutable values.

In practice: every key-value has a default; system settings (`/etc/skogai`)
are the base case; each repo carries a snapshot of base state from its last
clone/update/sync.

**How to apply:** frame designs as base + applied layers/diffs; never
propose a setting without a default. See [[concepts-not-mechanisms]].
