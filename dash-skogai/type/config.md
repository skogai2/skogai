---
type: type
title: config
description: key/value settings, folded across the base, global and local layers.
fields: [type, title]
owns: [config]
---

# config

a config is a [git config](https://git-scm.com/docs/git-config#_configuration_file) file of `section.key = value` pairs, read and written with `skogai config`.

## layers

folded in order, later wins:

1. **base**: `config` in dash. the defaults.
2. **global**: `~/.skogai/config`, or `$SKOGAI_GLOBAL_CONFIG`.
3. **local**: `<repo>/.skogai/config`, or `$SKOGAI_LOCAL_CONFIG`.
4. **env**: key `a.b-c` reads env `SKOGAI_A_B_C`, which overrides every layer.

## commands

- `skogai config get <key> [--show-origin]`: exit `1` if unset.
- `skogai config set <key> <value> [--global]`: writes local unless `--global`.
- `skogai config unset <key> [--global]`
- `skogai config list [--show-origin]`
- `skogai config env`: the resolved config as `export` lines, for `mise` `_.source` or `eval`.
- `skogai config files`: the path of each layer, and whether it exists.

## merge

every key is replaced by the later layer. a key set twice in one layer resolves to its last value.

## keys

- `stage.on-stop`, `commit.on-stop`, `merge.on-stop`: git automation on stop.
- `stage.on-user-prompt-submit`, `commit.on-user-prompt-submit`, `merge.on-user-prompt-submit`: git automation on prompt submit.
