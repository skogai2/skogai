---
type: tool
title: mise
---

# mise

dev environment, tool pins, tasks, and key/value config. dash does not wrap it: config is read and written with `mise config` directly.

## config layers

each layer is one mise toml file, folded in order, later wins: system, global, local. the dirs are set by `mise.config.toml` at the dash root (`SKOGAI_CONFIG_{SYSTEM,GLOBAL,LOCAL}_DIR`), each holding a `mise.config.toml`. keys live under `_.` (mise's free-form namespace), e.g. `_.skogai.config.system.dir`.

- read one key from one layer: `mise config get --file <layer> <key>`. a missing key exits `1`.
- write one key: `mise config set --file <layer> <key> <value>`.
- unset is `set <key> false`.
- resolved env, with the file each value came from: `mise env --env config --json-extended`.
- outside the sandbox, a layer is a flag and a module is `--env=<module>`:

  ```bash
  mise config --env exampleenv get --system
  ```

## history

`bin/skogai-config` (an argc wrapper over `git config -f` layers, with `--file x.md` frontmatter layers and `--show-origin`) was removed 2026-11-07: it could not read the toml layers, and mise covers get, set and origin. it is recoverable from `80e3e9b`.
