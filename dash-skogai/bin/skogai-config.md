# skogai-config

key/value settings, folded across the system, global and local layers. run as `argc config <cmd>` from anywhere under the dash root: `Argcfile.sh` defines `config` and hands it to `bin/skogai-config`.

## layers

each layer is one mise toml file, folded in order, later wins:

1. **system**: `$SKOGAI_CONFIG_SYSTEM_DIR/$SKOGAI_CONFIG_SYSTEM_FILE`
2. **global**: `$SKOGAI_CONFIG_GLOBAL_DIR/$SKOGAI_CONFIG_GLOBAL_FILE`
3. **local**: `$SKOGAI_CONFIG_LOCAL_DIR/$SKOGAI_CONFIG_LOCAL_FILE`

the defaults are the `@env` lines in `bin/skogai-config` (`system/mise.config.toml` and so on), and `mise.config.toml` at the dash root sets the same `_DIR` vars for `mise --env config`. a relative dir is from the dash root: argc cds to the folder holding `Argcfile.sh`, and `ARGC_PWD` is the caller's dir.

keys live under `_.` (mise's free-form namespace), e.g. `_.skogai.config.system.dir`.

## mise does the work

don't rebuild what mise already does:

- read one key from one layer: `mise config get --file <layer> <key>`. a missing key exits `1`.
- write one key: `mise config set --file <layer> <key> <value>`.
- resolved env with the file each value came from: `mise env --env config --json-extended`.
- no unset in mise.

## status

- works: `argc config files`, `argc config --help`, completion.
- broken: `get`, `list`, `env`, `set`, `unset` still read and write git-config format (`git config -f`), so they fail on the toml layers with `fatal: bad config line 1`.
- next: `get` as a fold over layers, local first, through `mise config get --file`. then `set` through `mise config set --file`. then decide whether `--file x.md` frontmatter layers, `list` and `env` are still needed next to `mise env`.

## commands (pre-mise, still in the script)

- `get <key> [--show-origin] [--file x.md]... [--scope s]`
- `set <key> <value> [--global | --file x.md [--scope s]]`
- `unset <key> [--global | --file x.md [--scope s]]`
- `list [--show-origin] [--file x.md]... [--scope s]`
- `env [--file x.md]... [--scope s]`
- `files [--file x.md]...`

## history

`bin/skogai` (2026-10-16), renamed `bin/skogai-config` (e4b1414), deleted by accident in f8ea24f when a `git mv` of its doc failed, restored from `f8ea24f^`. the old git-config version and its `type/config.md` are in that commit.
