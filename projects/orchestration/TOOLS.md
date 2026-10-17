# tools

the main session is the orchestrator. it discusses, decides, delegates and reviews. anything that would fill its context (reading many files, research, implementing, long command output) goes to a worker in a herdr pane. only the worker's short reply comes back.

this is skogix asking, once, for every session: delegating to herdr workers is allowed without asking again.

## delegate: one task, one worktree, one worker

tested 2026-10-17, herdr 0.9.5.

```bash
b=<branch>; p=/home/skogix/skogai/.skogai/worktrees/$b
wt switch -c $b --no-cd -y
pane=$(herdr pane split --current --direction right --cwd $p --no-focus | jq -r .result.pane.pane_id)
sleep 2; herdr pane run $pane "exec bash --norc --noprofile"
herdr pane wait-output $pane --match 'bash-' --timeout 10000
herdr agent start $b --kind claude --pane $pane --timeout 60000 -- --permission-mode auto
herdr agent prompt $b "<task>" --wait --timeout 600000
herdr agent read $b --source recent-unwrapped --lines 40
```

- panes start the login shell (fish), and atuin in its foreground group makes `agent start` fail with `agent_pane_busy`. `exec bash --norc --noprofile` gives it a plain shell.
- `--permission-mode auto` so the worker doesn't stop for every shell command.
- the prompt says what to do, which files it may touch, to commit with an explicit `git commit -m` and to reply with one line (hash + what changed). the worker's context pays for the work, not ours.
- `--wait` returns on idle, done or blocked. on `blocked`, `agent read` and ask skogix before answering it.
- a timeout doesn't mean the prompt was lost. read before re-sending.

## review and land

```bash
git -C $p log --oneline master..HEAD
git -C $p diff --stat master...HEAD
herdr pane close $pane                            # only panes we created
wt -C $p merge -y --no-squash --stage none        # keeps the worker's commits
```

- `--stage none`: the skogai-core Stop hook writes the worker's turns into `.skogai/journal.md` in its worktree. the default `--stage all` would commit that into master.
- that same journal change blocks the worktree removal after merge. TODO.md decides what happens to it.

`wt merge` and `wt step commit` generate messages with `[commit.generation]` in `~/.config/worktrunk/config.toml` (claude haiku, `claude -p`). workers still commit with their own `-m`, since they know what they did.

details: [TOOLS-wt.md](TOOLS-wt.md).

## herdr plugin actions (for skogix)

`herdr plugin action invoke <open|open-current|open-with-remotes|merge|merge-no-squash|remove> --plugin worktrunk` opens an interactive picker pane. it logs "succeeded" when the pane opens, not when the work is done. the orchestrator uses `wt` directly.

## reference

- `herdr --skill`: full herdr agent guide (ids, states, read sources, safety rules)
- `herdr <group>` with no subcommand lists commands. never run bare `herdr`.
