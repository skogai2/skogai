---
title: "Orchestration guidance lives in one plugin copy only, not duplicated in this repo"
author: Emil
date: 2026-11-07
standing: true
id: l-c5ccdcab
scope: repo
status: active
src: init-review
touches:
  - ".harness/context_summary.md"
  - dash-skogai/type/tool/herdr.md
---

## Decided
- A local orchestration skill drifted from the plugin's version, so its live findings were merged upstream and the local copy was deleted. A stale pointer to the old skill was then missed and needed a follow-up fix.
- In the code: Use `/vv-harness:harness-orchestrate` (skogai2/skogharness, vv-harness v6.3.2+). Do not recreate `.skogai/skills/herdr-orchestration`. Check `.harness/context_summary.md` and `dash-skogai/type/tool/herdr.md` point to the plugin.

_From PRs #14, #13 here, Nov 7._
