# wt (worktrunk)

worktree manager. orchestrator stays put; workers live in worktrees.

## layout

worktrees live under `<repo>/.skogai/worktrees/<branch>` (`/` in branch becomes `-`), set by `worktree-path` in `~/.config/worktrunk/config.toml`.

## create without cd

```sh
wt switch --create feat-x --no-cd             # new branch + worktree off default branch
wt switch -c feat-x -b dev --no-cd            # base on another branch
wt switch -c feat-x --no-cd -x claude -- 'do the thing'   # spawn a program in it; shell stays
```

`--no-cd` only affects the shell. hooks and `-x` still run in the worktree.

## target a worktree

global `-C <path>` runs any command as if from that path:

```sh
wt -C .skogai/worktrees/feat-x step diff
wt -C .skogai/worktrees/feat-x merge -y
```

## list

```sh
wt list                   # table
wt list --format json     # for parsing
wt list --branches        # include branches without worktrees
wt list --full            # ci status + llm summaries
```

## merge

merges the *current* branch into target (default branch): commit → squash → rebase → hooks → fast-forward → remove worktree.

```sh
wt merge                  # squash into one commit, remove worktree
wt merge --no-squash      # keep branch history
wt merge --no-remove      # keep the worktree after merge
wt merge --stage tracked  # stage: all (default) | tracked | none
wt merge -y               # skip approval prompts
wt merge dev              # target another branch
```

also: `--no-commit`, `--no-rebase`, `--no-ff`, `--no-hooks`, `--format json`.

## remove

```sh
wt remove                          # current worktree; deletes branch if merged
wt remove feat-x feat-y            # by branch
wt remove --no-delete-branch feat-x
wt remove -D feat-x                # delete unmerged branch too
wt remove -f feat-x                # remove even if dirty
```

runs in background by default; `--foreground` to block.

## step

the pieces of `wt merge`, run by hand.

```sh
wt step commit                     # stage + commit, llm-generated message
wt step commit --stage none        # commit only what's in the index
wt step commit --dry-run           # preview message
wt step diff                       # everything since branching (committed, staged, unstaged, untracked)
wt step diff -- --stat             # extra args go to git diff
wt step squash | rebase | push     # rest of the merge pipeline
```

commit messages come from `[commit.generation]` (currently `aichat -m ollama:llama3.2`).
