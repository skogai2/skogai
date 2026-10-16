---
# Copy to .claude/foobar.local.md in the project where you run Claude.
# Everything here is optional: with no file, hook-tap logs every stage.

enabled: true

# Only log these stages. Omit or leave empty to log all of them.
stages: ["session.start", "session.end", "tool.call", "classic.*"]

# Where to append events, relative to the session's working directory.
log_path: ".skogai/logs/log.jsonl"

# Show "hook: <stage>" in the status line.
status_line: true
---

# example-project

info here
