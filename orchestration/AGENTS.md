# AGENTS.md — Orchestration Layer

Guidance for coding agents operating in `/home/skogix/skogai/orchestration/`.

`CLAUDE.md` in this directory links here. Read `README.md` in this directory for detailed CLI syntax and operational workflows.

## Role & Responsibilities

Agents operating in this directory are **Orchestrators**. Your role is to plan, specify, delegate, supervise, and verify.

### MANDATORY RULE: Never Execute Direct Implementations in this Session
- **DO NOT** edit project code or implement features directly in this orchestration session.
- **DO NOT** execute long-running test suites or builds in the primary hub pane.
- **ALWAYS** delegate implementation tasks to sub-agents spawned in isolated worktrees via `herdr worktree create` and `herdr agent start`.
- **ALWAYS** write throwaway and scratch files to `./tmp/`, never to global `/tmp/`.

## Standard Workflow

1. **Plan & Specify**:
   - Check open work orders in `work-orders/open/`.
   - Ensure the declared `owns` files do not conflict with other active tasks (disjoint ownership invariant).
   - If drafting a new task, follow `work-orders/SPECIFICATION.md` and use `work-orders/TEMPLATE.md`.

2. **Spawn**:
   - Create an isolated worktree workspace:
     ```bash
     WS=$(herdr worktree create --workspace "$HERDR_WORKSPACE_ID" --branch "wo/<slug>" --label "<slug>" --no-focus)
     ```
   - Extract `.result.workspace.workspace_id` and `.result.root_pane.pane_id`.
   - Start the sub-agent in auto mode:
     ```bash
     herdr agent start "worker-<slug>" --kind claude --pane "<pane_id>" --timeout 60000 -- --permission-mode auto
     ```

3. **Dispatch & Supervise**:
   - Submit prompt with settled-state waiting:
     ```bash
     herdr agent prompt "worker-<slug>" "<task brief>" --wait --timeout 300000
     ```
   - Monitor status using `herdr agent get "worker-<slug>"` and inspect transcripts with `herdr agent read "worker-<slug>" --source recent-unwrapped`.
   - Never answer security or trust prompts autonomously. Alert the operator using `herdr notification show`.

4. **Verify & Retire**:
   - Adjudicate worker output by inspecting git diffs in the worktree (`git -C <worktree_path> diff`).
   - Run acceptance tests independently.
   - Clean up resources with `herdr worktree remove --workspace "<workspace_id>"`.
   - Move completed work orders to `work-orders/completed/`.
