# Tools

Installed vs actually used. Counts come from atuin (`history.db`, read-only), `mise ls`
and `pacman -Q`. "90d" means the 90 days up to 2026-10-30. Atuin history starts
2026-05-27. Human = atuin author `skogix`; agent = authors `claude-code` and `codex`.
Counts are first-word matches of the command name only.

### How many packages are explicitly installed with pacman, and how many mise tool entries are active?
- answer: 252 packages are explicitly installed with pacman (13 more are foreign
  packages, AUR). `mise ls --current` shows 77 active tool entries across
  `~/.config/mise/config.toml`, `~/skogai/mise.toml` and `/etc/mise/conf.d/omarchy-tools.toml`.
- source: `pacman -Qe | wc -l`; `pacman -Qm | wc -l`; `mise ls --current | wc -l`
- learned: 2026-10-30

### How big is the atuin history and who wrote it?
- answer: About 366k recorded commands since 2026-05-27. Authors: skogix ~333k,
  claude-code ~23k, codex ~10k, root 13. Agent attribution exists (author and
  author_kind columns), so human and agent use can be split.
- source: read-only sqlite query of `~/.local/share/atuin/history.db` (group by author); `atuin stats`
- learned: 2026-10-30

### What editor does skogix use?
- answer: nvim (neovim 0.12.6, pacman, with omarchy-nvim). 14490 all-time uses, 7359
  human uses in 90d, 0 by agents. vim 15 and nano 1 all-time.
- source: atuin history.db first-word counts; `pacman -Qe`
- learned: 2026-10-30

### Which shell is used?
- answer: fish is the login shell (`getent passwd`) and the shell in nearly all
  recent use: last 30d fish 62526, bash 2750, zsh 2640 human commands. zsh was the
  shell until recently (zsh 110k all-time vs fish 83k, fish first seen 2026-08-10).
  Claude Code's own shell is zsh (`$SHELL`).
- source: atuin history.db shell column; `getent passwd skogix`
- learned: 2026-10-30

### Which Python runner is used?
- answer: uv. 5851 all-time uses (2458 in 90d) against pip 19 all-time. pipx is
  used 91 times (all in 90d, all human) and python3 581 (290 by agents in 90d).
- source: atuin history.db first-word counts; `mise ls --current` (pipx, pipx:gptme, pipx:mypy)
- learned: 2026-10-30

### Which git client is used?
- answer: git itself (12242 all-time) plus lazygit (2311, 2163 in 90d, human only)
  and an `lg` alias (8277, 2423 in 90d). `gh` 3518 all-time (124 by agents in 90d).
  Agents use plain git (1320 uses in 90d).
- source: atuin history.db first-word counts; `pacman -Qe` (lazygit)
- learned: 2026-10-30

### Which terminal multiplexer is used?
- answer: herdr and tmux are both installed. In 90d herdr leads: 1318 uses (113 by
  agents) vs tmux 587. All-time tmux leads: 1528 vs 1318. herdr first used 2026-09-20
  and is overtaking tmux. zellij is not installed.
- source: atuin history.db first-word counts; `pacman -Qe` (herdr, tmux)
- learned: 2026-10-30

### Which AI agent CLIs are used most?
- answer: claude by far: 6013 all-time, 3257 in 90d. Then codex 1236 / 358, ollama
  385 / 237, aichat 218 / 123, gptme 105 / 103, letta 31 / 31, opencode 81 / 4.
  Agents record claude-code (~23k) and codex (~10k) as authors of their own
  commands.
- source: atuin history.db first-word counts (all-time / 90d); `mise ls --current`
- learned: 2026-10-30

### Which AI agent CLIs are installed through mise?
- answer: claude, codex, opencode, amp, copilot, crush, cursor-agent, grok, pi,
  aichat, gptme (pipx), letta (pipx), plus npm-installed kilocode, kimi-code,
  minimax code, deepseek dsh, command-code, freebuff, oh-my-pi, and http-installed
  devin and kiro-cli. Most come from `/etc/mise/conf.d/omarchy-tools.toml`.
- source: `mise ls --current`
- learned: 2026-10-30

### Which tools are installed but unused?
- answer: Zero atuin uses in 90d: amp, crush, cursor-agent, grok, copilot (18 uses
  all-time, last one before 90d ago), gemini (11 all-time, not on PATH). amp,
  crush, cursor-agent and grok have zero uses ever. Also unused in 90d: kimi,
  kiro-cli, devin, ori, muse, antigravity-cli, ghui, basecamp.
- source: `mise ls --current` crossed with atuin history.db first-word counts; `command -v`
- learned: 2026-10-30

### Which terminal emulator is used?
- answer: UNKNOWN. kitty and foot are installed (pacman); atuin records shell
  commands, not the emulator, so shell invocations (kitty 93, foot 0) do not
  establish it.
- source: `pacman -Qe`; atuin history.db
- learned: 2026-10-30

### What do agents run most?
- answer: Agent commands in 90d are mostly cd, git, cat, ls, sed, grep, find, rg,
  python3, then herdr (113), podman (108) and mise (92). rg is agent-heavy:
  244 of 282 90d uses are agents.
- source: atuin history.db, author_kind=2 rows, last 90 days
- learned: 2026-10-30
