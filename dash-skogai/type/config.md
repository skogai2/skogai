---
type: type
title: config
description: key/value settings, folded across the system, global and local layers.
fields: [type, title]
owns: [config]
---

# config

a config is a [git config](https://git-scm.com/docs/git-config#_configuration_file) file of `section.key = value` pairs, read and written with `skogai-config`, registered as `argc config`.

## layers

folded in order, later wins:

1. **system**: `$SKOGAI_SYSTEM_DIR/config`, default `/etc/skogai/config`. the defaults; `config` in dash is installed here.
2. **global**: `$SKOGAI_CONFIG_DIR/config`, default `~/.config/skogai/config`.
3. **local**: `$SKOGAI_LOCAL_DIR/config`, default `.skogai/config`. a relative dir is from the git root, or pwd outside a repo.
4. **file**: with `--file x.md` (repeatable), the frontmatter of `x.md`, then of `x.local.md`. nested keys flatten to `a.b.c`, `_` reads as `-`, and `--scope s` mounts them under `s.`. needs `yq`.
5. **env**: key `a.b-c` reads env `SKOGAI_A_BC`, which overrides every layer. `.` is a relation and becomes `_`; `-` is part of a name and is dropped.

## commands

- `skogai-config get <key> [--show-origin] [--file x.md]... [--scope s]`: exit `1` if unset, `2` if a layer can't be read. a list prints one item per line.
- `skogai-config set <key> <value> [--global | --file x.md [--scope s]]`: writes local unless `--global`. `--file` writes `x.local.md`, never `x.md`; the value is read as yaml.
- `skogai-config unset <key> [--global | --file x.md [--scope s]]`
- `skogai-config list [--show-origin] [--file x.md]... [--scope s]`: a list prints one line per item.
- `skogai-config env [--file x.md]... [--scope s]`: the resolved config as `export` lines, for `mise` `_.source` or `eval`. a list's items are newline-separated.
- `skogai-config files [--file x.md]...`: the path of each layer, and whether it exists.

## merge

every key is replaced by the later layer. a key set twice in one layer resolves to its last value.

in a file layer, a frontmatter list is one value, replaced whole. `null` (`~`) removes the key, so it falls through to the default.

## keys

- `stage.on-stop`, `commit.on-stop`, `merge.on-stop`: git automation on stop.
- `stage.on-user-prompt-submit`, `commit.on-user-prompt-submit`, `merge.on-user-prompt-submit`: git automation on prompt submit.
