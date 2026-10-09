---
type: Open Knowledge Insight
title: Knowledge insight from claude session
description: A project-scoped agent session produced a knowledge maintenance insight.
status: draft
okf_publish: false
okf_insight_id: 2f41ac142f52
okf_insight_kind: session-observation
generated:
  by: process:openknowledge-insight/claude
  at: 2026-10-09T10:22:48Z
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

Done. Here's what we built and how it works: **What's live:** A real OKF v0.2 bundle at `.skogai/knowledge`, replacing the old hand-rolled `.skogai/proposals/` drafts (deleted). Rules enabled: `project`, `writing`, `decisions`, `agents`, `changelog`. Connected read-write under registry key `skogai`, with a project-scoped Claude skill and knowledge-gap observation both active. First entry: `decisions/0001-adopt-okf.md`, recording this very change. **How the "trusted" tier actually works, since that's what you picked:** - Every search result is tied to a content hash of the bundle (`okf+sha256:/…

## Evidence

- Observer analyzed 61 user messages, 118 assistant messages, 58 tool calls, 58 tool results, 0 errors, 0 retries, and 0 validation events.
