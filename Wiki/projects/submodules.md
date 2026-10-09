---
type: Reference
title: Submodules
description: The projects/ directory and its two git submodules no longer exist; this page is historical.
tags: [skogai, submodules, okf]
status: deprecated
---

# Submodules (removed)

`projects/` and both submodules below are gone. Commit `a99d6d2` ("remove
gitmodules", 2026-10-09) emptied `.gitmodules` and removed the directory.
Source: `git log -1 a99d6d2`, `ls` on the repo root.

| Path | Remote | Pinned commit at setup (2026-10-04) |
| --- | --- | --- |
| `projects/ofk-claude` | `https://github.com/skogai2/okf` | `8e3187875e66051bb52f91a5ed27342e2c3208da` (`main`) |
| `projects/ofk-tools` | `https://github.com/skogai2/okf2` | `1d6b0e40c78d7fb1ec2dd459301876adcb499846` (`main`) |

## What replaced them

* `ofk-tools` survives as the installed `okn` binary (`~/.local/bin/okn`),
  independent of the submodule. It built and maintains [Wiki](../index.md)
  itself.
* `ofk-claude` was reinstalled as the Claude Code plugin
  `open-knowledge-plugin` (skills `okf`, `backfill`, `validate`, `visualize`),
  not restored as a submodule. See `log.md` for the 2026-10-09 entry.

## Notes

* Commits above come from `git submodule status` at setup time; they no
  longer resolve to anything in this repo.
* If the submodules come back, replace this page's content instead of
  appending to it — don't keep a dead table next to a live one.
