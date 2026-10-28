---
name: session-path-not-config
description: "when `which skogai` or PATH looks wrong, compare against a clean login shell before blaming config"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b36f33d6-0ddf-43ec-8c3b-c34909a33add
  modified: 2026-10-28T16:56:38.017Z
---

2026-10-28: four failed install attempts turned out to be stale PATH entries
the running terminal (and claude, and herdr panes) inherited from earlier
`skogai ... build | source` runs, not anything in config. a clean shell had
none of them.

**Why:** `fish_add_path` without `--path` also wrote them to the universal
`fish_user_paths`, so they survived restarts too; fixed in skogai-runner
e5c54df. env lines skogai prints must only touch the current shell.

**How to apply:** check `env -i HOME=$HOME USER=$USER TERM=xterm fish -l -c
'which skogai'` against the live shell first. while developing, call the
checkout's `bin/skogai` by full path, never put it on PATH. related:
[[temporary-paths]], [[offer-dont-install]].
