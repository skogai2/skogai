# Orchestrator — design notes

Status: draft, 2026-10-14. This is something to work from, not a decision.

What a setup is, its files, run options and commands are in
[FEATURES.md](../claude-code/FEATURES.md). This file covers only what is
specific to the orchestrator.

## Where it lives

`append-system-prompt.md` and `settings.json` here are hard links to
`projects/claude-code/setups/orchestration/`. Both names point to the same
file, so editing either one changes both.

Why: the main session imports the same prompt the harness tests, so we
iterate on our own setup by using it. A change shows up on the next
`/clear` with no harness run in between.

The prompt gets used in two ways:

| Where | How the prompt arrives | `settings.json` |
|---|---|---|
| This repo's main session | `@` import through `CLAUDE.md`, so as project instructions rather than system prompt | not applied, only listed |
| The harness (`SETUP=orchestration bin/agent`) | `--append-system-prompt-file` | applied (same as baseline) |

## The prompt today

Role only: discuss, decide, delegate and review, and workers do the bulk
of the work. It says nothing yet about *how* to delegate.

## Parked: parts that were in the prompt

These were cut down to the role. Each one comes back once there is
something real behind it.

| Part | Why it was there | Blocked on / what's needed first |
|---|---|---|
| Workers are setups | Setups are focused and tested by evals. Spawning them keeps the orchestrator's context on the discussion. | spawn path works from the main session (below) |
| Spawn command | `printf '%s\n' "$prompt" \| SETUP=<name> projects/claude-code/bin/agent` | same |
| Delegation permission | The default Claude Code prompt says not to spawn agents unless the user asks. This line is the user asking, once, for the whole session. | decide whether it applies to `bin/agent` too or only the `Agent` tool |
| `Agent` tool as fallback | Use only when no setup fits, and report that as a missing setup. | open question in PLAN.md |
| Tools rule | Earlier, tools we had were ignored. Checking `TOOLS.md` was a required step. | `TOOLS.md` doesn't exist |
| Handoff contract | One prompt out, one message back. | already true of `bin/agent`; FEATURES.md documents it |
| Report format | Makes worker results easy to check. Worked for the herdr worker on 2026-10-14. | a worker that uses it |

## Not covered by FEATURES.md

- Spawning a worker from the main session: the path to `bin/agent` from
  the repo root, and which setup to use for what (`TOOLS.md`).
- The main session vs harness split above.
- `TOOLS` defaults to none, so a harness run of `orchestration` has no
  `Bash` and can't spawn anything. It needs `TOOLS=default` until a setup
  can set its own tools (TODO.md).

## Open questions

- Should workers get their own appended prompt, or does each worker setup
  carry it?
- Workers run in an empty sandbox and can't see the repo, so everything
  has to be inlined. That breaks down for large inputs and implementation
  work until the sandbox TODO is solved.
- Inside the harness sandbox the orchestrator can't reach
  `projects/claude-code/bin/agent` either, so the spawn path can't be
  evaluated there yet.
- `cases/orchestration/research-summary.txt` tests whether the prompt
  alone makes it delegate. It hasn't been run, and with the role-only
  prompt and no tools it can't delegate yet anyway.
