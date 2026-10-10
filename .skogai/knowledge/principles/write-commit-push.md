---
type: Principle
title: Write, commit, push — a change that isn't on origin hasn't happened
description: Write agreed decisions and changes to disk immediately, commit them, and push to an owned origin; unpushed local work is disposable.
tags: [principle, git, global]
status: stable
generated: { by: "human:skogix", at: "2026-10-10T00:00:00Z" }
verified: { by: "human:skogix", at: "2026-10-10T00:00:00Z" }
---

# Principle

As soon as a decision or change is agreed, even a small or informal one,
write it to disk. Then commit it and push it to an origin we own (`skogai2`
or `Skogix`). Work that exists only locally is disposable and counts as not
having happened yet.

# Why

Unwritten and unpushed state drifts into an informal second source of
truth. The remote is the only source of truth
([decision 0005](../decisions/0005-dash-and-dot-skogai.md)).

# Applies

- In every skogai repo, for agents and for skogix.
- Only to origins we own. Fork upstreams are never pushed to
  ([decision 0006](../decisions/0006-push-on-land.md)).

# Expected to be argued out of place

When agents have their own accounts, sudo where needed, and real machines
and workspaces shared by many agents and users, real PRs with real rules
and routines take the place of committing and pushing directly to the
default branch. That is skogix's stated argument, and this principle holds
until then.

Staged here until `/skogai/knowledge/` exists
([decision 0007](../decisions/0007-knowledge-and-memory.md)).
