# Context Summary

Persistent record of architectural decisions, discovered patterns, gotchas, and active context.
This file is referenced in AGENTS.md and loaded every session.

## Active Context
- Currently working on: nothing; F002 (direct delegation) and F003 (plan-first delegation) of .skogai/skills/herdr-orchestration/ passing 2026-11-06
- Next up: skogix names the next feature; open gaps: plan rejection path and claude plan-mode status/shift+tab order never observed live

## Cross-Cutting Concerns
- Stack: bash + mise (tasks/tools) + jq/yq + argc; tests in bats; no tests and no coverage measurement yet
- Architecture: orchestration layer — the main interface where skogix and Claude plan and delegate; holds agents/skills (`.skogai/`, symlinked into `.claude/`), config, and `dash-skogai/`
- Priority order for machine health: mise dotfiles, then bootstrap, then doctor ("no dotfiles, no backup and no future")
- Delegation rule: checks only detect. A finding with `outside_repo: true` is never acted on directly by an agent; it becomes its own features.json feature that skogix approves

## Domain: herdr

### Decisions
- Oversight and messaging use existing herdr commands only, documented in dash-skogai/type/tool/herdr.md; no scripts (skogix: the removed orchestrate skill wrote its own tools instead of using what exists) (2026-11-06)
- Messaging goes through herdr (`agent prompt` default, `pane send-text` + `send-keys enter` tmux-style), not Claude Code's SendMessage (skogix 2026-11-06)
- Orchestration follows .skogai/skills/herdr-orchestration/SKILL.md; workers launch in auto mode (claude --permission-mode auto, codex --approve-for-me), never bypass flags (skogix 2026-11-06)
- The controller never answers trust prompts (codex folder trust, claude CLAUDE.md imports); notify skogix (2026-11-06)

### Gotchas
- Claude transcripts are under $CLAUDE_CONFIG_DIR/projects = /skogai/claude/projects, not ~/.claude/projects
- herdr's claude hook reports agent_session only on SessionStart; agents without one since show null
- a claude started under ~/skogai can block on the external CLAUDE.md imports dialog; after answering, plain `agent wait` returns at once on the stale blocked state. It is asked once per project: for ~/skogai WarningShown=true, Approved=false, so workers there now start without the dialog and without external imports
- `agent start` rejects multi-line argv (invalid_agent_argument); returns agent_pane_busy right after `tab create`; may return timeout while the tui is fine, then the agent name is unregistered (use pane id)
- a controller Claude Code in auto mode refuses to start a worker with --dangerously-skip-permissions ("Create Unsafe Agents")
- unfocused codex workers settle `idle`, claude `done`: wait with --until done --until idle (seen twice: F002, F003)
- a plan-first claude worker can reach its plan menu before herdr sees it ready: agent start returns agent_not_ready; read the screen. Full plan is in $CLAUDE_CONFIG_DIR/plans/<slug>.md; menu option 'Yes, and use auto mode' keeps it unattended (F003)
- the vv-harness plugin agent types can drop out mid-session; the spec gate then runs as a general-purpose agent given /skogai/claude/plugins/cache/skogix/vv-harness/<ver>/agents/spec-verification.md (F003)

## Domain: lint (hk)

### Gotchas
- hk fix-mode hooks (pre-commit) apply a step's `check_diff` patch; overriding only `check`/`fix` in hk.pkl leaves the builtin check_diff (for shfmt: tabs) in charge of every commit. hk.pkl now overrides shfmt check_diff (2026-11-06)
- one shellcheck error (SC1128) can mask warnings in the same batch; re-run after fixing

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

## Domain: auto mode

### Gotchas
- `rtk hook claude` (PreToolUse Bash, user settings /skogai/claude/settings.json) rewrites commands (cat→rtk read, grep→rtk grep). Auto mode then returns "no verdict, a hook changed the input" and allows one identical retry. Calls matched by an allow rule (`git *`) went through. `rtk hook claude` has no flag to skip the rewrite (2026-11-06)

## Improve-Harness Result: read-only Bash under auto mode (2026-11-06)
- Outcome: pending (rerun not done yet)
- Proof: baseline: in session 5bf125a1, all 4 rewritten Bash calls without an allow rule got "no verdict"; the `git add`/`git commit` calls (allowed by `Bash(git *)`) passed
- Hypothesis: if read-only rtk subcommands (diff, grep, json, ls, read, recall, rg, tree, wc) are allowlisted in .claude/settings.json, then a fresh session's `cat`/`grep`/`ls` calls run without the classifier error, because the allow rule matches the rewritten command. Weakened if the error still appears, meaning rules match the command before the rewrite. `rtk find` is left out because find can `-exec`/`-delete`
- Relay/latency: hypothesis and change in the same session; a fresh-session rerun is still needed
- Risk vs. carrying cost: 9 allow rules; they bypass auto-mode review only for rtk's read-only proxies
- Decision: retain if the fresh session shows no "no verdict" error on a plain `cat`/`grep`; remove the rules if the error persists
- Known limits: covers only Bash reads in this repo, on CLI 2.1.318 with rtk's current rewrite table

## Meta-Patterns
<!-- Coordination insights that apply across features — NOT domain-specific.
     Populated by the retrospective step at session end.
     These transfer to new projects: harness-init can import them as starting context. -->
- Restoring a config "as it was" must restore its filters first: an entry without its excludes is worse than a missing entry
- A spec gate proves a spec is testable, not that it is worth building; before gating, state in one sentence what changes in the world if the feature works (watching)
- When agents report history-derived claims, cross-check against anything the lead itself saw in-session; history sources have blind spots (backlog)
- Before building, ask why the previous attempt at the same thing was removed (backlog)
- A packet's verification step must be one the worker can pass when the work is right; diff -w made both workers stop on correct output (watching)
- Read a lint tool's full output before writing its failures into a spec; summaries mask findings (backlog)
- The spec gate earns its cost on the first proposal: it caught a test-layout contradiction (machine checks under a recursive full_test) before any code existed

## Meta-Session 2026-11-06 (F003)
- Scope accuracy: as planned; no scope expansions. The codex audit changed nothing (skogix kept all scripts), so half the run proved the flow but produced no diff
- Model calibration: both workers planned in about 1 min and stayed in scope on the first round; plan review found nothing to reject
- Discovery lineage: F003 came from F002's deferral; the herdr.md update reused F002's findings, so one live run fed three docs
- Approach patterns: the spec gate ASKed 8 then 1; most answers were defaults the lead could set, and the user only needed to choose the deletions, which came up live at plan review
- Plan approval: plan-first suits a slice whose outcome needs a human decision (deletions); for the doc slice it added a review without changing anything

## Meta-Session 2026-11-06 (F002)
- Scope accuracy: planned a formatting-only slice of 15 files; actual also needed hk.pkl (root cause) and 3 shellcheck fixes. The spec premise "fails only on shfmt" came from a grep of hk's summary, which hid shellcheck findings; 3 scope expansions, all user-approved
- Model calibration: workers on default models did a mechanical slice in ~30s each; both correctly stopped at the packet's own over-strict check (diff -w) instead of improvising
- Discovery lineage: every skill deviation surfaced only when a real launch was attempted; none was visible from --help
- Approach patterns: verify formatting-only with `shfmt -mn` (minified AST compare), not `git diff -w`, which fails on moved line breaks
- Plan approval: n/a (plan-first deferred to F003)

## Meta-Session 2026-11-06
- Scope accuracy: planned "continue"; actual: reset (skogix did not recognise protocol/, removed), then F001 chosen fresh. Spec gate took 3 rounds (ASK 14 questions, ASK 2, PASS)
- Model calibration: no implementer agents; lead did F001 directly. One throwaway haiku agent for the messaging check
- Discovery lineage: transcript path and startup dialog found only by running commands live, not from the old gotcha line (which had the wrong path)
- Approach patterns: asking "why was the last attempt removed" before speccing changed the feature from code to docs of existing tools
- Plan approval: n/a

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
