---
title: "Config environment variable names: dot means relation, hyphen is dropped"
author: Emil
date: 2026-11-07
standing: true
id: l-5346bfd6
scope: repo
status: active
src: init-review
---

## Decided
- A naming rule was needed so config keys map predictably to env vars.
- In the code: In `bin/skogai` `_env_name`, `.` becomes `_` and `-` is removed: `stage.on-stop` becomes `SKOGAI_STAGE_ONSTOP`. Keep `type/config.md` in sync.

_From PR #5 here, Oct 17._
