# mise mcp as a Claude Code MCP server

Status: verified 2026-10-14, mise 2026.10.9 (`/usr/bin/mise`), claude `-p` end-to-end.

## What's required

- **No experimental gate anymore.** `mcp` graduated from experimental in
  jdx/mise#10371 (2026-06-13, commit `1f5123b04`; it used to call
  `settings.ensure_experimental("mcp")`). Verified: `MISE_EXPERIMENTAL=0 mise mcp`
  still works. (`experimental = true` is set in `~/.config/mise/config.toml` anyway.)
- **Trusted config.** Resource reads follow trust rules and the server can't prompt.
  `~/skogai` and this worktree are trusted. `run_task`/`install_tool` additionally
  refuse any untrusted non-global config, and the child mise gets
  `MISE_REQUIRE_EXPLICIT_TRUST=1`.
- **Correct project dir.** Either `--cd <abs path>` or start it with the project as cwd.
  Claude Code starts stdio servers in the session cwd, so `args: ["mcp"]` with no
  `--cd` is enough. Started from `wip/mise/`, it still found the repo root because
  mise walks up the tree.
- No relevant settings keys besides `experimental` and `task.timeout` (the `run_task` limit).
  Optional env `MISE_SAFE=1` gives read-only use of untrusted projects (no env values, no `run_task`).

## Verified JSON-RPC (stdio, newline-delimited, run from repo root)

```
-> {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"probe","version":"0"}}}
<- result: protocolVersion 2025-06-18, serverInfo {name: mise, version: 2026.10.9}, capabilities [resources, tools]
-> {"jsonrpc":"2.0","method":"notifications/initialized"}
-> {"jsonrpc":"2.0","id":2,"method":"resources/list"}
<- [mise://tools, mise://tasks, mise://env, mise://config]
-> {"jsonrpc":"2.0","id":3,"method":"tools/list"}
<- [install_tool, list_commands, run_task]
-> {"jsonrpc":"2.0","id":4,"method":"resources/read","params":{"uri":"mise://tools"}}
<- {"ast-grep":[{"version":"0.50.0","requested_version":"latest","installed":true,"active":true,
     "source":{"type":"mise.toml","path":"/home/skogix/.config/mise/config.toml"}}], ...}
-> resources/read mise://config
<- config_files [<worktree>/mise.toml, ~/skogai/mise.toml, ~/.config/mise/config.toml,
   /etc/mise/conf.d/omarchy.toml], project_root <worktree>
-> resources/read mise://tasks   <- []   (no tasks defined yet)
-> resources/read mise://env     <- 0 keys here (contains real secret values when set)
```

stderr only gets `Starting mise MCP server...`, and stdout carries only clean JSON-RPC.

## Config snippet

`.mcp.json` (project scope, portable across worktrees, not yet added to the repo):

```json
{
  "mcpServers": {
    "mise": {
      "type": "stdio",
      "command": "mise",
      "args": ["mcp"]
    }
  }
}
```

Use `/usr/bin/mise` if a client doesn't have `PATH`. Add `"env": {"MISE_SAFE": "1"}` for
read-only use. No `MISE_EXPERIMENTAL` is needed.

End-to-end check (passed, no prompts):

```sh
echo "list the mise mcp resources, read mise://config" | \
  claude -p --mcp-config mise-mcp.json --strict-mcp-config \
    --allowedTools "ListMcpResourcesTool,ReadMcpResourceTool"
```

Gotcha: `--allowedTools` takes multiple values, so a prompt passed as a positional
argument after it is treated as one of its values ("Input must be provided"). Pipe the
prompt on stdin instead.

## Why the previous attempt likely failed

`~/.claude.json` has a **local-scope** entry under `projects["/home/skogix"]`:
`mise --cd /home/skogix/skogai mcp`. The command itself works (verified). But a
local-scope server only loads when claude is started in exactly `/home/skogix`. In
`~/skogai`, or in any worktree, it doesn't exist (`claude mcp list` there shows only
atuin-mcp). That is the most likely cause.

| Suspect | Reproduces? |
|---|---|
| Server registered under the wrong project scope (`/home/skogix`) | **yes**: not listed from the repo |
| Experimental gate | no, not since ~2026.6 (it would have before) |
| Untrusted config | yes in general (`-32603 Failed to load config: error parsing config file: <path>` for a dir with `[env]`), but skogai paths are trusted |
| Wrong cwd / no `--cd` | partly: from `~` without `--cd` you get `project_root: null` and global config only. That's wrong data, not a failure |
| Shim vs binary | no: only `/usr/bin/mise` exists, no mise shim |
| stdout noise from activation | no: Claude Code execs the command directly, with no shell rc. It only matters if wrapped in `fish -c` or `bash -lc` |

## Use in skogai

- Orchestrator/workers read `mise://tasks` to learn what can be run (once the repo
  defines tasks) instead of grepping `mise.toml`/`.mise/tasks`.
- `mise://tools` + `mise://config` give a worker the tool versions and active config
  without shell access. This fits harness setups with `TOOLS` = none, if a setup
  can carry an `mcp.json` (TODO.md `feature;mcp.json`).
- `run_task` is a narrow, permission-gated "execute" for workers: allow only
  `mcp__mise__run_task` instead of `Bash`. Combine with `--allowedTools` per setup.
- `list_commands` labels each mise command `read`/`write`/`destructive`, which helps
  when deciding what to auto-approve.
- Caution: `mise://env` returns secrets (fnox/age are in `mise.toml`). Consider
  denying `ReadMcpResourceTool` for `mise://env`, or use `MISE_SAFE=1` for workers.
