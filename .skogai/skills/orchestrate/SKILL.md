---
name: orchestrate
description: "You are the orchestrator: break work into tasks, dispatch each task to a subagent in its own Herdr worktree, then collect, review and integrate the results. Use when the user asks to orchestrate, delegate, parallelize or hand work to subagents, or mentions Herdr. Requires HERDR_ENV=1."
---

# Orchestrate

You are the orchestrator. You plan, write task specs, dispatch subagents, review their results and integrate them. Subagents implement. You do not implement dispatched work yourself and subagents never merge.

```
project   = { label, cwd }                      -> herdr workspace (long-lived)
task      = .skogai/tasks/<id>.md               -> herdr worktree + named agent (short-lived)
dispatch  : task -> agent                       worktree create, agent start, agent prompt
collect   : agent -> task(status: review)       agent wait, read task file
integrate : task -> done | revise | rejected    orchestrator reviews the branch, merges or sends back
```

## Preconditions

```bash
test "${HERDR_ENV:-}" = 1
```

If this fails, say you are not inside Herdr and stop. Never control a Herdr session from outside it.

The installed binary is the authority for syntax. Discover with `herdr --help` and by running a command group without a subcommand (`herdr agent`, `herdr pane`, `herdr worktree`, `herdr workspace`, `herdr tab`). Never run bare `herdr` (it attaches the TUI) and never probe a mutating subcommand by omitting arguments; `herdr workspace create` with defaults will execute.

Get your own context first:

```bash
herdr pane current --current
herdr workspace list
herdr agent list
```

`HERDR_WORKSPACE_ID` and `HERDR_PANE_ID` identify you. Long-lived project workspaces are bootstrapped by `~/.local/bin/herdr-workspaces`; do not create or close those.

## Task files

Tasks live centrally in `~/skogai/.skogai/tasks/<id>.md`, whatever project they target. Frontmatter is state, markdown is the spec and the result. Copy `~/skogai/.skogai/templates/task.md`.

```markdown
---
id: <kebab-case-id>
status: open            # open | dispatched | review | done | rejected
project: /abs/path/to/repo
base: master
branch: task/<id>
worktree:               # filled at dispatch
workspace:              # filled at dispatch
agent:                  # live agent name, filled at dispatch
kind: claude
---

# <title>

## spec
what to do, constraints, files in scope

## acceptance
- verifiable checks the subagent must run

## result
<!-- subagent writes here: summary, commands run, outcome, open questions -->
```

Ownership of fields:

- orchestrator: everything at creation; `worktree`, `workspace`, `agent`, `status: dispatched` at dispatch; `status: done|rejected` at integration.
- subagent: `## result` and `status: review` when finished. Nothing else.

One task = one branch = one agent. Keep tasks small enough that the acceptance section is concrete. Tasks that depend on each other are dispatched in order, not in parallel.

## Dispatch

1. Write the task file with `status: open`.
2. Create an isolated worktree with its own workspace, without stealing focus:

   ```bash
   herdr worktree create --cwd <project> --branch task/<id> --base <base> --label <id> --no-focus
   ```

   Read the workspace, root pane and path from the JSON response; never predict IDs. Run `herdr worktree list --cwd <project>` if a field is unclear.
3. Start the agent in the worktree's root pane with a unique name (`[a-z][a-z0-9_-]{0,31}`, use the task id or a short form of it):

   ```bash
   herdr agent start <name> --kind <kind> --pane <root-pane-id>
   ```

   Native agent arguments go after `--`. For `claude`, give the subagent write access to the central task file and a non-prompting permission mode, otherwise it sits `blocked` on its first edit:

   ```bash
   herdr agent start <name> --kind claude --pane <root-pane-id> -- --add-dir ~/skogai/.skogai/tasks --permission-mode auto
   ```

   `agent start` returns once the agent is ready; on `agent_not_ready` inspect with `agent read` before doing anything else.
4. Update the task file: `status: dispatched`, `worktree`, `workspace`, `agent`.
5. Hand over the task by path, not by pasting the spec:

   ```bash
   herdr agent prompt <name> "You are a subagent. Read ~/skogai/.skogai/tasks/<id>.md and implement it in your current worktree. Stay on branch task/<id>, commit your work there, run the acceptance checks, then write the ## result section and set status: review in that file. Do not merge, push, or touch other tasks." --wait --timeout 1800000
   ```

Dispatch several independent tasks before waiting on any of them.

## Collect

```bash
herdr agent wait <name> --timeout 1800000
herdr agent get <name>
```

States: `idle`/`done` means ready for input (probably finished), `working` means busy, `blocked` means an approval or question UI is showing, `unknown` means unclassified and proves nothing. A finished wait does not prove the task is done; the task file is the source of truth. Read it.

- `status: review`: go to integrate.
- still `dispatched`: `herdr agent read <name> --source recent-unwrapped --lines 120` to see why, then prompt with a specific follow-up.
- `blocked`: read the pane and decide. Answer routine approvals inside the task's scope; escalate anything destructive or out of scope to the user.

A timeout or `agent_prompt_stalled` does not prove the prompt was lost. Inspect before resending.

## Integrate

Review the branch in the worktree (`git -C <worktree> log --oneline <base>..` and the diff) against the spec and acceptance.

- accept: merge `task/<id>` into `base` from the project's main checkout, set `status: done`, then clean up.
- revise: append what is wrong under `## result`, set `status: dispatched`, prompt the same agent to address it.
- reject: set `status: rejected` with the reason, clean up without merging.

Cleanup of a task you created:

```bash
herdr worktree remove --workspace <task-workspace-id>
```

Remove only worktrees from tasks you dispatched. Use `--force` only after the branch is merged or the task is rejected. Report what was merged to the user.

## Raw panes

For ordinary commands (tests, servers) that are not agents, split a sibling pane and keep focus:

```bash
herdr pane split --current --direction right --cwd "$PWD" --no-focus
herdr pane run <pane-id> "just test"
herdr pane wait-output <pane-id> --match "test result" --timeout 120000
herdr pane read <pane-id> --source recent-unwrapped --lines 120
```

Split right when the pane is wide, down when narrow. `pane run` success means queued, not executed.

## Rules

- `--no-focus` everywhere; the user's focus stays where it is.
- Target with `--current`, explicit IDs from JSON, or unique agent names. Never another client's focused pane.
- Never close workspaces, tabs, panes or agents you did not create. Never use `workspace close --group` to bypass `workspace_group_close_required`.
- `--trust-repository` only when the user has verified the repo; it is not a retry flag.
- Never run `herdr server stop` or kill the herdr process. Use a named `--session` for experiments.
- IDs and agent names are scoped to one server. For remote machines use `herdr --machine <label> ...` on every command and rediscover IDs there; see `herdr machine`.
- CLI server errors are JSON on stderr with exit 1; syntax errors exit 2.
