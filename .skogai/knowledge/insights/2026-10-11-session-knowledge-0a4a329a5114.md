---
type: Open Knowledge Insight
title: Knowledge insight from claude session
description: A project-scoped agent session produced a knowledge maintenance insight.
status: draft
okf_publish: false
okf_insight_id: 0a4a329a5114
okf_insight_kind: session-observation
generated:
  by: process:openknowledge-insight/claude
  at: 2026-10-11T00:14:23Z
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

"mise" on its own is ambiguous, so I checked its state: mise itself is healthy, but the `skogai-mise` MCP server is broken because its config is missing the `mcp` subcommand. **The MCP server** - It is registered in `~/.claude.json` as `mise --cd /home/skogix/skogai`, which just prints mise's help and exits. That is why this session reports "Connection closed". - Running the same command with `mcp` appended answers the MCP handshake correctly. - I have not changed anything. To fix it, re-register the server (add `-s <scope>` if it wasn't registered at the default local scope), then restart the…

## Evidence

- Observer analyzed 7 user messages, 7 assistant messages, 3 tool calls, 3 tool results, 2 errors, 0 retries, and 0 validation events.
