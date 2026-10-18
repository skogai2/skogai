# todo

- [ ] sandbox;workers run in an empty, wiped `/tmp/.../work`, so a real worker can't see this repo. Add a mode that points `bin/agent` at a real directory (or a `wt` worktree) while keeping the config isolated.
- [ ] setup;a setup can't set its own tools or permissions. `TOOLS` comes from outside (default: none) and `-p` mode can't stop to ask, so each setup must carry its own tool and permission list.
- [ ] spawn;runs of the same setup share `/tmp/claude-code/<setup>` and wipe it, so parallel runs collide unless each gets its own `BOX`.
- [ ] feature;`model` file in a setup sets its default model (`MODEL` still overrides).
- [ ] feature;`mcp.json` in a setup gives it MCP servers (`--mcp-config`, keeping `--strict-mcp-config`).
- [ ] feature;`agents.json` in a setup defines its subagents (`--agents`). Needed for orchestrator workers.
- [ ] feature;`plugins/` in a setup loads plugins (`--plugin-dir`). Lets us test the skog plugin.
- [ ] feature;`env` in a setup is sourced before `claude` runs (per-setup `SKOGAI_*` and similar).
- [ ] feature;`add-dirs` in a setup grants read access to repo paths (`--add-dir` per line).
- [ ] feature;`schema.json` in a setup forces structured output (`--json-schema`; check `cli-reference.md` first).
- [ ] test;`append-system-prompt.md` and `work/` have no test in `projects/claude-code/tests/`.
