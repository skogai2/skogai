# Features

What a setup can do and how to use it. For how each feature is wired, see
CLAUDE.md.

## Setup files

A setup is a folder in `setups/<name>/`. Put a file in it to turn a feature
on.

| File | What it does |
|---|---|
| `settings.json` | The agent's settings. Copy it from baseline to start with everything stripped. |
| `system-prompt.md` | Replaces Claude Code's system prompt with your own. |
| `append-system-prompt.md` | Adds to the system prompt and keeps Claude Code's default. If `system-prompt.md` also exists, it's added to that instead. |
| `work/` | Files the agent finds in its working directory, such as `CLAUDE.md`, `.claude/` or fixtures. |

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
| `orchestration` | appended: orchestrator role | the orchestrator, which hands work to other setups |

None of them uses `work/`, and all three use the baseline `settings.json`.

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
