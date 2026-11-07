---
title: "The dash README is generated, so regenerate it instead of editing by hand"
author: Emil
date: 2026-11-07
standing: true
id: l-77773af0
scope: repo
status: active
src: init-review
touches:
  - dash-skogai/README.md
---

## Decided
- The type overview moved from a wide graph and table that were unreadable on a phone to a generated per-type README.
- In the code: Run `mise run dash:graph` to regenerate `dash-skogai/README.md`. `types.sh --json` gives the same data. Don't revive `tmp/graph/types.md`.

_From PR #7 here, Oct 17._
