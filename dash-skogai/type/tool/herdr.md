---
type: tool
title: herdr
---

# herdr

## oversight

verified live with herdr 0.9.5 (preview channel), claude code 2.1.318, 2026-11-06. only inside herdr (`HERDR_ENV=1`). claude agents only; other agent kinds are UNKNOWN (not checked), except that a codex worker was seen settling `idle` (F002).

orchestration (controller/worker delegation) lives in `.skogai/skills/herdr-orchestration/SKILL.md`.

| question | command |
|---|---|
| what is every agent doing | `herdr agent list`: pane_id, cwd, agent_status (idle/working/blocked/done/unknown), terminal_title_stripped (the task title), agent_session.value. `herdr api snapshot` adds panes, tabs, layouts in one call |
| what is it showing now | `herdr agent read <pane> --source recent-unwrapped --lines 120` (plain text, not json; truncates long replies) |
| what did it last say | its transcript, see below |
| wait for it | `herdr agent wait <pane> --timeout 30000`: returns at idle/done/blocked; add `--until <state>` (repeatable) for others. without `--timeout` it waits forever. an unfocused claude worker settles `done`, codex `idle`: wait for a finished worker with `herdr agent wait <target> --until done --until idle --timeout <ms>` |
| inspect it | `herdr agent get <target>`: the resolved agent; read it with `agent read` before answering a `blocked` wait |
| tell skogix | `herdr notification show "<title>" --body "<text>" --sound none` |
| send it text | `herdr agent prompt <agent> "<text>" --wait --timeout 120000` (default), or tmux-style `herdr pane send-text <pane> "<text>"` then `herdr pane send-keys <pane> enter` |

`<pane>`/`<agent>` is a pane id (`w88:p2`) or a live agent name.

### last answer from the transcript

`$CLAUDE_CONFIG_DIR/projects/<cwd-slug>/<agent_session.value>.jsonl`. here `CLAUDE_CONFIG_DIR=/skogai/claude`, not `~/.claude`. `<cwd-slug>` is the agent's cwd with every `/` and `.` replaced by `-` (`/home/skogix/.config/skogai` → `-home-skogix--config-skogai`).

```bash
jq -rs '[.[] | select(.type=="assistant")
  | (.message.content | if type=="array" then map(select(.type=="text") | .text) | join("\n") else . end)
  | select(length>0)] | last' "$transcript"
```

prints the last assistant entry with text; tool_use-only entries are skipped.

### agent_session is null

the claude integration (`/skogai/claude/hooks/herdr-agent-state.sh`, check with `herdr integration status`) reports the session id only on `SessionStart` (startup, resume, clear, compact, fork). an agent with no SessionStart since the server lost or never got its id shows `null`. 2026-11-06: `w88:p2` was null; its session started 05:00Z, the hook file was rewritten 05:50Z, and it had no SessionStart since. that is the likely cause, not confirmed. workaround: newest jsonl in its cwd-slug dir, matched on the task title (`grep -l '<title words>' $(ls -t <dir>/*.jsonl | head -5)`).

### why `agent prompt` over send-text

- it sends text and enter in one bracketed-paste submission.
- it refuses with `agent_blocked` when the agent is at an approval or question dialog; `send-text` types into the dialog.
- with `--wait` it confirms the agent started working and waits for it to settle.

### agent start failures

seen live with herdr 0.9.5, 2026-11-06 (F002), unless noted:

- `agent_pane_busy` right after `tab create`: the tab's shell is not up yet. retry.
- `timeout` while the tui actually started: herdr leaves the name unregistered (`agent_not_found`), so use the pane id. pass `--timeout 120000` (default is 30s).
- `agent_not_ready`: blocked during startup (a trust dialog). the name stays available for `agent read` and `agent send-keys` (`herdr --skill`).
- `invalid_agent_argument`: multi-line argv is rejected. launch packets must be one line.

## gotchas

- `herdr agent send-keys` answering a dialog can leave a stray key in the worker's input. clear it with `ctrl+u`.
- `herdr agent read` truncates long replies. read the answer from the transcript instead (see oversight).
- a `claude` worker started with `acceptEdits` still stops for approval on every shell command. in auto mode it ran unattended to `done` in ~20s (2026-10-14).
- claude asks the "allow external CLAUDE.md imports" dialog once per project. for `~/skogai` it was already answered (`hasClaudeMdExternalIncludesWarningShown` true, `hasClaudeMdExternalIncludesApproved` false), so workers there start without the dialog and without external imports (SKOGAI.md is not loaded). in a project where it still shows, `herdr agent start` returns `agent_not_ready` and the agent stays `blocked`. it is a trust decision for skogix. after it is answered, `herdr agent wait <agent> --until idle --until done` (a plain `wait` returns at once on the stale `blocked`) (F002, 2026-11-06).
