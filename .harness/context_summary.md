# Context Summary

Persistent record of architectural decisions, discovered patterns, gotchas, and active context.
This file is referenced in CLAUDE.md and loaded every session.

## Active Context
- Currently working on: nothing; features list reset 2026-11-06 (protocol/, bin/probe, tests/ removed at skogix's request — skogix did not recognise the protocol work)
- Next up: skogix names the real focus; add features for it and run them through the spec gate

## Cross-Cutting Concerns
- Stack: bash + mise (tasks/tools) + jq/yq + argc; tests in bats; no tests and no coverage measurement yet
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
- bin/checks/, tests/machine/ and the machine_check target were removed with the harness on 2026-10-31 (a2bd3bf) and not restored at re-init; the decisions above are history (2026-11-05)
- `.claude/settings.json` = harness stamp merged with skogix's prior settings (hooks concatenated, permissions unioned, `defaultMode: auto` kept); harness statusLine replaced `wt list statusline` (2026-10-29); same merge redone at re-init, statusLine again the harness one by skogix's choice (2026-11-05)

### Patterns
- Compare TOML semantically (python tomllib walk) against a known-good checkpoint from `~/.local/state/mise/history/repo.git` instead of reading text diffs

### Gotchas
- 2026-10-29 incident: an unknown writer rewrote ~/.config/mise/config.toml at 12:41 (checkpoint 787) — nested arrays/inline tables became strings, quoted-key `[bootstrap.*]` tables were dropped. Re-adding dotfiles entries without their include/exclude let the next sync publish secrets to skogai2/.dotfiles. Filters restored (checkpoint 825), secrets rotated by skogix; the leaked (now dead) values stay in origin history — purge skipped
- `mise dot status` warns `invalid file entry` and silently drops the entry from tracking; F002 turns that into a finding
- `~/.local/bin/mise` (2026.10.17) shadows the pacman `/usr/bin/mise` (2026.10.21)
- verify-git-identity.sh checks SSH identity, but pushes go over HTTPS — the credential helper decides the actual pushing account
- `trap '... $local_var' EXIT` inside a function fails under `set -u` once the function has returned; expand the value when setting the trap
- Commands run with Claude Code's `!` prefix are not recorded in atuin: the 2026-10-29 21:18 convergence run that succeeded is missing there, so atuin alone made the chain look always-failing
- commit-gate hook rejects `git add` and `git commit` in one Bash call; when a rejected call also held the add, the next commit silently picks up only the earlier-staged files. Check `git show --stat` after any hook rejection

## Meta-Patterns
<!-- Coordination insights that apply across features — NOT domain-specific.
     Populated by the retrospective step at session end.
     These transfer to new projects: harness-init can import them as starting context. -->
- Restoring a config "as it was" must restore its filters first: an entry without its excludes is worse than a missing entry
- A spec gate proves a spec is testable, not that it is worth building; before gating, state in one sentence what changes in the world if the feature works (watching)
- When agents report history-derived claims, cross-check against anything the lead itself saw in-session; history sources have blind spots (backlog)
- The spec gate earns its cost on the first proposal: it caught a test-layout contradiction (machine checks under a recursive full_test) before any code existed

## Meta-Session 2026-11-05
- Scope accuracy: re-init only; stamp mode=new would abort on existing files, so mode=upgrade wrote the 6 hooks and settings.json was merged by hand
- Model calibration: n/a, no agents spawned
- Discovery lineage: the coverage target depended on a test helper deleted with the harness; found by grepping for PROBE_KCOV_DIR before trusting the restored init.sh
- Approach patterns: restoring the tailored init.sh from git history (a2bd3bf^) beat re-deriving it from the generic template
- Plan approval: skogix approved upgrade mode and the harness status line

## Meta-Session 2026-10-30
- Scope accuracy: planned to build F001 as a check framework; skogix rejected it as testing nothing, and all six specs were rewritten mid-session into protocol + probes. The real scope was "learn the system", not "guard the system"
- Model calibration: Sonnet agents in herdr workspaces did F002-F006 with zero lead rework beyond one factual correction (F004) and one restructured entry (F003); no correction cycles >= 3
- Discovery lineage: atuin blind spot (`!` commands) and the probe runner's stdin wait were both found by verifying agent output, not by the agents
- Approach patterns: probe files committed before sections plus a no-context negative control made agent output checkable in minutes; lead re-running every probe set caught nothing false-positive but did catch a half-true claim only by cross-checking against what skogix ran in-session
- Plan approval: the spec gate passed a spec that tested nothing (it checks testability, not worth); skogix's "what does this actually do" was the check that mattered

## Meta-Session 2026-10-29
- Scope accuracy: init stretched across an unplanned dotfiles incident; the incident directly shaped F002's invalid-entry finding
- Model calibration: opus spec gate — first run BLOCK (30 questions), restructured proposal re-run
- Discovery lineage: F002's invalid-entry and secret-filter concerns came from the 12:41 incident
- Approach patterns: probing real tool JSON before writing specs removed most ambiguity questions
- Plan approval: n/a, no features implemented yet

## Closed Work Streams
- Machine checks (bin/checks, tests/machine): removed 2026-10-31 (a2bd3bf)
- Protocol + probes (F001-F006: protocol/, bin/probe, tests/probes, tests/unit/probe.bats): removed 2026-11-06 at skogix's request; history in git before this commit and in .skogai/memory/probe-method-lessons.md
