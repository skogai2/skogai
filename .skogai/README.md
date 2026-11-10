# .skogai layout

Repository-local definitions and working data live under `.skogai/`. Use
repository-relative paths in future consumers, resolved from the repository
root rather than a machine-specific checkout location.

| Path | Purpose and retention |
| --- | --- |
| `config/` | Tracked configuration definitions; the starter placeholder supplies no defaults. Generated `script_metadata.json` remains ignored by the root rules. |
| `memory/` | Tracked decisions and operational notes; start with `memory/MEMORY.md`. |
| `rules/` | Tracked agent and repository rules. |
| `scripts/` | Tracked supporting scripts. |
| `skills/` | Skill definitions when needed; this scaffold does not create or activate skills. |
| `tasks/` | Tracked task definitions. |
| `templates/` | Tracked reusable templates. |
| `workflow/` | Tracked workflow definitions. |
| `state/` | Durable local output, ignored by Git. Never treat this as disposable or include it in temporary-file cleanup. |
| `logs/` | Disposable local logs, already ignored by the root `.gitignore`. |
| `tmp/` | Disposable local scratch output, ignored by Git. |
| `worktrees/` | Local checkout workspace, ignored by Git; manage its contents through the owning worktree tool and preserve unfinished work. |

Tracked definitions describe how work runs; ignored local output is not shared
through Git. Keep data needed long-term in configuration or state, never in
logs or temporary output. Ignoring state does not make it disposable or provide
a backup.

The `config/.gitkeep` and the `.gitignore` files in `state/`, `tmp/`, and
`worktrees/` preserve starter directories in fresh checkouts. Consumers create
disposable directories on demand. Add module subdirectories only when an actual
consumer needs them; this layout introduces no runtime behavior or defaults.

Work orders stay in `orchestration/work-orders/`; they are not moved here.
