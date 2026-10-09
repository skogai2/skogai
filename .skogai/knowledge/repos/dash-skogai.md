---
type: Repository
title: dash-skogai
description: Source repo for /skogai, a shared multi-agent filesystem workspace — admin scripts, portable launchers, and Claude Code hooks.
tags: [repo, infrastructure, src]
generated: { by: "claude-code/claude-sonnet-5", at: "2026-10-10T00:00:00Z" }
stale_after: 2026-11-10T00:00:00Z
sources:
  - id: decision-0003
    resource: /decisions/0003-repo-roles.md
    title: Decision 0003 — repo roles
  - id: survey
    resource: https://github.com/skogai2/skogai/blob/master/.skogai/workorders/0007-survey-dash-skogai.md
    title: Survey workorder 0007
---

# Role

The source repo for `/skogai`: a shared, multi-agent filesystem
workspace. Provides admin scripts to create the `skogai` group/agent
users, a generator for portable `uv`-based launchers, and Claude Code
hook scripts that glue a memory system and herdr/wt into the shared
install.[^survey]

# Location

Local clone: `/home/skogix/.local/src/dash-skogai`. Remote:
`https://github.com/skogai2/dash-skogai.git`. gita group: `src`. The live
deploy is a separate, independent clone at `/skogai` — not a symlink.

# State

Active, mid-churn: all 16 commits are from 2026-10-02 to today; the tip
commit removed a shared fish config added only hours earlier.[^survey]
`/skogai`'s own checkout currently has uncommitted staged changes
(`.gitignore`, `mise.toml`) not reflected in this clone.

# Workorder notes

- This clone is not the live system — editing it does nothing until
  someone re-runs `admin/install-tools.sh` against `/skogai`, and
  `/skogai` can drift independently (it already has).
- Never run `admin/create-agents.sh`, `admin/setup-coordination.sh`, or
  `admin/test-coordination.sh` against the live system (`sudo`, real
  system users); test in a container/VM if needed.
- `gptme-contrib` submodule is uninitialized in this clone — run
  `git submodule update --init` first.
- Hook scripts hardcode `/home/skogix/claude/.skogai/memory` — won't
  resolve from an arbitrary worktree path.

# Open issues

- Should this clone become what `wt` worktrees branch from, or should
  `/skogai` (the live install) be the source of truth instead?

[^survey]: Survey workorder 0007
