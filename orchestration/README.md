# Herdr Agent Orchestration Hub

`/home/skogix/skogai/orchestration` is the central orchestration hub for managing multi-agent coding workflows across Skogai repositories. In this architecture, orchestrators running in `/home/skogix/skogai` do not modify project code directly within the primary session. Instead, they plan, author declarative Work Orders, and delegate tasks to specialized sub-agents running in isolated workspaces and panes using native `herdr` CLI commands.

---

## 1. Core Principles

1. **Mandatory Delegation**: Never execute implementation, refactoring, or multi-file edits in the primary orchestrator session. Spawning sub-agents is fast, cheap, and isolated; the orchestrator's role is planning, prompt specification, and quality adjudication.
2. **Strict Process & Workspace Isolation**: Every task modifying source code runs in a dedicated Git worktree (`~/.herdr/worktrees/<repo>/<branch>`) provisioned via `herdr worktree create`.
3. **Non-Intrusive Operation (`--no-focus`)**: Automated orchestration commands must never steal UI focus from the human operator. Always pass `--no-focus` when creating panes, tabs, or workspaces.
4. **Native Commands Only**: Use pure `herdr` CLI commands (v0.9.5, protocol 22) and standard utilities (`jq`). Never create or execute wrapper scripts around `herdr`.
5. **Separation of Concerns**: Work orders specify *what* to do (intent, inputs, deliverables, boundaries). The orchestrator dynamically assigns *where* and *how* it runs (worktree path, pane ID, agent kind).
6. **Scratch Storage Convention**: Write throwaway or scratch output to `./tmp/` (repo-local), never to global `/tmp/`.

---

## 2. Agent Lifecycle Commands Reference

| Operation | Native CLI Command | Key Options & Notes |
|---|---|---|
| **Worktree Provisioning** | `herdr worktree create --workspace <ws> --branch <branch> --label <label> --no-focus` | Creates isolated worktree at `~/.herdr/worktrees/<repo>/<branch>` and linked workspace. Returns JSON with `.result.workspace.workspace_id`, `.result.workspace.cwd`, and `.result.root_pane.pane_id`. |
| **Pane Allocation** | `herdr pane split --current --direction <right\|down> --no-focus` | Allocates a sibling pane for auxiliary commands or agents. Returns `.result.pane.pane_id`. |
| **Agent Start** | `herdr agent start <name> --kind <kind> --pane <pane_id> -- <args...>` | `<name>` matches `^[a-z][a-z0-9_-]{0,31}$`. Pane must be at interactive shell prompt. Pass auto-mode flags after `--`. |
| **Prompt Dispatch** | `herdr agent prompt <target> "<prompt>" --wait --timeout <ms>` | Atomic bracketed-paste submission + Enter. Rejects if blocked (`agent_blocked`). 5s activity gate (`agent_prompt_stalled`). Waits for `idle`, `done`, or `blocked`. |
| **Status Polling** | `herdr agent list` | Returns JSON array of all live agents with status (`idle`, `working`, `blocked`, `done`, `unknown`), session IDs, and titles. |
| **Target Status** | `herdr agent get <target>` | Fetches live lifecycle status and metadata for a specific agent. |
| **Settled Wait** | `herdr agent wait <target> --until done --until idle --timeout <ms>` | Explicit gate waiting for completion. Claude settles on `done` when unfocused; Codex settles on `idle`. |
| **Read Transcript** | `herdr agent read <target> --source recent-unwrapped --lines <N>` | Retrieves unwrapped terminal output. Required source for programmatic log and answer extraction. |
| **Send Keystrokes** | `herdr agent send-keys <target> <key>...` | Sends validated keys (`esc`, `ctrl+c`, `enter`, `ctrl+u`) to handle interactive menus or cancel commands. |
| **Operator Notification**| `herdr notification show "<title>" --body "<text>" --sound none` | Displays non-intrusive toast notification in Herdr TUI. |
| **Pane Teardown** | `herdr pane close <pane_id>` | Closes a single pane. |
| **Worktree Teardown** | `herdr worktree remove --workspace <workspace_id> [--force]` | Cleans up worktree checkout from disk and removes linked workspace. |

---

## 3. End-to-End Orchestrator Workflow

### Step 1: Work Order Selection & Ownership Conflict Check
Select an open work order from `orchestration/work-orders/open/<task-name>.md`. Verify that its `owns` list does not overlap with any currently active work order:
```bash
NEW_OWNS=$(yq eval '.owns[]' "orchestration/work-orders/open/<task-name>.md")
ACTIVE_OWNS=$(yq eval '.owns[]' orchestration/work-orders/open/*.md 2>/dev/null | grep -v -F -f <(echo "$NEW_OWNS"))
# Confirm disjointness across active dispatches
```

### Step 2: Provision Isolated Worktree Workspace
Create a dedicated Git worktree and Herdr workspace:
```bash
WS_INFO=$(herdr worktree create \
  --workspace "$HERDR_WORKSPACE_ID" \
  --branch "wo/<task-name>" \
  --label "<task-name>" \
  --no-focus)

WORKTREE_WS=$(echo "$WS_INFO" | jq -r '.result.workspace.workspace_id')
WORKTREE_PANE=$(echo "$WS_INFO" | jq -r '.result.root_pane.pane_id')
WORKTREE_PATH=$(echo "$WS_INFO" | jq -r '.result.workspace.cwd')
```

### Step 3: Instantiate Worker Agent in Auto-Mode
Ensure the target pane is at an interactive shell prompt, then launch the worker process:
```bash
# For Claude Code (auto permission mode):
herdr agent start "worker-<task-name>" \
  --kind claude \
  --pane "$WORKTREE_PANE" \
  --timeout 60000 \
  -- --permission-mode auto

# For OpenAI Codex (auto approval mode):
herdr agent start "worker-<task-name>" \
  --kind codex \
  --pane "$WORKTREE_PANE" \
  --timeout 60000 \
  -- --approve-for-me
```

### Step 4: Dispatch Work Brief
Dispatch the initial brief referencing the work order specification and absolute paths:
```bash
herdr agent prompt "worker-<task-name>" \
  "You are assigned work order $PWD/orchestration/work-orders/open/<task-name>.md. Read it, implement the deliverables within your owned paths, run acceptance checks, and report results." \
  --wait \
  --timeout 300000
```

### Step 5: Lifecycle Tracking & Gate Management
Monitor worker progress and settle state:
```bash
STATUS=$(herdr agent get "worker-<task-name>" | jq -r '.result.agent.status')

case "$STATUS" in
  "done"|"idle")
    echo "Worker settled. Extracting transcript..."
    herdr agent read "worker-<task-name>" --source recent-unwrapped --lines 120
    ;;
  "blocked")
    echo "Worker is blocked on an interactive prompt or approval."
    herdr agent read "worker-<task-name>" --source recent-unwrapped --lines 40
    # Trust prompts must never be auto-answered; alert operator:
    herdr notification show "Worker Blocked" --body "worker-<task-name> requires operator decision" --sound none
    ;;
  "working")
    echo "Worker still active; continuing wait loop."
    herdr agent wait "worker-<task-name>" --until done --until idle --timeout 180000
    ;;
esac
```

### Step 6: Verification & Adjudication
Never rely on agent self-reports alone. In the orchestrator or a manager pane:
1. Inspect git diff in the worktree:
   ```bash
   git -C "$WORKTREE_PATH" diff
   ```
2. Verify all modified files fall strictly within the work order's `owns` declaration:
   ```bash
   MODIFIED=$(git -C "$WORKTREE_PATH" diff --name-only origin/master...HEAD)
   # Assert MODIFIED is a strict subset of owns
   ```
3. Run the acceptance test commands independently:
   ```bash
   herdr pane run "$WORKTREE_PANE" "<acceptance_command>"
   ```

### Step 7: Teardown & Transition
1. Archive the work order:
   ```bash
   mv "orchestration/work-orders/open/<task-name>.md" "orchestration/work-orders/completed/<task-name>.md"
   ```
2. Merge the branch into master if verification passed cleanly.
3. Retire the worktree and workspace:
   ```bash
   herdr worktree remove --workspace "$WORKTREE_WS"
   ```

---

## 4. Error Handling & Recovery Matrix

| Error Code | Exit Code | Cause | Required Orchestrator Action |
|---|---|---|---|
| `agent_pane_busy` | 1 | Pane is executing a foreground command or shell prompt is not yet ready. | Sleep 1–2 seconds and retry `agent start`. |
| `agent_not_ready` | 1 | Agent encountered an initial trust or import dialog during startup. | Inspect `herdr agent read`. If trust dialog, alert operator via `herdr notification show`. The orchestrator must never answer trust prompts autonomously. |
| `invalid_agent_name` | 1 | Agent name violated `^[a-z][a-z0-9_-]{0,31}$`. | Adjust name to lowercase alphanumeric slug (≤32 chars) starting with a letter. |
| `invalid_agent_argument` | 1 | Multi-line or improperly formatted agent arguments were passed. | Ensure launch arguments after `--` are single-line strings. |
| `agent_blocked` | 1 | `agent prompt` rejected because agent is currently waiting at an approval or input dialog. | Inspect `herdr agent read`. Send keystroke via `agent send-keys` if standard UI navigation, or escalate to operator. |
| `agent_prompt_stalled` | 1 | Agent showed no activity within 5,000ms after prompt submission. | Inspect `herdr agent get`. Verify agent process is responsive. |
| `timeout` | 1 | Settled-state gate exceeded `--timeout <ms>`. | Check `agent get`. If still `working`, resume wait with `herdr agent wait`. Do NOT blindly re-prompt an active agent. |
| `not_linked_worktree` | 1 | `worktree remove` called on a primary workspace rather than a linked worktree. | Verify workspace ID from `herdr worktree list`. Do NOT run `workspace close --group` on the root workspace. |
| `workspace_group_close_required`| 1 | Attempted to close a workspace with child worktrees without passing `--group`. | Clean up child worktrees first using `herdr worktree remove`. |
