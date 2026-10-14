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
- **Workers:** today the prompt points at the built-in `Agent` tool. The
  direction (see [PLAN.md](PLAN.md)) is for workers to be other setups,
  spawned with `SETUP=<name> bin/agent`. The prompt changes once spawning is
  decided.
- **Case:** `cases/orchestration/research-summary.txt` asks for research
  without saying "delegate", to test whether the prompt alone makes it
  delegate. It hasn't been run yet.

## Why each part is in the prompt

| Part | Reason |
|---|---|
| Role | States that delegating is the default, not a last resort. |
| Delegation permission | The default Claude Code prompt says not to spawn agents unless the user asks. This line is the user asking, once, for the whole session. |
| Tools rule | Earlier, tools we had were ignored. The prompt makes checking `TOOLS.md` a required step and makes skipping a tool something the orchestrator has to say and explain. |
| Handoff contract | Keeps v0 small: one prompt out, one message back. |
| Report format | Makes worker results easy to check and summarize. The herdr worker on 2026-10-14 used it as asked and the reply was easy to review. |

## Open questions

- `TOOLS.md` doesn't exist yet, so the tools rule points at nothing.
- Should workers get their own appended prompt, or does each worker setup
  carry it?
- When workers become setups, does the "Delegation" section switch from
  the `Agent` tool to `bin/agent`, or keep both?
