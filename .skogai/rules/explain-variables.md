---
description: Define and explain every env var, path and magic value used in commands and reports
priority: 0
---
- When a command or message uses an env var, path, or magic value (`XDG_CONFIG_HOME=...`, a job
  tmp dir, a tailnet suffix, an id), set it visibly and say in one phrase what it is and why.
- In commands, prefer an explicit `export VAR=value` (or inline `VAR=value cmd`) over relying on
  hidden shell state from an earlier call.
- In reports, define each non-obvious variable where it first appears; skogix should never have to
  guess what `$FOO` or `id 3` refers to.
