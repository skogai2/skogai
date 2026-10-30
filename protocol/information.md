# Information

Where docs, configs and repos live. "Last commit" is a currency signal, as of 2026-10-30.

### Where are the dotfiles published?
- answer: GitHub repo skogai2/.dotfiles (branch main, mode sync), published by `mise dotfiles sync`. Last published 2026-10-30 04:53.
- source: `mise dotfiles status` (Repository section)
- learned: 2026-10-30

### What is the local path of the dotfiles git checkout?
- answer: ~/.dotfiles, a git repo whose origin is skogai2/.dotfiles (last commit 2026-10-30).
- source: `git -C ~/.dotfiles remote -v`
- learned: 2026-10-30

### Where do mise dotfiles checkpoints live?
- answer: ~/.local/state/mise/history, which holds a bare repo (repo.git, branch main, last commit 2026-10-30) plus an index and health files. It is not a working-tree git repo. Browse with `mise dotfiles history`; 878 checkpoints, latest 878 (2026-10-30 04:49). The history syncs to the dotfiles origin (skogai2/.dotfiles).
- source: `ls -la ~/.local/state/mise/history`; `mise dotfiles status`; `mise dotfiles history`
- learned: 2026-10-30

### Which mise config files load, and in what order?
- answer: From /home/skogix/skogai with MISE_ENV unset, `mise config ls` lists, in this order: ~/skogai/mise.toml (project, tools age argc yq jq fnox watchexec), ~/.config/mise/config.local.toml (no tools), ~/.config/mise/config.toml (main user config, also holds `[dotfiles]` and `[bootstrap]`), /etc/mise/conf.d/omarchy.toml, /etc/mise/conf.d/omarchy-tools.toml, /etc/mise/conf.d/omarchy-agent-accounts.toml. The three /etc files are the system layer (Omarchy). The listed order is mise's own output; the precedence rule itself was not verified here.
- source: `cd ~/skogai; env -u MISE_ENV mise config ls`
- learned: 2026-10-30

### Where do agent skills live?
- answer: Claude Code user skills: ~/.claude/skills, mostly symlinks into ~/.agents/skills, /usr/share/omarchy/default/agents/skills, or mise installs (fnox, worktrunk, wt-switch-create, concord-relay), plus real dirs (collie-walky-talky, herdr). Project skills for ~/skogai: ~/skogai/.skogai/skills (currently orchestrate); ~/skogai/.claude/skills is a symlink to it.
- source: `ls -la ~/.claude/skills ~/.agents/skills ~/skogai/.claude ~/skogai/.skogai/skills`
- learned: 2026-10-30

### ~/skogai: what is it?
- answer: Git repo (branch master, remote skogai2/skogai on GitHub, last commit 2026-10-30). The orchestration workspace: CLAUDE.md/SKOGAI.md entrypoints, docs/ (docs/skogix has the introduction), .skogai/ (rules, skills, memory, scripts, journal), .harness/, protocol/, tests/, config/, bin/ and mise.toml.
- source: `git -C ~/skogai remote -v`; `git -C ~/skogai log -1`; `ls -la ~/skogai`
- learned: 2026-10-30

### ~/skogai/dash-skogai: is it its own repo?
- answer: No. It is a tracked directory inside the ~/skogai repo (rev-parse gives /home/skogix/skogai). It holds the dash type system (type/, global/, local/, system/, workflows/, Argcfile.sh). Do not confuse it with /skogai, whose remote is the repo named dash-skogai.
- source: `git -C ~/skogai/dash-skogai rev-parse --show-toplevel`; `ls ~/skogai/dash-skogai`
- learned: 2026-10-30

### /skogai: what is it?
- answer: Git repo (branch master, remote skogai2/dash-skogai, last commit 2026-10-18, so the stalest of the set). The shared multi-agent workspace and source of truth: owner skogix, group skogai, setgid. Contains admin/, bin/, coordination/ (coord.db), scripts/, tools/, mise.toml, fnox.toml and a README with the layout table.
- source: `git -C /skogai remote -v`; `ls -la /skogai`; `sed -n 1,10p /skogai/README.md`
- learned: 2026-10-30

### ~/.config/skogai: what is it?
- answer: Git repo (branch master, remote skogai2/config, last commit 2026-10-28). Knowledge about how the machines are configured, one page per concern (mise, dotfiles, containers, secrets, atuin, tmux, herdr, window-manager). Holds no dotfiles or machine state; it describes and routes to them.
- source: `git -C ~/.config/skogai remote -v`; `sed -n 1,12p ~/.config/skogai/README.md`
- learned: 2026-10-30

### ~/.skogai: what is it?
- answer: Git repo (branch master, remote skogai2/dot-skogai, last commit 2026-10-29). Contains config/script_metadata.json, empty scripts/ and tmp/. Beyond that its purpose is only inferred from the name and layout.
- source: `git -C ~/.skogai remote -v`; `ls -la ~/.skogai`
- learned: 2026-10-30

### ~/.config/containers/systemd: what is it?
- answer: Git repo (branch master, remote skogai/podman, last commit 2026-10-29). Podman quadlet units (units/) and the services they run (basic-memory, mcphub, termix, skognet-cloudflare), with PLAN.md, SECRETS.md and SKOGAI.md routers.
- source: `git -C ~/.config/containers/systemd remote -v`; `ls -la ~/.config/containers/systemd`
- learned: 2026-10-30

### Where is the ~/skogai/.skogai/ layout documented, and what does it hold?
- answer: Contents: rules/ (10 rule files such as act-dont-ask, podman-quadlets), skills/, memory/, scripts/, logs/, journal.md and config/. It is tracked by the ~/skogai repo (last change 2026-10-29). The layout is also described in /skogai/knowledge/layout.md per the /skogai README.
- source: `ls -la ~/skogai/.skogai`; `sed -n 1,12p /skogai/README.md`
- learned: 2026-10-30

### What is ~/skogai/.ai/cactus for?
- answer: UNKNOWN
- source: `ls ~/skogai/.ai/cactus` shows only q-numbered files (e.g. q1-2-..., q10-12-...), no README. Tracked in ~/skogai, last change 2026-10-25.
- learned: 2026-10-30

### Does /skogai/knowledge exist on disk, and is the .skogai layout page current?
- answer: UNKNOWN
- source: the /skogai README names knowledge/ but the `ls -la /skogai` listing shows no knowledge directory; not investigated further.
- learned: 2026-10-30
