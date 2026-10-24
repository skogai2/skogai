# q10 — Dispatch model: how do we start?

status: elaborate
act: ask
kind: choice
thread: cloud-setup
agent: ba4aaf06-03d2-4c07-90d2-2db139be6124
cwd: .
asked at: 2026-10-24T09:55:35.428414+00:00

## Elaborate requested

still have no diea what you are talking about. what cli checkout, what defaults, WHAT?
requested at: 2026-10-24T10:40:32.205705+00:00

## Context

Pilot candidate: the cli checkout that hardcodes /home/skogix defaults, which
Codex flagged. A cloud agent gets the workorder and returns a PR link plus
test evidence, and we judge only that. My pick: pilot.

If nobody answers, I change nothing.

## Files

- /home/skogix/skogai/.skogai/scripts/claude/cloud-environment.sh
- /home/skogix/skogai/SKOGAI.md
- /home/skogix/skogai/AGENTS.md

## Options

- pilot — one real workorder to one repo, observe the Result
+ primitive first, schema comes from reality
- one data point
- schema-first — write WorkOrder/Result/repo-contract shapes
+ clear target for every repo
- designed before any return value exists
- park — only fix the shebang and commit the staged script
+ two minutes
- dispatch idea stays on hold
