---
type: tool
title: herdr
---

# herdr
## gotchas

- `herdr agent send-keys` answering a dialog can leave a stray key in the worker's input. clear it with `ctrl+u`.
- `herdr agent read` truncates long replies. read the worker's answer from its transcript instead: `agent_session.value` → `~/.claude/projects/<cwd-slug>/<id>.jsonl`, last assistant message.
- a `claude` worker started with `acceptEdits` still stops for approval on every shell command. in auto mode it ran unattended to `done` in ~20s (2026-10-14).
