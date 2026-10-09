# Tools

The tools available on this machine, what each is for, and how skogai uses it. 

## gita

**gita** (`/home/skogix/.local/bin/gita`, v0.16.8.2): status/command runner
across many git repos at once. Not worktree- or submodule-aware itself —
just a flat list of repo paths it knows about.

Already configured on this machine: `~/.config/gita/repos.csv` tracks 13
repos, `~/.config/gita/groups.csv` defines three groups — `projects` (the
9 `skogai/projects/*` submodules), `global` (config-skogai,
dot-skogai-home, skogai itself), and `skogai-root`.

Daily commands:
- `gita ll [group]` — status dashboard across tracked repos (or one group).
- `gita super <repo/group> <git-command>` — run a git command across repos.
- `gita shell <repo/group> <shell-command>` — run a non-git shell command across repos.
- `gita add`/`gita rm`, `gita group {add,rm,ls}` — manage what's tracked.

## Herdr and worktrees

- **herdr** (`/usr/bin/herdr`): terminal workspace manager for coding
  agents — panes, tabs, workspaces and agent lifecycle state
  (`idle`/`working`/`blocked`/`done`). Setup and conventions are in
  `projects/config/herdr.md`; the agent skill is `herdr --skill`.
  Daily agent-lifecycle commands: `herdr agent start <name> --kind <kind>
  --pane <id>`, `herdr agent prompt <target> "<text>" [--wait]`,
  `herdr agent wait <target> [--until STATUS]`, `herdr agent get
  <target>`, `herdr agent read <target> --source recent-unwrapped --lines
  N`, `herdr agent list`. herdr also has its own `herdr worktree create
  [--cwd PATH] [--branch NAME] [--base REF] [--no-focus]`, which creates a
  git worktree *and* opens it as a herdr pane in one call — this is what
  the old (deleted) `orchestration/dispatch.sh` used exclusively, never `wt`.
- **wt** (worktrunk, `mise`, v0.80.0): git worktree management, one
  worktree per task/branch, with a merge pipeline. `wt switch --create
  <branch> [--base <ref>]` creates a branch+worktree; `wt switch <branch>`
  switches to one; `wt list` shows all worktrees with status; `wt merge
  [target]` squashes, rebases onto target, runs `pre-merge` hooks, then
  fast-forward-merges and removes the worktree (the primary worktree is
  kept); `wt remove [branch]` deletes a worktree/branch directly. Config
  and hooks: project `.config/wt.toml` (none exists yet in this repo) or
  user `~/.config/worktrunk/config.toml` (currently only sets
  `worktree-path` and an LLM commit-message generator). Full guidance in
  worktrunk's own docs (`wt --help`).

**Open question — not resolved here:** both `wt` and `herdr worktree
create` make worktrees, differently. `wt` has the squash/rebase/hook
merge pipeline; `herdr worktree create` gives you a ready herdr pane in
the same call but no merge pipeline of its own. Which one owns worktree
creation for daily orchestration (or whether they're used together
somehow) is undecided.

