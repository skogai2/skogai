# Features

What a setup can do and how to use it. For how each feature is implemented, see
CLAUDE.md.

## Setup files

A setup is a folder in `setups/<name>/` that sits on top of `baseline`: it
inherits everything from baseline and holds only what it changes. Put a file in
it to turn a feature on.

| File | What it does |
|---|---|
| `settings.json` | Settings merged over baseline's. Leave it out to keep baseline's (everything stripped). |
| `system-prompt.md` | Replaces Claude Code's system prompt with your own. Without any prompt file, the setup uses baseline's. |
| `append-system-prompt.md` | Adds to the system prompt and keeps Claude Code's default. If `system-prompt.md` also exists, it's added to that instead. |
| `work/` | Files the agent finds in its working directory, such as `CLAUDE.md`, `.claude/` or fixtures. |
| `config/` | Files placed in the agent's config dir, such as plugin state or rules. |
| `plugin-dirs` | Plugins to load, one folder per line. |

Create a new setup with `mise run new-setup <name>`.

## Run options

Set these when you call `bin/agent` (or `mise run ask`):

| Option | Default | What it does |
|---|---|---|
| `SETUP` | `baseline` | Which setup to run |
| `MODEL` | `haiku` | Which model answers |
| `TOOLS` | none | Which tools the agent gets, e.g. `TOOLS=Bash,Read` |
| `OUTPUT` | `text` | `text`, `json` or `stream-json` |
| `KEEP=1` | off | Keep the sandbox from the last run instead of starting clean |
| `BOX` | `/tmp/claude-code/<setup>` | Where the sandbox lives |
| `LOADOUT` | none | Which loadout profile is active, in setups that use loadout |

The prompt goes in on stdin and the reply comes out on stdout:

    echo "say pong" | SETUP=commit-msg bin/agent

## Every run gets

- A clean, isolated sandbox: none of your own Claude Code config, memory,
  plugins, skills or MCP servers apply. Only your login carries over.
- A transcript in the sandbox you can read afterwards (`bin/transcript`).

## Setups

| Setup | Prompt | Use it for |
|---|---|---|
| `baseline` | replaced: a minimal test agent | the empty agent everything is compared against |
| `commit-msg` | replaced: commit-message writer | a diff in, a commit message out |
| `base` | appended: base orchestrator | the orchestrator to build on: delegates to `bin/agent` and herdr panes, reports the commands it ran |
| `orchestration` | appended: orchestrator role | the earlier role-only orchestrator |
| `loadout` | baseline's | the loadout plugin; profiles `default` and `vanilla` |


## Commands

| Command | What it does |
|---|---|
| `mise run ask "<prompt>"` | One prompt to a setup |
| `mise run inspect [setup]` | What the agent has (tools, skills, agents, plugins, MCP) and how big its context is |
| `mise run transcript [setup]` | Path to the latest transcript |
| `mise run eval <setup>` | Run every case in `cases/<setup>/` and save the results |
| `mise run review <setup>` | Read every response from the latest eval |
| `mise run compare <setup>` | See how the two latest evals differ |
| `mise run test` | Run the tests |
| `mise run orchestrator` | Talk to the orchestrator: interactive `claude` at the repo root with `setups/base`'s prompt appended (`SETUP=` for another) |
