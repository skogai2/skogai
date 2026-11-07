---
title: "Removed the harness scaffolding after finding spec-gated tests and parallel agents didn't work"
author: Emil
date: 2026-11-07
standing: true
id: l-9d615754
scope: repo
status: active
src: init-review
touches:
  - ".skogai/memory/probe-method-lessons.md"
---

## Tried and ruled out
- Post-mortem found fundamental design problems with spec-gated acceptance tests and parallel agent coordination. Lessons were kept in memory docs instead of the machinery.
- In the code: Read `.skogai/memory/probe-method-lessons.md` before reintroducing feature gates, commit hooks or parallel-agent coordination. Don't restore the old `.claude/hooks/` gates without addressing those issues.

_From PR #11 here, Oct 31._
