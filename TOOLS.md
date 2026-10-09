# Tools

The tools available on this machine, what each is for, and how skogai uses it.

## Orchestration (`bin/wo`)

The main session orchestrates, and workers do the implementation. See
[decision 0002](.skogai/knowledge/decisions/0002-orchestration-model.md).

```
bin/wo new <slug>      # .skogai/workorders/NNNN-<slug>.md from TEMPLATE.md
bin/wo dispatch <id>   # commit workorder → wt worktree → herdr tab in "workers" → start + prompt agent wo-NNNN
bin/wo status          # workorder status, worker agent state, worktree path
bin/wo land <id>       # status: done → origin check → wt merge (pre-merge hooks) → close tab → remove worktree → push origin
```

To wait for or inspect a worker, use `herdr agent wait wo-NNNN` and
`herdr agent read wo-NNNN --source recent-unwrapped --lines 120`.
`WO_KIND=codex` switches the worker kind, and `WO_ARGS` overrides the
agent's native arguments. Workers run in auto permission mode.

Workorder frontmatter options:
- `repo: <gita name>` makes another repo the target. The worker runs in a
  `wo/<id>` worktree of that repo and writes its report into the skogai
  worktree. `wo land` merges both.
- `add_dir: <path>` gives the worker read and write access to a directory outside its worktree.
- `model: <id>` sets the worker's model, for example `claude-opus-5-5`.

## herdr

**herdr** (`/usr/bin/herdr`, 0.9.3) is a terminal workspace manager for
coding agents. It manages panes, tabs and workspaces, and tracks each
agent's lifecycle state (`idle`/`working`/`blocked`/`done`). The agent
skill is `.claude/skills/herdr` (also `herdr --skill`). skogai uses it only
to host and drive workers. It does not create worktrees; `wt` does that.

## wt (worktrunk)

**wt** (`mise`, v0.80.0) manages git worktrees, one per branch, and
provides the merge pipeline. The user config (`~/.config/worktrunk/config.toml`)
puts worktrees in `.skogai/worktrees/<branch>` and generates commit messages
with haiku. The project config `.config/wt.toml` runs
`openknowledge validate` as a `pre-merge` hook.

## gita

**gita** (`~/.local/bin/gita`, v0.16.8.2) shows status and runs commands
across many git repos at once. It tracks every repo skogai manages, and its
names are what `repo:` uses. The groups are `home`, `src`, `forks` and
`parked`. New clones go in `~/.local/src/`. See
[decision 0003](.skogai/knowledge/decisions/0003-repo-roles.md).

- `gita ll [group]` shows a status dashboard.
- `gita super <repo/group> <git-command>` and `gita shell <repo/group> <cmd>` run a command across repos.
