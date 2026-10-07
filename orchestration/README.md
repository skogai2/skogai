# orchestration

Work orders for skogai, run through herdr. One orchestrator session plans
and watches; one worker agent per order does the implementation in its own
herdr worktree of the repo, and opens the PR.

## Flow

```
user request
  → orders/<id>.md            (orchestrator writes it, status: open)
  → dispatch.sh <id>          (worktree + worker agent wo-<id>, status: running)
  → worker commits, pushes, opens PR, reports PR_URL=...
  → orchestrator records pr:, status: pr-open
```

## Layout

| Path | What |
|------|------|
| `ORCHESTRATOR.md` | rules for the orchestrator session |
| `launch.sh` | starts the orchestrator: `claude` with `herdr --skill` and `ORCHESTRATOR.md` appended |
| `dispatch.sh` | dispatches one order to a worker |
| `orders/` | work orders; `_template.md` to start a new one |

## Start

From a herdr pane in `~/skogai`:

```bash
orchestration/launch.sh
```

## Dispatch an order

```bash
orchestration/dispatch.sh <id>
```

Workers are Claude sessions named `wo-<id>`. The first time a new worktree
opens, Claude asks whether to trust its folder. That prompt blocks startup,
so `dispatch.sh` stops and tells you the pane: accept the prompt there, then
send the order text with `herdr agent prompt wo-<id> "..."`. They start with default
permissions, so an approval prompt stops the worker and the orchestrator
has to ask you. To let them edit without asking:

```bash
ORCH_WORKER_ARGS="--permission-mode acceptEdits" orchestration/dispatch.sh <id>
```

## Watch

```bash
herdr agent list
herdr agent read wo-<id> --source recent-unwrapped --lines 120
herdr agent wait wo-<id>
```

## Cleanup

When an order is `pr-open` or `done`, its worktree is still on disk under
`~/.herdr/worktrees/`. Remove it with `herdr worktree remove --workspace <id>`
once the PR is merged or closed. The branch stays in the submodule.

## Limits

- The orchestrator never merges. Workers never push to a default branch.
- Each order owns one branch. Two orders on one repo need two branches.
- Nothing here is authenticated: any pane in this herdr session can drive
  these agents, the same as any other herdr pane.
