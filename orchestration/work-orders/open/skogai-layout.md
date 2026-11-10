---
name: skogai-layout
description: Establish a minimal filesystem scaffold for future .skogai paths
reads:
  - AGENTS.md
  - .gitignore
  - .skogai/memory/temporary-paths.md
owns:
  - .skogai/README.md
  - .skogai/config/.gitkeep
  - .skogai/state/.gitignore
  - .skogai/tmp/.gitignore
  - .skogai/worktrees/.gitignore
---

## Intent

Make the existing local structure discoverable and preserve starter paths in fresh checkouts. Keep durable state distinct from disposable output.

## Deliverables

- `.skogai/README.md`: document existing config, memory, rules, scripts, skills, tasks, templates, workflow, logs, tmp, worktrees, and new state paths. Explain tracked definitions versus local output; future consumers use repository-relative paths and create disposable directories on demand. New module subdirectories are added only when needed. Keep orchestration work orders in their existing location.
- `.skogai/config/.gitkeep`: preserve the configuration directory without inventing defaults.
- `.skogai/state/.gitignore`, `.skogai/tmp/.gitignore`, `.skogai/worktrees/.gitignore`: preserve these directories while ignoring local contents using `*` and `!.gitignore`. State is durable local output, never disposable. Logs remain covered by root ignore rules.

## Acceptance Criteria

- `git diff --check` exits 0.
- All five owned files exist.
- `git check-ignore .skogai/state/example .skogai/tmp/example .skogai/worktrees/example .skogai/logs/example` exits 0 and lists all four paths.
- `.harness/init.sh smoke_test` exits 0, or report any pre-existing failure precisely.

## Boundaries & Non-Goals

Preserve existing content; no migration, runtime code, dependencies, tool activation, or speculative module tree.

**Anti-Widening Directive**: If completing this task requires creating or modifying any file outside the `owns` list, the agent must STOP immediately, make no out-of-scope edits, and report the blocking dependency back to the orchestrator.

## Verification & Reporting

Report changed paths, verification output, and commit identifier. Commit only owned files; do not push.
