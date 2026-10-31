# Breaks

What fails, how often, and why. Counts come from atuin history as of 2026-10-30.
A failure is an exit code other than 0 and 130, excluding exit 1 from `grep`, `rg`, `diff`,
`test` and `[`; commands that never recorded an exit (-1) are not counted. A command name is
the first word after stripping leading `sudo`, `env` and `VAR=value` prefixes, so the name
of a `cd dir && other` chain is `cd`. Ranking is by raw failure count; ties rank alphabetically.
Human = atuin author `$all-user`, agent = `$all-agent`.

### How is a failure counted and ranked?
- answer: Exit codes 0 and 130 are not failures. Exit 1 from `grep`, `rg`, `diff`, `test`
  and `[` is not a failure either (it means "no match" or "differs"). Commands are grouped by
  first word after stripping `sudo`, `env` and `VAR=value`. Ranking is by raw count, with the
  failure rate (failures / runs of that command) shown alongside; ties rank alphabetically.
- source: F005 spec in `git show 593de0b:.harness/features.json`
- learned: 2026-10-30

### Which commands fail most for skogix (human)?
- answer: 45815 failures out of 260044 recorded runs all-time; 27432 of them in the last
  90 days. Top by raw count, all-time (rate, failures in last 90 days):
  `mise` 2381 (30.0%, 1839), `uv` 2080 (49.9%, 881), `git` 1904 (29.2%, 937), `ls` 1138
  (2.4%, 628), `argc` 1033 (24.0%, 797), `cd` 1025 (3.6%, 518), `claude` 1008 (21.7%, 595),
  `systemctl` 969 (36.9%, 659), `ping` 796 (56.1%, 579), `npm` 784 (27.2%, 301),
  `podman` 763 (42.3%, 754), `wt` 755 (22.2%, 360). Most-failing is `mise`; highest rate among
  these is `ping` (56.1%), then `uv` (49.9%). `podman` failures are almost all recent
  (754 of 763 in 90 days).
- source: `atuin search --author '$all-user' --include-duplicates --format '{exit} {time} {command}'`, aggregated with a script
- learned: 2026-10-30

### Which commands fail most for agents?
- answer: 1235 failures out of 32765 runs all-time; 801 in the last 90 days. Top by raw
  count: `cd` 223 (5.5%, 185 recent), `ls` 134 (7.9%, 64), `git` 123 (2.8%, 87), `find` 77 (5.2%),
  `echo` 71 (6.3%), `sed` 59 (1.9%), `cat` 56 (4.2%), `for` 20, `rg` 20, `node` 19,
  `pwd;` 19, `systemctl` 19. Agents fail about a tenth as often per run as skogix
  does (3.8% of runs against 17.6%). Most-failing for agents is `cd`.
- source: `atuin search --author '$all-agent' ...`, same aggregation
- learned: 2026-10-30

### Why does `cd` top the agent failure list?
- answer: `cd` itself is not the failing part. Agents write `cd dir && ...` or `cd dir; ...`
  chains in one command, and the recorded exit is that of the later part of the chain. By
  exit code the 223 `cd` failures are: 211 exit 1, 7 exit 2, 4 exit 128 (git), 1 exit 3.
  The same applies to `for`, `pwd;` and `echo` names. Treat agent "`cd`" failures as failures
  of the chained command.
- source: atuin_history only_failed with `$all-agent` and query `cd`; exit code split from the aggregation
- learned: 2026-10-30

### Which subcommands fail most?
- answer: Human `mise` (excluding bare `mise` with 342): `config` 327, `use` 262, `dot` 158,
  `env-vars` 130, `bootstrap` 122; exit codes overall 1 (1467), 2 (873), 127 (14), 5 (12).
  Human `git`: `push` 308, `pull` 293, `commit` 209, `submodule` 208, `config` 131,
  `sparse-checkout` 72 (none recent). Human `uv`: `run` 1313 (exit 2 dominates all uv failures:
  1445 of 2080), `tool` 438, `pip` 94, `sync` 80. Agent `git`: `status` 30,
  `log` 18, `add` 12, `diff` 6, `push` 6. Human `ssh` exits 255 555 times, `gh repo` fails
  410 times, `claude plugin` 395, `npm run` 368, `yay` 360.
- source: atuin aggregation by command and first subcommand
- learned: 2026-10-30

### What is the most common cause of the top failures (`mise`, `uv run`, `cd`)?
- answer: UNKNOWN. atuin_output returned "no captured output" for every sampled failed
  command (mise use, mise dot sync, an agent cd chain), so error text cannot be read. Output
  capture covers only recent commands run with the daemon on. Visible from metadata only:
  failing `mise use` calls come in bursts of repeated tries within a minute, and `mise`
  exit 2 (873) points at usage errors, but the causes are not confirmed.
- source: atuin_output on sampled history ids; atuin_history only_failed
- learned: 2026-10-30

### What is the mise binary shadowing gotcha?
- answer: `~/.local/bin/mise` shadows the pacman-installed `/usr/bin/mise` because
  `~/.local/bin` comes first in PATH (`type -a mise` lists `~/.local/bin/mise`, then
  `/usr/bin/mise`). Versions drifted apart: the shadowing copy reports 2026.10.17 (and
  prints a self-update warning), while `/usr/bin/mise` (owned by root, from pacman) reports
  2026.10.22. Updating via pacman changes nothing until the local copy is removed or
  updated with `mise self-update`.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas; `type -a mise`; `ls -l ~/.local/bin/mise /usr/bin/mise`; `mise --version` for each
- learned: 2026-10-30

### What happens when `mise dot status` meets an invalid file entry?
- answer: It warns `invalid file entry` and silently drops the entry from tracking, so
  the file is no longer synced or protected by its filters.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas
- learned: 2026-10-29

### Does checking the SSH identity say which account pushes from ~/skogai?
- answer: No. The remote is HTTPS, so the git credential helper decides the account that
  actually pushes, whatever `ssh -T git@github.com` reports.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas
- learned: 2026-10-29

### What other known gotchas are recorded?
- answer: The 2026-10-29 `~/.config/mise/config.toml` rewrite is in incidents.md. Test
  tooling gotchas: kcov does not trace bash that bats launches as child processes, and it
  misses continuation lines of multi-line statements, so raw coverage understates; a
  `trap` with a local variable inside a function fails under `set -u` after return.
- source: `git show 593de0b:.harness/context_summary.md` Gotchas
- learned: 2026-10-30
