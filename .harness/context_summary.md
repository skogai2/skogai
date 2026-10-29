# Context Summary

Persistent record of architectural decisions, discovered patterns, gotchas, and active context.
This file is referenced in CLAUDE.md and loaded every session.

## Active Context
- Currently working on: harness initialized; F001 (check framework) is the first claimable feature
- Next up: F001, then F002 dotfiles / F003 bootstrap in parallel; live-agent message tests to be designed with skogix and added via /harness-issue-prep

## Cross-Cutting Concerns
- Stack: bash + mise (tasks/tools) + jq/yq + argc; tests in bats, coverage via kcov on bin/checks
- Architecture: orchestration layer — the main interface where skogix and Claude plan and delegate; holds agents/skills (`.skogai/`, symlinked into `.claude/`), config, and `dash-skogai/`
- Priority order for machine health: mise dotfiles, then bootstrap, then doctor ("no dotfiles, no backup and no future")
- Delegation rule: checks only detect. A finding with `outside_repo: true` is never acted on directly by an agent; it becomes its own features.json feature that skogix approves

## Domain: Machine checks

### Decisions
- bash/mise/jq chosen: matches existing tooling in the repo, no build step (2026-10-29)
- Check = `bin/checks/<name>`, read-only, findings JSON array in `.skogai/logs/findings/<name>.json` (gitignored); finding fields: id, check, observed, expected, suggested_fix, outside_repo; no file contents or env values in findings (2026-10-29)
- init.sh targets: smoke (`bash -n` + `jq empty` on tracked files), full_test (smoke + `bats -r tests/unit`, fixture-driven via fake `mise` on PATH), machine_check (`bats -r tests/machine`, live, never in full_test), focused_test (one .bats) (2026-10-29)
- A feature passes on its tests/unit fixtures; a red tests/machine run is a finding to delegate, not a broken feature (2026-10-29)
- No doctor baseline/ratchet: `mise doctor` reported 0 errors after cleanup (2026-10-29)
- Remote stays HTTPS (`https://github.com/skogai2/skogai.git`); skogix declined switching to SSH (2026-10-29)
- `.claude/settings.json` = harness stamp merged with skogix's prior settings (hooks concatenated, permissions unioned, `defaultMode: auto` kept); harness statusLine replaced `wt list statusline` (2026-10-29)

### Patterns
- Compare TOML semantically (python tomllib walk) against a known-good checkpoint from `~/.local/state/mise/history/repo.git` instead of reading text diffs

### Gotchas
- 2026-10-29 incident: an unknown writer rewrote ~/.config/mise/config.toml at 12:41 (checkpoint 787) — nested arrays/inline tables became strings, quoted-key `[bootstrap.*]` tables were dropped. Re-adding dotfiles entries without their include/exclude let the next sync publish secrets to skogai2/.dotfiles. Filters restored (checkpoint 825), secrets rotated by skogix; the leaked (now dead) values stay in origin history — purge skipped
- `mise dot status` warns `invalid file entry` and silently drops the entry from tracking; F002 turns that into a finding
- `~/.local/bin/mise` (2026.10.17) shadows the pacman `/usr/bin/mise` (2026.10.21)
- verify-git-identity.sh checks SSH identity, but pushes go over HTTPS — the credential helper decides the actual pushing account

## Meta-Patterns
<!-- Coordination insights that apply across features — NOT domain-specific.
     Populated by the retrospective step at session end.
     These transfer to new projects: harness-init can import them as starting context. -->
- Restoring a config "as it was" must restore its filters first: an entry without its excludes is worse than a missing entry
- The spec gate earns its cost on the first proposal: it caught a test-layout contradiction (machine checks under a recursive full_test) before any code existed

## Meta-Session 2026-10-29
- Scope accuracy: init stretched across an unplanned dotfiles incident; the incident directly shaped F002's invalid-entry finding
- Model calibration: opus spec gate — first run BLOCK (30 questions), restructured proposal re-run
- Discovery lineage: F002's invalid-entry and secret-filter concerns came from the 12:41 incident
- Approach patterns: probing real tool JSON before writing specs removed most ambiguity questions
- Plan approval: n/a, no features implemented yet

## Closed Work Streams
- (none yet)
