---
type: Open Knowledge Insight
title: Knowledge insight from claude session
description: A project-scoped agent session produced a knowledge maintenance insight.
status: draft
okf_publish: false
okf_insight_id: f76ba6424ffb
okf_insight_kind: session-observation
generated:
  by: process:openknowledge-insight/claude
  at: 2026-10-11T00:23:17Z
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

You're right on both, and I withdraw both suggestions. 1. **The old version is not a leftover.** Five running sessions are on 2.1.295 right now, and two are on 2.1.296. I only looked at which version new launches resolve to and didn't check running processes before calling it "left behind". Uninstalling it would pull the binary out from under those five sessions. It only becomes prunable once they've exited, and it costs nothing in the meantime. 2. **There is no good reason to disable `hook-tap`.** Three live sessions have it loaded. I raised it only because its usage counter reads 0, but that…

## Evidence

- Session changed `.mcp.json`.
- Observer analyzed 17 user messages, 23 assistant messages, 11 tool calls, 11 tool results, 3 errors, 0 retries, and 0 validation events.
