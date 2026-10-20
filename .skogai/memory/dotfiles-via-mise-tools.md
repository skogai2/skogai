---
name: dotfiles-via-mise-tools
description: "For dotfiles and their history, use mise's own commands (mise dot ..., mise bootstrap services ...), never raw git/systemctl on its store."
metadata:
  node_type: memory
  type: feedback
  originSessionId: c9aa0a3e-a073-4215-98e9-9dad56b8d5b4
  modified: 2026-10-20T10:07:43.044Z
---

When anything touches dotfiles or mise dot history, use mise's own commands
(`mise dot status/paths/history/save/sync/exclude/untrack/undo/rollback`,
`mise bootstrap services ...`). Do not hand-roll `git --git-dir=.../repo.git`,
`update-ref`, `git clone --mirror` or `systemctl` on what mise manages, and do
not propose such command sequences as the fix. Start from the basics first:
what is tracked, how, where (`mise dot status`, `mise dot paths`).

**Why:** mise is built to keep stupid mistakes down; raw git and shell
workarounds bypass its checks. Emil prefers doing it himself over Claude
improvising (2026-10-20, after a raw-git history repair plan and a pty_proxy
change that locked every terminal).

**How to apply:** if mise has no command for what's needed, say so and stop;
don't fill the gap with raw git. Read-only checks with mise first, then
propose the mise command. Related: [[offer-dont-install]].
