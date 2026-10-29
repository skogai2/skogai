---
name: studio-harvest
description: "studio = generic pattern library rewritten from gamemaker (CCGS); base is commit 675d6fc, the todo branch dump is harvest material only"
metadata:
  node_type: memory
  type: project
  originSessionId: df19d76a-ba7b-4de1-9068-43a8eecf4922
  modified: 2026-10-29T03:30:15.585Z
---

`~/studio` base is commit 675d6fc (~780 lines, rewritten from scratch by skogix): concepts only, no agents, no domain. The `todo` branch "todo init" commit dumps the full gamemaker/CCGS tree (~108k lines: .claude, design, docs, skills, agents, studio-tests) purely to check what is worth keeping.

**Why:** the dump's text (docs/CLAUDE.md, templates, scripts) is not a constraint on anything; only what gets pulled into the base counts.

**How to apply:** harvest at concept level first — an idea the base lacks, where it lands in the base docs, its skogai counterpart. Mechanisms (scripts, hooks, file formats) come later. See [[concepts-not-mechanisms]].
