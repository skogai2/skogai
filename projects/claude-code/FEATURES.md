# Features

What a setup can do today, how it's wired, and which setups use it. A
feature is "a file in `setups/<name>/`, or an env var, that `bin/agent`
turns into Claude Code behavior". Add a row when a feature lands; move it
up from **Planned** when it's implemented and has a test.

## Implemented

### Per setup (files in `setups/<name>/`)

| Feature | File | How `bin/agent` applies it | Verified by |
|---|---|---|---|
| User settings | `settings.json` | copied to `config/settings.json` | `tests/00-surface.sh` (stripping) |
| Replace system prompt | `system-prompt.md` | `--system-prompt-file` | `tests/01-roundtrip.sh` |
| Append to system prompt | `append-system-prompt.md` | `--append-system-prompt-file` (after `system-prompt.md` if both exist) | none yet |
| Working-dir fixtures | `work/` | copied into `work/` (CLAUDE.md, `.claude/`, fixtures) | none yet; no setup uses it |

### Per run (env vars on `bin/agent`)

| Feature | Env var | Default | How it's applied |
|---|---|---|---|
| Setup choice | `SETUP` | `baseline` | picks `setups/$SETUP/` |
| Model | `MODEL` | `haiku` | `--model` |
| Tools | `TOOLS` | none | `--tools` |
| Output format | `OUTPUT` | `text` | `--output-format` (`--verbose` added for `stream-json`) |
| Thinking | `MAX_THINKING_TOKENS` | `0` | exported |
| Reuse sandbox | `KEEP=1` | wipe | skips the wipe and re-copy |
| Sandbox path | `BOX`, `SANDBOX_ROOT` | `/tmp/claude-code/$SETUP` | where `config/` and `work/` live |
| Extra flags | trailing args | none | passed straight to `claude` |

### Always on (hardcoded in `bin/agent`)

| Feature | How |
|---|---|
| Config isolation | `CLAUDE_CONFIG_DIR=$box/config`, wiped each run |
| Login | `config/.credentials.json` symlinks to `~/.claude` |
| One-shot | `-p`, prompt on stdin |
| No MCP | `--strict-mcp-config` with no config |
| No slash commands / built-in skills | `--disable-slash-commands` |

### Stripping (what `settings.json` turns off)

All three setups carry the same block, copied from baseline:
`syncClaudeAiSkills`, `syncClaudeAiPlugins`, and `autoMemoryEnabled` set to
`false`; the env vars `ENABLE_CLAUDEAI_MCP_SERVERS=false`,
`CLAUDE_CODE_DISABLE_POLICY_SKILLS=1` and
`CLAUDE_CODE_DISABLE_OFFICIAL_MARKETPLACE_AUTOINSTALL=1`; and the five
`cc-plugin-*@builtin` plugins disabled.

## Setups × features

| Setup | settings.json | system-prompt.md | append-system-prompt.md | work/ | cases | Purpose |
|---|---|---|---|---|---|---|
| `baseline` | stripping | "test agent, answer briefly" | – | – | – (uses `tests/`) | the empty agent everything is measured against |
| `commit-msg` | stripping | commit-message writer | – | – | 8 diffs | worker: diff in, commit message out |
| `orchestration` | stripping | – (keeps the default prompt) | orchestrator role | – | 1 (`research-summary`) | the orchestrator; delegates to other setups via `bin/agent` |

None of the setups declares its own tools; every run gets `TOOLS` from the
caller (none by default). That's why `orchestration` currently runs without
`Agent` or `Bash`.

## Tooling around setups

| Command | Does |
|---|---|
| `bin/inspect` | `init` surface (tools, skills, agents, plugins, MCP) and context size of a trivial turn |
| `bin/transcript` | path of the latest transcript in a sandbox |
| `bin/eval <setup>` | runs `cases/<setup>/*`, saves `.out`/`.json`/`.jsonl`, `meta.txt` and both prompt files to `runs/` |
| `bin/review`, `bin/compare` | read one run, diff the two newest |
| `tests/run` | `00-surface`, `01-roundtrip`, `02-transcript`, all against baseline |
| `mise run …` | wrappers: `ask`, `inspect`, `transcript`, `eval`, `review`, `compare`, `new-setup`, `test` |

## Planned

Same pattern: a file in the setup, picked up by `bin/agent`, copied by
`bin/eval`, asserted in `tests/`.

| Feature | File / var | Becomes | Source |
|---|---|---|---|
| Setup's own tools | `tools` | `--tools` (`TOOLS` overrides) | orchestration TODO "setup" |
| Setup's own permissions | `permissions` / `permission-mode` | `--permission-mode`, `--allowedTools`, `--disallowedTools` | TODO "setup", "herdr" |
| Run in a real directory | `workdir` / `WORKDIR` | run there (or in a `wt` worktree), config still isolated | TODO "sandbox" |
| Parallel runs | unique `BOX` per run | no shared, wiped sandbox | TODO "spawn" |
| Default model | `model` | `--model` (`MODEL` overrides) | – |
| MCP servers | `mcp.json` | `--mcp-config` | – |
| Subagents | `agents.json` | `--agents` | orchestrator workers |
| Plugins | `plugins/` | `--plugin-dir` | root TODO "skog plugin" |
| Env | `env` | sourced before `claude` | root TODO "SKOGAI_ENVs" |
| Extra read dirs | `add-dirs` | `--add-dir` per line | – |
| Structured output | `schema.json` | `--json-schema` (check `cli-reference.md`) | – |

Gaps in what's already implemented: `append-system-prompt.md` and `work/`
have no test, and `CLAUDE.md`'s layout section doesn't mention
`append-system-prompt.md`.
