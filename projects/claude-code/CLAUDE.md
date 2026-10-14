# claude-code test environment

A lab for learning exactly what Claude Code does. Start from an agent with everything stripped, add one feature at a time, and prove each one with a test or an eval run. Treat observed behavior as the source of truth over assumptions, including your own.

## Layout

- `bin/agent`: one-shot `claude -p` in an isolated sandbox. The prompt comes on stdin. Everything else builds on it.
- `bin/inspect`, `bin/transcript`: show what a session exposes, or locate its transcript.
- `bin/eval`, `bin/review`, `bin/compare`: batch-run cases, read all responses, diff two runs.
- `setups/<name>/`: one configuration under test. It holds `settings.json` (becomes the sandbox's user settings), `system-prompt.md`, and optionally `work/` (copied into the working dir).
- `cases/<setup>/`: input files for `bin/eval`, one prompt per file.
- `tests/NN-*.sh`: pass/fail checks, run with `tests/run`.
- `runs/`: eval output (gitignored). Each run folder contains `<case>.out`, `.json` and `.jsonl`, plus `meta.txt` and the system prompt used.

## Workflows

- **New feature:** copy `setups/baseline` to `setups/<feature>`, change only what the feature needs, and check the change with `SETUP=<feature> bin/inspect`. Add a test that asserts it.
- **New prompt task:** add a setup plus `cases/<setup>/`. Run `bin/eval <setup>`, then `bin/review <setup> | less`. After changing the prompt, run eval again and `bin/compare <setup>`.
- **Before committing:** run `tests/run`. It must pass.

## How isolation works

- `bin/agent` exports `CLAUDE_CONFIG_DIR=/tmp/claude-code/<setup>/config` and runs in `.../work`. Nothing from `~/.claude` applies except the credentials.
- The sandbox is wiped at the start of each run, so whatever is in it afterwards (transcripts, `.claude.json`, state) came from that run. Read those files rather than guessing.
- The `init` event (`OUTPUT=stream-json`, first line) lists tools, skills, agents, plugins and MCP servers. Assert on it, never on the model describing itself.

## Gotchas found so far

- `CLAUDE_CONFIG_DIR` only works from the process environment. Project settings `env` explicitly ignores it.
- An empty config dir has no login. `bin/agent` symlinks `~/.claude/.credentials.json`, so a token refresh inside a sandbox also updates the real file.
- An empty config dir syncs claude.ai skills and plugins unless `syncClaudeAiSkills` and `syncClaudeAiPlugins` are both `false`.
- Built-in plugins (`cc-plugin-*@builtin`) must be disabled in `enabledPlugins`. Built-in skills need `--disable-slash-commands`.
- Built-in agent names (Explore, Plan, ...) are always listed in `init`. They're inert without the `Agent` tool.
- Baseline context is about 570 tokens with haiku. A big jump means something leaked in.

Add new findings here as they come up, briefly and with how they were verified.

## Conventions

- Bash with `set -euo pipefail`. Each script starts with a comment header showing usage, and scripts resolve the project root themselves.
- Default to `MODEL=haiku` with thinking off. Switch models only when that's the thing being tested.
- Keep the baseline minimal. Features go in their own setup, never into baseline.

## Reference

Claude Code docs are in `../../tmp/claude-docs/`. Grep them before guessing about flags or settings. Most relevant: `cli-reference.md`, `settings.md`, `env-vars.md`, `claude-directory.md`, `hooks.md`, `changelog.md`. Check the installed version with `claude --version`.
