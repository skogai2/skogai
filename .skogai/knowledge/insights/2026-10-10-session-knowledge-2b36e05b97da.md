---
type: Open Knowledge Insight
title: Knowledge insight from claude session
description: A project-scoped agent session produced a knowledge maintenance insight.
status: draft
okf_publish: false
okf_insight_id: 2b36e05b97da
okf_insight_kind: session-observation
generated:
  by: process:openknowledge-insight/claude
  at: 2026-10-10T22:51:52Z
okf_insight_targets:
  - "."
okf_insight_route:
  risk: high
  approval: expert
  confidence: 0.5
  owners:
    - "unassigned"
tags: [insight, session-observation]
---

# Knowledge insight from claude session

## Insight

Yes, `wip/` makes sense: it sits outside `.skogai/knowledge`, so the draft needs no frontmatter and the pre-merge validation ignores it. The file is written to `/home/skogix/skogai/wip/knowledge-definitions.md` and is not committed. It holds your three parts plus two additions: - **Hand-added pieces:** what skogai has that `openknowledge` did not create (`.config/wt.toml`, the route chain, the `.gitignore` line, the `permissions` block). - **Known issues:** the `Stop` hook, the `knowledge` default key, and the dangling `SETUP.MD` links. `wip/` did not exist in skogai before, so this creates it…

## Evidence

- Observer analyzed 32 user messages, 37 assistant messages, 15 tool calls, 15 tool results, 1 errors, 0 retries, and 0 validation events.
