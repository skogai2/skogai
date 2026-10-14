# claude-code test environment

Start from a Claude Code agent with everything stripped, then add one feature at a time and prove it with a test.

Each run happens in a throwaway sandbox at `/tmp/claude-code/$SETUP/`:

- `config/` is `CLAUDE_CONFIG_DIR`: transcripts (`projects/*/*.jsonl`), `.claude.json`, settings, and any other state the run creates. `.credentials.json` is a symlink to `~/.claude`.
- `work/` is the working directory.

The sandbox is wiped at the start of every run (`KEEP=1` reuses it), so what's in it afterwards came from that run only.

## Setups

A setup is `setups/<name>/` containing:

- `settings.json`: copied into the sandbox as its user settings.
- `system-prompt.md`: replaces the default system prompt.
- `work/`: optional. Copied into the working dir (for CLAUDE.md, `.claude/`, fixtures).

## Commands

- `bin/agent`: a one-shot agent. The prompt comes on stdin. Env vars: `SETUP` (baseline), `MODEL` (haiku), `TOOLS` (none), `OUTPUT` (text), `KEEP`. Extra args are passed to `claude`.
- `bin/inspect`: prints the session surface and the context size of a trivial turn.
- `bin/transcript`: prints the path of the latest transcript in the sandbox.
- `bin/eval <setup>`: runs `cases/<setup>/*` and saves results to `runs/<setup>/<stamp>/`.
- `bin/review <setup>`: prints every response in the latest run. `bin/compare <setup>` diffs the last two runs.
- `tests/run`: runs `tests/NN-*.sh`.

See CLAUDE.md for workflows and gotchas.

Note: `CLAUDE_CONFIG_DIR` only takes effect from the process environment. Putting it under `env` in settings.json does nothing, because settings are read from the config dir.

Reference docs: `../../tmp/claude-docs/` (`settings.md`, `env-vars.md`, `cli-reference.md`, `claude-directory.md`).
