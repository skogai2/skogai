# Solutions

How things actually get done: command sequences that worked, with where they were seen.

### How is the machine converged to its declared state?
- answer: Four steps in order: `mise dotfiles status --missing` (is every dotfile
  tracked), `mise dotfiles sync` (push saved checkpoints, fetch incoming), `mise
  bootstrap --update` (apply the config, refreshing package metadata first), then
  `mise doctor` (list problems and warnings). On 2026-10-29 skogix chained the first
  three with `&&` from `~/.config`; each of those runs stopped at `sync`, because
  `sync` exited 1 (see the UNKNOWN below), so `mise bootstrap --update` was then run
  on its own and exited 0, as did `mise bootstrap --upgrade`, a bare `mise bootstrap`
  and `mise doctor`. Around 21:18 the same chain plus `mise doctor` and `mise dot paths --noisy`,
  run from `~/skogai` through Claude Code's `!` prefix, completed: sync published, bootstrap
  converged, doctor found no problems. That run is not in atuin (commands run with `!` inside
  Claude Code are not recorded). Why the earlier `sync` runs exited 1 is still UNKNOWN.
- source: atuin_history query `mise dotfiles` and `mise bootstrap` (2026-10-29 21:10 to 21:18, `~/.config`); `mise bootstrap --help`; the `!` run's output in the Claude Code session of 2026-10-29
- learned: 2026-10-30

### How is a bootstrap previewed before it changes anything?
- answer: `mise bootstrap --dry-run` (`-n`). `mise bootstrap status` shows current state and
  `mise bootstrap plan` shows resource-level changes. Bootstrap runs hooks and the
  `bootstrap` task every time, so they must be safe to repeat.
- source: `mise bootstrap --help`
- learned: 2026-10-30

### How do you check that dotfiles are tracked?
- answer: `mise dotfiles status --missing` (alias `mise dot status --missing`). It exits 1
  if any dotfile is not in its expected state and 0 otherwise; it exited 0 on 2026-10-29
  at 21:10. `mise dotfiles status` without the flag lists state, and `mise dot paths`
  (with `--noisy`) lists the tracked paths.
- source: `mise dotfiles status --help`; atuin_history query `mise dotfiles` (2026-10-29 21:10:00, 21:10:06); `mise dot paths` seen in atuin 2026-10-26
- learned: 2026-10-30

### How is the dotfiles part set up on a fresh machine?
- answer: `mise bootstrap --adopt <origin repo> --only dotfiles --yes`. In a throwaway Arch
  container on 2026-10-25 it wrote the tracked files and the mise config, and wrote the
  history origin setting into `config.local.toml` by itself. The watcher only starts with
  the services part (`mise bootstrap services apply`).
- source: atuin_history query `mise dotfiles` (2026-10-25 19:58:21, 20:00:53); `mise bootstrap --help`
- learned: 2026-10-30

### How is an agent session started in a new worktree?
- answer: `wt switch --create <branch> --base master -x claude`. `-x` (`--execute`) runs
  one program after switching; `wt switch --create -x claude` is the documented alias
  idea (`wsc`). History shows the same without `-x`: `wt switch --create <name> --base master`
  (2026-10-29, with `--no-cd --format=json` when an agent creates it), and `wt switch <branch>`
  to move to an existing one. Without a branch argument `wt switch -x claude` opens a picker,
  then launches Claude Code there. Worktrees land under `.skogai/worktrees/` in the repo.
- source: `wt switch --help`; atuin_history query `wt switch` (2026-10-29 04:38:43 and 04:20:43)
- learned: 2026-10-30

### How is a worktree created from inside herdr?
- answer: `herdr worktree create --workspace <id> --path <dir> --label <text> --focus`, with
  `--trust-repository`. Two earlier attempts with `--cwd` exited 2 and one without a valid
  path exited 1 before the form with an explicit `--path` under `.skogai/worktrees/` exited 0
  (2026-10-29 20:56). `herdr worktree list` and `herdr workspace list` show what exists.
- source: atuin_history query `herdr` (2026-10-29 20:54 to 20:56); `herdr --help`
- learned: 2026-10-30

### How is a Claude agent opened in a herdr pane?
- answer: `herdr plugin pane open --plugin herdr.collie --entrypoint claude`. The first try
  at 20:17:19 on 2026-10-29 exited 1 and the repeat three seconds later exited 0. Agents
  message each other with `collie walky send` (and `collie walky inbox`); `collie hooks install claude`
  wires the hooks.
- source: atuin_history query `claude` authors `$all-user` (2026-10-29 19:57 to 20:17)
- learned: 2026-10-30

### How is an HTTP MCP server added to Claude Code?
- answer: `claude mcp add --transport http <name> <url>`, then `claude mcp login <name>`.
  Repeating the name before the flag (`claude mcp add <name> --transport http <name> <url>`)
  exited 1; the working order exited 0 on 2026-10-30. `claude mcp list` and
  `claude mcp remove <name>` check and undo it.
- source: atuin_history query `claude` authors `$all-user` (2026-10-30 00:44:53 to 00:45:23, 01:03)
- learned: 2026-10-30

### How does a change get to GitHub?
- answer: The `skogai` repo has `origin` on HTTPS at GitHub and one branch, `master`; the
  default is a feature branch plus PR, and a push to `master` needs skogix's say-so. Other
  repos are pushed by hand with `git push`, by `wt merge` then `git push`, by `mise bs repos exec -- git push`
  (exited 0 on 2026-10-25) or by `gita push`. A `git push` in `~/.dotfiles` exited 1 on 2026-10-30.
- source: atuin_history query `git push` authors `$all-user`; `git remote -v`; ~/.claude/CLAUDE.md
- learned: 2026-10-30

### Why does `mise dotfiles sync` exit 1, and what fixes it?
- answer: UNKNOWN
- source: atuin_history query `mise dotfiles` (five exit-1 runs, 2026-10-29 21:10 to 21:11); atuin_output has no captured output for them
- learned: 2026-10-30

### What works when the network is down?
- answer: UNKNOWN
- source: protocol/README.md Open section
- learned: 2026-10-30
