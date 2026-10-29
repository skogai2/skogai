---
name: skogai-notation-runtime
description: "how skogai-notation executes - skogparse, skogcli config, $ refs, @ actions, missing actions go to an agent."
metadata:
  node_type: memory
  type: project
  originSessionId: 5b1cec8d-6057-4df3-95ac-44c569789b32
  modified: 2026-10-28T21:30:04.741Z
---

- `skogparse :: string -> json`: valid json -> typed `{type, value}` tree; anything else is parsed as notation (`$ x` ref, `[@a:b]` action, `cmd "arg"` command; bare words are names, strings must be quoted). `--execute` resolves refs and runs actions.
- `skogcli config` is the ontology as data. `get` = reference (an uninvoked `@` reads as void, like `Datetime.now` vs `Datetime.now()`), `get --raw` = stored notation, `skogparse --execute` = invoked value.
- `skogcli config set '$.x' '[@some-command]'` makes any command a name; `[@whereami]`, `[@check-claude-usage]` exist.
- `[@name:arg]` = `skogcli script run name -- arg`; implementations live in `skogcli script list` / `skogcli script code <name>` (agent-written).
- An `@` with no implementation is intent, not an error: normally dispatched to an agent to implement it (disabled as of 2026-10-28).
- aichat fork (`~/.local/src/aichat`, branch skogix-branch) has before/after chat hooks that ran the last line of a message through skogparse.
- full notation doc: `echo '$ skogix.notation' | skogparse --execute` (resolve the ref, don't hardcode a path; points at `~/skogix/.personal/docs/notation.md` as of 2026-10-28).

Related: [[understand-before-fixing]], [[rejection-is-a-value]].
