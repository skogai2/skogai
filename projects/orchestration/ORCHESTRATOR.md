# Orchestrator — design notes

Status: draft, 2026-10-14. This is something to work from, not a decision.

The prompt itself lives in
`projects/claude-code/setups/orchestration/append-system-prompt.md` and is
tested from there. This file explains it. Change the prompt there and the
reasons here.

## Setup

- **System prompt:** Claude Code's default prompt stays as it is. The
  harness appends our prompt with `--append-system-prompt-file` (`bin/agent`
  does this when a setup has `append-system-prompt.md`).
- **Tools:** the plan is all tools. In the harness, `TOOLS` still defaults
  to none, so runs need `TOOLS=default` until a setup can set its own (see
  [TODO.md](TODO.md)).
- **Workers:** other setups, spawned with plain Bash:
  `printf '%s\n' "$prompt" | SETUP=<name> projects/claude-code/bin/agent`.
  The built-in `Agent` tool is only a fallback when no setup fits, and that
  case gets reported as a missing setup.
- **Case:** `cases/orchestration/research-summary.txt` asks for research
  without saying "delegate", to test whether the prompt alone makes it
  delegate. It hasn't been run yet.

## Why each part is in the prompt

| Part | Reason |
|---|---|
| Role | States that delegating is the default, not a last resort. |
| Workers are setups | Setups are focused and tested by evals. Spawning them keeps the orchestrator's context on the discussion. |
| Delegation permission | The default Claude Code prompt says not to spawn agents unless the user asks. This line is the user asking, once, for the whole session. |
| Tools rule | Earlier, tools we had were ignored. The prompt makes checking `TOOLS.md` a required step and makes skipping a tool something the orchestrator has to say and explain. |
| Handoff contract | Keeps v0 small: one prompt out, one message back. |
| Report format | Makes worker results easy to check and summarize. The herdr worker on 2026-10-14 used it as asked and the reply was easy to review. |

## Open questions

- `TOOLS.md` doesn't exist yet, so the tools rule points at nothing.
- Should workers get their own appended prompt, or does each worker setup
  carry it?
- Workers can't see the repo (empty sandbox), so the prompt tells the
  orchestrator to inline everything. That breaks down for large inputs and
  for implementation work until the sandbox TODO is solved.
- Inside the harness sandbox the orchestrator itself can't reach
  `projects/claude-code/bin/agent` either, so the spawn path can't be
  evaluated there yet.
