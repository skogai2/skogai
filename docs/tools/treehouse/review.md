# treehouse review

user review of v3.1.4, from `--help` first, then hands-on. 2026-10-18.

## works as intended

- stdout/stderr split: `get --lease` prints only the path
- lease guards: wrong `--if-lease-holder` / `--if-lease-id` -> rc=1 with a precise error
- dirty slot without a tty -> rc=3, explanation and the exact `--force` command
- dry run by default for `prune` and `destroy`, risky classes opt-in per flag, skip reasons per slot
- `get` from inside a slot resolves to the parent repo's pool
- `init` refuses to overwrite (rc=1)
- invalid config fails fast with file and line (duplicate key)
- an unresolvable base branch is an error, never a silent fallback

## findings

behaviour:

- `status` hides dirty work: a slot shows `leased` while `destroy` shows `[leased,dirty]`
- `status` and `get` fail with `mkdir <root>: permission denied` on a bad `root`, naming neither the setting nor the file. a read-only command should not mkdir
- `destroy <leased-path>` skip exits 0, help says single-target skips exit non-zero (maybe dry-run only, undocumented)
- `prune -v` printed no skip reasons for skipped slots
- `return` discard prompt defaults to yes (`[Y/n]`)
- an `in-use` slot with no processes doesn't say what holds it; a lease without `--lease-holder` shows no holder
- hooks get no `TREEHOUSE_*` env: no slot, repo, lease or base branch
- plain `get` opens a subshell even without a tty, does the setup, then returns immediately

interface:

- `--all` means three scopes: `return` = this pool incl. leased, `destroy` = named pool excl. leased, `prune` = every pool (alias `--global`)
- three confirmation models: `--yes` (prune, destroy), interactive + `--force` (return)
- targets differ: `enter`/`lease` take a name, `return` path or name, `destroy` path only
- `lease` the command vs `get --lease` the flag
- `get --lease` help says leased slots survive `prune`; `lease` help says `prune` or `destroy`

docs:

- top-level `--help` never mentions `--lease`, the agent path
- bare `treehouse` = `get`, undocumented
- ~15 state words (slot, held, parked, damaged, recovered, stale, unlanded, orphan, ...) with no glossary; `status --help` is one line
- `max_trees`, the user config path and hooks are only in `init` output / README
- changelog text in help ("migrating from the removed --force flag")
- `get --help` is dominated by niche options (apfs, path templates)

## not yet tested

- hitting `max_trees`
- `pre_destroy` via `prune --yes` / `destroy --yes`
- a failing hook
- `.worktreeinclude`
- `-b/--branch`, `--base`
- `return --all`
- jj backend
