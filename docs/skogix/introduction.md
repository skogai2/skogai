# Skogai Orchestration & Setup Overview

This document serves as an introduction to the Skogai multi-agent coding repository structure, intended for orchestrators and sub-agents operating here.

## 1. Core Architecture and Layout
This repository relies heavily on multi-agent collaboration with a strict division of responsibilities:
- **Root Directory (`/`)**: Defines global tools (`mise.toml`), pre-commit hooks (`hk.pkl`), and generic harness testing scripts (`.harness/init.sh`).
- **`orchestration/`**: The core Hub where the agent orchestrator plans, delegates, and oversees worker agents. It includes declarative `work-orders/` mapping precisely *what* needs to be done, avoiding runtime targets within the specifications. Agents here NEVER modify project code or run long-running test suites.
- **`dash-skogai/`**: Home to the skogai type system, graph models, and `argc` CLI config. It maintains types indicating file ownership ("owns", "writes", "watches").
- **`.skogai/`**: Stores local rules, scripts (like `claude-code-documentation.sh`), memory indices (`MEMORY.md`), and historical operational insights that should be read to prevent repeating past failures.

## 2. Herdr Orchestration (v0.9.5, Protocol 22)
The orchestration layer strictly delegates using native `herdr` CLI commands.
- **Strict Isolation**: Agents meant to change code run in isolated `worktrees` (`herdr worktree create ... --no-focus`).
- **Workflow**:
  1. Pick an open work order (assuring no file overlap via `owns`).
  2. Spawn an isolated Git worktree & an agent in a background pane (`herdr agent start worker-<name> --kind claude/codex --permission-mode auto`).
  3. Dispatch prompt (`herdr agent prompt ... --wait`).
  4. Poll (`herdr agent list`, `herdr agent get`, `herdr agent read`).
  5. Adjudicate output via `git diff` within the worktree and run tests.
- **Rules**: NO direct implementations in the primary session, NO global `/tmp/` modifications (use repo-local `./tmp/`).

## 3. Trail Context Graph
This repo utilizes a context graph located at `.trail/cache/` (kept in sync via Git).
- For orienting: `trail map`
- For precise context: `trail ask "<query>" --source` to fetch small 8-line chunks of relevant files.
- Use `trail callers <symbol>` for cross-references.

## 4. Tests and Pre-flights
- **`hk check --all`**: Linting (shellcheck, shfmt, merge conflicts).
- **`.harness/init.sh smoke_test`**: Runs basic bash validations (`bash -n`) and jq parses json.
- **`.harness/init.sh full_test`**: Runs smoke_test + all bats file fixtures.
- Test commands run out of standard boundaries are discarded. Harness scripts provide structured checks without breaking dependencies.

## 5. Agent Constraints
- Obey deeply-nested `AGENTS.md` per folder scope.
- Sub-agents spawned dynamically receive specific path bounds (`owns` lists) which must not be crossed.
- Do not bypass permission boundaries or install unpinned packages. Wait for operator instruction on security blocks.
