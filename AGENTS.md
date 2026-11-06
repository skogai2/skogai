# AGENTS.md

Guidance for coding agents working in this repository. `CLAUDE.md` only links here.

- @SKOGAI.md

Orchestration layer: where skogix and Claude plan and delegate. Stack: bash + mise + jq/yq + argc (tools pinned in `mise.toml`).

## Commands

- Tests: `.harness/init.sh smoke_test` (bash -n, jq parse) / `full_test` (adds `bats -r tests/unit` once tests exist)
- Lint/format (hk, `hk.pkl`): `hk check --all` / `hk fix --all` — shellcheck, shfmt `-i 2 -ci`, private-key and merge-conflict detection. `dash-skogai/tmp/docs/**` is vendored and excluded.
- dash: `mise run dash:check [dot]` (read-only agent check), `mise run dash:graph` (regenerates `dash-skogai/README.md`)

## Layout

- `dash-skogai/`: the skogai type system and `argc config` CLI. Has its own `AGENTS.md`; read it before working there. Its `README.md` is generated from `type/*.md`, never hand-edited.
- herdr oversight (what every agent is doing, its last answer, sending it text): `dash-skogai/type/tool/herdr.md`.
- `.skogai/`: local rules, memory (index `.skogai/memory/MEMORY.md`), scripts, task templates. Check memory before re-deciding things.
- `tmp/`, `.skogai/logs/`: throwaway, gitignored.

## Agent instructions

Instructions live in `AGENTS.md`; every `CLAUDE.md` is only `@AGENTS.md`. See `.skogai/rules/agents-md.md`.

## Harness

vv-harness, re-initialised 2026-11-05; features list reset 2026-11-06 (protocol/probe work removed). Features: `.harness/features.json`; decisions: `.harness/context_summary.md` (read at session start); handoff: `.harness/claude-progress.txt`; build/test: `.harness/init.sh [smoke_test|full_test|focused_test <file>]`; gates: `.claude/hooks/`.

## Git

Identity: Emil Skogsund <emil@skogsund.se>, default SSH key (Skogix). Remote is HTTPS, so the credential helper decides the pushing account. One command per Bash call: chains defeat narrow permission rules, and the commit-gate hook rejects `git add` + `git commit` in one call.
