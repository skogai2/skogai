# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

- @SKOGAI.md

Orchestration layer: where skogix and Claude plan and delegate. Stack: bash + mise + jq/yq + argc (tools pinned in `mise.toml`).

## Commands

- Unit tests: `bats -r tests/unit`; one test: `bats tests/unit/probe.bats -f '<name regex>'`
- Lint/format (hk, `hk.pkl`): `hk check --all` / `hk fix --all` — shellcheck, shfmt `-i 2 -ci`, private-key and merge-conflict detection. `dash-skogai/tmp/docs/**` is vendored and excluded.
- Protocol probes (live, calls `claude -p`): `bin/probe $(printf -- '-c %s ' protocol/*.md) tests/probes/*.jsonl`
- dash: `mise run dash:check [dot]` (read-only agent check), `mise run dash:graph` (regenerates `dash-skogai/README.md`)

## Layout

- `protocol/` + `bin/probe` + `tests/probes/`: what an agent needs to know to run and recover this system. Entries are situation/answer/source/learned; unknowns are written as `UNKNOWN`, never left out. Probes (question + regex + source) are asked of a fresh, tool-less claude with only `protocol/*.md` as knowledge; commit a section's probes before the section. Format and redaction rules: `protocol/README.md`.
- `tests/unit/` tests `bin/probe` against a fake `claude` on PATH (`tests/helpers/fake-claude`), never the real CLI.
- `dash-skogai/`: the skogai type system and `argc config` CLI. Has its own `CLAUDE.md`; read it before working there. Its `README.md` is generated from `type/*.md`, never hand-edited.
- `.skogai/`: local rules, memory (index `.skogai/memory/MEMORY.md`), scripts, task templates. Check memory before re-deciding things.
- `tmp/`, `.skogai/logs/`: throwaway, gitignored.

## Harness

`.harness/` is from the vv-harness sessions of 2026-10-29/30 and is being re-introduced. Its `context_summary.md` and `claude-progress.txt` still reference `.harness/init.sh` and `bin/checks/`, which no longer exist; treat those as history until re-init. `.skogai/memory/probe-method-lessons.md` holds the lessons from those sessions.

## Probe gotchas

- haiku sometimes answers UNKNOWN for a fact that is in the context; one failing probe is noise until it repeats. A criterion is met on two consecutive passing runs.
- Regexes match meaning, not formatting; exact names must be expected literally.
- One fact per `###` heading.
- `claude -p` waits on non-TTY stdin; pass `</dev/null`.

## Git

Identity: Emil Skogsund <emil@skogsund.se>, default SSH key (Skogix). Remote is HTTPS, so the credential helper decides the pushing account. One command per Bash call: chains defeat narrow permission rules, and the commit-gate hook rejects `git add` + `git commit` in one call.
