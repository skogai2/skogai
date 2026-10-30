# Scale

Size of the system and what each layer costs and gives. Counts come from atuin
(`history.db`, read-only), `mise`, `pacman` and `git`, as of 2026-10-30. "90d" means
2026-08-01 to 2026-10-30. Atuin history starts 2026-05-27. Agent = atuin authors
`claude-code` and `codex`; human = `skogix` (13 `root` rows are neither). Counts are
rounded only where marked "about".

## Size

### How many commands are recorded, and how many are unique?
- answer: 365895 commands recorded all-time (about 366k) and 103347 unique command
  strings (74612 unique by skogix, 28964 by agents). In the last 90d: 190128 commands,
  58630 unique. See tools.md for the author split.
- source: sqlite3 read-only on `~/.local/share/atuin/history.db` (count, count distinct command); protocol/tools.md
- learned: 2026-10-30

### What share of commands do agents run?
- answer: Last 90d: 12723 of 190128 = 6.7% (claude-code 11761, codex 963). All-time:
  33058 of 365895 = 9.0%. Every row has an author (`skogix` or an agent name since
  2026-05-27), so author-based share covers 100% of history. The explicit agent tag
  (`author_kind` = 2) covers only 9768 rows: 2.7% of all-time history and 5.1% of
  90d, first seen 2026-09-03, so it undercounts agents by about a factor of three.
  Agents therefore run about one command in fifteen now and one in eleven over all time.
- source: sqlite3 read-only on `history.db` (author, author_kind, timestamp >= 2026-08-01); protocol/tools.md
- learned: 2026-10-30

### How many tools are installed, and how many are used?
- answer: 252 packages are explicitly installed with pacman (1384 installed in total,
  13 foreign/AUR). mise has 77 active tool entries. Of those 77, 48 have a recorded
  use of their command in 90d, 3 only before that (age, copilot, pandoc) and 26 never:
  adr-tools, amp, antigravity-cli, aqua, basecamp, crush, cursor-agent, ghui, grok,
  hey-cli, devin, kiro-cli, java, muse, deepseek dsh, kilocode, minimax code, kimi-code,
  command-code, freebuff, ori, mypy, playwright, qwen-code, ruby, watchexec. Matching is
  by command name with a small alias map (ripgrep=rg, worktrunk=wt, rust=cargo,
  python=python3, mr-boxington=mbx, oh-my-pi=omp), so a tool run only through another
  name (ruby via bundler, mypy via pipx) reads as unused; treat 26 as an upper bound.
  Sharper per-tool counts are in tools.md.
- source: `pacman -Qe | wc -l`, `pacman -Q | wc -l`, `mise ls --current --json` crossed with atuin first-word counts; protocol/tools.md
- learned: 2026-10-30

### How many repos, tracked dotfiles and AI CLIs are there?
- answer: Six git repos: ~/skogai, /skogai, ~/.config/skogai, ~/.skogai,
  ~/.config/containers/systemd and the ~/.dotfiles checkout (dash-skogai is a directory
  of ~/skogai, not a repo; see information.md). `mise dotfiles` tracks 54 entries
  covering 172 files, with 878 checkpoints. AI agent CLIs installed through mise: 24 of the 77
  entries (aichat, amp, antigravity-cli, claude, codex, copilot, crush, cursor-agent,
  grok, opencode, pi, qwen, qwen-code, gptme, letta, kilocode, kimi-code, minimax code,
  dsh, command-code, freebuff, oh-my-pi, devin, kiro-cli); muse and ori are not counted
  because their purpose is unverified, and ollama and gemini appear in history but not
  as mise tools. The list is a judgment call, not a measured set.
- source: `git -C <path> remote -v` per information.md; `mise dotfiles status`; `mise ls --current`; protocol/tools.md and protocol/information.md
- learned: 2026-10-30

## Layers

### How are commands attributed to a layer?
- answer: By command name, over all history (all authors):

  | Layer | Commands counted |
  |---|---|
  | dotfiles | `mise dot*` (`mise dot`, `mise dotfiles`) |
  | bootstrap | `mise bootstrap`, `pacman`, `systemctl` |
  | agent CLIs | `claude`, `codex`, `opencode`, `amp`, `copilot`, `crush`, `cursor-agent`, `grok`, `aichat`, `gptme`, `letta`, `ollama`, `gemini`, `kimi`, `kiro-cli`, `devin` |
  | config repos | `git` run with its working directory inside one of ~/skogai, /skogai, ~/.config/skogai, ~/.skogai, ~/.config/containers/systemd |

  A command name is the first word after stripping leading `sudo`, `env` and
  `VAR=value`. Failure rules are those of breaks.md (exit not 0, 130 or -1; exit 1 from
  `grep`, `rg`, `diff`, `test` and `[` ignored). `git` in ~/.dotfiles and `git` elsewhere
  are not attributed to any layer.
- source: F006 spec in .harness/features.json; protocol/breaks.md for the failure rule
- learned: 2026-10-30

### What does each layer cost (failures) and give (usage)?
- answer: All-time (runs, failures, rate; then 90d runs and failures):

  | Layer | Runs | Failures | Rate | 90d runs | 90d failures | Agent runs |
  |---|---|---|---|---|---|---|
  | agent CLIs | 8177 | 1413 | 17.3% | 4175 | 763 | 77 |
  | bootstrap | 4192 | 1178 | 28.1% | 2650 | 831 | 224 |
  | config repos | 2675 | 548 | 20.5% | 1451 | 309 | 882 |
  | dotfiles | 805 | 204 | 25.3% | 779 | 192 | 39 |

  By raw failures all-time the costliest layer is agent CLIs (claude alone: 6072 runs,
  1010 failures). Over the last 90d it is bootstrap (831), and bootstrap has the
  highest failure rate at 28.1%. Within bootstrap, `systemctl` is 988 of the 1178
  failures (3538 runs), `mise bootstrap` 122 of 412 runs and `pacman` 68 of 242.
  Dotfiles is the smallest layer but almost all of it is recent (779 of 805 runs in
  90d). Agents mostly use the config repos layer (882 of 2675 runs), which is where
  they fail least often (37 failures, 4.2%).
- source: sqlite3 read-only on `history.db` with the attribution table above (scratch script, not kept); protocol/breaks.md (costs), protocol/tools.md and protocol/solutions.md (usage)
- learned: 2026-10-30

### What does each layer give?
- answer: dotfiles: every config under ~/.config is checkpointed and published
  (54 entries, 172 files, last published 2026-10-30) and restorable with
  `mise bootstrap --adopt`, at the price of the 2026-10-29 secrets incident. bootstrap:
  one command converges the machine (252 pacman packages, mise tools, services); see
  solutions.md. agent CLIs: 3320 `claude` and 359 `codex` runs in 90d, the main way
  work is done here. config repos: knowledge and quadlet units in git, 6 repos. Value is
  usage, not measured benefit.
- source: protocol/solutions.md, protocol/information.md, protocol/incidents.md, protocol/tools.md
- learned: 2026-10-30

### What is the maintenance cost of each layer?
- answer: UNKNOWN
- source: no agreed measure of maintenance cost yet (time spent, edits per layer, drift); failures above measure breakage only, not upkeep
- learned: 2026-10-30

### Is it worth keeping the 26 apparently unused mise tools?
- answer: UNKNOWN
- source: usage is known (see above) but the cost of keeping a tool installed (disk, update time) was not measured, and skogix has not decided
- learned: 2026-10-30

## Inventory of scratch directories

Proposals only. Nothing was changed, deleted or moved; pruning is a separate feature
skogix approves. Size is apparent size from `du -sh --apparent-size`. "Last commit"
is `git log -1 --format=%cs -- <path>`, or `untracked` when git has no commit for it.

### What is under ~/skogai/tmp, and what is proposed?
- answer:

  | Entry | Size | Last commit | Proposal | Reason |
  |---|---|---|---|---|
  | tmp/0001-skogai-events.md | 9.6K | untracked (gitignored) | keep | ignored scratch, harmless and recoverable only from here |
  | tmp/.gitkeep | 0 | 2026-10-11 | keep | holds the directory in git |
- source: `ls -A ~/skogai/tmp`; `git log -1 --format=%cs -- <path>`; `git check-ignore -v`
- learned: 2026-10-30

### What is under ~/skogai/dash-skogai/tmp, and what is proposed?
- answer:

  | Entry | Size | Last commit | Proposal | Reason |
  |---|---|---|---|---|
  | definitions.md | 8.0K | 2026-10-18 | move | tracked content under a `tmp` name, belongs next to the dash types if still wanted |
  | docs | 120K | 2026-10-29 | keep | changed yesterday, still being worked on |
  | graph | 8.0K | 2026-10-17 | move | tracked and untouched for 13 days, `tmp` is the wrong home |
  | routing | 132K | 2026-10-17 | move | largest and stale for 13 days, same reason |
- source: `ls -A ~/skogai/dash-skogai/tmp`; `du -sh --apparent-size`; `git log -1 --format=%cs -- <path>`
- learned: 2026-10-30

### What is under ~/skogai/.skogai (excluding skills and logs), and what is proposed?
- answer:

  | Entry | Size | Last commit | Proposal | Reason |
  |---|---|---|---|---|
  | config | 0 | 2026-10-11 | delete | empty directory, no tracked files |
  | journal.md | 348K | 2026-10-25 | keep | largest tracked file, in use this month |
  | memory | 84K | 2026-10-29 | keep | changed yesterday |
  | rules | 40K | 2026-10-25 | keep | read by agents (information.md) |
  | scripts | 44K | 2026-10-26 | keep | tracked and recent |
  | tasks | 4.0K | 2026-10-28 | keep | tracked and recent |
  | templates | 4.0K | 2026-10-27 | keep | tracked and recent |
  | tmp | 242K | untracked | delete | untracked scratch that git cannot restore; skogix to confirm first, contents not reviewed |
  | TODO.md | 4.0K | 2026-10-28 | keep | tracked and recent |
  | workflow | 0 | 2026-10-25 | keep | holds only a tracked `.gitkeep` placeholder |
  | worktrees | 0 | untracked (gitignored) | keep | where `wt` and herdr create worktrees (solutions.md), currently empty |
- source: `ls -A ~/skogai/.skogai`; `du -sh --apparent-size`; `git log -1 --format=%cs -- <path>`; `git check-ignore`
- learned: 2026-10-30
