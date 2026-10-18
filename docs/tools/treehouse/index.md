# treehouse

a pool of reusable git worktrees so several agents can work on one repo in parallel. tested at v3.1.4.

verdict: a good basic tool that does what it says. the behaviour held under every misuse we tried; the weak spot is self-documentation (see [review](review.md)).

- source: `~/.local/src/skogai-fleet/inspiration/treehouse` (README has the full reference, incl. hooks)
- config: `~/.config/treehouse/config.toml` -> `~/.dotfiles/.config/treehouse/config.toml`, see [config](#config)
- pools: `~/.local/state/.treehouse/<repo>-<hash>/<slot>/<repo>-<slot>`

## lifecycle

```
get -> work -> return
         \-> lease (protect a plain get)    enter (attach, no state change)
maintenance: status, prune, destroy
```

a slot is `available`, `in-use` (process or owner reservation), or `leased` (durable, survives no processes). a leased slot is never handed out by `get` and never removed by `prune` or `destroy --all`.

## for agents

```sh
p=$(treehouse get --lease --lease-holder "$name")   # path on stdout, banners on stderr
treehouse get --lease --json                        # lease_id, holder, base_branch, ...
treehouse return "$p" --if-lease-holder "$name"     # refuses (rc=1) if someone else holds it
```

- plain `treehouse` / `treehouse get` opens an interactive subshell and returns the slot on exit. useless without a tty
- a dirty slot is never discarded without an answer: no tty -> rc=3 and the exact `--force` command
- `return --force` cleans, resets and returns without asking
- `enter --print-path <name>` gives the path of any slot, leased or not. a lease only stops treehouse, not people

## commands

| command | does | safety |
|---|---|---|
| `get [--lease] [-b branch] [--base b] [--no-fetch]` | acquire a slot (reuses, else creates up to `max_trees`) | |
| `lease <name>` | mark an existing slot leased, touches nothing else | |
| `enter <name> [--print-path]` | attach to any slot, no state change | |
| `return [path\|name] [--all] [--force]` | kill lingering processes, release lease, reset | prompts on dirty |
| `status [--json]` | one row per slot | hides dirty, see review |
| `prune [--all] [--prune-orphans] [-v]` | remove merged, clean, idle slots | dry run, `--yes` |
| `destroy <path> [--all] [--include-*]` | remove slots, risky classes opt-in | dry run, `--yes` |
| `init` | write a repo-level `treehouse.toml` | refuses to overwrite |

names are the numbers in the first column of `status`.

## config

precedence per setting: flag > env (`TREEHOUSE_*`) > repo `treehouse.toml` > user `config.toml` > default.

current user config:

- `root = "/home/skogix/.local/state"`: pools are state, kept out of `~/.config` so only the config is versioned. treehouse appends `.treehouse`. changing `root` hides existing pools, empty them first
- `max_trees = 16`
- `unique_leaf = true`: new slots are `<repo>-<slot>` so tools keyed on directory name see distinct checkouts. existing slots keep their paths
- `base_branch`, `worktree_path` unset. `worktree_path` would supersede `unique_leaf`
- no symlinks into the pool root: the same slot reached by two paths got `pre_destroy` twice
- hooks log to `~/.cache/treehouse/hooks.log`

hooks (`post_create`, `pre_destroy`) are only read from the user config, never from a repo `treehouse.toml`, so a cloned repo can't run shell. `post_create` runs on every acquire, reused slots included; for `--lease` its stdout goes to stderr. a failing hook is logged and does not fail the command. hooks get no `TREEHOUSE_*` env, only `$PWD`.

`.worktreeinclude` in a repo selects ignored/untracked files to copy from the main checkout into each slot (e.g. `.env`). this plus `post_create` is what "pre-warmed" means.
